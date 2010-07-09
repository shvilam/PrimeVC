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
package primevc.avm2.events;
 import primevc .gui.events.KeyboardEvents;
 import primevc .gui.events.KeyModState;
 import primevc.core.dispatcher.Wire;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.dispatcher.IWireWatcher;
 import flash.display.InteractiveObject;
 import flash.events.KeyboardEvent;
  using primevc.core.ListNode;

/**
 * Signal<-->flash.KeyboardEvent Proxy implementation
 * 
 * @author Danny Wilson
 * @creation-date jun 15, 2010
 */
class KeyboardSignal extends Signal1<KeyboardState>, implements IWireWatcher<KeyboardHandler>
{
	private var eventDispatcher:InteractiveObject;
	private var event:String;
	
	public function new (d:InteractiveObject, e:String)
	{
		super();
		this.eventDispatcher = d;
		this.event = e;
	}
	
	public function wireEnabled	(wire:Wire<KeyboardHandler>) : Void {
		Assert.that(n != null);
		if (n.next() == null) // First wire connected
			eventDispatcher.addEventListener(event, dispatch);
	}
	
	public function wireDisabled	(wire:Wire<KeyboardHandler>) : Void {
		if (n == null) // No more wires connected
			eventDispatcher.removeEventListener(event, dispatch);
	}
	
	private function dispatch(e:KeyboardEvent) {
		send( stateFromFlashEvent(e) );
	}
	
	static inline public function stateFromFlashEvent( e ) : KeyboardState
	{
		/*
			charCode				keyCode					keyLocation		KeyMod
			FFF (12-bit) 0-4095		3FF (10-bit) 0-1023		F (4-bit)		F (4-bit)
		*/
		var flags;
		
		#if flash9
		Assert.that(e.charCode		< 16384); // 14 bits available in AVM2
		Assert.that(e.keyCode		<  1024);
		
		flags = (switch (e.keyLocation) {
				case flash.ui.KeyLocation.STANDARD:	0;
				case flash.ui.KeyLocation.LEFT:		1;
				case flash.ui.KeyLocation.RIGHT:	2;
				case flash.ui.KeyLocation.NUM_PAD:	3; }) << 4;
		
		flags |= (e.charCode << 18)
				| (e.keyCode << 8)
				| (e.altKey?	KeyModState.ALT : 0)
				| (e.ctrlKey?	KeyModState.CMD | KeyModState.CTRL : 0)
				| (e.shiftKey?	KeyModState.SHIFT : 0);
		
		#elseif air?
		flags = //TODO: Implement AIR support
		#else error
		#end
		
		return new KeyboardState(flags, e.target);
	}
}
