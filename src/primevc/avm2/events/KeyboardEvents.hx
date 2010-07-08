package primevc.avm2.events;
private typedef KeyboardSignal = primevc.avm2.events.KeyboardSignal; // override import
 import primevc.gui.events.KeyboardEvents;
 import flash.events.KeyboardEvent;

/**
 * AVM2 keyboard event implementation.
 * 
 * @author Danny Wilson
 * @creation-date jun 14, 2010
 */
class KeyboardEvents extends KeyboardSignals
{
	public function new (eventDispatcher)
	{
		this.down = new KeyboardSignal(eventDispatcher, KeyboardEvent.KEY_DOWN);
		this.up   = new KeyboardSignal(eventDispatcher, KeyboardEvent.KEY_UP  );
	}
}