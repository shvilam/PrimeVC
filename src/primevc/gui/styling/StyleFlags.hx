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
 * @creation-date Sep 05, 2010
 */
class StyleFlags
{
	public static inline var ALL_PROPERTIES		: UInt = LAYOUT | FONT | SKIN | BACKGROUND | FONT | BORDER | EFFECTS | SHAPE | BOX_FILTERS | BACKGROUND_FILTERS | VISIBLE | OPACITY | ICON | OVERFLOW | STATES;
	public static inline var INHERETING_STYLES	: UInt = NESTING_STYLE | SUPER_STYLE | EXTENDED_STYLE | PARENT_STYLE;
	
	public static inline var NESTING_STYLE		: UInt = 1;
	public static inline var SUPER_STYLE		: UInt = 2;
	public static inline var EXTENDED_STYLE		: UInt = 4;
	public static inline var PARENT_STYLE		: UInt = 8;
	
	public static inline var LAYOUT				: UInt = 16;
	public static inline var FONT				: UInt = 32;
	public static inline var SKIN				: UInt = 64;
	
	public static inline var BACKGROUND			: UInt = 128;
	public static inline var BORDER				: UInt = 256;
	public static inline var EFFECTS			: UInt = 512;
	public static inline var SHAPE				: UInt = 1024;
	public static inline var BOX_FILTERS		: UInt = 2048;
	public static inline var BACKGROUND_FILTERS	: UInt = 4096;
	
	public static inline var VISIBLE			: UInt = 8192;
	public static inline var OPACITY			: UInt = 16384;
	public static inline var ICON				: UInt = 32768;
	public static inline var OVERFLOW			: UInt = 65536;
	public static inline var STATES				: UInt = 131072;
	
	
#if debug
	static public function readProperties (flags:UInt) : String
	{
		var output	= [];
		var result	= "";
		
		if (flags > 0)
		{
			if (flags.has( BACKGROUND ))			output.push("background");
			if (flags.has( BACKGROUND_FILTERS ))	output.push("background-filters");
			if (flags.has( BORDER ))				output.push("border");
			if (flags.has( BOX_FILTERS ))			output.push("box-filters");
			if (flags.has( EFFECTS ))				output.push("effects");
			if (flags.has( EXTENDED_STYLE ))		output.push("extended-style");
			if (flags.has( FONT ))					output.push("font");
			if (flags.has( ICON ))					output.push("icon");
			if (flags.has( LAYOUT ))				output.push("layout");
			if (flags.has( NESTING_STYLE ))			output.push("nesting-style");
			if (flags.has( OPACITY ))				output.push("opacity");
			if (flags.has( OVERFLOW ))				output.push("overflow");
			if (flags.has( PARENT_STYLE ))			output.push("parent-style");
			if (flags.has( SHAPE ))					output.push("shape");
			if (flags.has( SKIN ))					output.push("skin");
			if (flags.has( STATES ))				output.push("states");
			if (flags.has( SUPER_STYLE ))			output.push("super-style");
			if (flags.has( VISIBLE ))				output.push("visible");
			result = output.join(", ");
		}
		return "properties: " + result;
	}
#end
}