package primevc.js.events;

import primevc.core.geom.Point;
import primevc.gui.events.KeyModState;
import primevc.gui.events.MouseEvents;
import primevc.js.events.DOMSignal1;
import js.Dom;
	

typedef MouseEvent = 
{
	>DOMEvent,
	public var altKey 			(default, null):Bool; // Indicates whether or not the ALT key was pressed when the event was triggered.
	public var button			(default, null):Int; // The mouse button pressed. 0, 1, 2 are respectively left, middle and right buttons.
	public var clientX			(default, null):Int; // The x-coordinate relative to the viewport (excludes scroll offset)
	public var clientY			(default, null):Int; // The y-coordinate relative to the viewport (excludes scroll offset)
	public var ctrlKey 			(default, null):Bool; // Indicates whether or not the CTRL key was pressed when the event was triggered. 
	public var fromElement 		(default, null):Dynamic; // The element the mouse comes from. This is interesting to know in case of mouseover.
	public var metaKey			(default, null):Bool; // Indicates whether the META key was pressed when the event was triggered.
	public var offsetX			(default, null):Int; // The x-coordinate relative to the target.
	public var offsetY			(default, null):Int; // The y-coordinate relative to the target.
	public var relatedTarget	(default, null):Dynamic; // A secondary event target related to the event. 
    public var screenX			(default, null):Int; // Relative to the screen.
	public var screenY			(default, null):Int; // Relative to the screen.
	public var shiftKey 		(default, null):Bool; // Indicates whether or not the SHIFT key was pressed when the event was triggered.
	public var fromElement 		(default, null):Dynamic; // The element the mouse goes to. This is interesting to know in case of mouseout.
	public var x				(default, null):Int;
	public var y				(default, null):Int;
}


/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */
class MouseSignal extends DOMSignal1<MouseState>
{
	var clickCount:Int;
	
	public function new (d:Dynamic, e:String, cc:Int)
	{
		super(d, e);
		
		this.clickCount = cc;
	}
	
	
	override private function dispatch(e:MouseEvent) 
	{
		send( stateFromEvent(e, clickCount) );
	}
	
	
	static public function stateFromEvent( e:MouseEvent, clickCount:Int ) : MouseState
	{
		var flags;
		
		/** scrollDelta				Button				clickCount			KeyModState
			FF (8-bit) -127-127		FF (8-bit) 0-255	F (4-bit) 0-15		F (4-bit)
		*/
		
		Assert.that(clickCount >=  0);
		Assert.that(clickCount <= 15);
		
		flags = (clickCount & 0xF) << 4
				| (e.button != null? (e.button + 1) << 8 : 0)
				| (e.altKey?	KeyModState.ALT : 0)
				| (e.ctrlKey?	KeyModState.CMD | KeyModState.CTRL : 0)
				| (e.shiftKey?	KeyModState.SHIFT : 0);
		
		//e.stopImmediatePropagation();
		
		// TODO: MouseEvent properties offsetX and offsetY are supposedly buggy. If they don't work, calculate proper offset values.
		
	//	trace("stateFromFlashEvent "+e.type+"; "+e.localX+", "+e.localY+"; "+e.stageX+", "+e.stageY);
		return new MouseState(flags, e.target, new Point(e.offsetX, e.offsetY), new Point(e.clientX, e.clientY), e.relatedTarget);
	}
}