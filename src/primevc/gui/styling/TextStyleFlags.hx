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
package primevc.gui.styling;
  using primevc.utils.BitUtil;



/**
 * @author Ruben Weijers
 * @creation-date Sep 08, 2010
 */
extern class TextStyleFlags
{
	public static inline var ALL_PROPERTIES		= SIZE | FAMILY | COLOR | WEIGHT | STYLE | LETTER_SPACING | ALIGN | DECORATION | INDENT | TRANSFORM | TEXTWRAP | COLUMN_COUNT | COLUMN_GAP | COLUMN_WIDTH | EMBEDDED;
	public static inline var COLUMN_PROPERTIES	= COLUMN_COUNT | COLUMN_GAP | COLUMN_WIDTH;
	
	public static inline var SIZE				= 1 << 0;
	public static inline var FAMILY				= 1 << 1;
	public static inline var COLOR				= 1 << 2;
	public static inline var WEIGHT				= 1 << 3;
	public static inline var STYLE				= 1 << 4;
	
	public static inline var LETTER_SPACING		= 1 << 5;
	public static inline var ALIGN				= 1 << 6;
	public static inline var DECORATION			= 1 << 7;
	public static inline var INDENT				= 1 << 8;
	public static inline var TRANSFORM			= 1 << 9;
	
	public static inline var TEXTWRAP			= 1 << 10;
	public static inline var COLUMN_COUNT		= 1 << 11;
	public static inline var COLUMN_GAP			= 1 << 12;
	public static inline var COLUMN_WIDTH		= 1 << 13;
	public static inline var EMBEDDED			= 1 << 14;
	
	
#if debug
	public static inline function readProperties (flags:Int) : String
	{
		var output	= [];
		
		if (flags.has( ALIGN ))				output.push("align");
		if (flags.has( COLOR ))				output.push("color");
		if (flags.has( COLUMN_COUNT ))		output.push("column-count");
		if (flags.has( COLUMN_GAP ))		output.push("column-gap");
		if (flags.has( COLUMN_WIDTH ))		output.push("column-width");
		if (flags.has( DECORATION ))		output.push("decoration");
		if (flags.has( FAMILY ))			output.push("family");
		if (flags.has( INDENT ))			output.push("indent");
		if (flags.has( LETTER_SPACING ))	output.push("letter-spacing");
		if (flags.has( SIZE ))				output.push("size");
		if (flags.has( STYLE ))				output.push("style");
		if (flags.has( TEXTWRAP ))			output.push("textwrap");
		if (flags.has( TRANSFORM ))			output.push("transform");
		if (flags.has( WEIGHT ))			output.push("weight");
		
		return output.length > 0 ? output.join(", ") : "none";
	}
#end
}