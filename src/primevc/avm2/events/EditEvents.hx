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
package primevc.avm2.events;
#if flash10
 import flash.events.Event;
#else if flash9
 import flash.events.KeyboardEvent;
 import primevc.core.dispatcher.Signal0;
#end
 import primevc.gui.events.EditEvents;


/**
 * AVM2 implementation of events that are triggered when the platform's hotkeys
 * for copy, cut or paste are pressed.
 * 
 * @author Ruben Weijers
 * @creation-date Dec 12, 2010
 */
class EditEvents extends EditSignals
{
	public function new (eventDispatcher)
	{
#if flash10
		cut			= new FlashSignal0 (eventDispatcher, Event.CUT );
		copy		= new FlashSignal0 (eventDispatcher, Event.COPY );
		paste		= new FlashSignal0 (eventDispatcher, Event.PASTE );
		remove		= new FlashSignal0 (eventDispatcher, Event.CLEAR );
		selectAll	= new FlashSignal0 (eventDispatcher, Event.SELECT_ALL );
#else if flash9
		cut			= new Signal0();
		copy		= new Signal0();
		paste		= new Signal0();
		remove		= new Signal0();
		selectAll	= new Signal0();
		
		eventDispatcher.addEventListener(KeyboardEvent.KEY_DOWN, dispatch);
#end
	}
	
	
#if (flash9 && !flash10)
	private function dispatch (e:KeyboardEvent) : Void
	{
		var key = keyObj.keyCode();
		
		if (key == KeyCodes.BACKSPACE || key == KeyCodes.DELETE)
			remove.send();
		else if (keyObj.ctrlKey())
			switch (key)
			{
				case KeyCodes.A:	selectAll.send();
				case KeyCodes.X:	cut.send();
				case KeyCodes.C:	copy.send();
				case KeyCodes.V:	paste.send();
			}
	}
#end
}