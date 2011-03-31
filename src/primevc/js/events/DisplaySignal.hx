package primevc.js.events;

import js.Dom;

/**
 * @author Stanislav Sopov
 * @since march 2, 2010
 */

class DisplaySignal extends DOMSignal1<Type>
{
	override private function dispatch(event:Event) 
	{
		var displayEvent = new DisplayEvent(event);
		
		send(displayEvent);
	}
}

class DisplayEvent
{	
	public var type			(default, null):String; // The type of event that occurred.
	public var target 		(default, null):HtmlDom; // Returns the element that triggered the event
	
	public function new (event:Event)
	{
		type = event.type;
		target = event.target;
	}
}

