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
package primevc.gui.managers;
 import primevc.core.dispatcher.Wire;
 import primevc.core.IDisposable;
 import primevc.gui.display.Window;
 import primevc.gui.traits.IValidatable;


/**
 * Base class for managers who work with a queue like InvalidationManager and
 * RenderManager.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
class QueueManager implements IDisposable
{	
	/**
	 * Reference to the object that owns the object
	 */
	private var owner			: Window;
	private var first			: IValidatable;
	private var last			: IValidatable;
	
	/**
	 * Binding reference to the wire that will apply the update to the queue
	 * of objects
	 */
	private var updateQueueBinding	: Wire <Dynamic>;
	
	
	public function new (owner:Window)
	{
		this.owner = owner;
	}
	
	
	public function dispose ()
	{
		if (updateQueueBinding != null) {
			updateQueueBinding.dispose();
			updateQueueBinding = null;
		}
		
		while (last != null)
		{
			var obj = last;
			last = last.prevValidatable;
			obj.nextValidatable = obj.prevValidatable = null;
		}
		
		first	= null;
		owner	= null;
	}
	
	
	//
	// VALIDATION METHODS
	//
	
	
	private function enableBinding ()			{ updateQueueBinding.enable(); }
	private inline function disableBinding ()	{ updateQueueBinding.disable(); }
	
	
	private function validateQueue ()
	{
		var curCell = first;
		
		while (curCell != null)
		{
			var obj	= curCell;
			obj.validate();
			
			curCell	= curCell.nextValidatable;
			obj.nextValidatable = obj.prevValidatable = null;
		}
		first = last = null;
		disableBinding();
	}
	
	
	
	/**
	 * Add's an obj to the queue with objects
	 */
	public function add ( obj:IValidatable )
	{
		//only add the object if it's not in the list yet
		if (obj.prevValidatable != null || obj.nextValidatable != null)
			return;
		
		if (first == null)
			first = obj;
		else
			last.nextValidatable = obj;
		
		last = obj;
		
		if (first != null)
			enableBinding();
	}
	
	
	/**
	 * Removed an object from the queue with objects
	 */
	public function remove ( obj:IValidatable )
	{
		if (obj == first)	first = obj.nextValidatable;
		if (obj == last)	last = obj.prevValidatable;
		
		obj.nextValidatable = obj.prevValidatable = null;
		
		if (first == null)
			disableBinding();
	}
	
	
#if debug
	public function toString () { return "QueueManager"; }
#end
}