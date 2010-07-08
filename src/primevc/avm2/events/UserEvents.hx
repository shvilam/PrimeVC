package primevc.avm2.events;
 import primevc.core.dispatcher.INotifier;
 import primevc.gui.events.UserEvents;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.events.MouseEvents;


/**	
 * AVM2 UserEvents implementation
 * 
 * @creation-date	Jun 15, 2010
 * @author			Danny Wilson
 */
class UserEvents extends primevc.gui.events.UserSignals	
{
	public function new(eventDispatcher)
	{
		this.mouse	= new primevc.avm2.events.MouseEvents(eventDispatcher);
		this.key	= new primevc.avm2.events.KeyboardEvents(eventDispatcher);
		this.focus	= new FlashSignal0(eventDispatcher, flash.events.FocusEvent.FOCUS_IN);
		this.blur	= new FlashSignal0(eventDispatcher, flash.events.FocusEvent.FOCUS_OUT);
	}
}