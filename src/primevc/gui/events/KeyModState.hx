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
 *  Danny Wilson	<danny @ onlinetouch.nl>
 */
package primevc.gui.events;
 import primevc.gui.display.ISprite;

 
typedef TargetType		= 
	#if		flash9	flash.display.DisplayObject;
	#elseif	flash8	MovieClip;
	#elseif	js		DomElement;
	#else	Void;	#end

/**
 * Base class for UI state messages with key-modifiers.
 * 
 * @author Danny Wilson
 * @creation-date jun 14, 2010
 */
class KeyModState implements haxe.Public
{
	static inline var SHIFT	= 0x1;
	static inline var CTRL	= 0x2;
	static inline var ALT	= 0x4;
	static inline var CMD	= 0x8;
	
	/**
	 * Uses lowest 4 bits to store KeyModState: 0xF
	 */
	var flags	(default,null)		: Int;
	/**
	 * Target of the event
	 */  
	var target	(default,null)		: TargetType;
	
	public function new(f:Int, t:TargetType)
	{
		this.flags  = f;
		this.target = t;
	}
	
	/**
	 * True when the Shift key is pressed
	 */
	inline function shiftKey()		: Bool	{ return (flags & SHIFT) != 0; }
	
	/**
	 * Flash 9+:	True when Ctrl or Cmd key is pressed
	 * AIR:			Not implemented yet
	 */
	inline function ctrlKey()		: Bool	{ return (flags & CTRL)  != 0; }
	
	/**
	 * True when Alt key is pressed
	 */
	inline function altKey()		: Bool	{ return (flags & ALT)   != 0; }
	
	/**
	 * Flash 9+:	True when Ctrl or Cmd key is pressed
	 * AIR:			Not implemented yet
	 */
	inline function cmdKey()		: Bool	{ return (flags & CMD)   != 0; }
}