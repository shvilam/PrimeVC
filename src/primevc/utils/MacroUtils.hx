/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package primevc.utils;
 import haxe.macro.Context;
 import haxe.macro.Expr;
 import haxe.macro.Type;
#if macro
  using primevc.utils.MacroUtils;
#end




/**
 * @author Ruben Weijers
 * @creation-date May 17, 2011
 */
class MacroUtils
{
	@:macro public static function enableFields ()						: Expr { return enableFieldsImpl(); }
	@:macro public static function disableFields ()						: Expr { return disposeFieldsImpl(); }
	@:macro public static function startListeningFields ()				: Expr { return startListeningFieldsImpl(); }
	@:macro public static function stopListeningFields ()				: Expr { return stopListeningFieldsImpl(); }
	@:macro public static function unbindFields (l:Dynamic, h:Dynamic)	: Expr { return unbindFieldsImpl(l, h); }
//	@:macro public static function traceFields ()						: Expr { return callFunctionOnFieldsOf([], "trace"); }
	@:macro public static function disposeFields ()						: Expr { return disposeFieldsImpl(); }
	
	
	/**
	 * Marco that will instantiate all variables in the class of the given type
	 * @param	searchType		type that the searched properties should have to auto-instantiate
	 * @param	instType		typeName of the class that should be instantiated. 
	 * 			The searchType can also be an interface.
	 */
	@:macro public static function instantiateFieldsOf (searchType:String, instType:String) : Expr
	{
		return instantiateFieldsImpl(null, searchType, instType);
	}
	
	
	@:macro public static function autoInstantiate (searchType:String, instType:String, insertBefore:Bool = false) : Array<Field>
	{
		var f = Context.getBuildFields();
		return f.addMethod( "new", "Void", [], instantiateFieldsImpl( f.toClassFields(), searchType, instType ), insertBefore );
	}
	
	
	@:macro public static function autoDispose () : Array<Field>
	{
	//	var name	= Context.getLocalClass().get().name;
		var f = Context.getBuildFields();
		return f.addMethod( "dispose", "Void", [], disposeFieldsImpl( f.toClassFields() ) );
	}
	
	
	@:macro public static function autoStartListening () : Array<Field>
	{
		var f = Context.getBuildFields();
		return f.addMethod( "startListening", "Void", [], startListeningFieldsImpl( f.toClassFields() ) );
	}
	
	
	@:macro public static function autoStopListening () : Array<Field>
	{
		var f = Context.getBuildFields();
		return f.addMethod( "stopListeningFieldsImpl", "Void", [], stopListeningFieldsImpl( f.toClassFields() ) );
	}
	
	
	@:macro public static function autoEnable () : Array<Field>
	{
		var f = Context.getBuildFields();
		return f.addMethod( "enable", "Void", [], enableFieldsImpl( f.toClassFields() ) );
	}
	
	
	@:macro public static function autoDisable () : Array<Field>
	{
		var f = Context.getBuildFields();
		return f.addMethod( "disable", "Void", [], disableFieldsImpl( f.toClassFields() ) );
	}
	
	
	@:macro public static function autoUnbind () : Array<Field>
	{
		var f = Context.getBuildFields();
		return f.addMethod( "unbind", "Void", ["l:Dynamic", "?h:Dynamic"], unbindFieldsImpl( f.toClassFields() ) );
	}
	
	
/*	@:macro public static function autoTraceFields () : Array<Field>
	{
		return Context.getBuildFields().addMethod( "traceFields", "Void", [], Context.parse("MacroUtils.traceFields()", Context.currentPos()) );
	}
	
	
	@:macro public static function autoTraceMe () : Array<Field>
	{
		var f = Context.getBuildFields();
		return f.addMethod( "traceMe", "Void", ["a:String"], autoTraceMeImpl( f.toClassFields(), "a" ) );
	}*/
	

#if macro
	/**
	 * Method will create a block that calls the .dispose() method on all the
	 * fields that implement IDisposable. After disposing, all fields are set
	 * to null.
	 * 
	 * To allow calling this method from another macro, the implementation can't
	 * be a macro. If it would be, we lose information about the class that
	 * the macro is called from (@see Context.getLocalClass())
	 */
	private static inline function disposeFieldsImpl (fields:Array<ClassField> = null) : Expr
	{
		var local	= Context.getLocalClass().get();
		if (fields == null)
			fields	= local.fields.get();
		
		var blocks	= fields.generateMethodCalls([], "dispose()", "IDisposable");
		if (blocks.length > 0)
			blocks	= fields.setValueOf(blocks, "IDisposable", "null", false );
		return blocks.length > 0 ? blocks.toExpr() : null;
	}
	
	
	
