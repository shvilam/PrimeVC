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
package primevc.utils;


/**
 * Bunch of utility functions for faster/smaller if statements
 * 
 * @author Danny Wilson
 * @creation-date nov 29, 2010
 */
extern class IfUtil
{
	/**
	 * Helper function to use in expressions, to check in the fastest way possible if an object reference is not null.
	 * 
	 * @param	value
	 * @return	true when value != null
	 */
	static inline public function notNull (obj:Dynamic) : Bool
	{
		return	#if (js || flash9)	untyped obj  // single iffalse AVM2 instruction
				#else				obj != null
				#end ;
	}
	
	
	/**
	 * Helper function to use in expressions, to check in the fastest way possible if an object reference is null.
	 * 
	 * @param	value
	 * @return	true when value != null
	 */
	static inline public function isNull (obj:Dynamic) : Bool
	{
		return	#if (js || flash9)	!(untyped obj)  // single if true AVM2 instruction
				#else				obj == null
				#end ;
	}
	
	/**
	 * Helper function to use booleans (true == 1, false == 0) in arithmetic expressions, for example true + true == 2
	 * 
	 * @param	value
	 * @return	true when value != null
	 */
	static inline public function boolCalc (value:Bool) : Int
	{
		return	#if (js || flash9)	untyped value  // single iffalse AVM2 instruction
				#else				value? 1 : 0
				#end ;
	}
	
	/**
	 * Helper function to use in expressions, to check in the fastest way possible if a positive/unsigned integer != 0.
	 * 
	 * @param	value
	 * @return	AVM2: true when value > 0
	 * @return	Others: true when value != 0
	 */
	public static inline function not0 (value:Int) : Bool
	{
		return	#if (js || flash9)	untyped value  // single iffalse AVM2 instruction
				#else				value != 0
				#end ;
	}
}