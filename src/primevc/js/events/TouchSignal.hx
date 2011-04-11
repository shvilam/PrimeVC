package primevc.js.events;

import primevc.js.events.DOMEvent;
import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since 	March 2, 2011
 */

class TouchSignal extends DOMSignal1<TouchEvent>
{
	override private function dispatch(event:Event) 
	{
		var touchEvent = new TouchEvent(event);
		
		send(touchEvent);
	}
}


class TouchEvent extends DOMUIEvent
{
	public var scale			(default, null):Float; // The distance between two fingers since the start of an event as a multiplier of the initial distance.
	// The initial value is 1.0. If less than 1.0, the gesture is pinch close (to zoom out). 
	// If greater than 1.0, the gesture is pinch open (to zoom in).
	public var rotation			(default, null):Float; // The delta rotation since the start of an event, in degrees, where clockwise is positive and
	// counter-clockwise is negative. The initial value is 0.0.
	public var touches			(default, null):Array<Touch>; // A collection of Touch objects representing all touches associated with this event.
	public var targetTouches	(default, null):Array<Touch>; // A collection of Touch objects representing all touches associated with this target.
	public var changedTouches	(default, null):Array<Touch>; // A collection of Touch objects representing all touches that changed in this event.
	
	public function new (event:Event)
	{
		super(event);
		
		untyped
		{
			scale 			= event.scale;
			rotation 		= event.rotation;
			touches 		= event.touches;
			targetTouches 	= event.targetTouches;
			changedTouches 	= event.changedTouches;
		}
	}
}

class Touch extends DOMPointingEvent
{
	public var identifier	(default, null):Int; // An identifying number, unique to each touch event
	
	public function new (touch:Dynamic)
	{
		super(touch);
		
		identifier	= touch.identifier;
	}
}