	private static inline function startListeningFieldsImpl (fields:Array<ClassField> = null) : Expr
	{
		var local	= Context.getLocalClass().get();
		if (fields == null)
			fields	= local.fields.get();
		
		var blocks	= fields.generateMethodCalls( [], "startListening()", "IMVCActor", true );
		if (blocks.length > 0)
			blocks.unshift( Context.parse("if (isListening()) { return; }", Context.currentPos()) );
		return blocks.length > 0 ? blocks.toExpr() : null;
	}
	
	
	
	private static inline function stopListeningFieldsImpl (fields:Array<ClassField> = null) : Expr
	{
		var local	= Context.getLocalClass().get();
		if (fields == null)
			fields	= local.fields.get();
		
		var blocks = fields.generateMethodCalls( [], "stopListening()", "IMVCActor", true );
		if (blocks.length > 0)
			blocks.unshift( Context.parse("if (!isListening()) { return; }", Context.currentPos()) );
		return blocks.length > 0 ? blocks.toExpr() : null;
	}
	
	
	
	private static inline function enableFieldsImpl (fields:Array<ClassField> = null) : Expr
	{
		var local	= Context.getLocalClass().get();
		if (fields == null)
			fields	= local.fields.get();
		
		var blocks = fields.generateMethodCalls( [], "enable()", "IDisablable", true );
		if (blocks.length > 0)
			blocks.unshift( Context.parse("if (isEnabled()) { return; }", Context.currentPos()) );
		return blocks.length > 0 ? blocks.toExpr() : null;
	}
	
	
	
	private static inline function disableFieldsImpl (fields:Array<ClassField> = null) : Expr
	{
		var local	= Context.getLocalClass().get();
		if (fields == null)
			fields	= local.fields.get();
		
		var blocks = fields.generateMethodCalls( [], "disable()", "IDisablable", true );
		if (blocks.length > 0)
			blocks.unshift( Context.parse("if (!isEnabled()) { return; }", Context.currentPos()) );
		return blocks.length > 0 ? blocks.toExpr() : null;
	}
	
	
	
	private static inline function unbindFieldsImpl (fields:Array<ClassField> = null, l:String = "l", h:String = "h")	: Expr { return callMethodOnFieldsOf([], "unbind("+l+","+h+")",	"IUnbindable",	false, fields); }
//	private static inline function autoTraceMeImpl (fields:Array<ClassField> = null, v:String = "v")					: Expr { return callMethodOnFieldsOf([], "traceMe("+v+")",		"Client",		true,  fields); }
	
	private static inline function instantiateFieldsImpl (fields:Array<ClassField> = null, searchType:String, instType:String) : Expr
	{
		if (fields == null)
			fields = Context.getLocalClass().get().fields.get();
		return fields.setValueOf( [], searchType, "new "+instType+"()", true ).toExpr();
	}
	
	
	private static inline function callMethodOnFieldsOf(blocks:Array<Expr>, methodName:String, typeName:String, nullCheck:Bool = false, fields:Array<ClassField>) : Expr
	{
		if (fields == null)
			fields = Context.getLocalClass().get().fields.get();
		return fields.generateMethodCalls( [], methodName, typeName, nullCheck ).toExpr();
	}
	
	private static inline function callFunctionOnFieldsOf(blocks:Array<Expr>, functionName:String) : Expr
	{
		var fields = Context.getLocalClass().get().fields.get();
		return fields.callFunctionFor( [], functionName ).toExpr();
	}
	
#end
}



#if macro

