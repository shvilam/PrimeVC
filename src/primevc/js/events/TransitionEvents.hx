package primevc.js.events;

import primevc.core.dispatcher.Signals;

/**	
 * @author Stanislav Sopov
 * @since  March 2, 2011
 */

class TransitionEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var end(getEnd, null):TransitionSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getEnd() { if (end == null) { createEnd(); } return end; }
	
	private function createEnd() { end = new TransitionSignal(eventDispatcher, "webkitTransitionEnd"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).end	!= null ) end.dispose();
		
		end = null;
	}
}