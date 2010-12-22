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
package primevc.core.traits;
  using primevc.utils.BitUtil;


/**
 * QueueingInvalidatable allows to disable the broadcasting of an invalidate
 * call. When the broadcasting is disabled, all of the changes will be stored
 * in the "changes" flag.
 * 
 * When the broadcasting is enabled again, the changes will be dispatched.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 08, 2010
 */
class QueueingInvalidatable extends Invalidatable
{
	/**
	 * Flag indicating if the object should broadcast an invalidate call or do
	 * nothing with it.
	 */
	public var invalidatable	(default, setInvalidatable)	: Bool;
	private var changes			: Int;
	
	
	public function new ()
	{
		super();
		resetValidation();
	}
	
	
	public inline function resetValidation ()
	{
		changes			= 0;
		invalidatable	= true;
	}
	
	
	override public function invalidate (change:Int) : Void
	{
		if (invalidatable)
			super.invalidate(change);
		else
			changes = changes.set(change);
	}
	
	
	private inline function setInvalidatable (v:Bool)
	{
		if (v != invalidatable)
		{
			invalidatable = v;
			
			//broadcast queued changes?
			if (v && changes > 0) {
				invalidate(changes);
				changes = 0;
			}
		}
		return v;
	}
}