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
package primevc.tools.generator;
 import primevc.tools.generator.InstanceType;
 import primevc.tools.generator.ValueType;
 import primevc.types.Reference;
 import primevc.types.SimpleDictionary;
 import primevc.utils.NumberUtil;
  using primevc.types.Reference;
  using Std;
  using Type;


private typedef HaxeType = Type.ValueType;

/**
 * @author Ruben Weijers
 * @creation-date Sep 13, 2010
 */
class CodeGenerator implements ICodeGenerator
{
	/**
	 * List of all the values to generate
	 */
	public  var values				(default, null) : Array<ValueType>;
	/**
	 * List with an index of all the object-ids and their valueTypes 
	 */
	private var objInstances		: IntHash<ValueType>;
	
	/**
	 * Index of previously generated array's and the correct value-type.
	 * Nescesary since array's don't have an object-id.
	 */
	private var arrInstances		: SimpleDictionary<Array<Dynamic>, ValueType>;
	private var isStarted			: Bool;

	/**
	 * List with all classes that need to be imported.
	 * Keys are the names of the classes and the values are the full paths to 
	 * the classes.
	 */
	public  var imports				(default, null) : Hash<String>;

	/**
	 * List with instances that should be set to 'null' when an object is 
	 * refering to them.
	 */
	public var instanceIgnoreList	(default, null) : IntHash<Dynamic>;
	
	
	
	public function new ()
	{
#if !neko Assert.abstract(); #end
		instanceIgnoreList	= new IntHash();
	}
	
	
	public inline function start () : Void
	{
		if (!isStarted)
		{
			values			= new Array();
			objInstances	= new IntHash<ValueType>();
			arrInstances	= new SimpleDictionary();
			imports			= new Hash();
			isStarted		= true;
		}
	}


	public function generate (startObj:ICodeFormattable) : Void
	{
		start();
		startObj.cleanUp();
		startObj.toCode(this);
	}


	public function flush () : Void
	{
		if (!isStarted)
			return;
		
		arrInstances.dispose();
		values			= null;
		objInstances	= null;
		arrInstances	= null;
		imports			= null;
	}
	
	
	
	public inline function setSelfAction (name:String, ?params:Array<Dynamic>) : Void
	{
		values.push( tCallMethod(null, name, formatParams(params)) );
	}
	
	
	public function construct (obj:ICodeFormattable, ?params:Array<Dynamic>, ?alternativeType:Class<Dynamic>) : ValueType
	{
		Assert.that( !hasObject(obj) );
		obj.cleanUp();
		
		var classRef		= alternativeType == null ? obj.getClass() : alternativeType;
		var cFullName		= classRef.getClassName();
		var type:ValueType	= obj.isEmpty()
			? tEmpty( eNull )
			: tObject( new Instance( addImportFor(cFullName), InstanceType.object, formatParams(params) ) );
		
		objInstances.set( obj._oid, type );
		return type;
	}
	
	
	public function createClassNameConstructor (cFullName:String, ?params:Array<Dynamic>) : ValueType
	{
		return tObject( new Instance( addImportFor( cFullName ), object, formatParams(params) ) );
	}
	
	
	public function createFactory (obj:ICodeFormattable, classRef:String, params:Array<Dynamic>, arguments:Array<String> = null) : ValueType
	{
		Assert.that( !hasObject(obj) );
		obj.cleanUp();
		
		var type = tObject( new Instance( null, objFactory( new Instance(addImportFor(classRef), object, formatParams(params)), arguments ), null ));
	//	values.push(type);
		objInstances.set( obj._oid, type );
		return type;
	}
	
	
	
	public function constructFromFactory (obj:ICodeFormattable, factoryMethod:String, ?params:Array<Dynamic>) : ValueType
	{
		Assert.notNull(obj);
		Assert.notNull(factoryMethod);
		var type = tCallStatic( addImportFor( obj.getClass().getClassName() ), factoryMethod, formatParams(params) );
		objInstances.set( obj._oid, type );
	//	values.push( type );
		return type;
	}
	
	
	
	public function setAction ( obj:ICodeFormattable, name:String, ?params:Array<Dynamic>, onlyWithParams:Bool = false) : Void
	{
		Assert.notNull( obj );
		var p = formatParams(params);
		if (!onlyWithParams || p.length > 0)
			values.push( tCallMethod( getObject( obj ), name, p ) );
	}
	
	
	public function setProp ( obj:ICodeFormattable, name:String, value:Dynamic, ignoreIfEmpty:Bool = false ) : Void
	{
		Assert.notNull( obj );
		var v = formatValue(value);
		if (ignoreIfEmpty && isEmpty(v))
			v = null;
		
		if (v != null)
			values.push( tSetProperty( getObject( obj ), name, v ) );
	}
	
	
	
	
	private function addImportFor (fullName:String) : String
	{
		var i = fullName.lastIndexOf(".");
		if (i == -1)
			return fullName;
		
		var name = fullName.substr(i+1);
		
		//check if the class that is registered with the given name is in the same package as the current class
		if (imports.exists(name))
			return imports.get(name) == fullName ? name : fullName;
		
		imports.set( name, fullName );
		return name;
	}
	
	
	
