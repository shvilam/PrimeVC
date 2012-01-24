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
package primevc.gui.input;
 import primevc.gui.display.Window;
 import primevc.gui.events.MouseEvents;


/**
 * Class that will represent the mouse-cursor.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 22, 2010
 */
class Mouse //implements IInputDevice 
{
	public var x		(getX, never)	: Float;
	public var y		(getY, never)	: Float;
	
	private var window	(default, null)	: Window;
	public var events	(default, null)	: MouseEvents;
	
	
	public function new (window)
	{
		this.window = window;
		events		= window.userEvents.mouse;
	}
	
	
	public inline function show ()
	{
#if (flash9 || air)
		flash.ui.Mouse.show();
#end
	}
	
	
	public inline function hide ()
	{
#if (flash9 || air)
		flash.ui.Mouse.hide();
#end
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getX ()
	{
#if (flash9 || air)
		return window.target.mouseX;
#end
	}
	
	
	private inline function getY ()
	{
#if (flash9 || air)
		return window.target.mouseY;
#end
	}
}