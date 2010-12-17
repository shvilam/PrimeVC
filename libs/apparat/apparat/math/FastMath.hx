/*
 * This file is part of Apparat.
 *
 * Apparat is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Apparat is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Apparat. If not, see <http://www.gnu.org/licenses/>.
 *
 * Copyright (C) 2010 Joa Ebert
 * http://www.joa-ebert.com/
 *
 */
package apparat.math;
#if flash10
 import flash.Memory;
#end
  using apparat.math.FastMath;
  using Std;


/**
 * The FastMath class defines fast functions to work with Floats.
 *
 * FastMath functions are inlined by Apparat. Trigonometric functions
 * are only approximations. However all approximations should have an error
 * less than <code>0.008</code>.
 *
 * @author Joa Ebert
 * 
 * //TODO use apparat's memory class instead of the flash class
 * //TODO write a js implementation for the Memory using methods
 */
class FastMath
{
	public static inline var PI			: Float = 3.14159265;
	public static inline var HALVE_PI	: Float = 1.57079632;
	public static inline var DOUBLE_PI	: Float	= 6.28318531;
	
	public static inline var RAD_DEGREE	: Float = 180 / PI;
	public static inline var DEGREE_RAD	: Float = PI / 180;
	
	public static inline var INV_SQRT	: Float = 0x5f3759df;
	
	
#if flash10
	public static function __init__() : Void
	{
		var byteArray = new flash.utils.ByteArray();
		byteArray.length = flash.system.ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
		Memory.select(byteArray);
	}
#end
	
	
	/**
	 * Computes and returns the sine of the specified angle in radians.
	 *
	 * To calculate a radian, see the overview of the Math class.
	 *
	 * This method is only a fast sine approximation.
	 *
	 * @param angleRadians A float that represents an angle measured in radians.
	 * @return A float from -1.0 to 1.0.
	 */
	public static inline function sin(angleRadians: Float): Float
	{
		//
		// http://lab.polygonal.de/wp-content/articles/fast_trig/fastTrig.as
		//

		angleRadians += (DOUBLE_PI * (angleRadians < -PI).float()) - DOUBLE_PI * (angleRadians > PI).float();
		var sign:Float = (1.0 - ((angleRadians > 0.0).int() << 1));
		angleRadians = (angleRadians * (1.27323954 + sign * 0.405284735 * angleRadians));
		sign = (1.0 - ((angleRadians < 0.0).int() << 1));
		return angleRadians * (sign * 0.225 * (angleRadians - sign) + 1.0);
	}

	
	/**
	 * Computes and returns the cosine of the specified angle in radians.
	 *
	 * To calculate a radian, see the overview of the Math class.
	 *
	 * This method is only a fast cosine approximation.
	 *
	 * @param angleRadians A float that represents an angle measured in radians.
	 * @return A float from -1.0 to 1.0.
	 */
	public static inline function cos(angleRadians: Float): Float
	{
		//
		// http://lab.polygonal.de/wp-content/articles/fast_trig/fastTrig.as
		//

		angleRadians += (DOUBLE_PI * (angleRadians < -PI).float()) - DOUBLE_PI * (angleRadians > PI).float();
		angleRadians += HALVE_PI;
		angleRadians -= DOUBLE_PI * (angleRadians > PI).float();

		var sign:Float = (1.0 - ((angleRadians > 0.0).int() << 1));
		angleRadians = (angleRadians * (1.27323954 + sign * 0.405284735 * angleRadians));
		sign = (1.0 - ((angleRadians < 0.0).int() << 1));
		return angleRadians * (sign * 0.225 * (angleRadians - sign) + 1.0);
	}
	

