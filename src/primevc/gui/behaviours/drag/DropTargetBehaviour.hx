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
  using primevc.utils.Bind;


/**
 * Behaviour which will add an dropped item on the right child-depth an on the
 * right position.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 28, 2010
 */
class DropTargetBehaviour extends BehaviourBase <IDropTarget>
{
	override private function init ()
	{
		addDroppedChild.on( target.dragEvents.drop, this );
	}
	
	
	override private function reset ()
	{	
		target.dragEvents.drop.unbind(this);
	}


	private function addDroppedChild (droppedItem:DragSource) : Void
	{
		var newChild	= droppedItem.target;
		var depth		= target.children.length;
		depth			= target.getDepthForPosition( droppedItem.dropPosition );
		trace(target + ".addDroppedTile "+newChild+" on "+depth+" in "+target.name);
		
		if (droppedItem.origContainer != target || !target.children.has(newChild))
			target.children.add( newChild, depth );
		else
			target.children.move( newChild, depth );
	}
}