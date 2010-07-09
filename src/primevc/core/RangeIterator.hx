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
package primevc.core;
 

/**
 * Iterator object
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class RangeIterator 
{
	public var start	(default, setStart) : Int;
	public var max		: Int;
	public var stepSize	: Int;
	public var current	: Int;
	
	
	public function new(max:Int, stepSize:Int = 1, start:Int = 0) 
	{
		if (max == 0)
			max = Number.INT_MAX;
		
		set(max, stepSize, start);
	}
	
	
	public inline function set (max:Int, stepSize:Int = 1, start:Int = 0) {
		this.max		= max;
		this.stepSize	= stepSize;
		this.start		= start;
	}
	
	
	public inline function hasNext () : Bool {
		return current < max;
	}
	
	
	public inline function next () {
		var c = current;
		current = current + stepSize;
		if (current > max)
			current = max;
		return c;
	}
	
	
	private inline function setStart (v) {
		return start = current = v;
	}
	
	
#if debug
	public function toString () {
		return "iterating from " + start + " to " + max + " with steps of " + stepSize;
	}
#end
}