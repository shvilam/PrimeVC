package primevc.gui.events;
 import primevc.core.dispatcher.Signals;
 import primevc.gui.display.ISprite;

typedef KeyboardEvents = 
	#if		flash9	primevc.avm2.events.KeyboardEvents;
	#elseif	flash8	primevc.avm1.events.KeyboardEvents;
	#elseif	js		primevc.js  .events.KeyboardEvents;
	#else	error	#end

typedef KeyboardHandler = KeyboardState -> Void;
typedef KeyboardSignal  = primevc.core.dispatcher.INotifier<KeyboardHandler>;

/**
 * Cross-platform keyboard events.
 * 
 * @author Danny Wilson
 * @creation-date jun 14, 2010
 */
class KeyboardSignals extends Signals
{
	var down	(default,null) : KeyboardSignal;
	var up		(default,null) : KeyboardSignal;
}

class KeyboardState extends KeyModState
{
	/*  var flags: Range 0 to 0x3F_FF_FF_FF
		
		charCode				keyCode					keyLocation		KeyMod
		FFF (12-bit) 0-4095		3FF (10-bit) 0-1023		F (4-bit)		F (4-bit)
	*/
	
	inline function keyCode()		: Int	{ return (flags >>   8) & 0x3FF; }
	inline function charCode()		: Int	{ return (flags >>> 18); }
	
	inline function keyLocation()	: KeyLocation
	{
		// TODO: Bench if 0xFF00 >> 8  is faster then case 0x0100
		return switch ((flags & 0xF0) >> 4) {
			case 0:		KeyLocation.Standard;
			case 1:		KeyLocation.Left;
			case 2:		KeyLocation.Right;
			case 3:		KeyLocation.NumPad;
		}
	}
}
