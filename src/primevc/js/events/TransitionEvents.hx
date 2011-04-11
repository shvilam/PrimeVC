package primevc.js.events;

import primevc.core.dispatcher.Signals;
import js.Dom;

/**	
 * @author Stanislav Sopov
 * @since  March 2, 2011
 */

class TransitionEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var webkitTransitionEnd(getWebkitTransitionEnd, null):TransitionSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getWebkitTransitionEnd() { if (webkitTransitionEnd == null) { createWebkitTransitionEnd(); } return webkitTransitionEnd; }
	
	private function createWebkitTransitionEnd() { webkitTransitionEnd = new TransitionSignal(eventDispatcher, "webkitTransitionEnd"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).webkitTransitionEnd	!= null ) webkitTransitionEnd.dispose();
		
		webkitTransitionEnd = null;
	}
}