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
package primevc.avm2;
 import primevc.gui.display.IShape;
 import primevc.gui.display.Window;
 import primevc.gui.events.DisplayEvents;
 

/**
 * AVM2 Shape implementation
 * 
 * @creation-date	Jun 11, 2010
 * @author			Ruben Weijers
 */
class Shape extends flash.display.Shape, implements IShape
{
	/**
	 * The displaylist to which this sprite belongs.
	 */
	public var displayList		(default, default)		: DisplayList;
	/**
	 * Wrapper object for the stage.
	 */
	public var window			(default, setWindow)	: Window;
	public var displayEvents	(default, null)			: DisplayEvents;
	
	
	public function new() 
	{
		super();
		displayEvents = new DisplayEvents( this );
	}
	
	
	public function dispose()
	{
		if (displayEvents == null)
			return;		// already disposed
		
		displayEvents.dispose();
		displayEvents	= null;
		window			= null;
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setWindow (v) {
		return window = v;
	}
}