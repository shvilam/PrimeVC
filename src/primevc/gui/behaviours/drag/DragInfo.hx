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
 import primevc.core.IDisposable;
 import primevc.core.geom.Point;
 import primevc.core.geom.IRectangle;
 import primevc.gui.display.IDisplayContainer;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.traits.IDraggable;
 import primevc.gui.traits.IDropTarget;
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
	public var target										: IDraggable;
	
	/**
	 * Container in which the target used to be when the drag-operation 
	 * started.
	 */
	public var origContainer	(default, null)				: IDisplayContainer;
	
	/**
	 * Depth on which the target was in the displaylist when the drag-operation
	 * started.
	 */
	public var origDepth		(default, null)				: Int;
	
	/**
	 * Original location of the dragged item.
	 */
	public var origPosition		(default, null)				: Point;
	
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
	
	
	public function new (newTarget:IDraggable)
	{
		target			= newTarget;
		dropTarget		= newTarget.container.as(IDropTarget);
		origPosition	= new Point(target.x, target.y);
		layout			= target.  new LayoutClient( target.width.int(), target.height.int() );
		dragRectangle	= cast target.rect.clone(); //new IntRectangle( target.x.int(), target.y.int(), layout.width, layout.height );
		
		origContainer	= target.container;
		origDepth		= target.container.children.indexOf(target);
	}
	
	
	public function dispose ()
	{
		target			= null;
		dragRectangle	= null;
		dropTarget		= null;
		dropBounds		= null;
		origContainer	= null;
		origPosition	= null;
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