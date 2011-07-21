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



/**
 * @author	Ruben Weijers
 * @since	Jun 8, 2011
 */
enum ValueType
{
	tEmpty		(value:EmptyType);		// value indicated if it's an int, float, string or null value
	tString		(value:String);
	tInt		(value:Int);
	tUInt		(value:UInt);
	tFloat		(value:Float);
	tBool		(value:Bool);
	tEnum		(value:String, params:Array<ValueType>);
	tClass		(value:String);
	tObject		(value:Instance);		// array, object, objFactory or arrayFactory
	tColor		(rgb:Int, alpha:Int);
	tFunction	(value:String);			// reference to a function
	
	tCallStatic	(className:String, method:String, params:Array<ValueType>);
	tCallMethod	(on:ValueType, method:String, params:Array<ValueType>);
	tSetProperty(on:ValueType, prop:String, value:ValueType);
}


/**
 * @author	Ruben Weijers
 * @since	Jun 9, 2011
 */
enum EmptyType
{
	eNull;
	eString;
	eInt;
	eFloat;
}