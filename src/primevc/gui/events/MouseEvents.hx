/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 *
 * Authors:
 *  Danny Wilson	<danny @ onlinetouch.nl>
 */
package primevc.gui.events;
 import primevc.core.dispatcher.Signals;
 import primevc.core.geom.Point;
 import primevc.core.traits.IClonable;
 import primevc.gui.events.KeyModState;


typedef MouseEvents = 
	#if		flash9	primevc.avm2.events.MouseEvents;
	#elseif	flash8	primevc.avm1.events.MouseEvents;
	#elseif	js		primevc.js  .events.MouseEvents;
	#elseif	neko	primevc.neko.events.MouseEvents;
	#else			Dynamic; #end

typedef MouseHandler	= MouseState -> Void;
typedef MouseSignal		= primevc.core.dispatcher.Signal1<MouseState>;
//typedef MouseSignal		= primevc.core.dispatcher.INotifier<MouseHandler>;

/**
 * Cross-platform mouse events.
 * 
 * @author Danny Wilson
 * @author Ruben Weijers
 * @creation-date jun 14, 2010
 */
class MouseSignals extends Signals
{
	/** Fires when the mouse button is pressed */
	public var down			(getDown,			null) : MouseSignal;
	/** Fires when the mouse button is released */
	public var up			(getUp,				null) : MouseSignal;
	/** Fires when the mouse has moved */
	public var move			(getMove,			null) : MouseSignal;
	/** Fires when the a user presses and releases a button of the user's pointing device over the same InteractiveObject. */
	public var click		(getClick,			null) : MouseSignal;
	/** Fires when the a user double-clicks on an InteractiveObject. */
	public var doubleClick	(getDoubleClick,	null) : MouseSignal;
	/** Fires when a mouse moves over the interactive object, or a child of the object.
		In Flash 9+ this is a proxy to flash.events.MouseEvent.MOUSE_OVER */
	public var overChild	(getOverChild,		null) : MouseSignal;
	/** Fires when a mouse moves out of the interactive object, or a child of the object.
		In Flash 9+ (default,null) this is a proxy to flash.events.MouseEvent.MOUSE_OUT */
	public var outOfChild	(getOutOfChild,		null) : MouseSignal;
	/** Fires when a mouse moves over the hitarea of the the interactive object.
		In Flash 9+ this is a proxy to flash.events.MouseEvent.ROLL_OVER */
	public var rollOver		(getRollOver,		null) : MouseSignal;
	/** Fires when a mouse moves out of the hitarea of the interactive object.
		In Flash 9+ this is a proxy to flash.events.MouseEvent.ROLL_OUT */
	public var rollOut		(getRollOut,		null) : MouseSignal;
	/** Fires when a mouse scrollwheel is used. */
	public var scroll		(getScroll,			null) : MouseSignal;
	
	
	private inline function getDown ()			{ if (down == null)			{ createDown(); }			return down; }
	private inline function getUp ()			{ if (up == null)			{ createUp(); }				return up; }
	private inline function getMove ()			{ if (move == null)			{ createMove(); }			return move; }
	private inline function getClick ()			{ if (click == null)		{ createClick(); }			return click; }
	private inline function getDoubleClick ()	{ if (doubleClick == null)	{ createDoubleClick(); }	return doubleClick; }
	private inline function getOverChild ()		{ if (overChild == null)	{ createOverChild(); }		return overChild; }
	private inline function getOutOfChild ()	{ if (outOfChild == null)	{ createOutOfChild(); }		return outOfChild; }
	private inline function getRollOver ()		{ if (rollOver == null)		{ createRollOver(); }		return rollOver; }
	private inline function getRollOut ()		{ if (rollOut == null)		{ createRollOut(); }		return rollOut; }
	private inline function getScroll ()		{ if (scroll == null)		{ createScroll(); }			return scroll; }
	
	
	private function createDown ()			{ Assert.abstract(); }
	private function createUp ()			{ Assert.abstract(); }
	private function createMove ()			{ Assert.abstract(); }
	private function createClick () 		{ Assert.abstract(); }
	private function createDoubleClick ()	{ Assert.abstract(); }
	private function createOverChild ()		{ Assert.abstract(); }
	private function createOutOfChild ()	{ Assert.abstract(); }
	private function createRollOver ()		{ Assert.abstract(); }
	private function createRollOut ()		{ Assert.abstract(); }
	private function createScroll ()		{ Assert.abstract(); }
	
	
	override public function dispose ()
	{
		if ( (untyped this).down		!= null )		down.dispose();
		if ( (untyped this).up			!= null )		up.dispose();
		if ( (untyped this).move		!= null )		move.dispose();
		if ( (untyped this).click		!= null )		click.dispose();
		if ( (untyped this).doubleClick	!= null )		doubleClick.dispose();
		if ( (untyped this).overChild	!= null )		overChild.dispose();
		if ( (untyped this).outOfChild	!= null )		outOfChild.dispose();
		if ( (untyped this).rollOver	!= null )		rollOver.dispose();
		if ( (untyped this).rollOut		!= null )		rollOut.dispose();
		if ( (untyped this).scroll		!= null )		scroll.dispose();
		
		down = up = move = click = doubleClick = overChild = outOfChild = rollOver = rollOut = scroll = null;
	}
}

/**
 * State information sent by MouseSignal.
 * 
 * @author Danny Wilson
 * @creation-date jun 14, 2010
 */
class MouseState extends KeyModState, implements IClonable<MouseState>
{
	public static inline var fake = new MouseState( 0, null, null, null, null );
	
	/*  var flags: Range 0 to 0xFFFFFF
		
		scrollDelta				Button				clickCount				KeyMod
		FF (8-bit) -127-127		FF (8-bit) 0-255	F (4-bit) 0-15			F (4-bit)
	*/
	
	var local	(default,null)		: Point;
	var stage	(default,null)		: Point;
	
	/**
	 * A reference to a display list object that is related to the event. For 
	 * example, when a mouseOut event occurs, relatedObject represents the 
	 * display list object to which the pointing device now points. This 
	 * property applies to the mouseOut, mouseOver, rollOut, and rollOver events.
	 * 
	 * The value of this property can be null in two circumstances: if there no
	 * related object, or there is a related object, but it is in a security 
	 * sandbox to which you don't have access. Use the 
	 * isRelatedObjectInaccessible() property to determine which of these 
	 * reasons applies.
	 */
	var related	(default,null)		: UserEventTarget;

	
	
	public function new(f:Int, t:UserEventTarget, l:Point, s:Point, related:UserEventTarget)
	{
		super(f,t);
		this.local		= l;
		this.stage		= s;
		this.related	= related == null ? t : related;
	}
	
	inline function leftButton()	: Bool	{ return (flags & 0xF00 == 0x100); }
	inline function rightButton()	: Bool	{ return (flags & 0xF00 == 0x200); }
	inline function middleButton()	: Bool	{ return (flags & 0xF00 == 0x300); }
	
	inline function clickCount()	: Int	{ return (flags >> 4) & 0xF; }
	@:keep inline function scrollDelta()	: Int	{ return (flags >> 16); }
	
	
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
	
	
#if flash9
	public inline function isDispatchedBy (obj:UserEventTarget) : Bool
	{
		return obj != null && obj == related;
	}
#end
	
	
	public inline function clone () : MouseState
	{
		return new MouseState( flags, target, local, stage #if flash9, related #end);
	}
	
	
#if debug
	public var owner : MouseSignal;
	
	public function toString () {
		return "MouseState of "+owner+"; pos: "+local;
	}
#end
}
