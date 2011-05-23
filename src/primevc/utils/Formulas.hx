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
 import primevc.utils.NumberUtil;
  using primevc.utils.Formulas;


/**
 * Collection of usefull math-formulas.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 27, 2010
 */
extern class Formulas
{
	/**
	 * Method will return the square of the given number
	 */
	public static inline function square (v:Float) : Float {
		return v * v;
	}
	
	
	/**
	 * Method for calculating the length of a and b by using Pythagoras theorem.
	 * 
	 *   |\
	 * a |  \  c
	 *   |   \
	 *   |____\
	 * 		 b
	 * 
	 * a2 = c2 - b2
	 */
	public static inline function pythagorasA (b:Float, c:Float) : Float {
		return FastMath.sqrt( c.square() - b.square() );
	}
	
	
	/**
	 * Method for calculating the length of c by using Pythagoras theorem.
	 * 
	 *   |\
	 * a |  \  c
	 *   |   \
	 *   |____\
	 * 		 b
	 * 
	 * c2 = a2 + b2
	 */
	public static inline function pythagorasC (a:Float, b:Float) : Float {
		return FastMath.sqrt( a.square() + b.square() );
	}
	
	
	/**
	 * returns the radius for a circle with the given width and height. The 
	 * smallest value of these two will be used to calculate the circle.
	 */
	public static inline function getCircleRadius (width:Float, height:Float) : Float {
		return FloatMath.min( width * .5, height * .5 );
	}
	
	
	public static inline function radiansToDegrees (radians:Float) : Float {
		return radians * FastMath.RAD_DEGREE;
	}
	
	
	public static inline function degreesToRadians (degrees:Float) : Float {
		return degrees * FastMath.DEGREE_RAD;
	}
	
	
	public static inline function getCirclePerimeter (radius:Float) : Float {
		return radius * FastMath.DOUBLE_PI;
	}
	
	
	/**
	 * Method will return the radius of a polygon that is needed to cover a circle.
	 * 
	 * This is useful if you want to draw a part of a masked polygon to fill a
	 * piece of circle. Using the radius of the circle would leave a part of the
	 * circle uncovered.
	 * 
	 * @param	radius		radius of the circle to cover
	 * @param	sides		sides of the polygon
	 * @return 	radius of the polygon to cover the circle
	 */
	public static inline function polygonRadiusForCircle( radius:Float, sides:Int ) : Float
	{
		return radius / FastMath.cos( (1 / sides) * FastMath.PI);
	}
}