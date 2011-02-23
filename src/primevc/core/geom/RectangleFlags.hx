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
package primevc.core.geom;
  using primevc.utils.BitUtil;



/**
 * @author Ruben Weijers
 * @creation-date Oct 14, 2010
 */
class RectangleFlags
{
	public static inline var WIDTH		= 1 << 0;
	public static inline var HEIGHT		= 1 << 1;
	                                    
	public static inline var TOP		= 1 << 2;
	public static inline var CENTERY	= 1 << 3;
	public static inline var BOTTOM		= 1 << 4;
	                                    
	public static inline var LEFT		= 1 << 5;
	public static inline var CENTERX	= 1 << 6;
	public static inline var RIGHT		= 1 << 7;
	                                    
	public static inline var SIZE		= WIDTH | HEIGHT;
	public static inline var HORIZONTAL	= LEFT | RIGHT | CENTERX;
	public static inline var VERTICAL	= TOP | BOTTOM | CENTERY;
	public static inline var ALL		= HORIZONTAL | VERTICAL;
	
	
#if debug
	public static function readProperties (flags:Int) : String
	{
		var output	= [];
		
		if (flags.has( WIDTH ))			output.push("width");
		if (flags.has( HEIGHT ))		output.push("height");
		if (flags.has( TOP ))			output.push("top");
		if (flags.has( CENTERY ))		output.push("center-y");
		if (flags.has( BOTTOM ))		output.push("bottom");
		if (flags.has( LEFT ))			output.push("left");
		if (flags.has( CENTERX ))		output.push("center-x");
		if (flags.has( RIGHT ))			output.push("right");
		
		return "properties: " + output.join(", ");
	}
#end
}