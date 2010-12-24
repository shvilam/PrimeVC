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
package primevc.gui.layout;
  using primevc.utils.BitUtil;
 

/**
 * Collection of change flags for the layout-objects.
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class LayoutFlags 
{
	public static inline var ALL_PROPERTIES			= WIDTH | HEIGHT | INCLUDE | RELATIVE | ALGORITHM | MAX_WIDTH | MAX_HEIGHT | PERCENT_WIDTH | PERCENT_HEIGHT | PADDING | MARGIN | MAINTAIN_ASPECT | ROTATION | CHILD_WIDTH | CHILD_HEIGHT;
	public static inline var WIDTH_CONSTRAINTS		= MIN_WIDTH | MAX_WIDTH;
	public static inline var HEIGHT_CONSTRAINTS		= MIN_HEIGHT | MAX_HEIGHT;
	public static inline var WIDTH_PROPERTIES		= WIDTH | MEASURED_WIDTH | EXPLICIT_WIDTH;
	public static inline var HEIGHT_PROPERTIES		= HEIGHT | MEASURED_HEIGHT | EXPLICIT_HEIGHT;
	
	public static inline var SIZE					= WIDTH | HEIGHT;
	public static inline var POSITION				= X | Y;
	
	public static inline var WIDTH					= 1 << 0;
	public static inline var HEIGHT					= 1 << 1;
	public static inline var X						= 1 << 2;
	public static inline var Y						= 1 << 3;
	/**
	 * Flag indicating the includeInLayout property has changed
	 */
	public static inline var INCLUDE				= 1 << 4;
	/**
	 * The relative property or properties of the relative object are changed.
	 */
	public static inline var RELATIVE				= 1 << 5;
	/**
	 * Flag indicating that when the list with children of a layoutgroup have 
	 * changed.
	 */
	public static inline var LIST					= 1 << 6;
	/**
	 * Flag indicating that the children of the layout algorithm have changed.
	 */
	public static inline var CHILDREN_INVALIDATED	= 1 << 7;
	/**
	 * Flag indicating that a property of the layout algorithm is changed and
	 * the layout needs to be validated again.
	 */
	public static inline var ALGORITHM				= 1 << 8;
	/**
	 * Flag indicating that the width validator is changed
	 */
	public static inline var WIDTH_VALIDATOR		= 1 << 9;
	/**
	 * Flag indicating that the height validator is changed
	 */
	public static inline var HEIGHT_VALIDATOR		= 1 << 10;
	
	public static inline var MAX_WIDTH				= 1 << 11;
	public static inline var MIN_WIDTH				= 1 << 12;
	public static inline var PERCENT_WIDTH			= 1 << 13;
	public static inline var MEASURED_WIDTH			= 1 << 14;
	public static inline var EXPLICIT_WIDTH			= 1 << 15;
	
	public static inline var MAX_HEIGHT				= 1 << 16;
	public static inline var MIN_HEIGHT				= 1 << 17;
	public static inline var PERCENT_HEIGHT			= 1 << 18;
	public static inline var MEASURED_HEIGHT		= 1 << 19;
	public static inline var EXPLICIT_HEIGHT		= 1 << 20;
	
	public static inline var MARGIN					= 1 << 21;
	public static inline var PADDING				= 1 << 22;
	public static inline var MAINTAIN_ASPECT		= 1 << 23;
	public static inline var ROTATION				= 1 << 24;
	
	public static inline var CHILD_WIDTH			= 1 << 25;
	public static inline var CHILD_HEIGHT			= 1 << 26;
	
	
	/**
	 * Property is not meant as a flag but to incicate that a layout-client.
	 * percentage property is set to fill the left space
	 */
	public static inline var FILL					: Int = #if neko -1073741821 #else -2147483644 #end;


#if debug
	public static function readProperties (flags:Int) : String
	{
		var output	= [];
		
		if (flags.has( ALGORITHM ))				output.push("algorithm");
	//	if (flags.has( BOUNDARY_HEIGHT ))		output.push("boundary-height");
	//	if (flags.has( BOUNDARY_WIDTH ))		output.push("boundary-width");
		if (flags.has( CHILD_HEIGHT ))			output.push("child-height");
		if (flags.has( CHILD_WIDTH ))			output.push("child-width");
		if (flags.has( CHILDREN_INVALIDATED ))	output.push("children_invalidated");
		if (flags.has( EXPLICIT_HEIGHT ))		output.push("explicit-height");
		if (flags.has( EXPLICIT_WIDTH))			output.push("explicit-width");
		if (flags.has( HEIGHT ))				output.push("height");
		if (flags.has( INCLUDE ))				output.push("include");
		if (flags.has( LIST ))					output.push("list");
		if (flags.has( MAINTAIN_ASPECT ))		output.push("maintain-aspect-ratio");
		if (flags.has( MARGIN ))				output.push("margin");
		if (flags.has( MEASURED_HEIGHT ))		output.push("measured-height");
		if (flags.has( MEASURED_WIDTH ))		output.push("measured-width");
		if (flags.has( MAX_HEIGHT ))			output.push("max-height");
		if (flags.has( MAX_WIDTH ))				output.push("max-width");
		if (flags.has( MIN_HEIGHT ))			output.push("min-height");
		if (flags.has( MIN_WIDTH ))				output.push("min-width");
		if (flags.has( PADDING ))				output.push("padding");
		if (flags.has( PERCENT_HEIGHT ))		output.push("percent-height");
		if (flags.has( PERCENT_WIDTH ))			output.push("percent-width");
		if (flags.has( RELATIVE ))				output.push("relative");
		if (flags.has( ROTATION ))				output.push("rotation");
		if (flags.has( WIDTH_VALIDATOR ))		output.push("width-validator");
		if (flags.has( HEIGHT_VALIDATOR ))		output.push("height-validator");
		if (flags.has( X ))						output.push("x");
		if (flags.has( Y ))						output.push("y");
		if (flags.has( WIDTH ))					output.push("width");
		
		return "properties: " + output.join(", ")+" ("+flags+")";
	}
	
	
	public static function readProperty (flag:Int) : String
	{
		return switch (flag) {
			case WIDTH:					"width";
			case HEIGHT:				"height";
			case X:						"x";
			case Y:						"y";
			case INCLUDE:				"include_in_layout";
			case RELATIVE:				"relative_properties";
			case LIST:					"list";
			case CHILDREN_INVALIDATED:	"children_invalidated";
			case ALGORITHM:				"algorithm";
			case WIDTH_VALIDATOR:		"width-validator";
			case HEIGHT_VALIDATOR:		"height-validator";
			default:					"unkown(" + flag + ")";
		}
	}
#end
}