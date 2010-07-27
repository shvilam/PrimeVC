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
  using primevc.utils.Formulas;


/**
 * Collection of usefull math-formulas.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 27, 2010
 */
class Formulas
{
	public static inline var RAD_DEGREE = 180 / Math.PI;
	public static inline var DEGREE_RAD = Math.PI / 180;
	
	
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
		return Math.sqrt( c.square() - b.square() );
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
		return Math.sqrt( a.square() + b.square() );
	}
	
	
	/**
	 * returns the radius for a circle with the given width and height. The 
	 * smallest value of these two will be used to calculate the circle.
	 */
	public static inline function getCircleRadius (width:Float, height:Float) : Float {
		return Math.min( width * .5, height * .5 );
	}
	
	
	public static inline function radiansToDegrees (radians:Float) : Float {
		return radians * RAD_DEGREE;
	}
	
	
	public static inline function degreesToRadians (degrees:Float) : Float {
		return degrees * DEGREE_RAD;
	}
}