class BlocksUtil
{
	/**
	 * Macrohelper that will set the given value on each class-field of the given type.
	 * @param	fields			array with the fields of the class
	 * @param	typeName		interface or class name that the property to set should implement
	 * @param	value			string-value that the matched property should be set to		//FIXME giving a string is a bit dirty!!
	 * @param	assertNull		flag, if set to true, the method will add a Assert.null check in debug-mode for the variable to set
	 */
	public static inline function setValueOf( fields:Array<ClassField>, blocks:Array<Expr>, typeName:String, value:String, assertNull:Bool = false ) : Array<Expr>
	{
		var pos = Context.currentPos();
		
	//	blocks.push( Context.parse("trace('begin autosetters content "+typeName+"')", pos) );
		for (field in fields)
		{
			var c = field.getClassType();
			if (!field.meta.has("manual") && (c.hasInterface(typeName) || c.isClass(typeName)))
			{
#if debug		if (assertNull)
					blocks.push( Context.parse("if ("+field.name+" != null) { throw '"+field.name+" should be null'; }", Context.currentPos()) );
#end
	//			blocks.push( Context.parse("trace('===> "+field.name+" = "+value+"')", pos) );
	//			trace(field.name+" = "+value);
				blocks.push( Context.parse(field.name+" = "+value, Context.currentPos()) );						//TODO optimalization: don't use Context.parse but create macro typedefs instead..
			}
		}
		return blocks;
	}


	/**
	 * Macro helper method to call the given method on every class-variable that
	 * implements the given interface or the given className
	 */
	public static /*inline*/ function generateMethodCalls (fields:Array<ClassField>, blocks:Array<Expr>, method:String, typeName:String, nullCheck:Bool = false) : Array<Expr>
	{
		var pos = Context.currentPos();
		
		for (field in fields)
		{
			var c = field.getClassType();
	//		if (field.isVar())
	//			trace(field.name + ";\t\thasInterface? "+c.hasInterface(typeName)+";\t\tisClass? "+c.isClass(typeName)+"\t\t"+field.kind+" -> looking for "+typeName);
			if (!field.meta.has("manual") && (c.hasInterface(typeName) || c.isClass(typeName)))
			{
				var expr = field.name+"."+method;
	//			trace(expr);
				if (nullCheck)
					expr = "if (" + field.name + " != null) { " + expr + "; }";

				blocks.push( Context.parse(expr, pos) );																		//TODO optimalization: don't use Context.parse but create macro typedefs instead..
			}
		}

		return blocks;
	}


