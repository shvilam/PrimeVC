package primevc.js.events;

import primevc.core.dispatcher.Signals;

/**	
 * @author Stanislav Sopov
 * @since  March 2, 2011
 */
class TouchEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var start	(getStart, 	null):TouchSignal;
	public var move		(getMove,	null):TouchSignal;
	public var end		(getEnd,	null):TouchSignal;
	public var cancel	(getCancel,	null):TouchSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getStart	() { if (start 	== null) { createStart();	} return start; }
	private inline function getMove		() { if (move 	== null) { createMove();	} return move; }
	private inline function getEnd		() { if (end 	== null) { createEnd();		} return end; }
	private inline function getCancel	() { if (cancel == null) { createCancel(); 	} return cancel; }
	
	private function createStart	() { start 	= new TouchSignal(eventDispatcher, "touchstart"); }
	private function createMove		() { move 	= new TouchSignal(eventDispatcher, "touchmove"); }
	private function createEnd		() { end 	= new TouchSignal(eventDispatcher, "touchend"); }
	private function createCancel	() { cancel = new TouchSignal(eventDispatcher, "touchcancel"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).start	!= null ) start.dispose();
		if ( (untyped this).move	!= null ) move.dispose();
		if ( (untyped this).end		!= null ) end.dispose();
		if ( (untyped this).cancel	!= null ) cancel.dispose();
		
		start =
		move =
		end =
		cancel =
		null;
	}
}