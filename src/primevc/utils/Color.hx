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

#if neko
typedef Color = primevc.neko.utils.Color;
#else
 import primevc.types.RGBA;
  using primevc.utils.Color;
  using primevc.utils.NumberUtil;
//  using Math;
  using Std;
  using StringTools;


extern class Color
{
	public static inline var BLACK		= 0x000000;
	public static inline var WHITE		= 0xFFFFFF;
	
	
	/**
	 * Returns a random color with an alpha value that is always 0xFF
	 */
	public static inline function random () : RGBA						{ return RGBAUtil.ALPHA_MASK | ((Math.random() * WHITE).int() << 8); }

	/**
	 * Blends to RGBA colors together.
	 */
	public static inline function blend (v1:RGBA, v2:RGBA) : RGBA
	{
		//add each channel of the colors and divide them by 2
		var r = (v1.red()	+ v2.red())		>> 1;
		var g = (v1.green()	+ v2.green())	>> 1;
		var b = (v1.blue()	+ v2.blue())	>> 1;
		var a = (v1.alpha()	+ v2.alpha())	>> 1;
		return Color.create(r, g, b, a);
	}
	
	/**
	 * Blends two RGBA colors together with the given alpha. The returned RGBA
	 * value has an alpha of 100%
	 */
	public static inline function alphaBlendColors (v1:RGBA, v2:RGBA, alpha:Float) : RGBA
	{
		var invAlpha = 1 - alpha;
		return create(
			 	(alpha * v1.red()).int()	+ (invAlpha * v2.red()).int(),
				(alpha * v1.green()).int()	+ (invAlpha * v2.green()).int(),
				(alpha * v1.blue()).int()	+ (invAlpha * v2.blue()).int()
		);
	}
	
	
	/**
	 * Blends a RGBA color together with the given alpha. The returned RGBA
	 * value has an alpha of 100%
	 */
	public static inline function alphaBlend (v:RGBA, alpha:Float) : RGBA
	{
		return v.setAlpha(0xFF).tint( alpha );
	}
	
	
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
	
	/**
	 * Creates a RGBA color from a rgb value
	 */
	public static inline function rgbToRgba (rgb:UInt) : RGBA			{ return rgb << 8 | 0xFF; }
	/**
	 * Creates a RGBA color from a ARGB value
	 */
	public static inline function argbToRgba (argb:UInt) : RGBA			{ return argb << 8 | argb >> 24; }
	/**
	 * Creates a ARGB color from a RGBA value
	 */
	public static inline function argb (rgba:RGBA) : UInt				{ return (rgba >> 8) | rgba << 24; }
}


extern class RGBAUtil
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
	 * Returns the alpha value of a RGBA object as a UInt.
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
	public static inline function setRgb (v:RGBA, c:UInt) : RGBA		{ return (c & COLOR_MASK) | (v & INVERTED_COLOR_MASK); }
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
		return Color.create(
			(v.red() * tint).int(),
			(v.green() * tint).int(),
			(v.blue() * tint).int(),
			v.alpha()
		);
	}
}



extern class FloatColorUtil
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



extern class StringColorUtil
{
	public static inline var L1		= 0xF;
	public static inline var L2		= 0xFF;
	public static inline var L3		= 0xFFF;
	public static inline var L4		= 0xFFFF;
	public static inline var L5		= 0xFFFFF;
	public static inline var L6		= 0xFFFFFF;
	public static inline var L7		= 0xFFFFFFF;
	public static inline var L8		= 0xFFFFFFFF;
	
	/**
	 * Converts a RGBA value to a hexadecimal string. 
	 */
	public static inline function string (v:RGBA) : String			{ return rgbaToString(v); }
	public static inline function rgbaToString (v:RGBA) : String	{ return "0x"+v.rgb().hex(6) + v.alpha().hex(2); }
	public static inline function rgbToString (v:RGBA) : String		{ return "0x"+v.rgb().hex(6); }
	public static inline function uintToString (v:Int) : String
	{
		var h =  if (v < L1)	v.hex(1);
			else if (v < L2)	v.hex(2);
			else if (v < L3)	v.hex(3);
			else if (v < L4)	v.hex(4);
			else if (v < L5)	v.hex(5);
			else if (v < L6)	v.hex(6);
			else if (v < L7)	v.hex(7);
			else if (v < L8)	v.hex(8);
			else				v.hex();
		
		return "0x"+h;
	}
	
	/**
	 * Converts a hexadecimal string to a RGBA value
	 */
	public static inline function rgba (v:String) : RGBA
	{
		if (v.length == 3)
			v = v.charAt(0) + v.charAt(0) + v.charAt(1) + v.charAt(1) + v.charAt(2) + v.charAt(2);
		
		if (v.length == 6)
			v += "FF";
		
		return ("0x"+v).parseInt().validate();
	}
}
#end