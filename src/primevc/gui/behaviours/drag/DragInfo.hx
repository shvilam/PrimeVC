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
 import primevc.core.traits.IDisposable;
 import primevc.core.collections.IDataCursor;
 import primevc.core.geom.Point;
 import primevc.core.geom.IRectangle;
 import primevc.gui.display.DisplayDataCursor;
 import primevc.gui.display.IDisplayContainer;
 import primevc.gui.display.ISprite;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.traits.IDraggable;
 import primevc.gui.traits.IDropTarget;
 import primevc.gui.traits.ILayoutable;
  using primevc.utils.TypeUtil;
  using Std;


/**
 * DragInfo contains all the information about an object that is currenly
 * dragged.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 21, 2010
 */
class DragInfo implements IDisposable
{
	public var target			(default, null)				: IDraggable;
	
	/**
	 * Sprite to visualize the dragged-item during a drag operation.
	 * @default		target
	 */
	public var dragRenderer		(default, null)				: ISprite;
	
	/**
	 * Information about the displayList in which the target is placed.
	 */
	public var displayCursor	(default, null)				: DisplayDataCursor;
	
	/**
	 * Optional cursor pointer for the data
	 */
	public var dataCursor		(default, null)				: IDataCursor < Dynamic >;
	
	/**
	 * Layout object of the target
	 */
	public var layout			(default, null)				: LayoutClient;
	
	/**
	 * Rectangle indicating the boundaries of the dragged object in the global
	 * coordinate-space. x-y coordinates won't update automaticly unless the
	 * ShowDragGapBehaviour is used.
	 */
	public var dragRectangle	(default, null)				: IRectangle;
	
	/**
	 * The current dropTarget. Property will only be set if it allows the target
	 * as a IDraggable.
	 */
	public var dropTarget		(default, setDropTarget)	: IDropTarget;
	
	/**
	 * Location on which the item is dropped. Location is already converted
	 * to the coordinates of the dropTarget.
	 */
	public var dropBounds									: IRectangle;
	
	
	public function new (target:IDraggable, dataCursor:IDataCursor<Dynamic> = null, dragRenderer:ISprite = null, dragLayout:LayoutClient = null)
	{
		this.target			= target;
		this.displayCursor	= target.getDisplayCursor();
		this.dataCursor		= dataCursor;
		
		if (target.container.is(IDropTarget))
			this.dropTarget	= target.container.as(IDropTarget);
		
		this.dragRenderer	= (dragRenderer != null)	? dragRenderer : target;
		this.layout			= (dragLayout != null)		? dragLayout : new LayoutClient( target.rect.width, target.rect.height );
		this.dragRectangle	= this.dragRenderer.rect; //cast target.rect.clone(); //new IntRectangle( target.x.int(), target.y.int(), layout.width, layout.height );
	//	trace("new DragInfo "+target+" -> layout: "+this.layout);
	}
	
	
	public function dispose ()
	{
		if (target != dragRenderer)
			dragRenderer.dispose();
		
		if (dataCursor != null)		dataCursor.dispose();
		if (displayCursor != null)	displayCursor.dispose();
		
		target			= null;
		dragRectangle	= null;
		dragRenderer	= null;
		
		displayCursor	= null;
		dataCursor		= null;
		
		dropTarget		= null;
		dropBounds		= null;
	}
	
	
	public function restore ()
	{
		if (displayCursor != null)		displayCursor.restore();
		if (dataCursor != null)			dataCursor.restore();
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setDropTarget (v:IDropTarget) {
		if (dropTarget != null)
			dropTarget.dragEvents.out.send(this);
		
		dropTarget = v;
		
		if (dropTarget != null)
			dropTarget.dragEvents.over.send(this);
		
		return v;
	}
	
	
#if debug
	public function toString () {
		return "DragInfo( " + target + ") ";
	}
#end
}