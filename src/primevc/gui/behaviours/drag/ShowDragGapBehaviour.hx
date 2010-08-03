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
 import primevc.gui.core.IUIContainer;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.traits.IDropTarget;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * This behaviour will reveal the location of an IDraggable item in the 
 * IDropTarget when a IDraggable item is dragged over.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 28, 2010
 */
class ShowDragGapBehaviour extends BehaviourBase <IDropTarget>
{
	private var draggedItem : DragSource;
	private var layoutGroup	: LayoutContainer;


	override private function init ()
	{
		layoutGroup = target.layoutContainer;
		dragOverHandler			.on( target.dragEvents.over, this );
		removeTmpTileFromLayout	.on( target.dragEvents.out, this );
		removeTmpTileFromLayout	.on( target.dragEvents.drop, this );
	}
	
	
	override private function reset ()
	{
		layoutGroup = null;
		target.dragEvents.over.unbind(this);
		target.dragEvents.out.unbind(this);
		target.window.mouse.events.move.unbind(this);
	}
	
	
	private function dragOverHandler (source:DragSource)
	{
		draggedItem = source;
		updateTargetAfterMouseMove.on( target.window.mouse.events.move, this );
	}
	
	
	private function removeTmpTileFromLayout (source:DragSource)
	{
		target.window.mouse.events.move.unbind( this );
		layoutGroup.children.remove( source.layout );
		draggedItem = null;
	}
	
	
	private function updateTargetAfterMouseMove (mouseObject:MouseState)
	{
		var newDepth	= target.children.length;
		var dragPos		= target.globalToLocal( new Point( draggedItem.target.x, draggedItem.target.y ) );
		var curDepth	= layoutGroup.children.indexOf(draggedItem.layout);
		
		if (layoutGroup.algorithm != null)
			newDepth = layoutGroup.algorithm.getDepthForPosition( dragPos );
		
		//lower with one if the object should be placed at the end of the list, and is already there
		if (curDepth > -1 && newDepth == target.children.length)
			newDepth -= 1;

		if (curDepth == -1)
			layoutGroup.children.add( draggedItem.layout, newDepth );
		else if (curDepth != newDepth)
			layoutGroup.children.move( draggedItem.layout, newDepth, curDepth );
	}
}