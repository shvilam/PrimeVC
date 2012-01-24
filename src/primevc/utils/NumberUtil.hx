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
 import primevc.types.Number;
  using primevc.utils.NumberUtil;
  using Std;
 

/**
 * Quick convenience utilities for integers.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
extern class IntUtil
{
	/**
	 * Helper function which will return the int-value of the first parameter 
	 * as long as it is between the min and max values.
	 * 
	 * @param	value
	 * @param	min
	 * @param	max
	 */
	public static inline function within (value:Int, min:Int, max:Int) : Int {
		if (value < min)		value = min;
		else if (value > max)	value = max;
		return value;
	}
	
	
	/**
	 * Helper function to check of the given value is between the min and max 
	 * value.
	 * 
	 * @param	value
	 * @param	min
	 * @param	max
	 * @return	true or false
	 */
	public static inline function isWithin (value:Int, min:Int, max:Int) : Bool {
		return value >= min && value <= max;
	}
	
	
#if flash9
	public static inline function notSet (value:Int) : Bool		{ return value == Number.INT_NOT_SET; }
	public static inline function isSet (value:Int) : Bool		{ return value != Number.INT_NOT_SET; }
	public static inline function notEmpty (value:Int) : Bool	{ return value != Number.EMPTY; }
	public static inline function isEmpty (value:Int) : Bool	{ return value == Number.EMPTY; }
#else
	public static inline function notSet (value:Int) : Bool		{ return value == Number.INT_NOT_SET || value == null; }
	public static inline function isSet (value:Int) : Bool		{ return value != Number.INT_NOT_SET && value != null; }
#end
	
	public static inline function unset () : Int				{ return Number.INT_NOT_SET; }
	public static inline function getValue (v:Int) : Int		{ return v.isEmpty() ? Number.INT_NOT_SET : v; }
	
	public static inline function getBiggest (var1:Int, var2:Int) : Int		{ return IntMath.max(var1, var2); }
	public static inline function getSmallest (var1:Int, var2:Int) : Int	{ return IntMath.min(var1, var2); }
}




/**
 * Quick convenience utilities for floating point numbers.
 *
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
extern class FloatUtil
{
	/**
	 * Helper function which will return the float-value of the first parameter 
	 * as long as it is between the min and max values.
	 * 
	 * @param	value
	 * @param	min
	 * @param	max
	 */
	public static inline function within (value:Float, min:Float, max:Float) : Float {
		
		return if (value.notSet())	min;
		  else if (value < min)		min;
		  else if (value > max)		max;
		  else value;
	}
	
	
	/**
	 * Helper function to check of the given value is between the min and max 
	 * value.
	 * 
	 * @param	value
	 * @param	min
	 * @param	max
	 * @return	true or false
	 */
	public static inline function isWithin (value:Float, min:Float, max:Float) : Bool {
		return value >= min && value <= max;
	}
	
	
	public static inline function round (value:Float, precision:Int = 0) : Float {
		#if flash9 var Math = Math; /* cache the class reference */ #end
		return (Math.round(value * Math.pow(10, precision)) / Math.pow(10, precision));
	}
	
	
	public static inline function isEqualTo (value1:Float, value2:Float) : Bool
	{
		return value1 == value2 || (value1.notSet() && value2.notSet());
	}


	public static inline function notEqualTo (value1:Float, value2:Float) : Bool
	{
		return value1 != value2 && (value1.isSet() || value2.isSet());
	}


	public static inline function notSet (value:Float) : Bool	{ return !isSet(value); }
	public static inline function isSet  (value:Float) : Bool	{ return #if !flash9 value != null && #end /*!Math.isNaN(value)*/ (value == value) /* false if NaN )*/; }
	public static inline function notEmpty (value:Float) : Bool	{ return value != Number.EMPTY; }
	public static inline function isEmpty (value:Float) : Bool	{ return value == Number.EMPTY; }
	public static inline function unset () : Float				{ return Number.FLOAT_NOT_SET; }
	
	
	public static inline function getValue (v:Float) : Float	{ return v.isEmpty() ? Number.FLOAT_NOT_SET : v; }
	
	public static inline function getBiggest (var1:Float, var2:Float) : Float	{ return FloatMath.max(var1, var2); }
	public static inline function getSmallest (var1:Float, var2:Float) : Float	{ return FloatMath.min(var1, var2); }
}




/**
 * Math class for integers.
 * 
 * @creation-date	Jun 25, 2010
 * @author			Ruben Weijers
 */
extern class IntMath 
{
	/**
	 * Returns the absolute value, always >= 0
	 */
	public static inline function abs (x:Int) : Int
	{
		return #if neko (x ^ (x >> 30)) - (x >> 30) #else (x ^ (x >> 31)) - (x >> 31) #end;
	}
	
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
		return var1.isSet() && var1 < var2 ? var1 : var2;
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
		return (var1 % 1 == 0) ? var1.int() : var1.int() + 1; //var1.int() + (var1 > 0 ? 1 : 0);
	}
	
	
	public static inline function floorFloat (var1:Float) : Int
	{
		return var1 < 0 ? (var1 - .9).int() : var1.int();
	}
	
	
	public static inline function roundFloat (var1:Float) : Int
	{
		return ((var1 < 0 ? -.5 : .5) + var1).int();  //-1 * floorFloat( -1 * var1 + .5) : floorFloat(var1 + .5);		//OPTIMIZE!
	}
}





extern class FloatMath
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
	 * @return	smallest float
	 */
	public static inline function min (var1:Float, var2:Float) : Float
	{
		return var1 < var2 ? var1 : var2;
	}
}