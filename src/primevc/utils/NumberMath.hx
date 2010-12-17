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
 import apparat.math.FastMath;
  using Std;
 

/**
 * Math class for integers.
 * 
 * @creation-date	Jun 25, 2010
 * @author			Ruben Weijers
 */
class IntMath 
{
	/**
	 * Returns the biggest integer of the two given integers
	 * @param	var1
	 * @param	var2
	 * @return	biggest integer
	 */
	public static inline function max (var1:Int, var2:Int) : Int 
	{
		return var1 > var2 ? var1 : var2;
	}
	
	
	/**
	 * Returns the smallest integer of the two given integers
	 * @param	var1
	 * @param	var2
	 * @return	smallest integer
	 */
	public static inline function min (var1:Int, var2:Int) : Int
	{
		return var1 < var2 ? var1 : var2;
	}
	
	
	/**
	 * Math function to divide var1 with var2 and returning an floored integer.
	 * 
	 * @param	var1	Integer to divide
	 * @param	var2	Integer to divide with
	 * @return	result of the floored division
	 */
	public static inline function divFloor (var1:Int, var2:Int) : Int
	{
		return IntMath.floorFloat( var1 / var2 );
	//	return (var1 / var2).int();
	}
	
	
	
	/**
	 * Math function to divide var1 with var2 and returning an ceiled integer.
	 * 
	 * @param	var1	Integer to divide
	 * @param	var2	Integer to divide with
	 * 
	 * @return	result of the ceiled division
	 */
	public static inline function divCeil (var1:Int, var2:Int) : Int
	{
		return IntMath.ceilFloat( var1 / var2 );
		/*var intResult	= IntMath.divFloor(var1, var2);
		var floatResult	= var1 / var2;
		return (floatResult - intResult) > 0 ? intResult + 1 : intResult;*/
	}
	
	
	
	/**
	 * Math function to divide var1 with var2 and returning an rounded integer.
	 * 
	 * @param	var1	Integer to divide
	 * @param	var2	Integer to divide with
	 * @return	result of the rounded division
	 */
	public static inline function divRound (var1:Int, var2:Int) : Int
	{
		return IntMath.roundFloat( var1 / var2 );
	/*	var intResult	= IntMath.divFloor(var1, var2);
		var floatResult	= var1 / var2;
		return (floatResult - intResult) >= 0.5 ? intResult + 1 : intResult;*/
	}
	
	
	public static inline function isEven (val:Int) : Bool
	{
		return (val & 1) == 0;
	}
	
	
	
	public static inline function ceilFloat (var1:Float) : Int
	{
		return var1.int() + (var1 % 1 == 1 ? 1 : 0);
	}
	
	
	public static inline function floorFloat (var1:Float) : Int
	{
		return var1 < 0 ? (var1 - .9).int() : var1.int();
	}
	
	
	public static inline function roundFloat (var1:Float) : Int
	{
		return var1 < 0 ? -1 * floorFloat( -1 * var1 + .5) : floorFloat(var1 + .5);
	}
}





class FloatMath
{
	/**
	 * Returns the biggest float of the two given integers
	 * @param	var1
	 * @param	var2
	 * @return	biggest float
	 */
	public static inline function max (var1:Float, var2:Float) : Float
	{
		return var1 > var2 ? var1 : var2;
	}
	
	
	/**
	 * Returns the smallest integer of the two given integers
	 * @param	var1
	 * @param	var2
	 * @return	smallest integer
	 */
	public static inline function min (var1:Float, var2:Float) : Float
	{
		return var1 < var2 ? var1 : var2;
	}
}