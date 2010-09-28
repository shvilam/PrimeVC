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
package primevc.neko.utils;
 import primevc.types.RGBA;
  using primevc.neko.utils.Color;
  using primevc.utils.NumberUtil;
  using Std;
  using StringTools;



/**
 * Neko RGBA ColorUtil implementation.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 10, 2010
 */
class Color
{
	public static inline var BLACK					: UInt	= 0x000000;
	public static inline var WHITE					: UInt	= 0xFFFFFF;
	public static inline var ALPHA_MASK				: UInt = 0xFF;
	public static inline var COLOR_MASK				: UInt = 0xFFFFFF;
	public static inline var RED_MASK				: UInt = 0xFF0000;
	public static inline var GREEN_MASK				: UInt = 0x00FF00;
	public static inline var BLUE_MASK				: UInt = 0x0000FF;

	public static inline var INVERTED_ALPHA_MASK	: UInt = 0x00;
	public static inline var INVERTED_COLOR_MASK	: UInt = 0x000000;
	public static inline var INVERTED_RED_MASK		: UInt = 0x00FFFF;
	public static inline var INVERTED_GREEN_MASK 	: UInt = 0xFF00FF;
	public static inline var INVERTED_BLUE_MASK		: UInt = 0xFFFF00;


	/**
	 * Returns a random color with an alpha value that is always 0xFF
	 */
	public static inline function random () : RGBA						{ return {color: (Math.random() * WHITE).int(), a: ALPHA_MASK}; }

	/**
	 * Blends to RGBA colors together.
	 */
	public static inline function blend (v:RGBA, v2:RGBA) : RGBA		{ v.color |= v2.color; v.a |= v2.a; return v; }
	public static inline function blendUInt (v:UInt, v2:UInt) : UInt	{ return v | v2; }

	/**
	 * Makes sure that the given color is between BLACK and WHITE
	 */
	public static inline function validate( v:RGBA ) : RGBA				{ v.color = v.color.validate16Bit(); v.a = v.a.validate8Bit(); return v; }
	public static inline function validate16Bit (v:UInt) : UInt			{ return v.within(BLACK, WHITE); }
	public static inline function validate8Bit (v:UInt) : UInt			{ return v.within(0x00, 0xFF); }

	/**
	 * Creates a RGBA object containing gray values.
	 * @example		Color.gray( 10 );		// 0x0A0A0AFF
	 */
	public static inline function gray( v:UInt ) : RGBA					{ return {color: v << 16 | v << 8 | v, a: 0xFF}; }

	/**
	 * Creates a RGBA object from single color values.
	 * @example		Color.create( 255, 255, 0 );	// = 0xFFFF00FF;
	 */
	public static inline function create (r:UInt = 0, g:UInt = 0, b:UInt = 0, a:UInt = 0xFF) : RGBA {
		return {color: ( r << 16 | g << 8 | b ), a: a }.validate();
	}
	
	
	/**
	 * Returns the alpha value of a RGBA object as a UInt.
	 */
	public static inline function alpha (v:RGBA) : UInt					{ return v.a; }
	/**
	 * Returns the RGB properties of a RGBA value as 0xRRGGBB.
	 */
	public static inline function rgb (v:RGBA) : UInt					{ return v.color; }
	/**
	 * Returns the red color from a RGBA value as 0xRR
	 */
	public static inline function red (v:RGBA) : UInt					{ return (v.color & RED_MASK) >>> 16; }
	/**
	 * Returns the green color from a RGBA value as 0xGG
	 */
	public static inline function green (v:RGBA) : UInt					{ return (v.color & GREEN_MASK) >>> 8; }
	/**
	 * Returns the blue color from a RGBA value as 0xBB
	 */
	public static inline function blue (v:RGBA) : UInt					{ return v.color & BLUE_MASK; }


	/**
	 * Replaces the alpha value of a RGBA object.
	 */
	public static inline function setAlpha (v:RGBA, a:UInt) : RGBA		{ v.a = a; return v; }
	/**
	 * Replaces the RGB properties of a RGBA object.
	 */
	public static inline function setRgb (v:RGBA, c:UInt) : RGBA		{ v.color = c; return v; }
	/**
	 * Replaces the red value of a RGBA object.
	 */
	public static inline function setRed (v:RGBA, r:UInt) : RGBA		{ v.color = (v.color & INVERTED_RED_MASK) | (r << 16); return v; }
	/**
	 * Replaces the green value of a RGBA object.
	 */
	public static inline function setGreen (v:RGBA, g:UInt) : RGBA		{ v.color = (v.color & INVERTED_GREEN_MASK) | (g << 8); return v; }
	/**
	 * Replaces the blue value of a RGBA object.
	 */
	public static inline function setBlue (v:RGBA, b:UInt) : RGBA		{ v.color = (v.color & INVERTED_BLUE_MASK) | b; return v; }



	/**
	 * Darkens the RGBA color by the gray-amount (0-255).
	 */
	public static inline function darken (v:RGBA, grayV:UInt) : RGBA	{ v.color = v.color - Color.gray(grayV).color; return v.validate(); }
	/**
	 * Lightens the RGBA color by the gray-amount (0-255).
	 */
	public static inline function lighten (v:RGBA, grayV:UInt) : RGBA	{ v.color = v.color + Color.gray(grayV).color; return v.validate(); }
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
	
	
	/**
	 * Converts two bytes to a Float. Only one color channel should be given as input.
	 */
	public static inline function float (v:UInt) : Float			{ return v / 255; }

	/**
	 * Converts the given float (0-1) to a uint.
	 */
	public static inline function uint (v:Float) : UInt				{ return (v * 255).int().validate8Bit(); }
	
	
	/**
	 * Converts a RGBA value to a hexadecimal string. 
	 */
	public static inline function string (v:RGBA) : String			{ return rgbaToString(v); }
	public static inline function rgbaToString (v:RGBA) : String	{ return "0x"+v.color.hex(6) + v.a.hex(2); }
	public static inline function uintToString (v:UInt) : String	{ return "0x"+v.hex(6); }
	/**
	 * Converts a hexadecimal string to a RGBA value
	 */
	public static inline function rgba (v:String) : RGBA
	{
		var a = ALPHA_MASK;
		
		if (v.length == 3)
			v += v;
		else if (v.length == 8)
		{
			a = ("0x" + v.substr(6)).parseInt();
			v = v.substr(0, 6);
		}
		
		return {color: ("0x" + v).parseInt(), a: a }.validate();
	}
}