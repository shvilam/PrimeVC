package primevc.js.events;

import primevc.js.events.DOMSignal1;
import js.Dom;


typedef TransitionEvent = 
{
	>DOMEvent,
	public var propertyName	(default, null):String; // The name of the CSS property associated with this event.
	public var elapsedTime	(default, null):Float; // The duration of the transition, in seconds, since the event was sent.
}

/**
 * @author	Stanislav Sopov
 * @since 	April 7, 2011
 */
class TransitionSignal extends DOMSignal1<TransitionEvent>
{
	override private function dispatch(event:Event) 
	{
		send(cast event);
	}
}

