package primevc.js.events;

import primevc.core.dispatcher.Signals;
import js.Dom;

/**	
 * @since march 2, 2011
 * @author Stanislav Sopov
 */

class MouseEvents extends Signals
{
	var eventDispatcher:HtmlDom;
	
	public var mousemove(getMousemove,	null):MouseSignal;
	public var mousedown(getMousedown,	null):MouseSignal;
	public var mouseup	(getMouseup, 	null):MouseSignal;
	public var mouseover(getMouseover,	null):MouseSignal;
	public var mouseout	(getMouseout,	null):MouseSignal;
	public var click	(getClick,		null):MouseSignal;
	public var dblclick	(getDblclick,	null):MouseSignal;
	
	
	public function new(eventDispatcher:HtmlDom)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	
	private inline function getMousemove()	{ if (mousemove == null) { createMousemove();	} return mousemove; }
	private inline function getMousedown()	{ if (mousedown == null) { createMousedown();	} return mousedown; }
	private inline function getMouseup()	{ if (mouseup 	== null) { createMouseup();		} return mouseup; }
	private inline function getMouseover()	{ if (mouseover	== null) { createMouseover();	} return mouseover; }
	private inline function getMouseout()	{ if (mouseout	== null) { createMouseout(); 	} return mouseout; }
	private inline function getClick()		{ if (click 	== null) { createClick(); 		} return click; }
	private inline function getDblclick()	{ if (dblclick 	== null) { createDblclick(); 	} return dblclick; }
	
	
	private function createMousemove() 	{ mousemove = new MouseSignal(eventDispatcher, "mousemove"); }
	private function createMousedown() 	{ mousedown = new MouseSignal(eventDispatcher, "mousedown"); }
	private function createMouseup() 	{ mouseup 	= new MouseSignal(eventDispatcher, "mouseup"); }
	private function createMouseover() 	{ mouseover = new MouseSignal(eventDispatcher, "mouseover"); }
	private function createMouseout() 	{ mouseout 	= new MouseSignal(eventDispatcher, "mouseout"); }
	private function createClick() 		{ click 	= new MouseSignal(eventDispatcher, "click"); }
	private function createDblclick() 	{ dblclick 	= new MouseSignal(eventDispatcher, "dblclick"); }
	
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).mousemove	!= null ) mousemove.dispose();
		if ( (untyped this).mousedown	!= null ) mousedown.dispose();
		if ( (untyped this).mouseup		!= null ) mouseup.dispose();
		if ( (untyped this).mouseover	!= null ) mouseover.dispose();
		if ( (untyped this).mouseout	!= null ) mouseout.dispose();
		if ( (untyped this).click		!= null ) click.dispose();
		if ( (untyped this).dblclick	!= null ) dblclick.dispose();
		
		mousemove = 
		mousedown = 
		mouseup = 
		mouseover = 
		mouseout = 
		click = 
		dblclick = 
		null;
	}
}