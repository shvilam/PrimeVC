package primevc.js.events;

import primevc.core.dispatcher.Signals;
import js.Dom;

/**	
 * @author Stanislav Sopov
 * @since  March 2, 2011
 */

class TouchEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var touchStart	(getTouchStart, 	null):TouchSignal;
	public var touchMove	(getTouchMove,		null):TouchSignal;
	public var touchEnd		(getTouchEnd,		null):TouchSignal;
	public var touchCancel	(getTouchCancel,	null):TouchSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getTouchStart	() { if (touchStart 	== null) { createTouchStart();	} return touchStart; }
	private inline function getTouchMove	() { if (touchMove 		== null) { createTouchMove();	} return touchMove; }
	private inline function getTouchEnd		() { if (touchEnd 		== null) { createTouchEnd();	} return touchEnd; }
	private inline function getTouchCancel	() { if (touchCancel 	== null) { createTouchCancel(); } return touchCancel; }
	
	private function createTouchStart		() { touchStart 		= new TouchSignal(eventDispatcher, "touchstart"); }
	private function createTouchMove		() { touchMove 			= new TouchSignal(eventDispatcher, "touchmove"); }
	private function createTouchEnd			() { touchEnd 			= new TouchSignal(eventDispatcher, "touchend"); }
	private function createTouchCancel		() { touchCancel 		= new TouchSignal(eventDispatcher, "touchcancel"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).touchStart	!= null ) touchStart.dispose();
		if ( (untyped this).touchMove	!= null ) touchMove.dispose();
		if ( (untyped this).touchEnd	!= null ) touchEnd.dispose();
		if ( (untyped this).touchCancel	!= null ) touchCancel.dispose();
		
		touchStart =
		touchMove =
		touchEnd =
		touchCancel =
		null;
	}
}