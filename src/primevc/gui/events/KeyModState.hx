package primevc.gui.events;
 import primevc.gui.display.ISprite;

 
typedef TargetType		= 
	#if		flash9	flash.display.DisplayObject;
	#elseif	flash8	MovieClip;
	#elseif	js		DomElement;
	#else	error	#end

/**
 * Base class for UI state messages with key-modifiers.
 * 
 * @author Danny Wilson
 * @creation-date jun 14, 2010
 */
class KeyModState implements haxe.Public
{
	static inline var SHIFT	= 0x1;
	static inline var CTRL	= 0x2;
	static inline var ALT	= 0x4;
	static inline var CMD	= 0x8;
	
	/**
	 * Uses lowest 4 bits to store KeyModState: 0xF
	 */
	var flags	(default,null)		: Int;
	/**
	 * Target of the event
	 */  
	var target	(default,null)		: TargetType;
	
	public function new(f:Int, t:TargetType)
	{
		this.flags  = f;
		this.target = t;
	}
	
	/**
	 * True when the Shift key is pressed
	 */
	inline function shiftKey()		: Bool	{ return (flags & SHIFT) != 0; }
	
	/**
	 * Flash 9+:	True when Ctrl or Cmd key is pressed
	 * AIR:			Not implemented yet
	 */
	inline function ctrlKey()		: Bool	{ return (flags & CTRL)  != 0; }
	
	/**
	 * True when Alt key is pressed
	 */
	inline function altKey()		: Bool	{ return (flags & ALT)   != 0; }
	
	/**
	 * Flash 9+:	True when Ctrl or Cmd key is pressed
	 * AIR:			Not implemented yet
	 */
	inline function cmdKey()		: Bool	{ return (flags & CMD)   != 0; }
}