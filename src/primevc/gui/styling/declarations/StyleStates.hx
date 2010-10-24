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
package primevc.gui.styling.declarations;
#if (neko || debug)
  using primevc.utils.BitUtil;
  using StringTools;
#end


/**
 * @author Ruben Weijers
 * @creation-date Oct 20, 2010
 */
class StyleStates
{
	public static inline var ALL_STATES	: UInt = HOVER | DOWN | FOCUS | VALID | INVALID | REQUIRED | OPTIONAL | DISABLED | CHECKED | LOADING | LOADED | ERROR | DRAG_OVER | DRAG_OUT | DRAG_DROP;
	
	
	public static inline var NONE		: UInt = 0;
	public static inline var HOVER		: UInt = 1;
	public static inline var DOWN		: UInt = 2;
	public static inline var FOCUS		: UInt = 4;
	public static inline var VALID		: UInt = 8;
	public static inline var INVALID	: UInt = 16;
	public static inline var REQUIRED	: UInt = 32;
	public static inline var OPTIONAL	: UInt = 64;
	public static inline var DISABLED	: UInt = 128;
	public static inline var CHECKED	: UInt = 256;
	public static inline var LOADING	: UInt = 512;
	public static inline var LOADED		: UInt = 1024;
	public static inline var ERROR		: UInt = 2048;
	
	public static inline var DRAG_OVER	: UInt = 4096;
	public static inline var DRAG_OUT	: UInt = 8192;
	public static inline var DRAG_DROP	: UInt = 16384;
	
	
#if (neko || debug)
	public static function stringToState (v:String) : UInt
	{
		return switch (v.toLowerCase().trim())
		{
			case "hover":		HOVER;
			case "down":		DOWN;
			case "focus":		FOCUS;
			case "valid":		VALID;
			case "invalid":		INVALID;
			case "required":	REQUIRED;
			case "optional":	OPTIONAL;
			case "disabled":	DISABLED;
			case "checked":		CHECKED;
			case "loading":		LOADING;
			case "loaded":		LOADED;
			case "error":		ERROR;
			case "drag-over":	DRAG_OVER;
			case "drag-out":	DRAG_OUT;
			case "drag-drop":	DRAG_DROP;
			default:			Assert.that(false, "unkown state: "+v); 0;
		}
	}
	
	
	public static function stateToString (v:UInt) : String
	{
		return switch (v)
		{
			case HOVER:		"hover";
			case DOWN:		"down";
			case FOCUS:		"focus";
			case VALID:		"valid";
			case INVALID:	"invalid";
			case REQUIRED:	"required";
			case OPTIONAL:	"optional";
			case DISABLED:	"disabled";
			case CHECKED:	"checked";
			case LOADING:	"loading";
			case LOADED:	"loaded";
			case ERROR:		"error";
			case DRAG_OVER:	"drag-over";
			case DRAG_OUT:	"drag-out";
			case DRAG_DROP:	"drag-drop";
			default:		"unkown ( "+v+" )";
		}
	}
	
	
	public static function readProperties (flags:UInt) : String
	{
		var output	= [];
		var result	= "";
		
		if (flags > 0)
		{
			if (flags.has( HOVER ))		output.push("hover");
			if (flags.has( DOWN ))		output.push("down");
			if (flags.has( FOCUS ))		output.push("focus");
			if (flags.has( VALID ))		output.push("valid");
			if (flags.has( INVALID ))	output.push("invalid");
			if (flags.has( REQUIRED ))	output.push("required");
			if (flags.has( OPTIONAL ))	output.push("optional");
			if (flags.has( DISABLED ))	output.push("disabled");
			if (flags.has( CHECKED ))	output.push("checked");
			if (flags.has( LOADING ))	output.push("loading");
			if (flags.has( LOADED ))	output.push("loaded");
			if (flags.has( ERROR ))		output.push("error");
			if (flags.has( DRAG_OVER ))	output.push("drag-over");
			if (flags.has( DRAG_OUT ))	output.push("drag-out");
			if (flags.has( DRAG_DROP ))	output.push("drag-drop");
			result = output.join(", ");
		}
		else
			result = "none";
		return "properties: " + result;
	}
#end
}