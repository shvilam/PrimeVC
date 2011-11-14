package primevc.js.events;
 import primevc.core.dispatcher.Wire;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.dispatcher.IWireWatcher;
 import primevc.core.ListNode;
 import primevc.gui.events.UserEventTarget;
 import js.Dom;


/**
 * @author Stanislav Sopov
 * @creation-date march 2, 2010
 */
class DOMSignal1<Type> extends Signal1<Type>, implements IWireWatcher<Type->Void>
{
	var eventDispatcher:UserEventTarget;
	var event:String;
	
	
	public function new (eventDispatcher:UserEventTarget, event:String)
	{
		super();
		this.eventDispatcher = eventDispatcher;
		this.event = event;
	}
	
	
	public function wireEnabled (wire:Wire<Type->Void>) : Void
	{
		Assert.notNull(n);
		
		if (ListUtil.next(n) == null) // First wire connected
		{
		//	trace(eventDispatcher.id+" - "+js.Lib.isIE+" - "+event);
			if (js.Lib.isIE) 	(untyped eventDispatcher).attachEvent(event, dispatch, false);
			else				(untyped eventDispatcher).addEventListener(event, dispatch, false);
		}
	}
	
	
	public function wireDisabled (wire:Wire<Type->Void>) : Void
	{
		if (n == null) // No more wires connected
		{
			if (js.Lib.isIE) 	(untyped eventDispatcher).detachEvent(event, dispatch);
			else				(untyped eventDispatcher).removeEventListener(event, dispatch);
		}
	}
	
	
	private function dispatch(e:Event)	Assert.abstract()
}
