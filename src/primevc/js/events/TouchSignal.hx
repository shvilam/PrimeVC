package primevc.js.events;

import primevc.js.events.DOMSignal1;
import js.Dom;

typedef TouchEvent = 
{
	>DOMEvent,
	public var altKey			(default, null):Bool; // Indicates whether or not the ALT key was pressed when the event was triggered. 
	public var ctrlKey			(default, null):Bool; // Indicates whether or not the CTRL key was pressed when the event was triggered. 
	public var metaKey			(default, null):Bool; // Indicates whether or not the META key was pressed when the event was triggered. 
	public var shiftKey			(default, null):Bool; // Indicates whether or not the SHIFT key was pressed when the event was triggered. 
	public var touches			(default, null):Array<Touch>; // A collection of Touch objects representing all touches associated with this event.
	public var targetTouches	(default, null):Array<Touch>; // A collection of Touch objects representing all touches associated with this target.
	public var changedTouches	(default, null):Array<Touch>; // A collection of Touch objects representing all touches that changed in this event.
	// The delta rotation since the start of an event, in degrees, where clockwise is positive and
	// counter-clockwise is negative. The initial value is 0.0.
	public var rotation			(default, null):Float;
	// The distance between two fingers since the start of an event as a multiplier of the initial distance.
	// The initial value is 1.0. If less than 1.0, the gesture is pinch close (to zoom out). 
	// If greater than 1.0, the gesture is pinch open (to zoom in).
	public var scale			(default, null):Float;
}

typedef Touch = 
{
	public var target		(default, null):HtmlDom; // Node the touch event originated from.
	public var identifier	(default, null):Int; // The unique identifying number for this touch object.
	public var clientX		(default, null):Int; // The x-coordinate of the touch’s location relative to the window’s viewport (excludes scroll offset).
	public var clientY		(default, null):Int; // The y-coordinate of the touch’s location relative to the window’s viewport (excludes scroll offset).
	public var screenX		(default, null):Int; // The x-coordinate of the touch’s location in screen coordinates.
	public var screenY		(default, null):Int; // The y-coordinate of the touch’s location in screen coordinates.
	public var pageX		(default, null):Int; // The x-coordinate of the touch’s location in screen coordinates (includes scrolling).
	public var pageY		(default, null):Int; // The y-coordinate of the touch’s location in screen coordinates (includes scrolling).
}

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */
class TouchSignal extends DOMSignal1<TouchEvent>
{
	override private function dispatch(e:Event)
	{
		//untyped e.preventDefault();
		
		send(cast e);
	}
}