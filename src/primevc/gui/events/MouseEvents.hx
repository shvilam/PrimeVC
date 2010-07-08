package primevc.gui.events;
 import primevc.core.dispatcher.Signals;
 import primevc.core.geom.Point;
 import primevc.gui.display.ISprite;
 import primevc.gui.events.KeyModState;

typedef MouseEvents = 
	#if		flash9	primevc.avm2.events.MouseEvents;
	#elseif	flash8	primevc.avm1.events.MouseEvents;
	#elseif	js		primevc.js  .events.MouseEvents;
	#else	error	#end

typedef MouseHandler	= MouseState -> Void;
typedef MouseSignal		= primevc.core.dispatcher.INotifier<MouseHandler>;

/**
 * Cross-platform mouse events.
 * 
 * @author Danny Wilson
 * @creation-date jun 14, 2010
 */
class MouseSignals extends Signals
{
	/** Fires when the mouse button is pressed */
	var down		(default,null) : MouseSignal;
	/** Fires when the mouse button is released */
	var up			(default,null) : MouseSignal;
	/** Fires when the mouse has moved */
	var move		(default,null) : MouseSignal;
	/** Fires when the a user presses and releases a button of the user's pointing device over the same InteractiveObject. */
	var click		(default,null) : MouseSignal;
	/** Fires when the a user double-clicks on an InteractiveObject. */
	var doubleClick	(default,null) : MouseSignal;
	/** Fires when a mouse moves over the interactive object, or a child of the object.
		In Flash 9+ this is a proxy to flash.events.MouseEvent.MOUSE_OVER */
	var overChild	(default,null) : MouseSignal;
	/** Fires when a mouse moves out of the interactive object, or a child of the object.
		In Flash 9+ (default,null) this is a proxy to flash.events.MouseEvent.MOUSE_OUT */
	var outOfChild	(default,null) : MouseSignal;
	/** Fires when a mouse moves over the hitarea of the the interactive object.
		In Flash 9+ this is a proxy to flash.events.MouseEvent.ROLL_OVER */
	var rollOver	(default,null) : MouseSignal;
	/** Fires when a mouse moves out of the hitarea of the interactive object.
		In Flash 9+ this is a proxy to flash.events.MouseEvent.ROLL_OVER */
	var rollOut		(default,null) : MouseSignal;
	/** Fires when a mouse scrollwheel is used. */
	var scroll		(default,null) : MouseSignal;
}

/**
 * State information sent by MouseSignal.
 * 
 * @author Danny Wilson
 * @creation-date jun 14, 2010
 */
class MouseState extends KeyModState
{
	/*  var flags: Range 0 to 0xFFFFFF
		
		scrollDelta				Button				clickCount				KeyMod
		FF (8-bit) -127-127		FF (8-bit) 0-255	F (4-bit) 0-15			F (4-bit)
	*/
	
	var local	(default,null)		: Point;
	var stage	(default,null)		: Point;
	
	public function new(f:Int, t:TargetType, l:Point, s:Point)
	{
		super(f,t);
		this.local  = l;
		this.stage  = s;
	}
	
	inline function leftButton()	: Bool	{ return (flags & 0xF00 == 0x100); }
	inline function rightButton()	: Bool	{ return (flags & 0xF00 == 0x200); }
	inline function middleButton()	: Bool	{ return (flags & 0xF00 == 0x300); }
	
	inline function clickCount()	: Int	{ return (flags >> 4) & 0xF; }
	inline function scrollDelta()	: Int	{ return (flags >> 16); }
	
	
	inline function mouseButton()	: MouseButton
	{
		// TODO: Bench if 0xFF00 >> 8  is faster then case 0x0100
		return switch ((flags & 0xFF00) >> 8) {
			case 0:		MouseButton.None;
			case 1:		MouseButton.Left;
			case 2:		MouseButton.Right;
			case 3:		MouseButton.Middle;
			default:	MouseButton.Other((flags & 0xFF00) >> 8);
		}
	}
}
