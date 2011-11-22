package primevc.js.events;
 import primevc.core.dispatcher.Signals;


/**	
 * @author Stanislav Sopov
 * @since  March 2, 2011
 */
class TransitionEvents extends Signals
{
	private var eventDispatcher : Dynamic;
	public  var end 			(getEnd, null) : TransitionSignal;

	
	public function new(eventDispatcher:Dynamic)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}

	
	override public function dispose ()
	{
		super.dispose();
		eventDispatcher = null;
	}

	
	private inline function getEnd() { if (end == null) { createEnd(); } return end; }
	private inline function createEnd() { end = new TransitionSignal(eventDispatcher, "webkitTransitionEnd"); }
}