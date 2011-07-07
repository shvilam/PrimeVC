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
package primevc.tools.generator.output;
 import primevc.tools.generator.Instance;
 import primevc.tools.generator.InstanceType;
 import primevc.tools.generator.ValueType;
  using primevc.tools.generator.output.HaxeOutputUtil;
  using Std;
  using StringTools;



/**
 * @author	Ruben Weijers
 * @since	Jun 8, 2011
 */
class HaxeOutputUtil
{
	private static inline var EMPTY_INT	= primevc.types.Number.EMPTY;
	private static inline var FILL_INT	= primevc.gui.styling.LayoutStyleFlags.FILL;
	
	
	public static function writeValues (values:Array<ValueType>) : StringBuf
	{
		var doc = new StringBuf();
		for (value in values)
			doc.addLine( doc.write(value) );
		
		return doc;
	}
	
	
	public static function writeImports (list:Hash<String>) : StringBuf
	{
		var output	= new StringBuf();
		var a		= output.add;
		
	//	var s		= function (a:String, b:String):Int { return a > b ? 1 : (a < b ? -1 : 0); }	//from http://haxe.org/forum/thread/1841
		var arr		= new Array<String>();
		for (importable in list)
			arr.push(importable);
		
		arr.sort(function(a,b) { return Reflect.compare(a.toLowerCase(),b.toLowerCase()); });
		
		for (file in arr)
			a( " import " + file + ";\n" );
		
		return output;
	}
	
	
	
	
	private static inline function addLine (buf:StringBuf, v:String) : StringBuf
	{
		if (v != null)
			buf.add( "\n\t\t" + v + ";" );
		return buf;
	}
	
	
	
	
	private static function write (doc:StringBuf, content:ValueType) : String
	{
		switch (content)
		{
			case tString(v):				return "'" + v + "'";
			case tBool(v):					return v == true ? 'true' : 'false';
			case tObject(v):				return doc.writeObj(v);
			case tColor(rgb, a):			return "0x" + rgb.hex(6) + "" + a.hex(2);
			case tUInt(v):					return "0x" + v.hex(6);
			case tFunction(v):				return v;
			case tEnum(v, p):				return v + (p == null ? "" : "(" + p.format(doc) + ")");
			case tClass(v):					return v;
			case tFloat(v):					return v.string();
			
			case tEmpty(v):
				switch (v) {
					case eNull:				return "null";
					case eInt:				return "Number.INT_NOT_SET";
					case eFloat:			return "Number.FLOAT_NOT_SET";
					case eString:			return "''";
				}
			
			case tInt(v):
					 if (v == FILL_INT)		return "LayoutStyleFlags.FILL";
				else if (v == EMPTY_INT)	return "Number.EMPTY";
				else						return v.string();			
			
			case tCallStatic(o, m, p):		return doc.writeStaticCall(o, m, p);
			case tCallMethod(o, m, p):		return doc.writeMethodCall(o, m, p);
			case tSetProperty(o, n, v):		return doc.writeSetProperty(o, n, v);
		}
	}
	
	
	
	
	private static function writeObj (doc:StringBuf, v:Instance) : String
	{
		if (v.count == 0)
			return null;
		
		if (v.instantiated)
			return v.instName;
		
		var value		= new StringBuf();
		var a			= value.add;
		v.instantiated	= true;
		
		switch (v.type)
		{
			case object:			value.writeInstantiateObj( doc, v );
			case array:				value.writeInstantiateArray( doc, v );
			case objFactory(f, a2):
				var args = a2.writeArgs();
				a("function (");	a(args);	a(") { return "); value.writeInstantiateObj( doc, f, args ); a("; }");
			
			case arrayFactory(f, a2):
				var args = a2.writeArgs();
				a("function (");	a(args);	a(") { return "); value.writeInstantiateArray( doc, f, args ); a("; }");
		}
		
		if (v.count > 1)	return doc.writeVar( v, value );
		else				return value.toString();
	}
	
	
	
	
	private static inline function writeStaticCall (doc:StringBuf, cName:String, method:String, params:Array<ValueType>) : String
	{
		return cName + "." + method + "(" + params.format(doc) + ")";
	}
	
	
	
	
	private static inline function writeMethodCall (doc:StringBuf, v:ValueType, method:String, params:Array<ValueType>) : String
	{
		return (v != null ? doc.write(v) : "this") + "." + method + "(" + params.format(doc) + ")";
	}
	
	
	
	
	private static inline function writeSetProperty (doc:StringBuf, v:ValueType, prop:String, value:ValueType) : String
	{
		return (v != null ? doc.write(v) : "this") + "." + prop + " = " + doc.write(value);
	}
	
	
	
	
	private static inline function writeVar (doc:StringBuf, v:Instance, value:StringBuf) : String
	{
		var a			= doc.add;
		v.instName		= v.className.toVarName();
		
		doc.addLine( "var " + v.instName + " = " + value );
		return v.instName;
	}
	
	
	
	
	private static function format (params:Array<ValueType>, doc:StringBuf, extraParams:String = null) : String
	{
		var output = [];
		for (param in params)
			output.push( doc.write(param) );
		
		if (extraParams == "")
			extraParams = null;
		
		var p = output.join(", ");
		if (p != "" && extraParams != null)		p += ", " + extraParams;
		else if (extraParams != null)			p  = extraParams;
		
		return p;
	}
	
	
	
	private static function writeArgs (args:Array<String>) : String
	{
		return args == null ? "" : args.join(", ");
	}
	
	
	
	private static inline function writeInstantiateObj (line:StringBuf, doc:StringBuf, v:Instance, extraParams:String = null) : Void
	{
		var a = line.add;
		a("new ");
		a(v.className);
		a("(");
		a(v.params.format(doc, extraParams));
		a(")");
	}
	
	
	
	private static inline function writeInstantiateArray (line:StringBuf, doc:StringBuf, v:Instance, extraParams:String = null) : Void
	{
		var p = v.params.format(doc);
		if (p != "" && extraParams != null)		p += ", "+extraParams;
		else if (extraParams != null)			p  = extraParams;
		
		var a = line.add;
		a("[");
		a(v.params.format(doc, extraParams));
		a("]");
	}
	
	
	
	private static var instances : Int = 0;
	private static function toVarName (className:String) : String
	{
		//get class name without package stuff..
		var index:Int, name = className; //classRef.getClassName();
		
		while ( -1 != (index = name.indexOf(".")))
			name = name.substr( index + 1 );
		
		//make first char lowercase
		name = name.substr(0, 1).toLowerCase() + name.substr( 1 );
		
		//add a number at the end to make sure the varname is unique
		name += instances++;
		return name;
	}
}