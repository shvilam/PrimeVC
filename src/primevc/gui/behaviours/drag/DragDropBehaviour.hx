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
 import primevc.core.dispatcher.Wire;
 import primevc.core.geom.Point;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.events.MouseEvents;
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
class DragDropBehaviour extends DragBehaviourBase
{
	private var copyTarget	: Bool;
	private var moveBinding	: Wire < Dynamic >;
	
	
	public function new (target, ?dragBounds, ?copyTarget = false)
	{
		super(target, dragBounds);
		this.copyTarget = copyTarget;
	}
	
	
	override private function init () : Void
	{
		super.init();
		moveBinding	= checkDropTarget.on( target.window.mouse.events.move, this );
		moveBinding.disable();
	}
	
	
	override private function reset () : Void
	{
		super.reset();
		moveBinding.dispose();
		moveBinding	= null;
	}
	
	
	override private function startDrag (mouseObj:MouseState) : Void
	{
		dragSource = new DragSource(target);
#if flash9
		//move item to correct location
		var pos			= target.container.as(IDisplayObject).localToGlobal( dragSource.origPosition );
		target.visible	= false;
		target.window.children.add( cast target );
		target.x		= pos.x;
		target.y		= pos.y;
		target.visible	= true;
#end
		
		//start dragging and fire events
		target.startDrag();
		target.dragEvents.start.send(dragSource);
		moveBinding.enable();
	}
	
	
	override private function stopDrag (mouseObj:MouseState) : Void
	{
		target.stopDrag();
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
		
		moveBinding.disable();
		disposeDragSource();
	}
	
	
	override private function cancelDrag (mouseObj:MouseState) : Void
	{
		dragSource.dropTarget = null;
		stopDrag(mouseObj);
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
}