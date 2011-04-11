package primevc.js.events;

import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since	April 7, 2011	
 */

class DOMEvent 
{
	/*
	eventPhase constants
	const unsigned short CAPTURING_PHASE	= 1;
	const unsigned short AT_TARGET			= 2;
	const unsigned short BUBBLING_PHASE		= 3;
	*/
	
	public var event			(default, null):Event;
	
	public var type				(default, null):String; // The type of event.
	public var target 			(default, null):Dynamic; // The element to which the event was originally dispatched.
	public var currentTarget	(default, null):Dynamic; // The element whose EventListeners are currently being processed.
	public var relatedTarget	(default, null):Dynamic; // A secondary event target related to the event. 
    public var timeStamp		(default, null):Int; // The time (in milliseconds since 0:0:0 UTC 1st January 1970) at which the event was created.
	public var eventPhase		(default, null):Int; // Indicates which event-handling phase the event is in.
    public var bubbles			(default, null):Bool; // Indicates whether the event goes through the bubbling phase.
    public var cancelable		(default, null):Bool; // Indicates whether the event can be canceled.
	public var defaultPrevented	(getDefaultPrevented, null):Bool; // Indicates whether the default action has been prevented.
	public var canBubble		(default, null):Bool; // Webkit.
	public var returnValue		(default, null):Bool; // Webkit.
	public var srcElement		(default, null):Dynamic; // Webkit.
	
	public function new(event:Event) 
	{
		this.event = event;
		
		untyped
		{
			type				= event.type;
			target 				= event.target;
			currentTarget		= event.currentTarget;
			relatedTarget		= event.relatedTarget;
			timeStamp			= event.timeStamp;
			eventPhase			= event.eventPhase;
			bubbles				= event.bubbles;
			cancelable			= event.cancelable;
			defaultPrevented	= event.defaultPrevented;
			canBubble			= event.canBubble;
			returnValue			= event.returnValue;
			srcElement			= event.srcElement;
		}
	}
	
	public function preventDefault()
	{
		untyped event.preventDefault();
	}
	
	public function stopPropagation()
	{
		untyped event.stopPropagation();
	}
	
	private function getDefaultPrevented():Bool
	{
		return untyped event.defaultPrevented;
	}
}

class DOMUIEvent extends DOMEvent
{
	public var altKey 		(default, null):Bool; // Indicates whether or not the ALT key was pressed when the event was triggered. 	
	public var ctrlKey 		(default, null):Bool; // Indicates whether or not the CTRL key was pressed when the event was triggered. 
	public var metaKey		(default, null):Bool; // Indicates whether the META key was pressed when the event was triggered.
	public var shiftKey 	(default, null):Bool; // Indicates whether or not the SHIFT key was pressed when the event was triggered.
	
	public function new(event:Event) 
	{
		super(event);
		
		untyped
		{
			altKey		= event.altKey;
			ctrlKey		= event.ctrlKey;
			metaKey 	= event.metaKey;
			shiftKey	= event.shiftKey;
		}
	}
}

class DOMPointingEvent extends DOMUIEvent
{
	public var clientX		(default, null):Int; // X coordinate of touch relative to the viewport (excludes scroll offset)
	public var clientY		(default, null):Int; // Y coordinate of touch relative to the viewport (excludes scroll offset)
	public var screenX		(default, null):Int; // Relative to the screen
	public var screenY		(default, null):Int; // Relative to the screen
	public var pageX		(default, null):Int; // Relative to the full page (includes scrolling)
	public var pageY		(default, null):Int; // Relative to the full page (includes scrolling)
	
	public function new(event:Event) 
	{
		super(event);
		
		untyped
		{
			clientX 	= touch.clientX;
			clientY 	= touch.clientY;		
			screenX 	= touch.screenX;	
			screenY 	= touch.screenY;	
			pageX		= touch.pageX;	
			pageY		= touch.pageY;	
		}
	}
}