	/**
	 * Macro helper method to call the given function on every class-variable
	 */
	public static inline function callFunctionFor (fields:Array<ClassField>, blocks:Array<Expr>, method:String) : Array<Expr>
	{
		var pos = Context.currentPos();
		
		for (field in fields)
			if (field.isVar() && !field.meta.has("manual"))
				blocks.push( Context.parse(method + "('"+field.name+":\t'+ " + field.name + ")", pos) );								//TODO optimalization: don't use Context.parse but create macro typedefs instead..

		return blocks;
	}
	
	
	public static inline function toExpr (blocks:Array<Expr>, pos:Position = null) : Expr
	{
		if (pos == null)
			pos = Context.currentPos();
		return {expr: EBlock(blocks), pos: pos };
	}
	
	
	public static inline function getFields (userFields:Expr) : Array<Field>
	{
		return switch (userFields.expr) {
			case EVars(vars):
				switch (vars[0].type) {
					case TAnonymous(fl):	fl;
					default:				throw "wrong argument for userFields.def.vars[0].type. Should be ComplexType.TAnonymous but it is "+vars[0].type;
			}
			default:						throw "wrong argument for userFields.def! Should be ExprDef.EVar but it is "+userFields.expr;
		}
	}
	
	
#if debug
	private static var counter = 0;
#end
	
	
	/**
	 * Method will create a method definition for the given values and add the
	 * new method to list of userFields.
	 * 	- If the methodname already exists in the current-class, it will only insert
	 * 		the content of the method into the existing content.
	 * 	- if the methodname exists in a superclass of the current-class, it will
	 * 		add an override statement and a call to the super.methodName();
	 * 
	 * @param	userFields		fields in the current class
	 * @param	methodName		name of the method to add
	 * @param	returnType		return-type as a string.. It will be converted to some Expr value
	 * @param	methodContent	the expression that should be executed when the method is called
	 * @param	insertBefore	If the method is overwriting a super-method,
	 * 							it defines if the methodContent should be placed 
	 * 							before or after the super-call.
	 * 							@default is after super-call
	 * @return 		fields in the current class
	 */
	public static /*inline*/ function addMethod (userFields:Array<Field>, methodName:String, returnType:String, arguments:Array<String>, methodContent:Expr, insertBefore:Bool = false) : Array<Field>
	{
		if (methodContent == null)
			return userFields;
		
		var local			= Context.getLocalClass().get();
		var pos				= Context.currentPos();
		
		// check if the method is already declared in the current class ore one of the super classes
		var curDef		= userFields.getField( methodName );
		var hasSuper	= curDef != null ? false : local.hasSuper( methodName );
		
	//	trace("============");
	//	trace(local.name+".addMethod "+methodName+"("+arguments.join(", ")+")" #if debug + " " + counter++ #end );
	//	trace("curDef: "+(curDef != null));
	//	trace("hasSuper: "+hasSuper);
		
		// if it's already declared in the current class, add method implementation to the existing method
		if (curDef != null)
		{
			var current	= curDef.getContent();
			var pos		= current.pos;
			var block	= current.getBlock();
		//	trace(block);
			if (block == null)
			{
				block = new Array<Expr>();
				block.push( current );
				curDef.setContent(block.toExpr(pos));
			}
			
			if (insertBefore)	block.unshift( methodContent );
			else				block.push( methodContent );
		}
		
		
		// if the method is declared in a super class, override that implementation and call super
		else
		{
			var access = [APublic];
			if (hasSuper)
			{
				var argsStr		= arguments.toParameters();
				var superExpr	= methodName == "new" ? "super("+argsStr+")" : "super."+methodName+"("+argsStr+")";
				
				if (methodName != "new")
					access.push(Access.AOverride);
				
				var block = new Array<Expr>();
				if (insertBefore) {
					block.push( methodContent );
					block.push( Context.parse(superExpr, pos) );
				} else {
					block.push( Context.parse(superExpr, pos) );
					block.push( methodContent );
				}
				methodContent = block.toExpr();
			}
			
			// add the method to the class-definition
			userFields.push( {
				name:		methodName,
				doc:		null,
				meta:		[],
				access:		access,
				kind:		FFun({
					expr:	methodContent,
					args:	arguments.createArguments(), 
					params:	[],
					ret:	returnType.createTypePath()
				}),
				pos:		Context.currentPos()
			} );
		}
	//	trace("");
		return userFields;
	}
}



/**
 * Utility for enums and typedefs defined in haxe.macro.Type
 */
class MacroTypeUtil
{
	
	/**
	 * Recursive macro-helper to tell if the given ClassType implements the given
	 * interface
	 */
	public static function hasInterface (f:ClassType, type:String) : Bool
	{
	//	trace(f);
		if (f == null)			return false;
		if (type == "Dynamic")	return true;
		if (f.name == type)		return true;
		
		for (intf in f.interfaces)
			if (intf.t.get().hasInterface(type))
				return true;
		
		if (f.superClass != null)
			return hasInterface( f.superClass.t.get(), type );
		
		return false;
	}
	
	
	/**
	 * Recursive method to check if the given ClassType is the given type
	 * or a subclass of the given type.
	 */
	public static function isClass (f:ClassType, type:String) : Bool
	{
		if (f == null)			return false;
		if (type == "Dynamic")	return true;
		if (f.name == type)		return true;
		return f.getSuperClassField().isClass( type );
	}
	


	/**
	 * Macro helper to tell if the given class-field is a variable
	 */
	public static inline function isVar (field:ClassField) : Bool
	{
		return switch (field.kind) {
			case FVar(read, write): true;
			default: false;
		}
	}
	
	
	public static inline function isPublic (field:Field) : Bool
	{
		var pub = false;
		for (access in field.access)
			if (access == APublic) {
				pub = true;
				break;
			}
		return pub;
	}
	

