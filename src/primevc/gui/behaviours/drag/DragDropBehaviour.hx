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
 import primevc.gui.core.IUIElement;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.traits.IDataDropTarget;
 import primevc.gui.traits.IDropTarget;
  using primevc.gui.utils.UIElementActions;
  using primevc.utils.Bind;
  using primevc.utils.NumberMath;
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
//	private var copyTarget			: Bool;
	private var moveBinding			: Wire < Dynamic >;
	
	
/*	public function new (target, ?dragBounds, ?copyTarget = false)
	{
		super(target, dragBounds);
		this.copyTarget = copyTarget;
	}*/
	
	
	override private function init () : Void
	{
		super.init();
		moveBinding	= checkDropTarget.on( target.window.mouse.events.move, this );
		moveBinding.disable();
	}
	
	
	override private function reset () : Void
	{
		super.reset();
		if (moveBinding != null)
		{
			moveBinding.dispose();
			moveBinding	= null;
		}
	}
	
	
	override private function startDrag (mouseObj:MouseState) : Void
	{
		if (dragInfo != null)
		{
			cancelDrag(mouseObj);
			stopDrag(mouseObj);
		}
	//	haxe.Log.clear();
		dragInfo = target.createDragInfo();
#if flash9
		//move item to correct location
		var pos				= target.container.as(IDisplayObject).localToGlobal( dragInfo.displayCursor.position );
		var item			= dragInfo.dragRenderer;
		item.visible		= false;
		target.window.children.add( cast item );
		
		if (item.is(IUIElement))
			item.as(IUIElement).doMove( pos.x.roundFloat(), pos.y.roundFloat() );
		
		item.x			= pos.x;
		item.y			= pos.y;
		item.visible	= true;
#end
		
		//start dragging and fire events
		super.startDrag(mouseObj);
		moveBinding.enable();
	}
	
	
	override private function stopDrag (mouseObj:MouseState) : Void
	{	
		stopDragging();
		var item = dragInfo.dragRenderer;
		
		//remove dragrenderer from displaylist
		item.container.children.remove(item);
		
		if (dragInfo.dropTarget != null)
		{
#if flash9
			dragInfo.dropBounds = dragInfo.layout.outerBounds;
#end
			//notify the dragged item that the drag-operation is completed
			target.dragEvents.complete.send(dragInfo);
			
			//notify the dragInfo that an item is dropped
			dragInfo.dropTarget.dragEvents.drop.send(dragInfo);
		}
		else
		{
			//restore to old location
			dragInfo.restore();
			
			//notifiy the dragged item that the drag-operation is canceled
			target.dragEvents.exit.send( dragInfo );
			disposeDragInfo();
		}
		
		moveBinding.disable();
		dragInfo = null;
	}
	
	
	
	
	override private function cancelDrag (mouseObj:MouseState) : Void
	{
		trace(target+".cancelDrag \n");
		dragInfo.dropTarget = null;
	//	stopDrag(mouseObj);		<-- this is done by the draghelper
	}
	
	
	
	
	private function checkDropTarget () : Void
	{
		var item = dragInfo.dragRenderer;
		
		if (item.dropTarget == null || !item.dropTarget.is(IDropTarget)) {
			if (dragInfo.dropTarget == null || !item.isObjectOn( dragInfo.dropTarget ))
				dragInfo.dropTarget = null;
			return;
		}
		
		var curDropTarget = item.dropTarget.as(IDropTarget);
		
		//make sure the new droptarget isn't the same as the previous droptarget
		if (curDropTarget == dragInfo.dropTarget || curDropTarget == null)
			return;
		
		//check if the drag is allowed over the current dropTarget
		if (curDropTarget.is(IDataDropTarget) && dragInfo.dataCursor != null)
		{
			var dataTarget = curDropTarget.as(IDataDropTarget);
			if (dataTarget.isDataDropAllowed( cast dragInfo.dataCursor ))
				dragInfo.dropTarget = dataTarget;
		}
		else if (curDropTarget.isDisplayDropAllowed( dragInfo.displayCursor ))
			dragInfo.dropTarget = curDropTarget;
	}
}