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
package primevc.avm2;
 import primevc.core.IDisposable;
 import primevc.gui.display.ISprite;
 import primevc.gui.events.DisplayEvents;
 import primevc.gui.events.UserEvents;
 
 import flash.display.DisplayObjectContainer;
 import flash.display.InteractiveObject;
 
  using primevc.utils.TypeUtil;

 
/**
 * AVM2 sprite implementation
 * 
 * @author	Danny Wilson
 */
class Sprite extends flash.display.Sprite, implements ISprite
{
	public var userEvents (default, null)		: UserEvents;
	public var displayEvents (default, null)	: DisplayEvents;
	
	
	public function new()
	{
		super();
		userEvents		= new UserEvents( this );
		displayEvents	= new DisplayEvents( this );
	}
	
	
	public function dispose()
	{
		if (userEvents == null)
			return;		// already disposed
		
		userEvents.dispose();
		displayEvents.dispose();
		userEvents		= null;
		displayEvents	= null;
		
		for (i in 0 ... numChildren)
		{
			var child = getChildAt(0);
			if (child.is(IDisposable))
				cast(child, IDisposable).dispose();
			
			if (child.parent != null)
				child.parent.removeChild( child );		//just to be sure
		}
		
		if (parent != null)
			parent.removeChild(this);
	}
	
	
	public function attachTo(target:DisplayObjectContainer)
	{
		target.addChild(this);
	}
	
	
/*	public inline function resizeScrollRect (newWidth:Float, newHeight:Float)
	{
		var rect			= scrollRect == null ? new flash.geom.Rectangle() : scrollRect;
		rect.width			= newWidth;
		rect.height			= newHeight;
		scrollRect			= rect;
	}
	
	
	public inline function moveScrollRect (?newX:Float = 0, ?newY:Float = 0)
	{
		var rect			= scrollRect == null ? new flash.geom.Rectangle() : scrollRect;
		rect.x				= newX;
		rect.y				= newY;
		scrollRect			= rect;
	}*/
}
