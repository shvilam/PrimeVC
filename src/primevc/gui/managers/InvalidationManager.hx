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
 import primevc.gui.traits.IPropertyValidator;
 import primevc.gui.traits.IValidatable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * Manager object which can be called by every IInvalidating object. When an
 * IInvalidating object calls InvalidationManager.invalidate( obj ), the
 * manager will add the object to a queue of objects and starts listening for
 * the next ENTER_FRAME event (flash).
 * 
 * When an ENTER_FRAME event comes, the manager will loop through the queue of
 * invalid objects and call their 'validate' method.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
class InvalidationManager extends QueueManager
{
	public function new (owner)
	{
		super(owner);
		
		updateQueueBinding = validateQueue.on( owner.displayEvents.enterFrame, this );
		updateQueueBinding.disable();
	}
	
	
	override private function validateQueue ()
	{
		isValidating = true;
		disableBinding();
		
#if debug
		var s = traceQueues ? "\n\tbegin validating layout; first: "+first+"; last: "+last : null;
#end
		
		while (first != null)
		{
			var obj	= first.as(IPropertyValidator);
			obj.validate();
			
#if debug	if (traceQueues)
				s += "\n\t\tvalidated "+obj+"; next: "+obj.nextValidatable;
#end
			// During validation the queue can change (adding/removing items).
			// The 'first' property will be the correct value if the current 
			// validating object was removed from the queue during it's own 
			// validation (that means it's nextValidatable is already 'null').
			if (obj.nextValidatable != null)
				first = obj.nextValidatable;
			
			// Exit the loop if the current validating item is the last item 
			// and the nextValidatable is 'null' and the 'first' value isn't 
			// changed during validation.
			else if (obj == first)
			 	first = null;
			
			obj.nextValidatable = obj.prevValidatable = null;
		}
		
#if debug
		if (traceQueues)
			trace( s += "\n\tfinished validating layout; first: "+first+"; last: "+last );
#end
		
		last = null;
		isValidating = false;
	}
	
	
#if debug
	override public function toString () { return "InvalidationManager"; }
#end
}