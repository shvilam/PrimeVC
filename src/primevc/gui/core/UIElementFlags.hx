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
package primevc.gui.core;
  using primevc.utils.BitUtil;


/**
 * Flags used in UIElements
 * 
 * @author Ruben Weijers
 * @creation-date Nov 19, 2010
 */
#if !debug extern #end class UIElementFlags
{
	public static inline var LAYOUT			= 1 << 0;
	public static inline var GRAPHICS		= 1 << 1;
	public static inline var STYLE			= 1 << 2;
	
	
	public static inline var DATA			= 1 << 3;
	public static inline var STATE			= 1 << 4;
	
	//
	// UITEXTFIELD PROPERTIES
	//
	
	public static inline var TEXT			= 1 << 5;
	public static inline var RESTRICT		= 1 << 6;
	public static inline var MAX_CHARS		= 1 << 7;
	public static inline var TEXTSTYLE		= 1 << 8;
	public static inline var DISPLAY_HTML	= 1 << 9;
	public static inline var MULTILINE		= 1 << 10;
	
	
	//
	// ScrollBar
	public static inline var TARGET			= 1 << 11;
	
	//
	// IICON OWNER PROPERTIES
	public static inline var ICON			= 1 << 12;
	public static inline var ICON_FILL		= 1 << 13;
	
	//
	// SliderBase
	public static inline var PERCENTAGE 	= 1 << 14;
	public static inline var DIRECTION		= 1 << 15;
	
	
	//
	// ScrollBar and ProgressBar
	public static inline var SOURCE			= 1 << 16;
	
	
	public static inline var SCALE			= 1 << 17;
	

	
#if debug
	static public function readProperties (flags:Int) : String
	{
		var output	= [];
		
		if (flags.has( LAYOUT ))		output.push("layout");
		if (flags.has( GRAPHICS ))		output.push("graphics");
		if (flags.has( STYLE ))			output.push("style");
		if (flags.has( DATA ))			output.push("data");
		if (flags.has( STATE ))			output.push("state");
		if (flags.has( TEXTSTYLE ))		output.push("textstyle");
		if (flags.has( TEXT ))			output.push("text");
		if (flags.has( DISPLAY_HTML ))	output.push("displayHTML");
		if (flags.has( RESTRICT ))		output.push("restrict");
		if (flags.has( MAX_CHARS ))		output.push("maxChars");
		if (flags.has( TARGET ))		output.push("target");
		if (flags.has( ICON ))			output.push("icon");
		if (flags.has( ICON_FILL ))		output.push("iconFill");
		if (flags.has( PERCENTAGE ))	output.push("percentage");
		if (flags.has( DIRECTION ))		output.push("direction");
		if (flags.has( SOURCE ))		output.push("source");
		if (flags.has( SCALE ))			output.push("scale");
		
		return output.length > 0 ? output.join(", ") : "no-properties";
	}
#end
}