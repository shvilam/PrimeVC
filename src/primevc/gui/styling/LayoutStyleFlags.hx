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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.styling;
  using primevc.utils.BitUtil;


/**
 * Flags for layout-properties within the styling definition
 * @author Ruben Weijers
 * @creation-date Jan 14, 2011
 */
extern class LayoutStyleFlags
{
	public static inline var ALL_PROPERTIES				= SIZE | RELATIVE | ALGORITHM | PERCENT_WIDTH | PERCENT_HEIGHT | PADDING | MARGIN | MAINTAIN_ASPECT | ROTATION | CHILD_WIDTH | CHILD_HEIGHT | WIDTH_CONSTRAINTS | HEIGHT_CONSTRAINTS;

	public static inline var WIDTH_CONSTRAINTS			= PERCENT_WIDTH_CONSTRAINTS | MIN_WIDTH | MAX_WIDTH;
	public static inline var HEIGHT_CONSTRAINTS			= PERCENT_HEIGHT_CONSTRAINTS | MIN_HEIGHT | MAX_HEIGHT;

	public static inline var PERCENT_WIDTH_CONSTRAINTS	= PERCENT_MIN_WIDTH | PERCENT_MAX_WIDTH;
	public static inline var PERCENT_HEIGHT_CONSTRAINTS	= PERCENT_MIN_HEIGHT | PERCENT_MAX_HEIGHT;

	public static inline var SIZE						= WIDTH | HEIGHT;

	public static inline var WIDTH					= 1 << 0;
	public static inline var HEIGHT					= 1 << 1;
	/**
	 * The relative property or properties of the relative object are changed.
	 */
	public static inline var RELATIVE				= 1 << 2;
	/**
	 * Flag indicating that a property of the layout algorithm is changed and
	 * the layout needs to be validated again.
	 */
	public static inline var ALGORITHM				= 1 << 3;
	public static inline var INCLUDE				= 1 << 20;

	public static inline var MAX_WIDTH				= 1 << 4;
	public static inline var MIN_WIDTH				= 1 << 5;
	public static inline var MAX_HEIGHT				= 1 << 6;
	public static inline var MIN_HEIGHT				= 1 << 7;
	public static inline var PERCENT_WIDTH			= 1 << 8;
	public static inline var PERCENT_HEIGHT			= 1 << 9;
	
	public static inline var MAINTAIN_ASPECT		= 1 << 10;
	public static inline var ROTATION				= 1 << 11;
	public static inline var MARGIN					= 1 << 12;
	public static inline var PADDING				= 1 << 13;

	public static inline var CHILD_WIDTH			= 1 << 14;
	public static inline var CHILD_HEIGHT			= 1 << 15;
	
	public static inline var PERCENT_MIN_WIDTH		= 1 << 16;
	public static inline var PERCENT_MAX_WIDTH		= 1 << 17;
	public static inline var PERCENT_MIN_HEIGHT		= 1 << 18;
	public static inline var PERCENT_MAX_HEIGHT		= 1 << 19;
	
	/**
	 * Property is not meant as a flag but to incicate that a layout-client.
	 * percentage property is set to fill the left space
	 */
	public static inline var FILL					: Int = #if neko -1073741821 #else -2147483644 #end;


#if debug
	public static inline function readProperties (flags:Int) : String
	{
		var output	= [];

		if (flags.has( ALGORITHM ))				output.push("algorithm");
		if (flags.has( CHILD_HEIGHT ))			output.push("child-height");
		if (flags.has( CHILD_WIDTH ))			output.push("child-width");
		if (flags.has( HEIGHT ))				output.push("height");
		if (flags.has( MAINTAIN_ASPECT ))		output.push("maintain-aspect-ratio");
		if (flags.has( MARGIN ))				output.push("margin");
		if (flags.has( MAX_HEIGHT ))			output.push("max-height");
		if (flags.has( MAX_WIDTH ))				output.push("max-width");
		if (flags.has( MIN_HEIGHT ))			output.push("min-height");
		if (flags.has( MIN_WIDTH ))				output.push("min-width");
		if (flags.has( PADDING ))				output.push("padding");
		if (flags.has( PERCENT_HEIGHT ))		output.push("percent-height");
		if (flags.has( PERCENT_WIDTH ))			output.push("percent-width");
		if (flags.has( PERCENT_MAX_HEIGHT ))	output.push("percent-max-height");
		if (flags.has( PERCENT_MAX_WIDTH ))		output.push("percent-max-width");
		if (flags.has( PERCENT_MIN_HEIGHT ))	output.push("percent-min-height");
		if (flags.has( PERCENT_MIN_WIDTH ))		output.push("percent-min-width");
		if (flags.has( RELATIVE ))				output.push("relative");
		if (flags.has( ROTATION ))				output.push("rotation");
		if (flags.has( WIDTH ))					output.push("width");

		return output.length > 0 ? output.join(", ") : "none";
	}
#end
}