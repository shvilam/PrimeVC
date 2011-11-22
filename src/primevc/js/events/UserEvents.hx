package primevc.js.events;
 import primevc.gui.events.UserEvents;
 import primevc.gui.events.UserEventTarget;


/**	
 * @since  march 2, 2011
 * @author Stanislav Sopov
 */
class UserEvents extends UserSignals
{
	private var eventDispatcher : UserEventTarget;

	public var touch	(getTouch,		null)	: TouchEvents;
	public var gesture	(getGesture,	null)	: GestureEvents;

	
	public function new(eventDispatcher)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private function createMouse 	() { mouse		= new MouseEvents(eventDispatcher); }
	private function createTouch 	() { touch		= new TouchEvents(eventDispatcher); }
	private function createGesture 	() { gesture	= new GestureEvents(eventDispatcher); }
	private function createFocus 	() { focus		= new FocusEvents(eventDispatcher); }
	private function createKeyboard	() { keyboard	= new KeyboardEvents(eventDispatcher); }
	
	private inline function getTouch 	() { if (touch == null)		{ createTouch();	} return touch; }
	private inline function getGesture 	() { if (gesture == null)	{ createGesture();	} return gesture; }
}