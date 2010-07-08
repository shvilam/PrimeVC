package primevc.avm2.events;
 import flash.events.IEventDispatcher;
 import flash.events.Event;
 
 import primevc.core.dispatcher.Wire;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.dispatcher.IWireWatcher;
 import primevc.core.ListNode;


/**
 * Signal0<-->flash.Event Proxy implementation
 * 
 * @author Danny Wilson
 * @creation-date jun 15, 2010
 */
class FlashSignal0 extends Signal0, implements IWireWatcher<Void->Void>
{
	var eventDispatcher:IEventDispatcher;
	var event:String;
	
	public function new (d:IEventDispatcher, e:String)
	{
		super();
		this.eventDispatcher = d;
		this.event = e;
	}
	
	public function wireEnabled (wire:Wire<Void -> Void>) : Void {
		Assert.that(n != null);
		if (ListNode.next(n) == null) // First wire connected
			eventDispatcher.addEventListener(event, dispatch);
	}
	
	public function wireDisabled	(wire:Wire<Void -> Void>) : Void {
		if (n == null) // No more wires connected
			eventDispatcher.removeEventListener(event, dispatch);
	}
	
	private function dispatch(e:Event) {
		send();
	}
}
