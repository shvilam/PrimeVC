package primevc.js.events;
private typedef MouseSignal = primevc.js.events.MouseSignal; // override import
 import primevc.gui.events.MouseEvents;
 import primevc.gui.events.UserEventTarget;


/**	
 * @creation-date march 2, 2011
 * @author Stanislav Sopov
 * @author Ruben Weijers
 */
class MouseEvents extends MouseSignals
{
	private var eventDispatcher : UserEventTarget;
	
	
	public function new(eventDispatcher:UserEventTarget)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}
	
	override private function createDown ()			{ down			= new MouseSignal(eventDispatcher, "mousedown",	1); }
	override private function createUp ()			{ up			= new MouseSignal(eventDispatcher, "mouseup", 	1); }
	override private function createMove ()			{ move			= new MouseSignal(eventDispatcher, "mousemove",	0); }
	override private function createClick () 		{ click			= new MouseSignal(eventDispatcher, "click",		1); }
	override private function createDoubleClick ()	{ doubleClick	= new MouseSignal(eventDispatcher, "dblclick",	2); }
	override private function createOverChild ()	{ overChild		= new MouseSignal(eventDispatcher, "mouseenter",0); }
	override private function createOutOfChild ()	{ outOfChild	= new MouseSignal(eventDispatcher, "mouseleave",0); }
	override private function createRollOver ()		{ rollOver		= new MouseSignal(eventDispatcher, "mouseover",	0); }
	override private function createRollOut ()		{ rollOut		= new MouseSignal(eventDispatcher, "mouseout",	0); }
	override private function createScroll ()		{ scroll		= new MouseSignal(eventDispatcher, "wheel",		0); }
}