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
package primevc.gui.behaviours.drag;
 import primevc.core.geom.Point;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.events.KeyboardEvents;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;
 

/**
 * Behaviour which will add drag-and-drop functionality to an object.
 * The given target object needs to implement the interface IDraggable.
 * 
 * To drop an item in a sprite, this sprite needs to implement the interface
 * IDropTarget.
 * 
 * @creation-date	Jul 8, 2010
 * @author			Ruben Weijers
 */
class DragDropBehaviour extends BehaviourBase <IDraggable>
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
		target.window.mouse.events.up.unbind( this );
		target.window.mouse.events.move.unbind( this );
		target.window.userEvents.key.down.unbind( this );
		
		if (dragSource != null) {
			target.stopDrag();
			dragSource.dispose();
			dragSource = null;
		}
	}
	
	
	private function startDrag () : Void
	{
		dragSource = new DragSource(target);
		target.window.application.clearTraces();
#if flash9
		//move item to correct location
		var pos			= target.container.as(IDisplayObject).localToGlobal( dragSource.origPosition );
		target.visible	= false;
		target.window.children.add( cast target );
		target.x		= pos.x;
		target.y		= pos.y;
		trace("startDrag "+pos+" - "+dragSource.origPosition);
		target.visible	= true;
#end
		
		//start dragging and fire events
		target.startDrag();
		target.dragEvents.start.send(dragSource);
		
		//set event handlers
		target.userEvents.mouse.down.unbind( this );
		stopDrag		.on( target.window.mouse.events.up, this );
		checkDropTarget	.on( target.window.mouse.events.move, this );
		handleKeyPress	.on( target.window.userEvents.key.down, this );
	}
	
	
	private inline function stopDrag () : Void
	{
		if (dragSource.dropTarget != null)
		{
#if flash9
			var pos		= new Point(target.x, target.y);
			pos			= dragSource.dropTarget.globalToLocal( pos );
			dragSource.dropPosition = pos;
#end
			//notify the dragged item that the drag-operation is completed
			target.dragEvents.complete.send(dragSource);
			
			//notify the dragSource that an item is dropped
			dragSource.dropTarget.dragEvents.drop.send(dragSource);
		}
		else
		{
			//restore to old location
			target.visible	= false;
			target.x		= dragSource.origPosition.x;
			target.y		= dragSource.origPosition.y;
			dragSource.origContainer.children.add( target, dragSource.origDepth );
			target.visible	= true;
			
			//notifiy the dragged item that the drag-operation is canceled
			target.dragEvents.exit.send( dragSource );
		}
		
		reset();
		//listen to mouse down event again
		startDrag.on( target.userEvents.mouse.down, this );
	}
	
	
	private inline function cancelDrag () : Void
	{
		dragSource.dropTarget = null;
		stopDrag();
	}
	
	
	private function checkDropTarget () : Void
	{
		var curDropTarget = target.dropTarget.as(IDropTarget);
		if (curDropTarget == null && (dragSource.dropTarget == null || !dragSource.target.isObjectOn( dragSource.dropTarget ))) {
			dragSource.dropTarget = null;
			return;
		}
		//make sure the new droptarget isn't the same as the previous droptarget
		if (curDropTarget == dragSource.dropTarget || curDropTarget == null)
			return;
		
		//check if the drag is allowed over the current dropTarget
		if (curDropTarget.isDropAllowed(dragSource)) {
			dragSource.dropTarget = curDropTarget;
		}
	}
	
	
	private function handleKeyPress (state:KeyboardState) : Void
	{
#if flash9
		if (state.keyCode() == flash.ui.Keyboard.ESCAPE)
			cancelDrag();
#end
	}
}