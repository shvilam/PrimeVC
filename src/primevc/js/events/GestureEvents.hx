package primevc.js.events;

import primevc.core.dispatcher.Signals;

/**	
 * @author Stanislav Sopov
 * @since  May 3, 2011
 */
class GestureEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var gestureStart		(getGestureStart,	null):GestureSignal;
	public var gestureChange	(getGestureChange,	null):GestureSignal;
	public var gestureEnd		(getGestureEnd,		null):GestureSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getGestureStart 	() { if (gestureStart	== null) { createGestureStart();	} return gestureStart; }
	private inline function getGestureChange	() { if (gestureChange	== null) { createGestureChange();	} return gestureChange; }
	private inline function getGestureEnd		() { if (gestureEnd 	== null) { createGestureEnd();		} return gestureEnd; }
	
	private function createGestureStart		() { gestureStart 	= new GestureSignal(eventDispatcher, "gesturestart"); }
	private function createGestureChange	() { gestureChange 	= new GestureSignal(eventDispatcher, "gesturechange"); }
	private function createGestureEnd		() { gestureEnd		= new GestureSignal(eventDispatcher, "gestureend"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).gestureStart	!= null ) gestureStart.dispose();
		if ( (untyped this).gestureChange	!= null ) gestureChange.dispose();
		if ( (untyped this).gestureEnd		!= null ) gestureEnd.dispose();
		
		gestureStart =
		gestureChange =
		gestureEnd =
		null;
	}
}