	/**
	 * Computes and returns the angle of the poInt <code>y/x</code> in radians, when measured counterclockwise
	 * from a circle's <em>x</em> axis (where 0,0 represents the center of the circle).
	 * The return value is between positive pi and negative pi.
	 *
	 * @author Eugene Zatepyakin
	 * @author Joa Ebert
	 * @author Patrick Le Clec'h
	 *
	 * @param y A float specifying the <em>y</em> coordinate of the poInt.
	 * @param x A float specifying the <em>x</em> coordinate of the poInt.
	 *
	 * @return A float.
	 */
	public static inline function atan2(y:Float, x:Float):Float
	{
		var sign:Float = 1.0 - ((y < 0.0).int() << 1);
		var absYandR:Float = y * sign + 2.220446049250313e-16;
		var partSignX:Float = ((x < 0.0).int() << 1); // [0.0/2.0]
		var signX:Float = 1.0 - partSignX; // [1.0/-1.0]
		absYandR = (x - signX * absYandR) / (signX * x + absYandR);
		return ((partSignX + 1.0) * 0.7853981634 + (0.1821 * absYandR * absYandR - 0.9675) * absYandR) * sign;
	}


	/**
	 * Computes and returns an absolute value.
	 *
	 * @param value The float whose absolute value is returned.
	 * @return The absolute value of the specified parameter.
	 */
	public static inline function abs(value: Float): Float
	{
		return value * (1.0 - ((value < 0.0).int() << 1));
	}


	/**
	 * Computes and returns the sign of the value.
	 *
	 * @param value The float whose sign value is returned.
	 * @return The -1.0 if value<0.0 or 1.0 if value >=0.0 .
	 */
	public static inline function sign(value: Float): Float
	{
		return (1.0 - ((value < 0.0).int() << 1));
	}
	

	/**
	 * Returns the smallest value of the given parameters.
	 *
	 * @param value0 A float.
	 * @param value1 A float.
	 * @return The smallest of the parameters <code>value0</code> and <code>value1</code>.
	 */
	public static inline function min(value0: Float, value1: Float): Float
	{
		return (value0 < value1) ? value0 : value1;
	}


	/**
	 * Returns the largest value of the given parameters.
	 *
	 * @param value0 A float.
	 * @param value1 A float.
	 * @return The largest of the parameters <code>value0</code> and <code>value1</code>.
	 */
	public static inline function max(value0: Float, value1: Float): Float
	{
		return (value0 > value1) ? value0 : value1;
	}


