package primevc.js.events;

import primevc.core.dispatcher.Signals;
import js.Dom;

/**	
 * @since march 2, 2011
 * @author Stanislav Sopov
 */

class MouseEvents extends Signals
{
	var eventDispatcher:Dynamic;
	
	public var mouseMove	(getMouseMove,	null):MouseSignal;
	public var mouseDown	(getMouseDown,	null):MouseSignal;
	public var mouseUp		(getMouseUp, 	null):MouseSignal;
	public var mouseOver	(getMouseOver,	null):MouseSignal;
	public var mouseOut		(getMouseOut,	null):MouseSignal;
	public var mouseEnter	(getMouseEnter,	null):MouseSignal;
	public var mouseLeave	(getMouseLeave,	null):MouseSignal;
	public var click		(getClick,		null):MouseSignal;
	public var dblClick		(getDblClick,	null):MouseSignal;
	
	public function new(eventDispatcher:Dynamic)
	{
		this.eventDispatcher = eventDispatcher;
	}
	
	private inline function getMouseMove()	{ if (mouseMove 	== null) { createMouseMove();	} return mouseMove; }
	private inline function getMouseDown()	{ if (mouseDown 	== null) { createMouseDown();	} return mouseDown; }
	private inline function getMouseUp()	{ if (mouseUp 		== null) { createMouseUp();		} return mouseUp; }
	private inline function getMouseOver()	{ if (mouseOver		== null) { createMouseOver();	} return mouseOver; }
	private inline function getMouseOut()	{ if (mouseOut		== null) { createMouseOut();	} return mouseOut; }
	private inline function getMouseEnter()	{ if (mouseEnter	== null) { createMouseEnter();	} return mouseEnter; }
	private inline function getMouseLeave()	{ if (mouseLeave	== null) { createMouseLeave();	} return mouseLeave; }
	private inline function getClick()		{ if (click 		== null) { createClick();		} return click; }
	private inline function getDblClick()	{ if (dblClick 		== null) { createDblClick();	} return dblClick; }
	
	private function createMouseMove() 	{ mouseMove		= new MouseSignal(eventDispatcher, "mousemove"); }
	private function createMouseDown() 	{ mouseDown		= new MouseSignal(eventDispatcher, "mousedown"); }
	private function createMouseUp() 	{ mouseUp		= new MouseSignal(eventDispatcher, "mouseup"); }
	private function createMouseOver() 	{ mouseOver		= new MouseSignal(eventDispatcher, "mouseover"); }
	private function createMouseOut() 	{ mouseOut		= new MouseSignal(eventDispatcher, "mouseout"); }
	private function createMouseEnter() { mouseEnter	= new MouseSignal(eventDispatcher, "mouseenter"); }
	private function createMouseLeave() { mouseLeave	= new MouseSignal(eventDispatcher, "mouseleave"); }
	private function createClick() 		{ click 		= new MouseSignal(eventDispatcher, "click"); }
	private function createDblClick() 	{ dblClick 		= new MouseSignal(eventDispatcher, "dblclick"); }
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ( (untyped this).mouseMove	!= null ) mouseMove.dispose();
		if ( (untyped this).mouseDown	!= null ) mouseDown.dispose();
		if ( (untyped this).mouseUp		!= null ) mouseUp.dispose();
		if ( (untyped this).mouseOver	!= null ) mouseOver.dispose();
		if ( (untyped this).mouseOut	!= null ) mouseOut.dispose();
		if ( (untyped this).mouseEnter	!= null ) mouseEnter.dispose();
		if ( (untyped this).mouseLeave	!= null ) mouseLeave.dispose();
		if ( (untyped this).click		!= null ) click.dispose();
		if ( (untyped this).dblClick	!= null ) dblClick.dispose();
		
		mouseMove = 
		mouseDown = 
		mouseUp = 
		mouseOver = 
		mouseOut = 
		mouseEnter = 
		mouseLeave = 
		click = 
		dblClick = 
		null;
	}
}