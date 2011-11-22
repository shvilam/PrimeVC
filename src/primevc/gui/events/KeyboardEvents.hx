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
 import primevc.core.dispatcher.Signals;
// import primevc.gui.display.ISprite;

typedef KeyboardEvents = 
	#if		flash9	primevc.avm2.events.KeyboardEvents;
	#elseif	flash8	primevc.avm1.events.KeyboardEvents;
	#elseif	js		primevc.js  .events.KeyboardEvents;
	#else	#error;	#end

typedef KeyboardHandler = KeyboardState -> Void;
typedef KeyboardSignal  = primevc.core.dispatcher.INotifier<KeyboardHandler>;

/**
 * Cross-platform keyboard events.
 * 
 * @author Danny Wilson
 * @creation-date jun 14, 2010
 */
class KeyboardSignals extends Signals
{
	var down	(default,null) : KeyboardSignal;
	var up		(default,null) : KeyboardSignal;
}

class KeyboardState extends KeyModState
{
	/*  var flags: Range 0 to 0x3F_FF_FF_FF
		
		charCode				keyCode					keyLocation		KeyMod
		FFF (12-bit) 0-4095		3FF (10-bit) 0-1023		F (4-bit)		F (4-bit)
	*/
	
	inline function keyCode()		: Int	{ return (flags >>   8) & 0x3FF; }
	inline function charCode()		: Int	{ return (flags >>> 18); }
	
	inline function keyLocation()	: KeyLocation
	{
		// TODO: Bench if 0xFF00 >> 8  is faster then case 0x0100
		return switch ((flags & 0xF0) >> 4) {
			case 0:		KeyLocation.Standard;
			case 1:		KeyLocation.Left;
			case 2:		KeyLocation.Right;
			case 3:		KeyLocation.NumPad;
		}
	}
}
