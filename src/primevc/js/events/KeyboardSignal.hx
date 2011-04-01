package primevc.js.events;

import js.Dom;

/**
 * @author Stanislav Sopov
 * @since march 2, 2010
 */

class KeyboardSignal extends DOMSignal1<Type>
{
	override private function dispatch(event:Event) 
	{
		var keyboardEvent = new KeyboardEvent(event);
		
		send(keyboardEvent);
	}
}


class KeyboardEvent
{	
	public var type			(default, null):String; // The type of event that occurred.
	public var keyCode  	(default, null):Int; // The code of the pressed key
	public var target 		(default, null):HtmlDom; // Returns the element that triggered the event
	public var altKey 		(default, null):Bool; // Returns whether or not the "ALT" key was pressed when an event was triggered 	
	public var ctrlKey 		(default, null):Bool; // Returns whether or not the "CTRL" key was pressed when an event was triggered 	 	
	public var shiftKey 	(default, null):Bool; //Returns whether or not the "SHIFT" key was pressed when an event was triggered
	
	public function new (event:Event)
	{
		type = event.type;
		target = event.target;
		altKey = event.altKey;
		ctrlKey = event.ctrlKey; 
		shiftKey = event.shiftKey;
		
		// TODO: include keyCode/charCode parsing routine if needed
		keyCode = event.keyCode;
	}
}




