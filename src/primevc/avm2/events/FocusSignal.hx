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
 import flash.events.FocusEvent;
 import primevc.core.dispatcher.IWireWatcher;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.dispatcher.Wire;
 import primevc.gui.events.FocusState;
 import primevc.gui.events.KeyModState;
  using primevc.core.ListNode;


private typedef FocusHandler = FocusState -> Void;

/**
 * Signal<-->flash.MouseEvent Proxy implementation
 * 
 * @author Ruben Weijers
 * @creation-date jan 26, 2010
 */
class FocusSignal extends Signal1<FocusState>, implements IWireWatcher<FocusHandler>
{
	var eventDispatcher	: IEventDispatcher;
	var event			: String;
	
	
	public function new (d:IEventDispatcher, e:String)
	{
		super();
		this.eventDispatcher = d;
		this.event = e;
	}
	
	
	public function wireEnabled	(wire:Wire<FocusHandler>) : Void {
		Assert.that(n != null);
		if ( n.next() == null) // First wire connected
			eventDispatcher.addEventListener(event, dispatch, false, 0, true);
	}
	
	
	public function wireDisabled	(wire:Wire<FocusHandler>) : Void {
		if (n == null) // No more wires connected
			eventDispatcher.removeEventListener(event, dispatch, false);
	}
	
	
	private function dispatch(e:FocusEvent)
	{
		send( stateFromFlashEvent(e) );
	}
	
	
	static public function stateFromFlashEvent( e:FocusEvent ) : FocusState
	{
		var flags;
		
		/** scrollDelta				Button				clickCount			KeyModState
			FF (8-bit) -127-127		FF (8-bit) 0-255	F (4-bit) 0-15		F (4-bit)
		*/
#if flash9
		flags  = (e.shiftKey ? KeyModState.SHIFT : 0);
		flags |= (e.keyCode << 8);
		
#elseif air?
		flags = //TODO: Implement AIR support
#else error
#end
	//	trace("stateFromFlashEvent "+e.type+"; "+e.localX+", "+e.localY+"; "+e.stageX+", "+e.stageY);
		return new FocusState(flags, e.target, e.relatedObject);
	}


#if debug
	public function toString () {
		return "FocusSignal[ "+event+" ]";
	}
#end
}

