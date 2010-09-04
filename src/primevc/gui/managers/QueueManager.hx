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
 import primevc.utils.FastArray;
  using primevc.utils.FastArray;


/**
 * Base class for managers who work with a queue like InvalidationManager and
 * RenderManager.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
class QueueManager < ChildType, OwnerType >
		implements IDisposable
//	,	implements haxe.rtti.Generic
{	
	/**
	 * Reference to the object that owns the object
	 */
	private var owner				: OwnerType;
	
	/**
	 * Queue with objects that need to be updated on the next 
	 * updateQueueBinding call.
	 */
	private var queue				: FastArray < ChildType >;
	
	/**
	 * Binding reference to the wire that will apply the update to the queue
	 * of objects
	 */
	private var updateQueueBinding	: Wire <Dynamic>;
	
	
	public function new (owner:OwnerType)
	{
		this.owner		= owner;
		queue			= FastArrayUtil.create();
	}
	
	
	public function dispose ()
	{
		if (updateQueueBinding != null)
			updateQueueBinding.dispose();
		
		queue.removeAll();
		updateQueueBinding = null;
		owner	= null;
		queue	= null;
	}
	
	
	//
	// VALIDATION METHODS
	//
	
	
	private function enableBinding ()	{ updateQueueBinding.enable(); }
	private function disableBinding ()	{ if (queue.length == 0) updateQueueBinding.disable(); }
	
	
	/**
	 * Add's an obj to the queue with objects
	 */
	public function add ( obj:ChildType )
	{
		queue.push( obj );
		enableBinding();
	}
	
	
	
	/**
	 * Removed an object from the queue with objects
	 */
	public inline function remove ( obj:ChildType )
	{
		queue.remove(obj);
		disableBinding();
	}
}