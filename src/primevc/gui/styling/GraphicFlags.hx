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
	public static inline var ALL_PROPERTIES		= SKIN | BACKGROUND | BORDER | SHAPE | VISIBLE | OPACITY | ICON | OVERFLOW | BORDER_RADIUS;
	public static inline var DRAWING_PROPERTIES	= BACKGROUND | BORDER | SHAPE | BORDER_RADIUS;
	
	public static inline var SKIN				= 1 << 0;
	public static inline var BACKGROUND			= 1 << 1;
	public static inline var BORDER				= 1 << 2;
	public static inline var SHAPE				= 1 << 3;
	public static inline var VISIBLE			= 1 << 4;
	public static inline var OPACITY			= 1 << 5;
	public static inline var ICON				= 1 << 6;
	public static inline var OVERFLOW			= 1 << 7;
	public static inline var BORDER_RADIUS		= 1 << 8;
	
	
#if debug
	static public function readProperties (flags:Int) : String
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
		if (flags.has( BORDER_RADIUS ))			output.push("border-radius");
		
		return output.length > 0 ? output.join(", ") : "none";
	}
#end
}