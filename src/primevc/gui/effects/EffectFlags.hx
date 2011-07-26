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
package primevc.gui.effects;
  using primevc.utils.BitUtil;



/**
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
#if !debug extern #end class EffectFlags
{
	public static inline var ALL_PROPERTIES		= MOVE | RESIZE | ROTATE | SCALE | SHOW | HIDE;
	                                            
	public static inline var EASING				= 1 << 0;
	public static inline var DELAY				= 1 << 1;
	public static inline var DURATION			= 1 << 2;
	public static inline var AUTO_HIDE_FILTERS	= 1 << 3;
	
	public static inline var ROTATE				= 1 << 4;
	public static inline var MOVE				= 1 << 5;
	public static inline var RESIZE				= 1 << 6;
	public static inline var SCALE				= 1 << 8;
	public static inline var SHOW				= 1 << 9;
	public static inline var HIDE				= 1 << 10;
	
	

#if debug
	public static function readProperties (flags:Int) : String
	{
		var output	= [];
		
		if (flags.has( HIDE ))		output.push("hide");
		if (flags.has( MOVE ))		output.push("move");
		if (flags.has( RESIZE ))	output.push("resize");
		if (flags.has( ROTATE ))	output.push("rotate");
		if (flags.has( SCALE ))		output.push("scale");
		if (flags.has( SHOW ))		output.push("show");
		
		return "properties: " + output.join(", ");
	}
#end	
}