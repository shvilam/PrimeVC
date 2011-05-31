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
 * DAMAGE.
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.tools.generator;
 import primevc.gui.layout.LayoutFlags;
 import primevc.neko.traits.IHasTypeParameters;
 import primevc.types.Number;
 import primevc.types.Reference;
 import primevc.types.RGBA;
 import primevc.types.SimpleDictionary;
 import primevc.utils.Color;
 import primevc.utils.FastArray;
 import primevc.utils.NumberUtil;
  using primevc.types.Reference;
  using primevc.utils.FastArray;
  using Std;
  using Type;


private typedef ArrayMapType = SimpleDictionary < Array<Dynamic>, String >;
private typedef VarMapType = IntHash < String >;


/**
 * Class to loop through a set of IHxFormattable and put the output of these
 * objects as haxe code in a file.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 13, 2010
 */
class HaxeCodeGenerator implements ICodeGenerator
{
	private var output		: StringBuf;
	
	/**
	 * List with all the variables and there id's
	 */
	private var varMap		: VarMapType;
	/**
	 * List with all the arrays to generate
	 */
	private var arrayMap	: ArrayMapType;
	
	/**
	 * List with all classes that need to be imported.
	 * Keys are the names of the classes and the values are the full paths to 
	 * the classes.
	 */
	private var importMap	: Hash<String>;
	private var varCounter	: Int;
	private var linePrefix	: String;
	
	public var tabSize		(default, setTabSize) : Int;
	
	/**
	 * List with instances that should be set to 'null' when an object is 
	 * refering to them.
	 */
	public var instanceIgnoreList	: IntHash < Dynamic >;
	
	
	public function new (?tabSize = 0)
	{
#if !neko
		Assert.abstract();
#end
		this.tabSize		= tabSize;
		instanceIgnoreList	= new IntHash();
	}
	
	
	private inline function setTabSize (size:Int) : Int
	{
		if (tabSize != size) {
			tabSize = size;
			
			linePrefix = "";
			for (i in 0...size)
				linePrefix += "\t";
		}
		return size;
	}
	
	
	public inline function start () : Void
	{
		output		= new StringBuf();
		varMap		= new VarMapType();
		arrayMap	= new ArrayMapType();
		importMap	= new Hash();
		varCounter	= 0;
	}
	
	
	public function generate (startObj:ICodeFormattable) : Void
	{
		start();
		startObj.toCode(this);
	}
	
	
	public function flush () : String
	{
		if (output == null)
			return "";
		
		var str		= output.toString();
		output		= null;
		varMap		= null;
		return str;
	}
	
	
	public function flushImports () : String
	{
		var sbuf = new StringBuf();
		for (i in importMap) {
			sbuf.add(" import ");
			sbuf.add(i); sbuf.add(";\n");
		}
		
//		return sbuf.toString();
//		var str = " import " + importMap.valueList().join(";\n import ") + ";";
//		importMap.dispose();
		importMap = null;
		return sbuf.toString();
	}
	
	
	
	public function createFactory (obj:ICodeFormattable, classRef:String, params:Array<Dynamic>, arguments:Array<String> = null)
	{
		Assert.notNull(params);
		var a	= "";
		var p	= formatArguments( params, true );
		
		if (arguments != null && arguments.length > 0)
		{
			a = arguments.join(", ");
			if (p != "")	p = a + ", " + p;
			else			p = a;
		}
		
		addLine( "var " + createObjectVar(obj, false) + " = " +"function("+a+") { return new "+classRef+"("+p+"); }" );
	}
	
	
	public function construct (obj:ICodeFormattable, ?params:Array<Dynamic>, ?alternativeType:Class<Dynamic>) : Void
	{
		var type = alternativeType == null ? obj.getClass() : alternativeType;
		addLine( "var " + createObjectVar(obj, false) + " = " +createClassConstructor( type, params ) + ";" );
	}
	
	
	public function createClassConstructor (classRef:Class<Dynamic>, ?params:Array<Dynamic>)
	{
		Assert.notNull(classRef);
		return createClassNameConstructor( classRef.getClassName(), params );
	}
	
	
	
