package primevc.js.events;
 import primevc.core.dispatcher.Signals;
 import primevc.gui.events.UserEventTarget;

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */
class FocusEvents extends Signals
{
	private var eventDispatcher : UserEventTarget;
	
	public var focus		(getFocus,		 null) : FocusSignal;
	public var focusIn		(getFocusIn,	 null) : FocusSignal;
	public var DOMFocusIn	(getDOMFocusIn,	 null) : FocusSignal;
	public var blur			(getBlur,		 null) : FocusSignal;
	public var focusOut		(getFocusOut,	 null) : FocusSignal;
	public var DOMFocusOut	(getDOMFocusOut, null) : FocusSignal;
	

	public function new(eventDispatcher)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}

	
	override public function dispose ()
	{
		super.dispose();
		eventDispatcher = null;
	}

	
	private inline function getFocus			() { if (focus		 == null) { createFocus();		 } return focus; }
	private inline function getFocusIn			() { if (focusIn 	 == null) { createFocusIn();	 } return focusIn; }
	private inline function getDOMFocusIn		() { if (DOMFocusIn	 == null) { createDOMFocusIn();	 } return DOMFocusIn; }
	private inline function getBlur				() { if (blur 		 == null) { createBlur();		 } return blur; }
	private inline function getFocusOut			() { if (focusOut 	 == null) { createFocusOut();	 } return focusOut; }
	private inline function getDOMFocusOut		() { if (DOMFocusOut == null) { createDOMFocusOut(); } return DOMFocusOut; }
	
	private inline function createFocus			() { focus			= new FocusSignal(eventDispatcher, "focus"); }
	private inline function createFocusIn		() { focusIn		= new FocusSignal(eventDispatcher, "focusin"); }
	private inline function createDOMFocusIn	() { DOMFocusIn		= new FocusSignal(eventDispatcher, "DOMFocusIn"); }
	private inline function createBlur			() { blur			= new FocusSignal(eventDispatcher, "blur"); }
	private inline function createFocusOut		() { focusOut		= new FocusSignal(eventDispatcher, "focusout"); }
	private inline function createDOMFocusOut	() { DOMFocusOut	= new FocusSignal(eventDispatcher, "DOMFocusOut"); }
}



	





