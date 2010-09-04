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
 import flash.events.IEventDispatcher;
 import flash.events.TextEvent;
 import primevc.core.dispatcher.IWireWatcher;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.dispatcher.Wire;
 import primevc.core.ListNode;
 import primevc.gui.events.TextEvents;



/**
 * AVM2 TextSignal implementation
 * 
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class TextSignal extends Signal1 <String>, implements IWireWatcher < TextHandler > 
{
	var eventDispatcher:IEventDispatcher;
	var event:String;


	public function new (d:IEventDispatcher, e:String)
	{
		super();
		this.eventDispatcher = d;
		this.event = e;
	}

	public function wireEnabled (wire:Wire<TextHandler>) : Void {
		Assert.that(n != null);
		if (ListNode.next(n) == null) // First wire connected
			eventDispatcher.addEventListener(event, dispatch);
	}

	public function wireDisabled	(wire:Wire<TextHandler>) : Void {
		if (n == null) // No more wires connected
			eventDispatcher.removeEventListener(event, dispatch);
	}

	private function dispatch(e:TextEvent) {
		send(e.text);
	}
}