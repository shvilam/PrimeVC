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
// import flash.display.InteractiveObject;
 import flash.events.IEventDispatcher;
 import flash.events.MouseEvent;
 import primevc.core.dispatcher.IWireWatcher;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.dispatcher.Wire;
 import primevc.core.geom.Point;
 import primevc.gui.events.KeyModState;
 import primevc.gui.events.MouseEvents;
  using primevc.core.ListNode;

/**
 * Signal<-->flash.MouseEvent Proxy implementation
 * 
 * @author Danny Wilson
 * @creation-date jun 15, 2010
 */
class MouseSignal extends Signal1<MouseState>, implements IWireWatcher<MouseHandler>
{
	var eventDispatcher:IEventDispatcher;
	var event:String;
	var clickCount:Int;
	
	
	public function new (d:IEventDispatcher, e:String, cc:Int)
	{
		super();
		this.eventDispatcher = d;
		this.event = e;
		this.clickCount = cc;
	}
	
	
	public function wireEnabled	(wire:Wire<MouseHandler>) : Void {
		Assert.that(n != null);
		if ( n.next() == null) // First wire connected
			eventDispatcher.addEventListener(event, dispatch, false, 0, true);
	}
	
	
	public function wireDisabled	(wire:Wire<MouseHandler>) : Void {
		if (n == null) // No more wires connected
			eventDispatcher.removeEventListener(event, dispatch, false);
	}
	
	
	private function dispatch(e:MouseEvent) {
#if debug
			var state = stateFromFlashEvent(e, clickCount);
			state.owner = this;
			send( state );
#else
			send( stateFromFlashEvent(e, clickCount) );
#end
	}
	
	
	static public function stateFromFlashEvent( e:MouseEvent, clickCount:Int ) : MouseState
	{
	//	return new FlashMouseState(e, clickCount);
		var flags;
		
		/** scrollDelta				Button				clickCount			KeyModState
			FF (8-bit) -127-127		FF (8-bit) 0-255	F (4-bit) 0-15		F (4-bit)
		*/
		
#if flash9
		Assert.that(clickCount >=  0);
		Assert.that(clickCount <= 15);
		
		flags = e.delta << 16
				| (clickCount & 0xF) << 4
				| (e.buttonDown? 0x0100 : 0)
				| (e.altKey?	KeyModState.ALT : 0)
				| (e.ctrlKey?	KeyModState.CMD | KeyModState.CTRL : 0)
				| (e.shiftKey?	KeyModState.SHIFT : 0);
		
		//e.stopImmediatePropagation();
		
#elseif air?
		flags = //TODO: Implement AIR support
#else error
#end
	//	trace("stateFromFlashEvent "+e.type+"; "+e.localX+", "+e.localY+"; "+e.stageX+", "+e.stageY);
		return new MouseState(flags, e.target, new Point(e.localX, e.localY), new Point(e.stageX, e.stageY), e.relatedObject);
	}


#if debug
	public function toString () {
		return "MouseSignal[ "+event+" ]";
	}
#end
}

/*


class FlashMouseState extends MouseState
{
	private var event:MouseEvent;
	
	
	public function new (e:MouseEvent, clickCount:Int)
	{
		var flags;
		
		/** scrollDelta				Button				clickCount			KeyModState
			FF (8-bit) -127-127		FF (8-bit) 0-255	F (4-bit) 0-15		F (4-bit)
		*//*
#if flash9
		Assert.that(clickCount >=  0);
		Assert.that(clickCount <= 15);
		
		flags = e.delta << 16
				| (clickCount & 0xF) << 4
				| (e.buttonDown? 0x0100 : 0)
				| (e.altKey?	KeyModState.ALT : 0)
				| (e.ctrlKey?	KeyModState.CMD | KeyModState.CTRL : 0)
				| (e.shiftKey?	KeyModState.SHIFT : 0);
		
#elseif air?
		flags = //TODO: Implement AIR support
#else error
#end
	//	trace("stateFromFlashEvent "+e.type+"; "+e.localX+", "+e.localY+"; "+e.stageX+", "+e.stageY);
		this.event = e;
		super(flags, e.target, new Point(e.localX, e.localY), new Point(e.stageX, e.stageY), e.relatedObject);
		cancelBubling();
	}
	
	
	public function cancelBubling ()
	{
		event.stopImmediatePropagation();
	}
}*/