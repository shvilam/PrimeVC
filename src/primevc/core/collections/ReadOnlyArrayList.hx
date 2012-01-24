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
 import haxe.FastList;
 import primevc.core.collections.iterators.FastArrayForwardIterator;
 import primevc.core.collections.iterators.FastArrayReversedIterator;
 import primevc.core.collections.iterators.IIterator;
 import primevc.core.events.ListChangeSignal;
 import primevc.utils.FastArray;
  using primevc.utils.Bind;
  using primevc.utils.FastArray;
  using primevc.utils.IfUtil;



/**
 * IReadOnlyList implementation with vector in flash10 and otherwise an array.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 19, 2010
 */
class ReadOnlyArrayList < DataType > implements IReadOnlyList < DataType >, implements haxe.rtti.Generic
{
	public var beforeChange	(default, null)		: ListChangeSignal<DataType>;
	public var change		(default, null)		: ListChangeSignal<DataType>;
	public var list			(default, null)		: FastArray < DataType >;
	public var length		(getLength, never)	: Int;
	
	
	public var array		(getArray,null)		: FastArray < DataType >;
		inline function getArray() : FastArray<DataType> return #if flash10 flash.Vector.convert(list) #else list #end
	
	public function new( wrapAroundList:FastArray<DataType> = null )
	{
		change 		 = new ListChangeSignal();
		beforeChange = new ListChangeSignal();
		
		if (wrapAroundList.isNull())
			list = FastArrayUtil.create();
		else
		 	list = wrapAroundList;
	}
	
	
	public function dispose ()
	{
		beforeChange.dispose();
		change.dispose();
		list	= null;
		change	= beforeChange = null;
	}
	
	
	public function clone () : IReadOnlyList < DataType >
	{
		return new ReadOnlyArrayList<DataType>( list.clone() );
	}
	
	
	public function duplicate () : IReadOnlyList < DataType >
	{
		return new ReadOnlyArrayList<DataType>( list.duplicate() );
	}
	
	
	private inline function getLength ()								{ return list.length; }
	public inline function iterator () : Iterator <DataType>			{ return cast forwardIterator(); }
	public inline function forwardIterator () : IIterator <DataType>	{ return cast new FastArrayForwardIterator<DataType>(list); }
	public inline function reversedIterator () : IIterator <DataType>	{ return cast new FastArrayReversedIterator<DataType>(list); }

	public inline function disableEvents ()								{ beforeChange.disable(); change.disable(); }
	public inline function enableEvents ()								{ beforeChange.enable();  change.enable(); }
	
	public inline function asIterableOf<B> ( type:Class<B> ) : Iterator<B>
	{
		#if debug for (i in 0 ... list.length) Assert.isType(list[i], type); #end
		return cast forwardIterator();
	}
	
	/**
	 * Returns the item at the given position. It is allowed to give negative values.
	 * The returned item will then be on position -> length - askedPosition
	 * 
	 * @param	pos
	 * @return
	 */
	public inline function getItemAt (pos:Int) : DataType
	{
		Assert.that(pos >= 0, pos+"");
	//	var i:Int = pos < 0 ? length + pos : pos;
		return list[pos];
	}
	
	
	public inline function indexOf (item:DataType) : Int
	{
		return list.indexOf(item);
	}
	
	
	public inline function has (item:DataType) : Bool
	{
		return list.indexOf(item) >= 0;
	}
	
	
	/**
	 * Method will remove the items from this list and inject the values of 
	 * the other list into this list. Changes in the otherList after injection
	 * will not be noticed by this list..
	 */
	public function inject (otherList:FastArray<DataType>)
	{
		this.list = otherList;
		change.send( ListChange.reset );
	}




	//
	// PAIRING / BINDING WITH OTHER LISTS
	//

	/**
	 * Keeps track of which lists are updating this list
	 */
	private var boundTo : FastList < ReadOnlyArrayList < DataType > >;
	/**
	 * Keeps track of which lists should be updated when this list changes
	 */
	private var writeTo : FastList < ReadOnlyArrayList < DataType > >;



	/**
	 * Makes sure this.value is (and remains) equal
	 * to otherList.
	 *	
	 * In other words, update this when otherList changes.
	 */
	public inline function bind (other:ReadOnlyArrayList<DataType>)
	{
		other.keepUpdated(this);
	}

	
	/**
	 * @see IBindableReadonly
	 */
	public function unbind (other:ReadOnlyArrayList<DataType>)
	{
		Assert.notNull(other);
		Assert.notEqual(other, this);
		
		var removed = false;
		if (writeTo.notNull()) 	{ 
			removed = this.writeTo.remove(cast other);
			if (removed) {
				beforeChange.unbind( other );
				change.unbind( other );
			}
		}
		if (boundTo.notNull()) 	removed = this.boundTo.remove(other) || removed;
		if (removed)			other.unbind(this);
		
		return removed;
	}
	
	
	/**
	 * Will remove every binding to lists which update this object, or which this object updates.
	 */
	public function unbindAll ()
	{
		if (writeTo.notNull()) while (!writeTo.isEmpty())	writeTo.pop().unbind(this);
		if (boundTo.notNull()) while (!boundTo.isEmpty())	boundTo.pop().unbind(this);
	}



	
	private inline function registerBoundTo(other:ReadOnlyArrayList<DataType>)
	{
		Assert.notNull(other);
		
		var b = this.boundTo;
		if (b.isNull())
			b = this.boundTo = new FastList<ReadOnlyArrayList<DataType>>();
		
		addToBoundList(b, other);
	}
	
	
	private inline function addToBoundList<T>(list:FastList<T>, other:T)
	{
		Assert.notNull(list);
		
		// Only bind if not already bound.
		var n = list.head;
		while (n.notNull())
		 	if (n.elt == other) { list = null; break; } // already bound, skip add()
			else n = n.next;
		
		if (list.notNull())
			list.add(other);
	}
	
	
	/**
	 * @see IBindableReadonly
	 */
	private function keepUpdated (other:ReadOnlyArrayList<DataType>)
	{
		Assert.notNull(other);
		Assert.notEqual(other, this);
		
		other.list = list.clone();
		other.beforeChange.send.on( beforeChange, other );
		other.applyChanges.on( change, other );
		(untyped other).registerBoundTo(this);
		
		var w = this.writeTo;
		if (w.isNull())
			w = this.writeTo = new FastList<ReadOnlyArrayList<DataType>>();
		
		addToBoundList(w, other);
	}


	private function applyChanges (c:ListChange<DataType>) : Void
	{
		switch (c) {
			case added(   item, newPos ):			list.insertAt(item, newPos);
			case removed( item, oldPos ):			list.removeAt(oldPos);
			case moved(   item, newPos, oldPos ):	list.move(item, newPos, oldPos);
			case reset:								list.removeAll();	
		}
		change.send(c);
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