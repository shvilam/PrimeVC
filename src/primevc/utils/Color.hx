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
 import primevc.types.RGBA;
  using primevc.utils.Color;
  using primevc.utils.IntUtil;
//  using Math;
  using Std;
  using StringTools;


class Color
{
	public static inline var BLACK		: UInt	= 0x000000;
	public static inline var WHITE		: UInt	= 0xFFFFFF;
	
	
	/**
	 * Returns a random color with an alpha value that is always 0xFF
	 */
	public static inline function random () : RGBA						{ return RGBAUtil.ALPHA_MASK | ((Math.random() * WHITE).int() << 8); }

	/**
	 * Blends to RGBA colors together.
	 */
	public static inline function blend (v:RGBA, v2:RGBA) : RGBA		{ return v | v2; }
	
	/**
	 * Makes sure that the given color is between BLACK and WHITE
	 */
	public static inline function validate( v:RGBA ) : UInt				{ return v.rgb().validate24Bit() << 8 | v.alpha().validate8Bit(); }
	public static inline function validate24Bit (v:UInt) : UInt			{ return v.within(BLACK, WHITE); }
	public static inline function validate8Bit (v:UInt) : UInt			{ return v.within(0x00, 0xFF); }
	
	/**
	 * Creates a RGBA object containing gray values.
	 * @example		Color.gray( 10 );		// 0x0A0A0AFF
	 */
	public static inline function gray( v:UInt ) : RGBA					{ return v << 24 | v << 16 | v << 8 | 0xFF; }
	
	/**
	 * Creates a RGBA object from single color values.
	 * @example		Color.create( 255, 255, 0 );	// = 0xFFFF00FF;
	 */
	public static inline function create (r:UInt = 0, g:UInt = 0, b:UInt = 0, a:UInt = 0xFF) : RGBA {
		return ( r << 24 | g << 16 | b << 8 | a ).validate();
	}
}


class RGBAUtil
{
	public static inline var ALPHA_MASK				: RGBA = 0x000000FF;
	public static inline var COLOR_MASK				: RGBA = 0xFFFFFF00;
	public static inline var RED_MASK				: RGBA = 0xFF000000;
	public static inline var GREEN_MASK				: RGBA = 0x00FF0000;
	public static inline var BLUE_MASK				: RGBA = 0x0000FF00;
	
	public static inline var INVERTED_ALPHA_MASK	: RGBA = 0xFFFFFF00;
	public static inline var INVERTED_COLOR_MASK	: RGBA = 0x000000FF;
	public static inline var INVERTED_RED_MASK		: RGBA = 0x00FFFFFF;
	public static inline var INVERTED_GREEN_MASK 	: RGBA = 0xFF00FFFF;
	public static inline var INVERTED_BLUE_MASK		: RGBA = 0xFFFF00FF;
	
	
	/**
	 * Returns the alpha value of a RGBA object as a Float.
	 */
	public static inline function alpha (v:RGBA) : UInt					{ return v & ALPHA_MASK; }
	/**
	 * Returns the RGB properties of a RGBA value as 0xRRGGBB.
	 */
	public static inline function rgb (v:RGBA) : UInt					{ return (v & COLOR_MASK) >>> 8; }
	/**
	 * Returns the red color from a RGBA value as 0xRR
	 */
	public static inline function red (v:RGBA) : UInt					{ return (v & RED_MASK) >>> 24; }
	/**
	 * Returns the green color from a RGBA value as 0xGG
	 */
	public static inline function green (v:RGBA) : UInt					{ return (v & GREEN_MASK) >>> 16; }
	/**
	 * Returns the blue color from a RGBA value as 0xBB
	 */
	public static inline function blue (v:RGBA) : UInt					{ return (v & BLUE_MASK) >>> 8; }
	
	
	/**
	 * Replaces the alpha value of a RGBA object.
	 */
	public static inline function setAlpha (v:RGBA, a:UInt) : RGBA		{ return (v & INVERTED_ALPHA_MASK) | a; }
	/**
	 * Replaces the RGB properties of a RGBA object.
	 */
	public static inline function setRgb (v:RGBA, c:UInt) : RGBA		{ return (v & INVERTED_COLOR_MASK) | (c << 8); }
	/**
	 * Replaces the red value of a RGBA object.
	 */
	public static inline function setRed (v:RGBA, r:UInt) : RGBA		{ return (v & INVERTED_RED_MASK) | (r << 24); }
	/**
	 * Replaces the green value of a RGBA object.
	 */
	public static inline function setGreen (v:RGBA, g:UInt) : RGBA		{ return (v & INVERTED_GREEN_MASK) | (g << 16); }
	/**
	 * Replaces the blue value of a RGBA object.
	 */
	public static inline function setBlue (v:RGBA, b:UInt) : RGBA		{ return (v & INVERTED_BLUE_MASK) | (b << 8); }
	
	
	
	/**
	 * Darkens the RGBA color by the gray-amount (0-255).
	 */
	public static inline function darken (v:RGBA, grayV:UInt) : RGBA	{ return ( v - Color.gray(grayV) ).validate(); }
	/**
	 * Lightens the RGBA color by the gray-amount (0-255).
	 */
	public static inline function lighten (v:RGBA, grayV:UInt) : RGBA	{ return ( v + Color.gray(grayV) ).validate(); }
	/**
	 * Changes the tint of the RGBA color to the given float value (0 - 1).
	 * @example		0xFF0000FF.tint(.5);	//gives: 0x7F0000FF
	 */
	public static inline function tint (v:RGBA, tint:Float) : RGBA {
		var r = (v.red() * tint).int();
		var g = (v.green() * tint).int();
		var b = (v.blue() * tint).int();
		var a = v.alpha();
		return Color.create(r, g, b, a);
	}
}



class FloatColorUtil
{	
	/**
	 * Converts two bytes to a Float. Only one color channel should be given as input.
	 */
	public static inline function float (v:UInt) : Float			{ return v / 255; }
	
	/**
	 * Converts the given float (0-1) to a uint.
	 */
	public static inline function uint (v:Float) : UInt				{ return (v * 255).int().validate8Bit(); }
}



class StringColorUtil
{	
	/**
	 * Converts a RGBA value to a hexadecimal string. 
	 */
	public static inline function string (v:RGBA) : String				{ return "0x"+v.rgb().hex(6) + v.alpha().hex(2); }
	/**
	 * Converts a hexadecimal string to a RGBA value
	 */
	public static inline function rgba (v:String) : RGBA				{ return v.parseInt().validate(); }
}