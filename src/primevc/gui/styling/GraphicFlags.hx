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
 * @creation-date Oct 25, 2010
 */
class GraphicFlags
{
	public static inline var ALL_PROPERTIES		: UInt = SKIN | BACKGROUND | BORDER | SHAPE | VISIBLE | OPACITY | ICON | OVERFLOW;
	public static inline var DRAWING_PROPERTIES	: UInt = BACKGROUND | BORDER | SHAPE;
	
	public static inline var SKIN				: UInt = 1;
	public static inline var BACKGROUND			: UInt = 2;
	public static inline var BORDER				: UInt = 4;
	public static inline var SHAPE				: UInt = 8;
	public static inline var VISIBLE			: UInt = 16;
	public static inline var OPACITY			: UInt = 32;
	public static inline var ICON				: UInt = 64;
	public static inline var OVERFLOW			: UInt = 128;
	
	
#if debug
	static public function readProperties (flags:UInt) : String
	{
		var output	= [];
		
		if (flags.has( BACKGROUND ))			output.push("background");
		if (flags.has( BORDER ))				output.push("border");
		if (flags.has( ICON ))					output.push("icon");
		if (flags.has( OPACITY ))				output.push("opacity");
		if (flags.has( OVERFLOW ))				output.push("overflow");
		if (flags.has( SHAPE ))					output.push("shape");
		if (flags.has( SKIN ))					output.push("skin");
		if (flags.has( VISIBLE ))				output.push("visible");
		
		return "properties: " + output.join(", ");
	}
#end
}