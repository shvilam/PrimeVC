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
 import primevc.core.geom.IntRectangle;
 import primevc.core.geom.Rectangle;
 import primevc.core.traits.IDisposable;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.display.ISprite;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.input.Mouse;
 import primevc.gui.traits.ILayoutable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;

/**
 * Base class for dragging classes.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 29, 2010
 */
class DragBehaviourBase extends BehaviourBase <ISprite>
{
	private var dragInfo			: DragInfo;
	private var dragBounds			: IntRectangle;
	private var mouseTarget			: ISprite;
	private var mouseEnabledValue	: Bool;
	
	public var dragHelper			(default, null) : DragHelper;
	
	
	
	/**
	 * @param	dragTarget		the object that will be dragged
	 * @param	dragBounds		Rectangle in which the target can be dragged. 
	 * 							If null, there are no limits to where the target can be dragged
	 * @param	mouseTarget		The object that will trigger the dragging of the target
	 * 							If null (default), the target will start the drag
	 */
	public function new (dragTarget:ISprite, ?dragBounds:IntRectangle, ?mouseTarget:ISprite, delay:Int = -1)
	{
		super(dragTarget);
		this.dragBounds		= dragBounds;
		this.mouseTarget	= mouseTarget == null ? dragTarget : mouseTarget;
		
		if (delay == -1)
			delay = Mouse.DRAG_DELAY;
		
		dragHelper = new DragHelper( mouseTarget, startDrag, stopDrag, cancelDrag, delay );
	}
	
	
	override private function init () : Void
	{
		enable();
	}
	
	
	override private function reset () : Void
	{
		if (dragHelper != null) {
			dragHelper.dispose();
			dragHelper = null;
		}
		
		disposeDragInfo();
		dragBounds = null;
	}


	public inline function enable ()	{ dragHelper.start.on( mouseTarget.userEvents.mouse.down, this ); }
	public inline function disable ()	{ mouseTarget.userEvents.mouse.down.unbind( this ); }
	
	
	private function startDrag (mouseObj:MouseState) : Void
	{
		if (dragInfo == null)
			dragInfo = target.createDragInfo();
			
		var dragTarget = dragInfo.dragRenderer;
		
#if flash9
		mouseEnabledValue		= dragTarget.mouseEnabled;
		dragTarget.mouseEnabled	= false;
#end
		if (dragBounds == null)
			dragTarget.startDrag();
		else
		{
			var bounds		 = dragBounds.toFloatRectangle();
			bounds.width	-= dragInfo.dragRectangle.width;
			bounds.height	-= dragInfo.dragRectangle.height;
			dragTarget.startDrag( false, bounds );
		}
		
		if (dragTarget.is(ILayoutable))
			dragTarget.as(ILayoutable).layout.includeInLayout = false;
		
		target.userEvents.drag.start.send(dragInfo);
	}
	
	
	private function cancelDrag (mouseObj:MouseState) : Void
	{
		Assert.abstract();
	}


	private function stopDrag (mouseObj:MouseState) : Void
	{
	//	if (dragInfo != null)
	//	{
			stopDragging();
			target.userEvents.drag.complete.send(dragInfo);
	//	}
	}
	
	
	private function stopDragging ()
	{
		var item = dragInfo.dragRenderer;
		item.stopDrag();
		item.mouseEnabled = mouseEnabledValue;
		
		if (target.is(ILayoutable))
			target.as(ILayoutable).layout.includeInLayout = true;

	}


	private inline function disposeDragInfo ()
	{
		if (dragInfo != null) {
			dragInfo.dispose();
			dragInfo = null;
		}
	}
}