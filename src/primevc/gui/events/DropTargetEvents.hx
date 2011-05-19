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
package primevc.gui.events;
 import primevc.core.dispatcher.Signals;
 import primevc.core.dispatcher.Signal1;
 import primevc.gui.behaviours.drag.DragInfo;



/**
 * Events used for objects that accept an object to be dragged in
 * 
 * @author Ruben Weijers
 * @creation-date Jul 21, 2010
 */
class DropTargetEvents extends Signals
{
	/**
	 * Dispatched by the target on which the dragged item is dropped on the
	 * DropTarget.
	 */
	var drop	(default, null) : Signal1 <DragInfo>;
	
	/**
	 * Dispatched by an object when a IDraggable object is moved over it and
	 * it's allowed to be dropped on the DropTarget.
	 */
	var over	(default, null) : Signal1 <DragInfo>;
	
	/**
	 * Dispatched by the DropTarget when an allowed IDraggable object is
	 * moved out of the DropTarget.
	 */
	var out		(default, null) : Signal1 <DragInfo>;
	
	
	public function new ()
	{
		super();
		drop	= new Signal1();
		over	= new Signal1();
		out		= new Signal1();
	}
}