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
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.traits.IDataDropTarget;
 import primevc.gui.traits.IDropTarget;
 import primevc.gui.traits.ILayoutable;
 import primevc.utils.NumberUtil;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * Behaviour which will add an dropped item on the right child-depth and on the
 * right position. This behaviour should be added to the container that will
 * accept the drag&drop (IDropTarget).
 * 
 * @author Ruben Weijers
 * @creation-date Jul 28, 2010
 */
class ApplyDropBehaviour extends BehaviourBase <IDropTarget>
{
	override private function init ()
	{
		addDroppedItem.on( target.dragEvents.drop, this );
	}
	
	
	override private function reset ()
	{
		target.dragEvents.drop.unbind(this);
	}


	private function addDroppedItem (droppedItem:DragInfo) : Void
	{
		var newChild	= droppedItem.target;
		var depth		= IntMath.min( target.children.length, target.getDepthForBounds( droppedItem.dropBounds ) );
		
		//add itemrenderer to datalist?
		if (target.isDisplayDropAllowed( droppedItem.displayCursor ))
		{
			var cursor = droppedItem.displayCursor;
			if (cursor.target.is(ILayoutable))
			{
				var layout = cursor.target.as(ILayoutable).layout;
				layout.x = droppedItem.dragRectangle.left;
				layout.y = droppedItem.dragRectangle.top;
			}
			else
			{
				cursor.target.x = droppedItem.dragRectangle.left;
				cursor.target.y = droppedItem.dragRectangle.top;
			}
			cursor.moveTarget( depth, target.children );
		}
		else
			droppedItem.displayCursor.restore();
		
		//add data item to datalist?
		if (target.is(IDataDropTarget) && droppedItem.dataCursor != null)
		{
			var dataTarget	= target.as(IDataDropTarget);
			var dataCursor	= droppedItem.dataCursor;
			
			if (dataTarget.isDataDropAllowed( cast dataCursor ))
				dataCursor.moveTarget( depth, dataTarget.list );
			else
				dataCursor.restore();
				
		}
		
		droppedItem.dispose();
	}
}