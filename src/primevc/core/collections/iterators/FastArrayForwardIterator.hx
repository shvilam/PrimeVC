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
 import primevc.utils.FastArray;
  using Std;


/**
 * Forward iterator for a fast-array
 * 
 * @creation-date	Jul 1, 2010
 * @author			Ruben Weijers
 */
class FastArrayForwardIterator <DataType> implements IIterator <DataType>
	#if flash9	,	implements haxe.rtti.Generic #end
{
	private var target	(default, null)	: FastArray<DataType>;
	public var current	(default, null)	: Int;
	
	
	public function new (target:FastArray<DataType>)
	{
		this.target	= target;
		rewind();
	}
	
	public inline function setCurrent (val:Dynamic)	{ current = val; }
	public inline function rewind ()				{ current = 0; }
	public inline function hasNext ()				{ return current < target.length.int(); }		// <- Vector.length is defined as UInt, but since haXe damns it to implement UInt, we have to cast it :-(
	public inline function next ()					{ return target[ current++ ]; }
	public inline function value ()					{ return target[ current ]; }
	
//	public inline function hasPrev ()				{ return (current - 1) >= 0 ; }
//	public inline function prev ()					{ current -= 2; return value(); }
	
//	public inline function isValid (val:Dynamic)	{ return val >= 0 && val < target.length.int(); }
}