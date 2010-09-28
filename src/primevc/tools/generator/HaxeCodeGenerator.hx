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
 import primevc.types.RGBA;
 import primevc.utils.Color;
 import primevc.utils.NumberUtil;
  using Std;
  using Type;


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
	private var varMap		: Hash < String >;
	private var varCounter	: Int;
	private var linePrefix	: String;
	
	public var tabSize		(default, setTabSize) : Int;
	
	
	public function new (?tabSize = 0) {
		this.tabSize = tabSize;
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
		varMap		= new Hash();
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
		
		var str	= output.toString();
		output	= null;
		varMap	= null;
		return str;
	}
	
	
	public function construct (obj:ICodeFormattable, ?args:Array<Dynamic>) : Void {
		addLine( "var " + createVarName(obj, false) + " = new " + getClassName(obj) + "( " + formatArguments( args, true ) + " );" );
	}
	
	
	public function setAction ( obj:ICodeFormattable, name:String, ?args:Array<Dynamic>) : Void
	{
		Assert.notNull( obj );
		Assert.that( varMap.exists( obj.uuid ) );
		addLine( getVar(obj) + "." + name + "(" + formatArguments(args) +");" );
	}
	
	
	public function setSelfAction (name:String, ?args:Array<Dynamic>) : Void
	{
		addLine( "this." + name + "(" + formatArguments(args) +");" );
	}
	
	
	public function setProp ( obj:ICodeFormattable, name:String, value:Dynamic ) : Void {
		Assert.that( varMap.exists( obj.uuid ) );
		addLine( getVar(obj) + "." + name + " = " + formatValue(value) + ";");
	}
	
	
	private function formatArguments (args:Array<Dynamic>, isConstructor:Bool = false) : String
	{
		if (args == null)
			return "";
		
		var newArgs = [];
		for (arg in args)
			newArgs.push( formatValue(arg, isConstructor) );
		
		return newArgs.join(", ");
	}
	
	
	private function formatValue (v:Dynamic, isConstructor:Bool = false) : String
	{
		if		(isColor(v))					return Color.string(v);
		else if (Std.is( v, ICodeFormattable ))	return "cast " + getVar(v);
		else if (isUndefinedNumber(v))			return (Std.is( v, Int ) || isConstructor) ? "primevc.types.Number.INT_NOT_SET" : "primevc.types.Number.FLOAT_NOT_SET";
		else if (v == LayoutFlags.FILL)			return "primevc.gui.layout.LayoutFlags.FILL";
		else if (v == null)						return "null";
		else if (Std.is( v, String ))			return "'" + v + "'";
		else if (Std.is( v, Int ))				return Std.string(v);
		else if (Std.is( v, Float ))			return Std.string(v);
		else if (Std.is( v, Bool ))				return v ? "true" : "false";
		else if (null != Type.getEnum(v))		return getEnumName(v);
		else									throw "unknown value type: " + v;
		return "";
	}
	
	
	private inline function isColor (v:Dynamic)					: Bool		{ return Reflect.hasField(v, "color") && Reflect.hasField(v, "a"); }
	private inline function getClassName (obj:ICodeFormattable)	: String	{ return Type.getClass(obj).getClassName(); }
	private inline function getEnumName (obj:Dynamic)			: String	{ return Type.getEnum( obj ).getEnumName() + "." + obj; }
	private inline function addLine( line:String)				: Void		{ output.add( "\n" + linePrefix + line ); }
	private inline function getVar (obj:ICodeFormattable)		: String	{ return varMap.exists( obj.uuid ) ? varMap.get( obj.uuid ) : createVarName( obj ); }
	
	
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
	
	
	private function createVarName (obj:ICodeFormattable, constructObj:Bool = true) : String
	{
		if (varMap.exists(obj.uuid))
			return varMap.get(obj.uuid);
		
		if (obj.isEmpty())
			return null;
		
		//get class name without package stuff..
		var index:Int, name = getClassName( obj );
		
		while ( -1 != (index = name.indexOf(".")))
			name = name.substr( index + 1 );
		
		//make first char lowercase
		name = name.substr(0, 1).toLowerCase() + name.substr( 1 );
		
		//add a number at the end to make sure the varname is unique
		name += varCounter++;
		
		varMap.set( obj.uuid, name );
		
		if (constructObj)
			obj.toCode(this);
		
		return name;
	}
}