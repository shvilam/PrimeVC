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
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.avm2.display;
 import flash.display.DisplayObject;
 import primevc.core.geom.IntRectangle;
 import primevc.gui.display.DisplayDataCursor;
 import primevc.gui.display.IDisplayContainer;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.display.ITextField;
 import primevc.gui.display.Window;
 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.TextEvents;
 import primevc.gui.events.UserEvents;
  using primevc.utils.TypeUtil;
  using Std;


/**
 * PrimeVC AVM2 TextField implementation
 * 
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class TextField extends flash.text.TextField, implements ITextField 
{	
	/**
	 * The padding to be added to textWidth to get the width
	 * of a TextField that can display the text without clipping.
	 */ 
	public static inline var TEXT_WIDTH_PADDING:Int = 5;

	/**
	 * The padding to be added to textHeight to get the height
	 * of a TextField that can display the text without clipping.
	 */ 
	public static inline var TEXT_HEIGHT_PADDING:Int = 4;
	
	
	public var container		(default, setContainer)		: IDisplayContainer;
	public var window			(default, setWindow)		: Window;
	
	public var displayEvents	(default, null)				: DisplayEvents;
	public var textEvents		(default, null)				: TextEvents;
	public var userEvents		(default, null)				: UserEvents;
	
	public var rect				(default, null)				: IntRectangle;
	
	/**
	 * Returns the textWidth + TEXT_WIDTH_PADDING
	 */
	public var realTextWidth	(getRealTextWidth, never)	: Float;
	/**
	 * Returns the textHeight + TEXT_HEIGHT_PADDING
	 */
	public var realTextHeight	(getRealTextHeight, never)	: Float;
	
	
	
	public function new () 
	{
		super();
		displayEvents	= new DisplayEvents( this );
		textEvents		= new TextEvents( this );
		userEvents		= new UserEvents( this );
		rect			= new IntRectangle( x.int(), y.int(), width.int(), height.int() );
	}
	
	
	public function dispose ()
	{
		if (displayEvents == null)
			return;		// already disposed
		
		if (container != null)
			container.children.remove(this);
		
		displayEvents.dispose();
		textEvents.dispose();
		userEvents.dispose();
		rect.dispose();
		
		displayEvents	= null;
		textEvents		= null;
		userEvents		= null;
		container		= null;
		window			= null;
		rect			= null;
	}


	public function isObjectOn (otherObj:IDisplayObject) : Bool
	{
		return otherObj == null ? false : otherObj.as(DisplayObject).hitTestObject( this.as(DisplayObject) );
	}
	
	
#if !neko
	public function getDisplayCursor () : DisplayDataCursor
	{
		return new DisplayDataCursor(this);
	}
#end
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setContainer (v)
	{
		container	= v;
		if (v != null)	window = container.window;
		else			window = null;
		return v;
	}
	
	
	private inline function setWindow (v)
	{
		return window = v;
	}
	
	
	private inline function getRealTextWidth ()		{ return textWidth + TEXT_WIDTH_PADDING; }
	private inline function getRealTextHeight ()	{ return textHeight + TEXT_HEIGHT_PADDING; }
}