package primevc.js.events;
 
import primevc.core.dispatcher.Wire;
import primevc.core.dispatcher.Signal1;
import primevc.core.dispatcher.IWireWatcher;
import primevc.core.ListNode;
import js.Dom;


/**
 * @author Stanislav Sopov
 * @since march 2, 2010
 */
class DOMSignal1<Type> extends Signal1<Type>, implements IWireWatcher<Type->Void>
{
	var eventDispatcher:HtmlDom;
	var event:String;
	
	
	public function new (eventDispatcher:HtmlDom, event:String)
	{
		super();
		this.eventDispatcher = eventDispatcher;
		this.event = event;
	}
	
	
	public function wireEnabled (wire:Wire<Type -> Void>) : Void {
		
		Assert.that(n != null);
		
		if (ListUtil.next(n) == null) // First wire connected
		{
			//eventDispatcher.addEventListener(event, dispatch, false, 0, true);
			untyped
			{    
				if (js.Lib.isIE)
				{
					eventDispatcher.attachEvent(event, dispatch, false);
				}
				else 
				{
					eventDispatcher.addEventListener(event, dispatch, false);
				}
			}
		}
	}
	
	
	public function wireDisabled (wire:Wire<Void -> Void>) : Void {
		
		if (n == null) // No more wires connected
		{
			//eventDispatcher.removeEventListener(event, dispatch, false);
			untyped
			{    
				if (js.Lib.isIE)
				{
					eventDispatcher.detachEvent(event, dispatch);
				} 
				else 
				{
					eventDispatcher.removeEventListener(event, dispatch);
				}
			}
		}
	}
	
	
	private function dispatch(e:Event) 
	{
		Assert.abstract();
	}
}
