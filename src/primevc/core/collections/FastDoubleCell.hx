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
package primevc.core.collections;
 

/**
 * FastCell with a back- and forward reference.
 * 
 * @creation-date	Jul 1, 2010
 * @author			Ruben Weijers
 */
class FastDoubleCell <T> #if (flash9 || cpp) implements haxe.rtti.Generic #end
{
	public var data : T;
	public var prev : FastDoubleCell<T>;
	public var next : FastDoubleCell<T>;
	
	
	public function new (data, ?prev, ?next)
	{
		this.data = data;
		this.prev = prev;
		this.next = next;
	}
	
	
	public inline function dispose ()
	{
		data = null;
		next = prev = null;
	}
	
	
	/**
	 * Insert's the current cell before the given cell
	 */
	public function insertBefore ( cell:FastDoubleCell <T >)
	{
		if (cell.prev != this)
		{
			prev = cell.prev;
			if (prev != null)
				prev.next = this;
		
			cell.prev	= this;
		//	cell.next	= next;
			next		= cell;
		}
		return this;
	}
	
	
	/**
	 * Insert's the current cell after the given cell
	 */
	public function insertAfter ( cell:FastDoubleCell <T> )
	{
		if (cell.next != this)
		{
			next = cell.next;
			if (next != null)
				next.prev	= this;
			
			cell.next	= this;
			prev		= cell;
		}
		return this;
	}
	
	
	public function remove ()
	{
		if (prev != null)	prev.next = next;
		if (next != null)	next.prev = prev;
		
		prev = next = null;
	//	dispose();
	}
	
#if debug
	public function toString () { return data+"Cell"; }
#end
}