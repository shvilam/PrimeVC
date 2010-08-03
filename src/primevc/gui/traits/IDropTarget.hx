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
package primevc.gui.traits;
 import primevc.core.geom.Point;
 import primevc.gui.behaviours.drag.DragSource;
 import primevc.gui.core.IUIContainer;
 import primevc.gui.events.DropTargetEvents;


/**
 * Interface describing objects that can accapt objects to be dropped in.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 22, 2010
 */
interface IDropTarget implements IUIContainer
{
	/**
	 * Eventgroup which will dispatch events when an IDraggable object is 
	 * interacting with this IDropTarget.
	 */
	public var dragEvents	: DropTargetEvents;
	
	/**
	 * Method to check if an IDraggable-item is allowed to drop on this
	 * container.
	 */
	public function isDropAllowed (draggedItem:DragSource) : Bool;
	
	
	/**
	 * Method which should return the depth of a dropped item with the given
	 * coordinates.
	 */
	public function getDepthForPosition (pos:Point) : Int;
}
