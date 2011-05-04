package primevc.js.events;

import js.Dom;

/**
 * @author Stanislav Sopov
 * @since march 2, 2010
 */

class FocusSignal extends DOMSignal1<Type>
{
	override private function dispatch(event:Event) 
	{
		var focusEvent = new FocusEvent(event);
		
		send(focusEvent);
	}
}


class FocusEvent
{	
	public var type			(default, null):String; // The type of event that occurred.
	public var target 		(default, null):HtmlDom; // Returns the element that triggered the event
	public var relatedObject(default, null):HtmlDom; // Returns the element related to the element that triggered the event
	
	public function new (event:Event)
	{
		type = event.type;
		target = event.target;
		
		untyped 
		{
			relatedObject = event.relatedObject;
		}
	}
}

