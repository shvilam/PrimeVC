package primevc.js.events;
 import primevc.core.geom.Point;
 import primevc.gui.events.TouchEvents;
 import js.Dom;

/**
 * @author Ruben Weijers
 * @creation-date Nov 10, 2011
 */
class TouchSignal extends DOMSignal1<TouchState>
{
	override private function dispatch(e:Event) 
	{
		var t:Array<Touch> 	= (untyped e).touches;
		var local:Point		= t.length > 0 ? new Point(t[0].clientX, t[0].clientY) : null;
		var stage:Point		= t.length > 0 ? new Point(t[0].screenX, t[0].screenY) : null;
		send(new TouchState(e.target, local, stage));
	}
}




//import js.Dom;

/**
 * @author Stanislav Sopov
 * @since march 2, 2011
 */
/*class TouchSignal extends DOMSignal1<Type>
{
	override private function dispatch(event:Event) 
	{
		var touchEvent = new TouchEvent(event);
		
		send(touchEvent);
	}
}


class TouchEvent
{	
	public var type				(default, null):String; // The type of event that occurred.
	// The distance between two fingers since the start of an event as a multiplier of the initial distance. The
	// initial value is 1.0. If less than 1.0, the gesture is pinch close (to zoom out). If greater than 1.0, the
	// gesture is pinch open (to zoom in).
	public var scale			(default, null):Float;
	// The delta rotation since the start of an event, in degrees, where clockwise is positive and
	// counter-clockwise is negative. The initial value is 0.0.
	public var rotation			(default, null):Float;
	public var allTouches		(default, null):Array<Touch>; // A collection of Touch objects representing all touches associated with this event.
	public var targetTouches	(default, null):Array<Touch>; // A collection of Touch objects representing all touches associated with this target.
	public var changedTouches	(default, null):Array<Touch>; // A collection of Touch objects representing all touches that changed in this event.
	
	
	public function new (event:Event)
	{
		type = event.type;
		scale = event.scale;
		rotation = event.rotation;
		
		untyped 
		{
			allTouches = event.touches;
			targetTouches = event.targetTouches;
			changedTouches = event.changedTouches;
		}
	}
}*/


typedef Touch = {
	public var target		(default, null):HtmlDom; // Node the touch event originated from
	public var identifier	(default, null):Int; // An identifying number, unique to each touch event
	public var clientX		(default, null):Int; // X coordinate of touch relative to the viewport (excludes scroll offset)
	public var clientY		(default, null):Int; // Y coordinate of touch relative to the viewport (excludes scroll offset)
	public var screenX		(default, null):Int; // Relative to the screen
	public var screenY		(default, null):Int; // Relative to the screen
	public var pageX		(default, null):Int; // Relative to the full page (includes scrolling)
	public var pageY		(default, null):Int; // Relative to the full page (includes scrolling)
}

/*
class Touch
{
	public var target		(default, null):HtmlDom; // Node the touch event originated from
	public var identifier	(default, null):Int; // An identifying number, unique to each touch event
	public var clientX		(default, null):Int; // X coordinate of touch relative to the viewport (excludes scroll offset)
	public var clientY		(default, null):Int; // Y coordinate of touch relative to the viewport (excludes scroll offset)
	public var screenX		(default, null):Int; // Relative to the screen
	public var screenY		(default, null):Int; // Relative to the screen
	public var pageX		(default, null):Int; // Relative to the full page (includes scrolling)
	public var pageY		(default, null):Int; // Relative to the full page (includes scrolling)
	
	public function new (touch:Dynamic)
	{
		target		= (touch.target != null) 		? cast(touch.target, HtmlDom) 		: null;	
		identifier	= (touch.identifier != null)	? Std.parseInt(touch.identifier)	: null;
		clientX 	= (touch.clientX != null) 		? Std.parseInt(touch.clientX) 		: null;
		clientY 	= (touch.clientY != null) 		? Std.parseInt(touch.clientX) 		: null;		
		screenX 	= (touch.screenX != null) 		? Std.parseInt(touch.clientX) 		: null;	
		screenY 	= (touch.screenY != null) 		? Std.parseInt(touch.clientX) 		: null;	
		pageX		= (touch.pageX != null) 		? Std.parseInt(touch.clientX) 		: null;	
		pageY		= (touch.pageY != null) 		? Std.parseInt(touch.clientX) 		: null;	
	}
}
*/