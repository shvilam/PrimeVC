package primevc.js.events;

import primevc.core.dispatcher.Signals;

/**	
 * @author Stanislav Sopov
 * @since  May 3, 2011
 */
class GestureEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var start	(getStart,	null):GestureSignal;
	public var change	(getChange,	null):GestureSignal;
	public var end		(getEnd,	null):GestureSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getStart 	() { if (start	== null) { createStart();	} return start; }
	private inline function getChange	() { if (change	== null) { createChange();	} return change; }
	private inline function getEnd		() { if (end 	== null) { createEnd();		} return end; }
	
	private function createStart	() { start 	= new GestureSignal(eventDispatcher, "gesturestart"); }
	private function createChange	() { change = new GestureSignal(eventDispatcher, "gesturechange"); }
	private function createEnd		() { end	= new GestureSignal(eventDispatcher, "gestureend"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).start	!= null ) start.dispose();
		if ( (untyped this).change	!= null ) change.dispose();
		if ( (untyped this).end		!= null ) end.dispose();
		
		start =
		change =
		end =
		null;
	}
}