package primevc.js.events;

import primevc.core.dispatcher.Wire;
import primevc.core.dispatcher.Signal0;
import primevc.core.dispatcher.IWireWatcher;
import primevc.core.ListNode;
import js.Dom;
import js.Lib;


/**
 * @author	Stanislav Sopov
 * @since 	April 6, 2011
 */

class DOMSignal0 extends Signal0, implements IWireWatcher<Void->Void>
{
	var eventDispatcher:Dynamic;
	var event:String;
	
	
	public function new (eventDispatcher:Dynamic, event:String)
	{
		super();
		this.eventDispatcher = eventDispatcher;
		this.event = event;
	}
	
	
	public function wireEnabled (wire:Wire<Void->Void>):Void
	{	
		Assert.that(n != null);
		
		if (ListUtil.next(n) == null) // First wire connected
		{
			untyped eventDispatcher.addEventListener(event, dispatch, false);
		}
	}
	
	
	public function wireDisabled (wire:Wire<Void->Void>):Void
	{	
		if (n == null) // No more wires connected
		{
			untyped eventDispatcher.removeEventListener(event, dispatch, false);
		}
	}
	
	
	private function dispatch(e:Event) 
	{
		Assert.abstract();
	}
}
