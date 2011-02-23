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
package primevc.core.collections.iterators;
 import primevc.core.collections.FastDoubleCell;


/**
 * Iterate object for the DoubleFastList implementation
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class FastDoubleCellForwardIterator <DataType> implements IIterator <DataType>
	#if (flash9 || cpp) ,implements haxe.rtti.Generic #end
{
	private var first (default, null)	: FastDoubleCell<DataType>;
	public var current (default, null)	: FastDoubleCell<DataType>;
	
	public function new (first:FastDoubleCell<DataType>) 
	{
		this.first = first;
		rewind();
#if (unitTesting && debug)
		test();
#end
	}
	
	
	public inline function setCurrent (val:Dynamic)	{ current = val; }
	public inline function rewind ()				{ current = first; }
	public inline function hasNext () 				{ return current != null; }
	public inline function value ()					{ return current.data; }
	
	
	public inline function next () : DataType
	{
		var c = current;
		current = current.next;
		return c.data;
	}
	
	
#if (unitTesting && debug)
	public function test ()
	{
		var cur = first, prev:FastDoubleCell<DataType> = null;
		while (cur != null)
		{
			if (prev == null)	Assert.null( cur.prev, "first incorrect" );
			else				Assert.equal( cur.prev, prev, "previous incorrect" );
			
			prev	= cur;
			cur		= cur.next;
		}
	}
#end
}
