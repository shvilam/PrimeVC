package primevc.js.events;

import primevc.core.dispatcher.Signals;
import js.Dom;

/**	
 * @since march 2, 2011
 * @author Stanislav Sopov
 */

class FocusEvents extends Signals
{
	var eventDispatcher:HtmlDom;
	
	public var focus(getFocus,	null):FocusSignal;
	public var blur (getBlur,	null):FocusSignal;

	
	public function new(eventDispatcher:HtmlDom)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	
	private inline function getFocus()	{ if (focus	== null) { createFocus();	} return focus; }
	private inline function getBlur()	{ if (blur 	== null) { createBlur();	} return blur; }
	
	
	private function createFocus() 	{ focus	= new FocusSignal(eventDispatcher, "focus"); }
	private function createBlur() 	{ blur	= new FocusSignal(eventDispatcher, "blur"); }
	
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).focus	!= null ) focus.dispose();
		if ( (untyped this).blur	!= null ) blur.dispose();
		
		focus =
		blur =
		null;
	}
}



	