	private function formatParams (args:Array<Dynamic>) : Array<ValueType>
	{
		if (args == null || args.length == 0)
			return [];
		
		var newArgs = new Array(); //neko.NativeArray.alloc(args.length);	// make new array with the same length
		for (i in 0 ... args.length)
			newArgs[i] = formatValue(args[i]);
		
		// try to remove all the empty parameters at the end of the constructor
		var i = newArgs.length;
		while (i-->0)
			switch (newArgs[i]) {
				default:		break;			// first non-empty argument.. stop searching
				case tEmpty(v):	newArgs.pop();	// remove last argument from list
			}
		
		return newArgs;
	}
	
	
	private function formatValue (v:Dynamic) : ValueType
	{
		var type:ValueType = null;
		if		(isColor(v))					type = tColor(v.color, v.a);
		else if (v.is( ICodeFormattable ))		type = getObject(v);
		else if (v.is( Reference))				type = cast(v, Reference).toCode(this);
		
		else if (isUndefinedFloat(v))			type = tEmpty( eFloat );
		else if (isUndefinedInt(v))				type = tEmpty( eInt );
		else if (v == null)						type = tEmpty( eNull );
		
		else if (v.is( String ))				type = tString( v );
		else if (v.is( Array ))					type = getArray(v);
		else if (v.is( Int ))					type = v > 255 ? tUInt(v) : tInt(v);
		else if (v.is( Float ))					type = tFloat(v);
		else if (v.is( Bool ))					type = tBool(v);
	//	else if (Std.is( v, Hash ))				type = formatHash(v);
		else if (null != v.getEnum())			type = convertEnum(v);
		else if (null != v.getClassName())		type = tClass( addImportFor( Type.getClassName(cast v) ) );
		else if (null != v.getClass())			type = createClassNameConstructor( v.getClass().getClassName(), null );
		
		if (type == null)
			type = convertType( Type.typeof(v), v );
	//		throw "unknown value type: " + v+"; "+Type.typeof(v);
		
		return type;
	}
	
	
	private inline function isColor				(v:Dynamic)				: Bool		{ return Reflect.hasField(v, "color") && Reflect.hasField(v, "a"); }
	private inline function isEmpty				(v:ValueType)			: Bool 		{ return switch (v) { case tEmpty(v): true; default: false; } }
	private inline function getClassName		(obj:ICodeFormattable)	: String	{ return obj.getClass().getClassName(); }
	
	private inline function isUndefinedFloat	(v:Dynamic)				: Bool		{ return Std.is(v, Float) && FloatUtil.notSet( v ); }
	private inline function isUndefinedInt		(v:Dynamic)				: Bool		{ return Std.is(v, Int) && IntUtil.notSet( v ); }
	public  inline function hasObject			(obj:ICodeFormattable)	: Bool		{ return objInstances.exists(obj._oid); }
	public  inline function hasArray			(arr:Array<Dynamic>)	: Bool		{ return arrInstances.exists(arr); }
	
	
	public function getObject (obj:ICodeFormattable) : ValueType
	{
		if (hasObject(obj))
			return useObject( objInstances.get( obj._oid ) );
		
		if (instanceIgnoreList.exists(obj._oid))
			return tEmpty(eNull);
		
		obj.cleanUp();
		obj.toCode(this);
		return objInstances.get( obj._oid );
	}
	
	
	public function getArray( arr:Array<Dynamic> ) : ValueType
	{
		if (hasArray(arr))
			return useObject( arrInstances.get( arr ) );
		
		var type = tObject( new Instance( "Array", array, formatParams(arr) ) );
		arrInstances.set( arr, type );
		values.push(type);
		return type;
	}
	
	
	private function useObject (v:ValueType) : ValueType
	{
		switch (v) {
			default:
	//			throw "wrong valuetype "+v;
				return v;
			
			case tObject(i):
				i.count++;
				return v;
		}
	}
	
	
	private function convertEnum (obj:Dynamic) : ValueType
	{
		var name	= addImportFor( Type.getEnum( obj ).getEnumName() ) + "." + Type.enumConstructor( obj );
		var eParams	= Type.enumParameters( obj );
		var tParams	= [];
		
		//find and write the parameters of the enum.
		if (eParams.length > 0)
		{
			for (eParam in eParams)
			{
				var tParam:ValueType = convertType( Type.typeof(eParam), eParam );
	/*			switch (type)
				{
					case TClass( c ):
						//create constructor with the right parameters from just a Class Reference..
						var cName	= c.getClassName();
						var pack	= cName.substr( 0, cName.lastIndexOf(".") );
						tParam		= createClassNameConstructor( pack + "." + eParam, null );
					//	strParam	= "new " + pack + "." + param;
					
					default:
						tParam		= formatValue( eParam );
				}*/
				
				if (tParam != null)
					tParams.push(tParam);
			}
			
		//	if (tParams.length > 0)
		//		name += "( " + strParams.join(", ") + " )";
		}
		
		if (tParams.length == 0)
			tParams = null;
		return tEnum( name, tParams );
	}
	
	
	private function convertType (t:HaxeType, value:Dynamic) : ValueType
	{
		var type:ValueType = null;
		switch(t) {
			case TClass(c):		type = createClassNameConstructor( c.getClassName(), null );
			case TNull:			type = tEmpty(eNull);
			case TFloat:		type = tFloat(value);
			case TInt:			type = tInt(value);
			case TBool:			type = tBool(value);
			case TFunction:		type = tFunction(value);
			case TObject:		type = createClassNameConstructor( Type.getClass(value).getClassName(), null );
			case TEnum(e):		type = convertEnum(e);
			case TUnknown:		type = tEmpty(eNull);
	//		default:			type = tEmpty(eNull);
		}
		return type;
	}
}