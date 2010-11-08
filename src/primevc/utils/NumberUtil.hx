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
 import primevc.types.Number;
 import primevc.utils.NumberMath;
 

/**
 * Quick convenience utilities for integers.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class IntUtil
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
	public static inline function notSet (value:Int) : Bool	{ return value == Number.INT_NOT_SET; }
	public static inline function isSet (value:Int) : Bool	{ return value != Number.INT_NOT_SET; }
#else
	public static inline function notSet (value:Int) : Bool	{ return value == Number.INT_NOT_SET || value == null; }
	public static inline function isSet (value:Int) : Bool	{ return value != Number.INT_NOT_SET && value != null; }
#end
	
	public static inline function unset () : Int			{ return Number.INT_NOT_SET; }
	
	public static inline function getBiggest (var1:Int, var2:Int) : Int		{ return IntMath.max(var1, var2); }
	public static inline function getSmallest (var1:Int, var2:Int) : Int	{ return IntMath.min(var1, var2); }
}




/**
 * Quick convenience utilities for floating point numbers.
 *
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class FloatUtil
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
	public static inline function isWithin (value:Float, min:Float, max:Float) : Bool {
		return value >= min && value <= max;
	}
	
	
	public static inline function round (value:Float, precision:Int = 0) : Float {
		value = value * Math.pow(10, precision);
		value = Math.round(value) / Math.pow(10, precision);
		return value;
	}


	public static inline function notSet (value:Float) : Bool	{ return !isSet(value); }
	public static inline function isSet  (value:Float) : Bool	{ return #if !flash9 value != null && #end (value == value) /* false if NaN )*/; }
	public static inline function unset () : Float				{ return Number.FLOAT_NOT_SET; }
	
	
	public static inline function getBiggest (var1:Float, var2:Float) : Float	{ return FloatMath.max(var1, var2); }
	public static inline function getSmallest (var1:Float, var2:Float) : Float	{ return FloatMath.min(var1, var2); }
}