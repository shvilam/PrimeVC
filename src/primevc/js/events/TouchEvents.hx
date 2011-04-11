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
	
	public var orientationChange(getOrientationChange,	null):TouchSignal;
	public var touchStart		(getTouchStart, 		null):TouchSignal;
	public var touchMove		(getTouchMove,			null):TouchSignal;
	public var touchEnd			(getTouchEnd,			null):TouchSignal;
	public var touchCancel		(getTouchCancel,		null):TouchSignal;
	public var gestureStart		(getGestureStart,		null):TouchSignal;
	public var gestureChange	(getGestureChange,		null):TouchSignal;
	public var gestureEnd		(getGestureEnd,			null):TouchSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getOrientationChange()	{ if (orientationChange == null) { createOrientationChange();	} return orientationChange; }
	private inline function getTouchStart()			{ if (touchStart 		== null) { createTouchStart();			} return touchStart; }
	private inline function getTouchMove()			{ if (touchMove 		== null) { createTouchMove();			} return touchMove; }
	private inline function getTouchEnd()			{ if (touchEnd 			== null) { createTouchEnd();			} return touchEnd; }
	private inline function getTouchCancel()		{ if (touchCancel 		== null) { createTouchCancel();			} return touchCancel; }
	private inline function getGestureStart()		{ if (gestureStart 		== null) { createGestureStart();		} return gestureStart; }
	private inline function getGestureChange()		{ if (gestureChange 	== null) { createGestureChange();		} return gestureChange; }
	private inline function getGestureEnd()			{ if (gestureEnd 		== null) { createGestureEnd();			} return gestureEnd; }
	
	private function createOrientationChange() { orientationChange 	= new TouchSignal(eventDispatcher, "orientationchange"); }
	private function createTouchStart		() { touchStart 		= new TouchSignal(eventDispatcher, "touchstart"); }
	private function createTouchMove		() { touchMove 			= new TouchSignal(eventDispatcher, "touchmove"); }
	private function createTouchEnd			() { touchEnd 			= new TouchSignal(eventDispatcher, "touchend"); }
	private function createTouchCancel		() { touchCancel 		= new TouchSignal(eventDispatcher, "touchcancel"); }
	private function createGestureStart		() { gestureStart 		= new TouchSignal(eventDispatcher, "gesturestart"); }
	private function createGestureChange	() { gestureChange 		= new TouchSignal(eventDispatcher, "gesturechange"); }
	private function createGestureEnd		() { gestureEnd			= new TouchSignal(eventDispatcher, "gestureend"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).orientationChange	!= null ) orientationChange.dispose();
		if ( (untyped this).touchStart			!= null ) touchStart.dispose();
		if ( (untyped this).touchMove			!= null ) touchMove.dispose();
		if ( (untyped this).touchEnd			!= null ) touchEnd.dispose();
		if ( (untyped this).touchCancel			!= null ) touchCancel.dispose();
		if ( (untyped this).gestureStart		!= null ) gestureStart.dispose();
		if ( (untyped this).gestureChange		!= null ) gestureChange.dispose();
		if ( (untyped this).gestureEnd			!= null ) gestureEnd.dispose();
		
		orientationChange =
		touchStart =
		touchMove =
		touchEnd =
		touchCancel =
		gestureStart =
		gestureChange =
		gestureEnd =
		null;
	}
}