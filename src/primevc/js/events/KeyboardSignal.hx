package primevc.js.events;

import primevc.gui.events.KeyboardEvents;
import primevc.gui.events.KeyModState;
import primevc.js.events.DOMSignal1;
import js.Dom;

typedef KeyboardEvent = 
{
	>DOMEvent,
	/*
	keyLocation constants
	KEY_LOCATION_LEFT 		= 0x01; 
	KEY_LOCATION_NUMPAD 	= 0x03; 
	KEY_LOCATION_RIGHT 		= 0x02; 
	KEY_LOCATION_STANDARD 	= 0x00; 
	*/
	public var altGraphKey	(default, null):Bool;
	public var altKey 		(default, null):Bool; // Indicates whether or not the ALT key was pressed when the event was triggered. 
	public var charCode		(default, null):Int; // Works for keypress event. Sometimes browser-specific. 
	public var ctrlKey 		(default, null):Bool; // Indicates whether or not the CTRL key was pressed when the event was triggered. 
	public var keyCode		(default, null):Int; // Works for keydown/keyup events. Sometimes browser-specific. 
	public var keyIdentifier(default, null):String; // String identifier for the key.
	public var keyLocation	(default, null):Int; // The location of the key on the keyboard.
	public var metaKey		(default, null):Bool; // Indicates whether the META key was pressed when the event was triggered.
	public var shiftKey 	(default, null):Bool; // Indicates whether or not the SHIFT key was pressed when the event was triggered.
}

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */
class KeyboardSignal extends DOMSignal1<KeyboardState>
{	
	override private function dispatch(e:Event)
	{
		send( stateFromEvent(cast e) );
	}
	
	static  public function stateFromEvent( e:KeyboardEvent ) : KeyboardState
	{	
		/*
			charCode				keyCode					keyLocation		KeyMod
			FFF (12-bit) 0-4095		3FF (10-bit) 0-1023		F (4-bit)		F (4-bit)
		*/
		
		var flags;

		Assert.that(e.charCode	< 16384); // 14 bits available in AVM2
		Assert.that(e.keyCode	<  1024);
		
		flags = (e.altKey?	KeyModState.ALT : 0)
			| (e.ctrlKey?	KeyModState.CMD | KeyModState.CTRL : 0)
			| (e.shiftKey?	KeyModState.SHIFT : 0);
		
		
		flags |= cast(e.keyLocation, UInt) << 4;
		flags |= (e.charCode << 18);
		flags |= (e.keyCode << 8);

		return new KeyboardState(flags, e.target);
	}
}