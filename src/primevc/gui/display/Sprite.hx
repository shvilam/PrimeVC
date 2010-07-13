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
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.display;

// ----------------------------------
// Actual Sprite layer implementation
// ----------------------------------

typedef Sprite = 
	#if		flash9	primevc.avm2.Sprite;
	#elseif	flash8	primevc.avm1.Sprite;
	#elseif	js		primevc.js  .Sprite;
	#else			SpriteImpl


 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.IUserEvents;
 import primevc.core.geom.Matrix2D;
 import primevc.core.geom.Rectangle;
 import primevc.gui.events.UserEvents;

/**
 * Mock implementation of Sprite
 * 
 * @author			Danny Wilson
 * @author			Ruben Weijers
 * @creation-date	unknown
 */
class SpriteImpl implements ISprite
{
	public var displayList		(default, default)				: DisplayList;
	public var children			(default, null)					: DisplayList;
	
	public var userEvents		(default, null)					: UserEvents;
	public var displayEvents	(default, null)					: DisplayEvents;
	
	public var dropTarget		(default, null)					: IDisplayObject;
	public var parent			(default, null)					: ISprite;
	
	public var transform		(default,null)					: Matrix2D;
	public var visible			(getVisibility, setVisibility)	: Bool;
	private var _visible:Bool;
	
	public var mouseEnabled		(getEnabled, setEnabled)		: Bool;
		private inline function getEnabled ()					{ return mouseEnabled; }
		private inline function setEnabled (v:Bool)				{ return mouseEnabled = v; }
	
	public var alpha			(default, setAlpha)				: Float;
		private inline function setAlpha(a:Float)				{ return alpha = a; }	
	
	public var x				(getX,			setX)			: Float;
	public var y				(getY,			setY)			: Float;
	public var width			(getWidth,		setWidth)		: Float;
	public var height			(getHeight,		setHeight)		: Float;
	
	
	
	
	public function new()
	{
		children		= new DisplayList( this );
		userEvents		= new UserEvents( this );
		displayEvents	= new DisplayEvents( this );
	}
	
	
	public function render () {}
	
	
	public inline function dispose() : Void
	{
		displayEvents.dispose();
		userEvents.dispose();
		children.dispose();
		
		children		= null;
		window			= null;
		displayList		= null;
		displayEvents	= null;
	}


	//
	// GETTERS / SETTERS
	//

	private function setWindow (v) {
		return window = v;
	}
	
	
	public function startDrag(?lockCenter:Bool, ?bounds:Rectangle) : Void;
	public function stopDrag () : Void;
	
	private inline function getX ()					{ return x; }
	private inline function getY ()					{ return y; }
	private inline function getWidth ()				{ return width; }
	private inline function getHeight ()			{ return height; }
	private inline function setX (v)				{ return x = v; }
	private inline function setY (v)				{ return y = v; }
	private inline function setWidth (v)			{ return width = v; }
	private inline function setHeight (v)			{ return height = v; }
	
	private inline function getVisibility()			{ return _visible; }
	private inline function setVisibility(v:Bool)	{ return _visible = v; }
}
#end
