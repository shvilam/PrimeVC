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
package primevc.gui.behaviours.dragdrop;
 import primevc.core.geom.Point;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.ISkin;
 import primevc.gui.events.KeyboardEvents;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;
 

/**
 * Behaviour which will an UI-element draggable.
 * 
 * @creation-date	Jul 8, 2010
 * @author			Ruben Weijers
 */
class DragBehaviour extends BehaviourBase <IDraggable>
{
	private var dragSource	: DragSource;
	private var copyTarget	: Bool;
	
	
	public function new (target, copyTarget = false)
	{
		this.copyTarget = copyTarget;
		super(target);
	}
	
	
	override private function init () : Void
	{
		startDrag.on( target.userEvents.mouse.down, this );
	}
	
	
	override private function reset () : Void
	{
		target.userEvents.mouse.down.unbind( this );
		target.displayList.window.userEvents.mouse.up.unbind( this );
		target.displayList.window.userEvents.key.down.unbind( this );
		dragSource = null;
	}
	
	
	private function startDrag () : Void
	{
		dragSource = new DragSource(target);
		
#if flash9
		//move item to correct location
		var pos		= new Point(target.x, target.y);
		pos			= target.as(flash.display.DisplayObject).parent.localToGlobal(pos);
		target.x	= pos.x;
		target.y	= pos.y;
		var w = target.displayList.window;
		w.children.add( cast target );
#end
		
		target.startDrag();
		
		//set event handlers
		target.userEvents.mouse.down.unbind( this );
		stopDrag.on( target.displayList.window.userEvents.mouse.up, this );
		handleKeyPress.on( target.displayList.window.userEvents.key.down, this );
	}
	
	
	private inline function stopDrag () : Void
	{
		target.stopDrag();
		dragSource.origDisplayList.add( cast target, dragSource.origDepth );
		dragSource = null;
		
		target.displayList.window.userEvents.mouse.up.unbind( this );
		target.displayList.window.userEvents.key.down.unbind( this );
		startDrag.on( target.userEvents.mouse.down, this );
	}
	
	
	private inline function cancelDrag () : Void
	{
		if (target.is(ISkin)) {
			var layout = target.as(ISkin).layout;
			target.x = layout.x;
			target.y = layout.y;
		}
		stopDrag();
	}
	
	
	private function handleKeyPress (state:KeyboardState) : Void
	{
#if flash9
		if (state.keyCode() == flash.ui.Keyboard.ESCAPE)
			cancelDrag();
#end
	}
}