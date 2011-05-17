package primevc.js.events;

import primevc.core.dispatcher.Signals;

/**	
 * @since march 2, 2011
 * @author Stanislav Sopov
 */
class KeyboardEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var keyDown	(getKeyDown,	null):KeyboardSignal;
	public var keyUp 	(getKeyUp,		null):KeyboardSignal;
	public var keyPress (getKeyPress,	null):KeyboardSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getKeyDown()	{ if (keyDown	== null) { createKeyDown();		} return keyDown; }
	private inline function getKeyUp()		{ if (keyUp 	== null) { createKeyUp();		} return keyUp; }
	private inline function getKeyPress()	{ if (keyPress 	== null) { createKeyPress();	} return keyPress; }
	
	private function createKeyDown() 	{ keyDown	= new KeyboardSignal(eventDispatcher, "keydown"); }
	private function createKeyUp()		{ keyUp		= new KeyboardSignal(eventDispatcher, "keyup"); }
	private function createKeyPress()	{ keyPress	= new KeyboardSignal(eventDispatcher, "keypress"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).keyDown		!= null ) keyDown.dispose();
		if ( (untyped this).keyUp		!= null ) keyUp.dispose();
		if ( (untyped this).keyPress	!= null ) keyPress.dispose();
		
		keyDown = 
		keyUp = 
		keyPress = 
		null;
	}
}

