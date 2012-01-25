package primevc.js.events;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.events.UserEventTarget;


/**	
 * @since march 2, 2011
 * @author Stanislav Sopov
 * @author Ruben Weijers
 */
class KeyboardEvents extends KeyboardSignals
{
	private var eventDispatcher : UserEventTarget;
	

	public function new(eventDispatcher:UserEventTarget)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}
	

	override private function createKeyDown() 	{ keyDown	= new KeyboardSignal(eventDispatcher, "keydown"); }
	override private function createKeyUp()		{ keyUp		= new KeyboardSignal(eventDispatcher, "keyup"); }
	override private function createKeyPress()	{ keyPress	= new KeyboardSignal(eventDispatcher, "keypress"); }
	
	
	override public function dispose ()
	{
		super.dispose();
		eventDispatcher = null;
	}
}

