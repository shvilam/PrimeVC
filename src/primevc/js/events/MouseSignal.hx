package primevc.js.events;

import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */

class MouseSignal extends DOMSignal1<MouseEvent>
{
	override private function dispatch(event:Event) 
	{
		var mouseEvent = new MouseEvent(event);
		
		send(mouseEvent);
	}
}

class MouseEvent extends DOMPointingEvent
{	 	
	public var button(default, null):Int; //	Indicates which mouse button changed state. 0, 1 and 2 indicate left, middle and right mouse buttons respectively.
	
	public function new (event:Event)
	{
		super(event);
		
		untyped
		{
			button = event.button;
		}
	}
}