	/**
	 * Macro helper to retrieve the class definition of the given field. If the
	 * field doesn't have a class-type or if it's not a variable, the method
	 * will return null;
	 */
	public static inline function getClassType (field:ClassField) : ClassType
	{
		return !isVar(field) || field.type == null ? null : switch (field.type) {
			case TInst(t, params): t != null ? t.get() : null;
			default: null; //throw "unkown type for "+field.name+" => "+field.type;
		}
	}
	
	
	/**
	 * Macro helper to retrieve the superClass.ClassType of the given field or
	 * null if there's none.
	 */
	public static inline function getSuperClassField (field:ClassType) : ClassType
	{
		return field == null || field.superClass == null ? null : field.superClass.t.get();
	}
	
	
	public static inline function getField (fields:Array<ClassField>, fieldName:String) : ClassField
	{
		var fl:ClassField = null;
		for (field in fields)
			if (field.name == fieldName) {
				fl = field;
				break;
			}
		
		return fl;
	}
	
	
	public static function hasSuper (classDef:ClassType, fieldName:String) : Bool
	{
		var s = classDef.superClass;
		if (s == null)					return false;
		else if (fieldName == "new")	return true;
		
		var def = s.t.get();
		for (field in def.fields.get())
			if (field.name == fieldName)
				return true;
		
		return hasSuper( def, fieldName );
	}
	
	
	
}



/**
 * Utility for enums and typedefs defined in haxe.macro.Expr
 */
class MacroExprUtil
{
	public static inline function getContent (field:Field) : Expr
	{
		Assert.notNull(field);
		return switch (field.kind) {
			case FFun(f):	return f.expr;
			default:		throw "wrong field.kind.. Should be FieldType.FFun instead of "+field.kind;
		}
	}
	
	
	public static inline function setContent (field:Field, content:Expr) : Expr
	{
		Assert.notNull(field);
		return switch (field.kind) {
			case FFun(f):	return f.expr = content;
			default:		throw "wrong field.kind.. Should be FieldType.FFun instead of "+field.kind;
		}
	}
	
	
	public static inline function getBlock (expr:Expr) : Array<Expr>
	{
		return switch (expr.expr) {
			case EBlock(exprs):	exprs;
			default:			null;
		}
	}
	
	
	
	/**
	 * Macro helper to create the typePath for the given typeName
	 */
	public static inline function createTypePath (typeName:String) : ComplexType
	{
		return TPath({ pack : [], name : typeName, params : [], sub : null });
	}
	
	
	/**
	 * Returns the value of a EConst(c) if it's a string. If the given ExprDef
	 * isn't a EConst or if it's a Constant.CRegexp, the method will return 
	 * null.
	 */
	public static inline function getConstantString (e:ExprDef) : String
	{
		return switch (e) {
			case EConst(c):
				switch (c) {
					case CInt(s):		s;
					case CFloat(s):		s;
					case CString(s):	s;
					case CIdent(s):		s;
					case CType(s):		s;
					default:			null;
				}
			default:					null;
		}
	}
	
	
	public static inline function getField (fields:Array<Field>, fieldName:String) : Field
	{
		var fl:Field = null;
		for (field in fields)
			if (field.name == fieldName) {
				fl = field;
				break;
			}
		
		return fl;
	}
	
	
	public static inline function createArguments (params:Array<String>) : Array<FunctionArg>
	{
		var p = new Array<FunctionArg>();
		
		for (param in params) {
			var opt	= param.substr(0,1) == "?";
			if (opt)
				param = param.substr(1);
			
			var v = param.split(":");
			p.push({
				name:	v[0],
				opt:	opt,
				type:	v[1].getArgsType(),
				value:	null
			});
		}
		return p;
	}
	
	
	private static inline function getArgsType (typeStr:String) : Null<ComplexType>
	{
		var packs = typeStr.split(".");
		return TPath( {name: packs.pop(), pack: packs, params: [], sub: null} );
	}
	
	
	public static inline function toParameters (params:Array<String>) : String
	{
		var p = [];
		
		for (param in params) {
			if (param.substr(0,1) == "?")
				param = param.substr(1);
			p.push( param.split(":")[0] );	
		}
		return p.join(", ");
	}
}



/**
 * Utility to convert haxe.macro.Expr.Field to haxe.maco.Type.ClassField
 */
