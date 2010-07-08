package primevc.avm2.events;
 import flash.display.DisplayObject;
 import flash.events.Event;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.dispatcher.Signals;
 import primevc.gui.events.DisplayEvents;


/**
 * Display object-event implementation
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class DisplayEvents extends DisplaySignals
{
	public function new (target:DisplayObject)
	{
		addedToStage		= new FlashSignal0( target, Event.ADDED_TO_STAGE );
		removedFromStage	= new FlashSignal0( target, Event.REMOVED_FROM_STAGE );
		enterFrame			= new FlashSignal0( target, Event.ENTER_FRAME );
	}
}