	public function createClassNameConstructor (className:String, ?params:Array<Dynamic>)
	{
		Assert.notNull( className );
		return "new " + addImportFor(className) + "( " + formatArguments( params, true ) + " )";
	}
	
	
	public function addImportFor (fullClassName:String) : String
	{
		var i = fullClassName.lastIndexOf(".");
		if (i == -1)
			return fullClassName;
		
		var className	= fullClassName.substr( i + 1 );
		
		//check if the class that is registered with the given name is in the same package as the current class
		if (importMap.exists(className))
			return importMap.get( className ) == fullClassName ? className : fullClassName;
		
		importMap.set( className, fullClassName );
		return className;
	}
	
	
	public function setAction ( obj:ICodeFormattable, name:String, ?args:Array<Dynamic>) : Void
	{
		Assert.notNull( obj );
		Assert.that( varMap.exists( obj._oid ) );
		addLine( getVar(obj) + "." + name + "(" + formatArguments(args) +");" );
	}
	
	
	public function setSelfAction (name:String, ?args:Array<Dynamic>) : Void
	{
		addLine("this." + name + "(" + formatArguments(args) + ");");
	}
	
	
	public function setProp ( obj:ICodeFormattable, name:String, value:Dynamic ) : Void {
		Assert.that( varMap.exists( obj._oid ) );
		var valueStr = formatValue(value);
		if (valueStr != null)
			addLine( getVar(obj) + "." + name + " = " + valueStr + ";");
	}
	
	
	private function formatArguments (args:Array<Dynamic>, isConstructor:Bool = false) : String
	{
		if (args == null)
			return "";
		
		var newArgs = neko.NativeArray.alloc(args.length);
		for (i in 0 ... args.length)
			newArgs[i] = formatValue(args[i], isConstructor);
		
		//try to remove all the empty parameters at the end of the constructor
		var i = args.length;
		while (i-->0)
		{
			var val = newArgs[i];
			if (val == null || val == "null" || val == "Number.INT_NOT_SET" || val == "Number.FLOAT_NOT_SET")
				{}
			else
				break;
		}
		
		if (i != 0)
		{
			var buf = new StringBuf();
			for (j in 0 ... i+1) {
				buf.add(newArgs[j]);
				if (j < i) buf.add(", ");
			}
			return buf.toString();
		}
		else return newArgs[0];
	}
	
	
	private function formatValue (v:Dynamic, isConstructor:Bool = false) : String
	{
		var str = "";
		if		(isColor(v))						return Color.string(v);
		else if (Std.is( v, ICodeFormattable ))		return castString( v, getVar( v ) );
		else if (Std.is( v, Reference))				return castString( v, cast(v, Reference).toCode(this) );
		else if (isUndefinedNumber(v))				return (Std.is( v, Int )) ? "Number.INT_NOT_SET" : "Number.FLOAT_NOT_SET";
		else if (v == LayoutFlags.FILL)				return "LayoutStyleFlags.FILL";
		else if (v == Number.EMPTY)					return "Number.EMPTY";
		else if (v == null)							return "null";
		else if (Std.is( v, String ))				return "'" + v + "'";
		else if (Std.is( v, Array ))				return castString( v, getArray( cast v ) );
		else if (Std.is( v, Int ))					return v > 255 ? Color.uintToString(v) : Std.string(v);
		else if (Std.is( v, Float ))				return Std.string(v);
		else if (Std.is( v, Bool ))					return v ? "true" : "false";
	//	else if (Std.is( v, Hash ))					return formatHash(v);
		else if (null != Type.getEnum(v))			return getEnumName(v);
		else if (null != Type.getClassName(v))		return addImportFor( Type.getClassName(cast v) );
		else										throw "unknown value type: " + v;
		return "";
	}
	
	
	private inline function isColor (v:Dynamic)					: Bool		{ return Reflect.hasField(v, "color") && Reflect.hasField(v, "a"); }
	private inline function getClassName (obj:ICodeFormattable)	: String	{ return Type.getClass(obj).getClassName(); }
	private inline function a( str:String )						: Void		{ output.add(str); }
	private inline function addLine( line:String )				: Void		{ a("\n"); a(linePrefix); a(line); }
	private inline function getVar (obj:ICodeFormattable)		: String	{ return createObjectVar( obj ); }
	public  inline function hasVar (obj:ICodeFormattable)		: Bool		{ return varMap.exists(obj._oid); }
	public  inline function varName (obj:ICodeFormattable)		: String	{ return varMap.get(obj._oid); }
	private inline function getArray( arr:Array<Dynamic> )		: String	{ return createArrayVar( arr ); }
	
	
	private inline function getEnumName (obj:Dynamic)			: String
	{
		var name	= addImportFor( Type.getEnum( obj ).getEnumName() ) + "." + Type.enumConstructor( obj );
		var params	= Type.enumParameters( obj );
		
		//find and write the parameters of the enum.
		if (params.length > 0)
		{
			var strParams = [];
			for (param in params)
			{
				var type = Type.typeof(param);
				var strParam:String = null;
				switch (type)
				{
					case TClass( c ):
						//create constructor with the right parameters from just a Class Reference..
						var cName	= c.getClassName();
						var pack	= cName.substr( 0, cName.lastIndexOf(".") );
						strParam	= "new " + pack + "." + param;
					
					default:
						strParam	= formatValue( param );
				}
				
				if (strParam != null)
					strParams.push(strParam);
			}
			
			if (strParams.length > 0)
				name += "( " + strParams.join(", ") + " )";
		}
		return name;
	}
	
	
	private inline function isUndefinedNumber (v:Dynamic) : Bool
	{
		var isUndef = false;
		if (Std.is(v, Int) || Std.is(v, Float))
		{
			if		(v == null)			isUndef = true;
			else if (Std.is(v, Int))	isUndef = IntUtil.notSet( cast v );
			else if (Std.is(v, Float))	isUndef = FloatUtil.notSet( cast v );
		}
		return isUndef;
	}

	
	private inline function castString (v:Dynamic, vStr:String) : String
	{
		if (vStr != null && ( v.is(haxe.rtti.Generic) || v.is( IHasTypeParameters ) ) )
			vStr = "cast " + vStr;
		
		return vStr;
	}
	
	
	private function createObjectVar (obj:ICodeFormattable, constructObj:Bool = true) : String
	{
		if (hasVar(obj))
			return varMap.get(obj._oid);
		
		obj.cleanUp();
		if (obj.isEmpty())
			return null;
		
		if (instanceIgnoreList.exists(obj._oid))
			return null;
		
		var name = createVarName( obj.getClass() );
		Assert.notNull( name );
		Assert.notThat( name == "" );
		
		varMap.set( obj._oid, name );
		
		if (constructObj)
			obj.toCode(this);
		
		return name;
	}
	
	
	private function createVarName (classRef:Class<Dynamic>)
	{
		//get class name without package stuff..
		var index:Int, name = classRef.getClassName();
		
		while ( -1 != (index = name.indexOf(".")))
			name = name.substr( index + 1 );
		
		//make first char lowercase
		name = name.substr(0, 1).toLowerCase() + name.substr( 1 );
		
		//add a number at the end to make sure the varname is unique
		name += varCounter++;
		return name;
	}
	
	
	private function createArrayVar (arr:Array<Dynamic>) : String
	{
		if (arrayMap.exists(arr))
			return arrayMap.get(arr);
		
		var name = "array" + arrayMap.length;
		arrayMap.set( arr, name );
		
		//write array code
		addLine( "var " + name + " = [ " + formatArguments(arr) + " ];" );
		
		return name;
	}
}