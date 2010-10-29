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
 import primevc.core.geom.Rectangle;
 import primevc.core.IDisposable;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.traits.IDraggable;
  using primevc.utils.TypeUtil;

/**
 * Base class for dragging classes.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
class DragBehaviourBase extends BehaviourBase <IDraggable>
{
	private var dragInfo	: DragInfo;
	private var dragHelper	: DragHelper;
	private var dragBounds	: Rectangle;
	
	
	public function new (target, ?dragBounds:Rectangle)
	{
		super(target);
		this.dragBounds = dragBounds;
	}
	
	
	override private function init () : Void
	{
		dragHelper = new DragHelper( target, startDrag, stopDrag, cancelDrag );
	}
	
	
	override private function reset () : Void
	{
		if (dragHelper != null) {
			dragHelper.dispose();
			dragHelper = null;
		}
		
		disposeDragInfo();
		
		if (dragBounds.is(IDisposable)) {
			dragBounds.as(IDisposable).dispose();
			dragBounds = null;
		}
	}
	
	
	private function startDrag (mouseObj:MouseState) : Void	{ Assert.abstract(); }
	private function cancelDrag (mouseObj:MouseState) : Void { Assert.abstract(); }


	private function stopDrag (mouseObj:MouseState) : Void
	{	
		target.stopDrag();
		target.dragEvents.complete.send(dragInfo);
		disposeDragInfo();
	}


	private inline function disposeDragInfo ()
	{
		if (dragInfo != null) {
			dragInfo.dispose();
			dragInfo = null;
		}
	}
}