	/**
	 * Computes and returns the square root of the specified float.
	 *
	 * <p><b>Note:</b>Calling this function will overwrite the first
	 * four bytes of the ApplicationDomain.domainMemory ByteArray. It is
	 * required that such a ByteArray exists.</p>
	 *
	 * @param value A float or expression greater than or equal to 0.
	 * @see initMemory
	 * @return If the parameter val is greater than or equal to zero, a float; otherwise NaN (not a float).
	 * @throws TypeError If no <code>ApplicationDomain.domainMemory</code> has been set.
	 */
	public static inline function sqrt(value: Float): Float
	{
#if flash10
		var originalValue: Float = value;
		var halfValue: Float = value * 0.5;
		var i: Int = 0;
		
		if (value > 0.0)
		{
			Memory.setFloat(0, value);
			i = INV_SQRT - (Memory.getI32(0) >> 1);
			Memory.setI32(0, i);
			value = Memory.getFloat(0);
			value = originalValue * value * (1.5 - halfValue * value * value);
		}
		else if(value < 0.0)
			value = Math.NaN;
		
		return value;
#else
		return Math.sqrt(value);
#end
	}

	
#if flash10
	/**
	 * Computes and returns the reciprocal of the square root for the specified float.
	 *
	 * <p><b>Note:</b>Calling this function will overwrite the first
	 * four bytes of the ApplicationDomain.domainMemory ByteArray. It is
	 * required that such a ByteArray exists.</p>
	 *
	 * @param value A float or expression greater than or equal to 0.
	 * @return If the parameter val is greater than or equal to zero, a float; otherwise NaN (not a float).
	 * @see initMemory
	 * @throws TypeError If no <code>ApplicationDomain.domainMemory</code> has been set.
	 */
	public static inline function rsqrt(value: Float): Float
	{
		var halfValue: Float = value * 0.5;
		var i: Int = 0;
		
		if(value == 0.0)
			return 0.0;
		else if(value < 0.0)
			return Math.NaN;
		
		Memory.setFloat(0, value);
		i = INV_SQRT - (Memory.getI32(0) >> 1);
		Memory.setI32(0, i);
		value = Memory.getFloat(0);
		
		return value * (1.5 - halfValue * value * value);
	}

	
	/**
	 * Computes and returns the square root of the specified float.
	 *
	 * The address parameter should be a poInter to a <code>char[4]</code> in 
	 * the Alchemy memory buffer.
	 * 
	 * @param value A float or expression greater than or equal to 0.
	 * @param address The address in the Alchemy memory buffer.
	 * @return If the parameter val is greater than or equal to zero, a float; otherwise NaN (not a float).
	 * @throws TypeError If no <code>ApplicationDomain.domainMemory</code> has been set.
	 */
	public static inline function sqrt2(value: Float, address: Int): Float
	{
		var originalValue: Float = value;
		var halfValue: Float = value * 0.5;
		var i: Int = 0;
		
		if(value == 0.0)
			return 0.0;
		else if(value < 0.0)
			return Math.NaN;
		
		Memory.setFloat(address, value);
		i = INV_SQRT - (Memory.getI32(address) >> 1);
		Memory.setI32(address, i);
		value = Memory.getFloat(address);
		
		return originalValue * value * (1.5 - halfValue * value * value);
	}
	

	/**
	 * Computes and returns the reciprocal of the square root for the specified float.
	 *
	 * The address parameter should be a poInter to a <code>char[4]</code> in 
	 * the Alchemy memory buffer.
	 * 
	 * @param value A float or expression greater than or equal to 0.
	 * @param address The address in the Alchemy memory buffer.
	 * @return If the parameter val is greater than or equal to zero, a float; otherwise NaN (not a float).
	 * @see initMemory
	 * @throws TypeError If no <code>ApplicationDomain.domainMemory</code> has been set.
	 */
	public static inline function rsqrt2 (value: Float, address: Int): Float
	{
		var halfValue: Float = value * 0.5;
		var i: Int = 0;
		
		if(value == 0.0)
			return 0.0
		else if(value < 0.0)
			return Math.NaN;
		
		Memory.setFloat(address, value);
		i = INV_SQRT - (Memory.getI32(address) >> 1);
		Memory.setI32(address, i);
		value = Memory.getFloat(address);
		
		return value * (1.5 - halfValue * value * value);
	}
#end
	
	
	/**
	 * Integer cast with respect to its sign.
	 * 
	 * @param value A float.
	 * @return The float casted to an Integer with respect to its sign.
	 */
	public static inline function rInt (value: Float): Int
	{
		return (value + 0.5 - (value < 0).float()).int();
	}
	

	/**
	 * Test if a Float is not a Float.
	 *
	 * @param value A float.
	 * @return true if value is not a Float.
	 */
	public static inline function isNaN(n:Float):Bool
	{
		return n != n;
	}
}





/**
 * @author	Ruben Weijers
 * @since	Dec 15, 2010
 */
class IntTypeUtil
{
	public static inline function int (v:Bool) : Int
	{
		return	#if (js || flash9)	untyped v  // single iffalse AVM2 instruction
				#else				v ? 1 : 0
				#end ;
	}
}



/**
 * @author	Ruben Weijers
 * @since	Dec 15, 2010
 */
class FloatTypeUtil
{
	public static inline function float (v:Bool) : Float
	{
		return	#if (js || flash9)	untyped v  // single iffalse AVM2 instruction
				#else				v ? 1.0 : 0.0
				#end ;
	}
}