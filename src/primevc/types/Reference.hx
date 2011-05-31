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
package primevc.types;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.types.Factory;


enum Reference {
	func			(name:String, cssValue:String);						//function reference
	objInstance		(obj:Factory<Dynamic>);								//reference to a class-object that will be instantiated
	classInstance	(name:String, p:Array<Dynamic>, cssValue:String);	//reference to a classname that will be instantiated
	className		(name:String, cssValue:String);						//reference to a class in string form
}


#if neko
class ReferenceUtil
{
	public static inline function toCSS (ref:Reference) : String
	{
		return switch (ref) {
			case className (name, css):			css != null ? css : "Class( " + name + " )";
			case objInstance (factory):			factory.toCSS();
			case classInstance (name, p, css):	css != null ? css : name;
			case func (name, css):				css != null ? css : "unkown-function";
		}
	}
	
	
	public static inline function toCode (ref:Reference, code:ICodeGenerator) : String
	{
		switch (ref) {
			case className ( name, css ):			return name;
			case objInstance ( factory ):			code.construct( factory ); return code.varName(factory); //code.createClassConstructor( factory.classRef, factory.params );
			case classInstance ( name, p, css ):	return code.createClassNameConstructor( name, p );
			case func ( name, css ):				return name;
		}
	}
}
#end