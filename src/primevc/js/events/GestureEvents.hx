package primevc.js.events;
 import primevc.core.dispatcher.Signals;


/**	
 * @author Stanislav Sopov
 * @author Ruben Weijers
 * @since  May 3, 2011
 */
class GestureEvents extends Signals
{
	private var eventDispatcher : UserEventTarget;
	
	public var start	(getStart,	null) : GestureSignal;
	public var change	(getChange,	null) : GestureSignal;
	public var end		(getEnd,	null) : GestureSignal;
	

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

	
	private inline function getStart 	() { if (start	== null) { createStart();	} return start; }
	private inline function getChange	() { if (change	== null) { createChange();	} return change; }
	private inline function getEnd		() { if (end 	== null) { createEnd();		} return end; }
	
	private inline function createStart	() { start 	= new GestureSignal(eventDispatcher, "gesturestart"); }
	private inline function createChange() { change = new GestureSignal(eventDispatcher, "gesturechange"); }
	private inline function createEnd	() { end	= new GestureSignal(eventDispatcher, "gestureend"); }
}