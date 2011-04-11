package primevc.js.events;

import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since 	April 7, 2011
 */

class TouchSignal extends DOMSignal1<TransitionEvent>
{
	override private function dispatch(event:Event) 
	{
		var transitionEvent = new TransitionEvent(event);
		
		send(transitionEvent);
	}
}


class TransitionEvent extends DOMEvent
{
	public var propertyName	(default, null):String; // The name of the CSS property associated with this event.
	public var elapsedTime	(default, null):Float; // The duration of the transition, in seconds, since the event was sent.
	
	public function new (event:Event)
	{
		super(event);
		
		untyped
		{
			propertyName	= event.propertyName;
			elapsedTime 	= event.elapsedTime
		}
	}
}
