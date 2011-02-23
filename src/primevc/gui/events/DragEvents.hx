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
 * Event-signals which are fired when an object is being dragged and dropped.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 21, 2010
 */
class DragEvents extends Signals
{
	
	/**
	 * Dispatched by the object that is being dragged when a drag operation
	 * starts.
	 */
	var start		(default, null)		: Signal1<DragInfo>;
	
	/**
	 * Dispatched by the object that is being dragged when a drag operation is
	 * completed and dropped in a dropTarget.
	 */
	var complete	(default, null)		: Signal1<DragInfo>;
	
	/**
	 * Dispatched when the drag operation is canceled. This could happen when
	 * the user releases the dragged object while it's not on a droptarget or
	 * when the user presses the [esc] key.
	 */
	var cancel		(default, null)		: Signal1<DragInfo>;
	
	
	public function new ()
	{
		start		= new Signal1();
		complete	= new Signal1();
		cancel		= new Signal1();
	}
}