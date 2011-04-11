package primevc.js.events;

import primevc.gui.events.KeyboardEvents;
import primevc.gui.events.KeyModState;
import primevc.core.dispatcher.Wire;
import primevc.core.dispatcher.Signal1;
import primevc.core.dispatcher.IWireWatcher;
using primevc.core.ListNode;
import js.Dom;
import js.Lib;

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */

class KeyboardSignal extends DOMSignal1<KeyboardEvent>
{
	override private function dispatch(event:Event) 
	{
		var keyboardEvent = new KeyboardEvent(event);
		
		send(keyboardEvent);
	}
}

class KeyboardSignal extends Signal1<KeyboardState>, implements IWireWatcher<KeyboardHandler>
{	
	/*
	keyLocation constants
	const unsigned long KEY_LOCATION_LEFT 		= 0x01; 
	const unsigned long KEY_LOCATION_NUMPAD 	= 0x03; 
	const unsigned long KEY_LOCATION_RIGHT 		= 0x02; 
	const unsigned long KEY_LOCATION_STANDARD	= 0x00;
	
	
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
	
	public var char				(default, null):String; // The character value of the key pressed.
	public var key				(default, null):String; // The key value of the key pressed. 
	// If the value is a character, it must match the value of the KeyboardEvent.char attribute.
	public var keyCode			(default, null):Int; // The numerical code of the key pressed (platform-dependant). 
	public var location			(default, null):Int; // The location of the key on the device.
	public var repeat			(default, null):Bool; // Indicates whether or not the key has been pressed in a reptetitive manner. 
	public var altGraphKey		(default, null):Bool; // Webkit.
	public var charCode			(default, null):Int; // Webkit.
	public var keyIdentifier	(default, null):String; // Webkit.
	public var keyLocation		(default, null):Int; // Webkit.
	*/


	private var eventDispatcher:IEventDispatcher;
	private var event:String;
	
	public function new (d:IEventDispatcher, e:String)
	{
		super();
		this.eventDispatcher = d;
		this.event = e;
	}
	
	public function wireEnabled	(wire:Wire<KeyboardHandler>) : Void {
		Assert.that(n != null);
		if (n.next() == null) // First wire connected
			eventDispatcher.addEventListener(event, dispatch, false, 0, true);
			
			untyped
			{    
				if (js.Lib.isIE)
				{
					eventDispatcher.attachEvent(event, dispatch, false);
				}
				else 
				{
					eventDispatcher.addEventListener(event, dispatch, false);
				}
			}
	}
	}
	
	public function wireDisabled	(wire:Wire<KeyboardHandler>) : Void {
		if (n == null) // No more wires connected
			eventDispatcher.removeEventListener(event, dispatch, false);
			
			untyped
			{    
				if (js.Lib.isIE)
				{
					eventDispatcher.detachEvent(event, dispatch, false);
				} 
				else 
				{
					eventDispatcher.removeEventListener(event, dispatch, false);
				}
			}
		}
	}
	
	private function dispatch(e:KeyboardEvent) {
		send( stateFromFlashEvent(e) );
	}
	
	static  public function stateFromFlashEvent( e:KeyboardEvent ) : KeyboardState
	{
		/*
			charCode				keyCode					keyLocation		KeyMod
			FFF (12-bit) 0-4095		3FF (10-bit) 0-1023		F (4-bit)		F (4-bit)
		*/
		var flags;

		Assert.that(e.charCode		< 16384); // 14 bits available in AVM2
		Assert.that(e.keyCode		<  1024);
		
		flags = (e.altKey?	KeyModState.ALT : 0)
			| (e.ctrlKey?	KeyModState.CMD | KeyModState.CTRL : 0)
			| (e.shiftKey?	KeyModState.SHIFT : 0);
		
		
		flags |= cast(e.keyLocation, UInt) << 4;
		flags |= (e.charCode << 18);
		flags |= (e.keyCode << 8);

		return new KeyboardState(flags, e.target);
	}
}




