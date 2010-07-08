package primevc.avm2.events;
private typedef MouseSignal = primevc.avm2.events.MouseSignal; // override import
 import primevc.core.geom.Point;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.events.KeyModState;
 import flash.events.MouseEvent;


/**
 * Group of proxying Signals to flash.events.Mouse events.
 * 
 * @author Danny Wilson
 * @creation-date jun 11, 2010
 */
class MouseEvents extends MouseSignals
{
	public function new (eventDispatcher)
	{
		this.down		 = new MouseSignal(eventDispatcher, MouseEvent.MOUSE_DOWN,		1);
		this.up			 = new MouseSignal(eventDispatcher, MouseEvent.MOUSE_UP,		1);
		this.move		 = new MouseSignal(eventDispatcher, MouseEvent.MOUSE_MOVE,		0);
		this.click		 = new MouseSignal(eventDispatcher, MouseEvent.CLICK,			1);
		this.doubleClick = new MouseSignal(eventDispatcher, MouseEvent.DOUBLE_CLICK,	2);
		this.overChild	 = new MouseSignal(eventDispatcher, MouseEvent.MOUSE_OVER,		0);
		this.outOfChild	 = new MouseSignal(eventDispatcher, MouseEvent.MOUSE_OUT,		0);
		this.rollOver	 = new MouseSignal(eventDispatcher, MouseEvent.ROLL_OVER,		0);
		this.rollOut	 = new MouseSignal(eventDispatcher, MouseEvent.ROLL_OUT,		0);
		this.scroll		 = new MouseSignal(eventDispatcher, MouseEvent.MOUSE_WHEEL,	0);
	}
}