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
#if (neko || debug)
  using primevc.utils.BitUtil;
  using StringTools;
#end


/**
 * @author Ruben Weijers
 * @creation-date Oct 20, 2010
 */
extern class StyleStateFlags
{
	public static inline var ALL_STATES			= MOUSE_STATES | FORM_STATES | PROGRESS_STATES | SELECTED | DRAG_STATES;
	public static inline var DRAG_STATES		= DRAG_OVER | DRAG_DROP;
	public static inline var PROGRESS_STATES	= PROGRESS | COMPLETED | ERROR | INDETERMINATE;
	public static inline var MOUSE_STATES		= HOVER | DOWN;
	public static inline var FORM_STATES		= FOCUS | VALID | INVALID | REQUIRED | OPTIONAL | DISABLED | CHECKED | EDITABLE;
	
	
	public static inline var NONE			= 0;
	public static inline var HOVER			= 1 << 1;
	public static inline var DOWN			= 1 << 2;
	public static inline var FOCUS			= 1 << 3;
	
	public static inline var VALID			= 1 << 4;
	public static inline var INVALID		= 1 << 5;
	public static inline var REQUIRED		= 1 << 6;
	public static inline var OPTIONAL		= 1 << 7;
	
	public static inline var DISABLED		= 1 << 8;
	public static inline var CHECKED		= 1 << 9;
	public static inline var EDITABLE		= 1 << 10;
	public static inline var SELECTED		= 1 << 11;
	
	public static inline var PROGRESS		= 1 << 12;
	public static inline var COMPLETED		= 1 << 13;
	public static inline var ERROR			= 1 << 14;
	
	/**
	 * style class for loaders with a indeterminate ending
	 */
	public static inline var INDETERMINATE	= 1 << 15;
	/**
	 * style class for loaders with a determinate ending
	 */
	public static inline var DETERMINATE	= 1 << 16;
	
	public static inline var DRAG_OVER		= 1 << 17;
//	public static inline var DRAG_OUT		= 1 << 16;
	public static inline var DRAG_DROP		= 1 << 18;
	
	
#if (neko || debug)
	public static function stringToState (v:String) : Int
	{
		return switch (v.toLowerCase().trim())
		{
			case "hover":			HOVER;
			case "down":			DOWN;
			case "focus":			FOCUS;
			
			case "valid":			VALID;
			case "invalid":			INVALID;
			
			case "required":		REQUIRED;
			case "optional":		OPTIONAL;
			
			case "disabled":		DISABLED;
			
			case "checked":			CHECKED;
			case "selected":		SELECTED;
			
			case "progress":		PROGRESS;
			case "indeterminate":	INDETERMINATE;
			case "determinate":		DETERMINATE;
			
			case "completed":		COMPLETED;
			case "error":			ERROR;
			
			case "editable":		EDITABLE;
			
			case "drag-over":		DRAG_OVER;
		//	case "drag-out":		DRAG_OUT;
			case "drag-drop":		DRAG_DROP;
			default:				Assert.that(false, "unkown state: "+v); 0;
		}
	}
	
	
	public static function stateToString (v:Int) : String
	{
		return switch (v)
		{
			case HOVER:			"hover";
			case DOWN:			"down";
			case FOCUS:			"focus";
			
			case VALID:			"valid";
			case INVALID:		"invalid";
			
			case REQUIRED:		"required";
			case OPTIONAL:		"optional";
			
			case DISABLED:		"disabled";
			
			case CHECKED:		"checked";
			case SELECTED:		"selected";
			
			case PROGRESS:		"progress";
			case INDETERMINATE:	"indeterminate";
			case DETERMINATE:	"determinate";
			
			case COMPLETED:		"completed";
			case ERROR:			"error";
			
			case EDITABLE:		"editable";
			
			case DRAG_OVER:		"drag-over";
		//	case DRAG_OUT:		"drag-out";
			case DRAG_DROP:		"drag-drop";
			
			default:			"unkown ( "+v+" )";
		}
	}
	
	
	public static inline function readProperties (flags:Int) : String
	{
		var output	= [];
		var result	= "";
		
		if (flags > 0)
		{
			if (flags.has( HOVER ))				output.push("hover");
			if (flags.has( DOWN ))				output.push("down");
			if (flags.has( FOCUS ))				output.push("focus");
			
			if (flags.has( VALID ))				output.push("valid");
			if (flags.has( INVALID ))			output.push("invalid");
			
			if (flags.has( REQUIRED ))			output.push("required");
			if (flags.has( OPTIONAL ))			output.push("optional");
			
			if (flags.has( DISABLED ))			output.push("disabled");
			
			if (flags.has( CHECKED ))			output.push("checked");
			if (flags.has( SELECTED ))			output.push("selected");
			
			if (flags.has( PROGRESS ))			output.push("progress");
			if (flags.has( INDETERMINATE ))		output.push("indeterminate");
			if (flags.has( DETERMINATE ))		output.push("determinate");
			
			if (flags.has( COMPLETED ))			output.push("completed");
			if (flags.has( ERROR ))				output.push("error");
			
			if (flags.has( EDITABLE ))			output.push("editable");
			
			if (flags.has( DRAG_OVER ))			output.push("drag-over");
		//	if (flags.has( DRAG_OUT ))			output.push("drag-out");
			if (flags.has( DRAG_DROP ))			output.push("drag-drop");
			result = output.join(", ");
		}
		else
			result = "none";
		return "properties: " + result;
	}
#end
}