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
 import primevc.core.traits.IDisposable;
 import primevc.gui.display.Window;
 import primevc.gui.traits.IValidatable;


/**
 * Base class for managers who work with a queue like InvalidationManager and
 * RenderManager.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
class QueueManager implements IDisposable, implements IValidatable
{	
	/**
	 * Reference to the object that owns the object
	 */
	private var owner				: Window;
	private var first				: IValidatable;
	private var last				: IValidatable;
	private var isValidating		: Bool;
	
	/**
	 * Binding reference to the wire that will apply the update to the queue
	 * of objects
	 */
	private var updateQueueBinding	: Wire <Dynamic>;
	
	
	public function new (owner:Window)
	{
		this.owner		= owner;
		isValidating	= false;
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
			last = cast last.prevValidatable;
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
	private function validateQueue ()			{ Assert.abstract(); }
	
	
	
	/**
	 * Add's an obj to the end of the queue with objects
	 */
	public function add ( obj:IValidatable )
	{
		//if the invalidated object is the first in the list, it's probably 
		//invalidated during it's own validation. To make sure the object is valid
		//it will be removed from the queue and then added at the end of the 
		//queue.
		if (isValidating && obj == first && obj != last)
			remove(obj);
		
		//only add the object if it's not in the list yet
	//	else if (obj.prevValidatable == null && first != null && obj == first)
	//		return;
			
	//	else if (obj.nextValidatable == null && last != null && obj == last)
	//		return;
		
	//	else if (obj.prevValidatable != null && obj.prevValidatable == last)
	//		return;
		
		else if (obj.isQueued())
			return;
			
//#if debug	if (obj.prevValidatable == null)	Assert.equal( obj, first, obj + "" );
//			if (obj.nextValidatable == null)	Assert.equal( obj, last, obj + "" ); #end
//			return;
		
		if (first == null)
		{
			first = obj;
			obj.prevValidatable = this;
			obj.nextValidatable = last;
			enableBinding();
		}
		else
		{
			last.nextValidatable	= obj;
			obj.prevValidatable		= last;
		}
		
		last = obj;
	}
	
	
	/**
	 * Removed an object from the queue with objects
	 */
	public function remove ( obj:IValidatable )
	{
		if (obj.prevValidatable == this)
			obj.prevValidatable = null;
		
		if (obj == first)	first = obj.nextValidatable;
		if (obj == last)	last = obj.prevValidatable;
		
		if (obj.prevValidatable != null)	obj.prevValidatable.nextValidatable = obj.nextValidatable;
		if (obj.nextValidatable != null)	obj.nextValidatable.prevValidatable = obj.prevValidatable;
		
		obj.nextValidatable = obj.prevValidatable = null;
		
		if (first == null)
			disableBinding();
	}
	
	
	//
	// IVALIDATABLE IMPLEMENTATION
	//
	
	//properties are only here to make the manager also an IValidatable
	public var prevValidatable		: IValidatable;
	public var nextValidatable		: IValidatable;
	public inline function isOnStage ()		{ return true; }
	public inline function isQueued ()		{ return true; }
	
	
#if debug
	/**
	 * flag indicating if the traceQueue method should trace anything.
	 * @default false
	 */
	public var traceQueues : Bool;
	
	
	public function traceQueue ()
	{
		if (!traceQueues) return;
		
		var curCell = first;
		var i = 0;
		var s = "\n\t\t\tlistQueue; isValidating? "+isValidating+"; isListening? "+updateQueueBinding.isEnabled();
		while (curCell != null)
		{
			s += "\n\t\t\t\t\t\t\t[ "+i+" ] = "+curCell;
			curCell	= curCell.nextValidatable;
			i++;
		}
		s += "\n\t\t\tqueue length: "+i;
		trace(s);
	}
	
	
	public function toString () { return "QueueManager"; }
#end
}