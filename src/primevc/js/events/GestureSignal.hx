package primevc.js.events;

import primevc.core.geom.Point;
import primevc.js.events.DOMSignal1;
import js.Dom;

typedef GestureEvent = 
{
	>DOMEvent,
	public var altKey			(default, null):Bool; // Indicates whether or not the ALT key was pressed when the event was triggered. 
	public var ctrlKey			(default, null):Bool; // Indicates whether or not the CTRL key was pressed when the event was triggered. 
	public var metaKey			(default, null):Bool; // Indicates whether or not the META key was pressed when the event was triggered. 
	public var shiftKey			(default, null):Bool; // Indicates whether or not the SHIFT key was pressed when the event was triggered. 
	// The delta rotation since the start of an event, in degrees, where clockwise is positive and
	// counter-clockwise is negative. The initial value is 0.0.
	public var rotation			(default, null):Float;
	// The distance between two fingers since the start of an event as a multiplier of the initial distance.
	// The initial value is 1.0. If less than 1.0, the gesture is pinch close (to zoom out). 
	// If greater than 1.0, the gesture is pinch open (to zoom in).
	public var scale			(default, null):Float;
}

/**
 * @author	Stanislav Sopov
 * @since	May 3, 2011
 */

class GestureSignal extends DOMSignal1<GestureEvent>
{
	override private function dispatch(event:Event)
	{
		send(cast event);
	}
}