class FieldUtil
{
	public static inline function getClassField (field:Field) : ClassField
	{
		var cField:ClassField = cast {
			name:		field.name,
			type:		null,
			isPublic:	true,
			params:		new Array<{ name : String, t : Type }>(),
			meta:		field.meta.toMetaAccess(),
			kind:		null,
			expr:		{expr: null, pos: field.pos},
			pos:		field.pos
		};
		
		switch (field.kind) {
	//		default:			throw "unkown field "+field.name+" => "+field.kind;
			case FProp(get, set, t):
				cField.kind		= FieldKind.FVar( get.toAccess(), set.toAccess() );
				
				var type = t.complexTypeToTypePath();
				if (type != null)
					cField.type	= Context.getType( type.name ); //Type.TInst(null, []);
				
			case FFun(f):
				cField.params	= cast f.args;
				cField.kind		= FieldKind.FMethod( MethNormal );
	//			cField.expr		= f.expr;
				
			case FVar(ct, e):
				var path = ct.complexTypeToTypePath();
				
				if (path != null)
				{
					var type = Context.getType( path.name );
					switch (type) {
						default:
					//		throw "unkown type "+field.name+" => "+type;
					//	case TFun(args, ret):
						//	cField.params = args;
						
						case TInst(t, params):
							cField.type		= type;
							cField.isPublic	= !t.get().isPrivate;
							cField.kind		= FieldKind.FVar( AccNormal, AccNo );
					}
				}
		}
		
		if (cField.kind == null)
			cField = null;
		return cField;
	}
	
	
	public static inline function toClassFields (fields:Array<Field>) : Array<ClassField>
	{
		var f = [];
		for (field in fields) {
			var type = field.getClassField();
			if (type != null)
				f.push(type);
		}
		return f;
	}
	
	
	public static inline function toMetaAccess (metaData:Metadata) : MetaAccess
	{
		return new TmpMetaAccess(metaData);
	}
	
	
	public static inline function toAccess (getter:String) : VarAccess
	{
		return switch (getter) {
			case "default":		AccNormal;
			case "null":		AccNo;
			case "never":		AccNever;
			default:			AccCall(getter);
		}
	}
	
	
	public static inline function complexTypeToTypePath (t:Null<ComplexType>) : TypePath
	{
		var p:TypePath = null;
		if (t != null)
			switch (t) {
				default:
				case TPath(path):
					p = path;
			}
		return p;
	}
	
	
	/*
	public static inline function autoBuildFieldsTest ()
	{
		trace("== BEGIN TRACE FIELDS ==");
		var fields = Context.getBuildFields();
		for (field in fields)
		{
			switch (field.kind) {
				default:
				case FVar(t, e):
					switch (t) {
						default:
						case TPath(p):
							switch (Context.getType( p.name )) {
								default:
								case TInst(type, params):
									trace(field.name+" => "+type.get().interfaces);
							}
					}
			}
		}
		trace("== END TRACE FIELDS ==");
		
		trace("== BEGIN TRACE CLASS FIELDS ==");
		var cFields = Context.getLocalClass().get().fields.get();
		for (cField in cFields)
		{
			switch (cField.type) {
				default:
				case TInst(type, params):
					trace(cField.name+" => "+type.get().interfaces);
			}
		}
		trace("== END TRACE CLASS FIELDS ==");
	}*/
}


class TmpMetaAccess
{
	private var meta : Metadata;
	public function new (meta:Metadata)	{ this.meta = meta == null ? [] : meta; }
	public function get()				{ return meta; }
	public function has(name:String)	{ return indexOf(name) > -1; }
	
	
	public function add( name:String, params:Array<Expr>, pos:Position )
	{
		meta.push( {name: name, params: params, pos: pos} );
	}
	
	
	public function remove( name : String ) : Void
	{
		var pos = indexOf(name);
		if (pos > -1)
			meta.splice(pos, 1);
	}
	
	
	private inline function indexOf (name:String) : Int
	{
		var pos = -1;
		for (i in 0...meta.length) {
			var item = meta[i];
			if (item.name == name) {
				pos = i;
				break;
			}
		}
		return pos;
	}
}


#end