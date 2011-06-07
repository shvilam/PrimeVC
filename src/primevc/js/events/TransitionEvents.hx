package primevc.js.events;

import primevc.core.dispatcher.Signals;

/**	
 * @author Stanislav Sopov
 * @since  March 2, 2011
 */

class TransitionEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var transitionEnd(getTransitionEnd, null):TransitionSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getTransitionEnd() { if (transitionEnd == null) { createTransitionEnd(); } return transitionEnd; }
	
	private function createTransitionEnd() { transitionEnd = new TransitionSignal(eventDispatcher, "webkitTransitionEnd"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).transitionEnd	!= null ) transitionEnd.dispose();
		
		transitionEnd = null;
	}
}