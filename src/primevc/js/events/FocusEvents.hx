package primevc.js.events;

import primevc.core.dispatcher.Signals;
import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */

class FocusEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var focus		(getFocus,			null):FocusSignal;
	public var focusIn		(getFocusIn,		null):FocusSignal;
	public var DOMFocusIn	(getDOMFocusIn,		null):FocusSignal;
	public var blur			(getBlur,			null):FocusSignal;
	public var focusOut		(getFocusOut,		null):FocusSignal;
	public var DOMFocusOut	(getDOMFocusOut,	null):FocusSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getFocus		() { if (focus			== null) { createFocus();		} return focus; }
	private inline function getFocusIn		() { if (focusIn 		== null) { createFocusIn();		} return focusIn; }
	private inline function getDOMFocusIn	() { if (DOMFocusIn		== null) { createDOMFocusIn();	} return DOMFocusIn; }
	private inline function getBlur			() { if (blur 			== null) { createBlur();		} return blur; }
	private inline function getFocusOut		() { if (focusOut 		== null) { createFocusOut();	} return focusOut; }
	private inline function getDOMFocusOut	() { if (DOMFocusOut	== null) { createDOMFocusOut();	} return DOMFocusOut; }
	
	private function createFocus		() { focus			= new FocusSignal(eventDispatcher, "focus"); }
	private function createFocusIn		() { focusIn		= new FocusSignal(eventDispatcher, "focusin"); }
	private function createDOMFocusIn	() { DOMFocusIn		= new FocusSignal(eventDispatcher, "DOMFocusIn"); }
	private function createBlur			() { blur			= new FocusSignal(eventDispatcher, "blur"); }
	private function createFocusOut		() { focusOut		= new FocusSignal(eventDispatcher, "focusout"); }
	private function createDOMFocusOut	() { DOMFocusOut	= new FocusSignal(eventDispatcher, "DOMFocusOut"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).focus		!= null ) focus.dispose();
		if ( (untyped this).focusIn		!= null ) focusIn.dispose();
		if ( (untyped this).DOMFocusIn	!= null ) DOMFocusIn.dispose();
		if ( (untyped this).blur		!= null ) blur.dispose();
		if ( (untyped this).focusOut	!= null ) focusOut.dispose();
		if ( (untyped this).DOMFocusOut	!= null ) DOMFocusOut.dispose();
		
		focus = 
		focusIn = 
		DOMFocusIn = 
		blur = 
		focusOut = 
		DOMFocusOut = 
		null;
	}
}



	





