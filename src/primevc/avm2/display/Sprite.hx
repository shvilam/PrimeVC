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
package primevc.avm2.display;
 import flash.display.DisplayObject;
 import primevc.core.geom.IntRectangle;
 import primevc.gui.behaviours.drag.DragInfo;
 import primevc.gui.display.DisplayDataCursor;
 import primevc.gui.display.ISprite;
 import primevc.gui.display.DisplayList;
 import primevc.gui.display.IDisplayContainer;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.display.Window;
 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.UserEventTarget;
 import primevc.gui.events.UserEvents;
  using primevc.utils.NumberMath;
  using primevc.utils.TypeUtil;

 
/**
 * AVM2 sprite implementation
 * 
 * @author	Danny Wilson
 * @author	Ruben Weijers
 */
class Sprite extends flash.display.Sprite, implements ISprite
{
	/**
	 * List with all the children of the sprite
	 */
	public var children			(default, null)			: DisplayList;
	
	public var window			(default, setWindow)	: Window;
	public var container		(default, setContainer)	: IDisplayContainer;
	
	public var userEvents		(default, null)			: UserEvents;
	public var displayEvents	(default, null)			: DisplayEvents;
	
	public var rect				(default, null)			: IntRectangle;
	public var isDragging		: Bool;
	
	
	
	public function new ()
	{
		super();
		children		= new DisplayList( this );
		userEvents		= new UserEvents( this );
		displayEvents	= new DisplayEvents( this );
		rect			= new IntRectangle( x.roundFloat(), y.roundFloat(), width.roundFloat(), height.roundFloat() );
	}
	
	
	public function dispose ()
	{
		if (userEvents == null)
			return;		// already disposed
		
		window = null;
		children.dispose();
		userEvents.dispose();
		displayEvents.dispose();
		
		if (container != null)
			container.children.remove(this);
		
		rect.dispose();
		
		children		= null;
		userEvents		= null;
		displayEvents	= null;
		rect			= null;
	}
	
	
	public inline function isObjectOn (otherObj:IDisplayObject) : Bool
	{
		return otherObj == null ? false : otherObj.as(DisplayObject).hitTestObject( this.as(DisplayObject) );
	}
	
	
	public function isFocusOwner (target:UserEventTarget) : Bool
	{
		return target == this;
	}
	
	
#if !neko
	public function getDisplayCursor () : DisplayDataCursor
	{
		return new DisplayDataCursor(this);
	}
	
	
	public function createDragInfo () : DragInfo
	{
		return new DragInfo( this );
	}
#end
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setContainer (newV:IDisplayContainer)
	{
		if (container != newV)
		{
			var oldV	= container;
			container	= newV;
			
			if (container != null) {
				//if the container property is set and the sprite is not yet in the container, add the sprite to the container
			//	if (!container.children.has(this))
			//		container.children.add(this);
				
				window = container.window;
			}
			
			//if the container prop is set to null, remove the sprite from it's previous container and set the window prop to null.
			else if (oldV != null) {
				if (oldV.children.has(this))
					oldV.children.remove(this);
				
				window = null;
			}
		}
		return newV;
	}
	
	
	private inline function setWindow (v)
	{
		if (window != v)
		{
			window = v;
			for (i in 0...children.length)
			{
				var child = children.getItemAt(i);
				if (child != null)
					child.window = v;
			}
		}
		return v;
	}
}
