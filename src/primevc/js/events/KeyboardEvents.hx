package primevc.js.events;

import primevc.core.dispatcher.Signals;
import js.Dom;

/**	
 * @since march 2, 2011
 * @author Stanislav Sopov
 */

class KeyboardEvents extends Signals
{
	var eventDispatcher:HtmlDom;
	
	public var keydown	(getKeydown,	null):KeyboardSignal;
	public var keyup 	(getKeyup,		null):KeyboardSignal;
	public var keypress (getKeypress,	null):KeyboardSignal;
	
	
	public function new(eventDispatcher:HtmlDom)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	
	private inline function getKeydown()	{ if (keydown	== null) { createKeydown();	} return keydown; }
	private inline function getKeyup()		{ if (keyup 	== null) { createKeyup();	} return keyup; }
	private inline function getKeypress()	{ if (keypress 	== null) { createKeypress();} return keypress; }
	
	
	private function createKeydown() 	{ keydown	= new KeyboardSignal(eventDispatcher, "keydown"); }
	private function createKeyup()		{ keyup		= new KeyboardSignal(eventDispatcher, "keyup"); }
	private function createKeypress()	{ keypress	= new KeyboardSignal(eventDispatcher, "keypress"); }
	
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
/*		if ( (untyped this).keydown		!= null ) keydown.dispose();
		if ( (untyped this).keyup		!= null ) keyup.dispose();
		if ( (untyped this).keypress	!= null ) keypress.dispose();
		
		keydown = 
		keyup = 
		keypress = 
		null;*/
	}
}

