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
 import primevc.core.collections.iterators.FastArrayForwardIterator;
 import primevc.core.collections.iterators.FastArrayReversedIterator;
 import primevc.core.collections.iterators.IIterator;
 import primevc.core.events.ListChangeSignal;
 import primevc.utils.FastArray;
  using primevc.utils.FastArray;



/**
 * IReadOnlyList implementation with vector in flash10 and otherwise an array.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 19, 2010
 */
class ReadOnlyArrayList < DataType >
	implements IReadOnlyList < DataType >
	#if GenericArrays, implements haxe.rtti.Generic #end
{
	public var change		(default, null)		: ListChangeSignal < DataType >;
	private var list		(default, null)		: FastArray < DataType >;
	public var length		(getLength, never)	: Int;
	
	
	public function new( wrapAroundList:FastArray<DataType> = null )
	{
		change	= new ListChangeSignal();
		
		if (wrapAroundList == null)
			list = FastArrayUtil.create();
		else
		 	list = wrapAroundList;
	}
	
	
	public function dispose ()
	{
		change.dispose();
		list	= null;
		change	= null;
	}
	
	
	public function clone () : IReadOnlyList < DataType >
	{
		var l = new ReadOnlyArrayList<DataType>();
		for (child in this)
			l.list.insertAt(child, l.length);
		
		return l;
	}
	
	
	private inline function getLength ()						{ return list.length; }
	public inline function iterator () : Iterator <DataType>	{ return cast forwardIterator(); }
	public function forwardIterator () : IIterator <DataType>	{ return cast new FastArrayForwardIterator<DataType>(list); }
	public function reversedIterator () : IIterator <DataType>	{ return cast new FastArrayReversedIterator<DataType>(list); }
	
	
	/**
	 * Returns the item at the given position. It is allowed to give negative values.
	 * The returned item will then be on position -> length - askedPosition
	 * 
	 * @param	pos
	 * @return
	 */
	public function getItemAt (pos:Int) : DataType
	{
		var i:Int = pos < 0 ? length + pos : pos;
		return list[i];
	}
	
	
	public function indexOf (item:DataType) : Int {
		return list.indexOf(item);
	}
	
	
	public function has (item:DataType) : Bool {
		return list.indexOf(item) >= 0;
	}
	
	
#if debug
	public var name : String;
	
	public function toString()
	{
		var items = [];
		var i = 0;
		for (item in this) {
			items.push( "[ " + i + " ] = " + item ); // Type.getClassName(Type.getClass(item)));
			i++;
		}
		return name + "ArrayList ("+items.length+")\n" + items.join("\n");
	}
#end
}