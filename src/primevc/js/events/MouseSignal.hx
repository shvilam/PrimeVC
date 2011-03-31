package primevc.js.events;

import js.Dom;

/**
 * @author Stanislav Sopov
 * @since march 2, 2010
 */

class MouseSignal extends DOMSignal1<Type>
{
	override private function dispatch(event:Event) 
	{
		var mouseEvent = new MouseEvent(event);
		
		send(mouseEvent);
	}
}


class MouseEvent
{	
	public var type			(default, null):String; // The type of event that occurred.
	public var target 		(default, null):HtmlDom; // Returns the element that triggered the event
	public var altKey 		(default, null):Bool; // Returns whether or not the "ALT" key was pressed when an event was triggered 	
	public var button 		(default, null):Int; // Returns which mouse button was clicked when an event was triggered 
	public var clientX 		(default, null):Int; // Returns the horizontal coordinate of the mouse pointer when an event was triggered 	
	public var clientY 		(default, null):Int; // Returns the vertical coordinate of the mouse pointer when an event was triggered 	
	public var ctrlKey 		(default, null):Bool; // Returns whether or not the "CTRL" key was pressed when an event was triggered 	 	
	public var screenX 		(default, null):Int; // Returns the horizontal coordinate of the mouse pointer when an event was triggered 	
	public var screenY 		(default, null):Int; // Returns the vertical coordinate of the mouse pointer when an event was triggered 	
	public var shiftKey 	(default, null):Bool; //Returns whether or not the "SHIFT" key was pressed when an event was triggered
	
	public function new (event:Event)
	{
		type = event.type;
		target = event.target;
		altKey = event.altKey;
		button = event.button;
		clientX = event.clientX;	 	
		clientY = event.clientY;	 
		ctrlKey = event.ctrlKey; 
		screenX = event.screenX; 
		screenY = event.screenY; 
		shiftKey = event.shiftKey; 
	}
}




