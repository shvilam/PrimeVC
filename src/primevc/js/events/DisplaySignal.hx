package primevc.js.events;

import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */

class DisplaySignal extends DOMSignal1<DisplayEvent>
{
	override private function dispatch(event:Event) 
	{
		var displayEvent = new DisplayEvent(event);
		
		send(displayEvent);
	}
}

class DisplayEvent extends DOMEvent
{	
	/*
	attrChange constants
	const unsigned short ADDITION = 2; 
	const unsigned short MODIFICATION = 1; 
	const unsigned short REMOVAL = 3; 
	*/
	
	public var attrChange	(default, null):Int; // The type of change which triggered the event.
	public var attrName		(default, null):String; // The name of the modified attribute.
	public var newValue		(default, null):String; // The new value of the modified attribute.
	public var prevValue	(default, null):String; // The previous value of the modified attribute.
	public var relatedNode	(default, null):Dynamic; // A secondary element related to the event. 
	
	public function new (event:Event)
	{
		super(event);
		
		untyped
		{
			attrChange	= event.attrChange;
			attrName	= event.attrName;
			newValue	= newValue;
			prevValue	= prevValue;
			relatedNode	= relatedNode;
		}
	}
}