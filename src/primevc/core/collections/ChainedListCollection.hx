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
 import primevc.core.collections.SimpleList;
 import primevc.core.events.ListEvents;
 import primevc.utils.IntMath;
  using primevc.utils.IntMath;
  using primevc.utils.TypeUtil; 


/**
 * ChainedListCollection is a collection of chained lists. It combines the
 * advanteges of a chained-list (speed) with the advantages of an indexed
 * list.
 * 
 */
class ChainedListCollection <DataType> implements IList <DataType>,
	implements IListCollection < DataType, ChainedList<DataType> > 
	#if (flash9 || cpp) ,implements haxe.rtti.Generic #end
{
	public var events		(default, null)				: ListEvents < DataType >;
	
	private var _length		: Int;
	public var length		(getLength, never)			: Int;
	
	public var lists		(default, null)				: ArrayList <ChainedList<DataType>>;
	/**
	 * Maximum number of items per chained list.
	 */
	public var maxPerList	(default, setMaxPerList)	: Int;
	
	
	public function new (max:Int = -1)
	{
		events		= new ListEvents();
		lists		= new ArrayList<ChainedList<DataType>>();
	//	lists.push( new ChainedList() );
		
		maxPerList	= max;
		_length		= 0;
	}
	
	
	public function dispose ()
	{
		events.dispose();
		
		for (list in lists)
			list.dispose();
		
		lists.removeAll();
		lists	= null;
		events	= null;
	}
	
	
	
	//
	// ILISTCOLLECTION METHODS
	//
	
	public function addList (list)
	{
		if (lists.length != 0) {
			var lastList = lists.getItemAt(lists.length - 1);
			lastList.nextList = list;
		}
		
		list.max = maxPerList;
		lists.add(list);
		return list;
	}
	
	
	public function removeList (list)
	{
		var index = lists.indexOf(list);
		
		//check if list isn't the first list
		if (index > 0)
			lists.getItemAt(index - 1).nextList = list.nextList;
		
		lists.remove(list);
		list.dispose();
	}
	
	
	//
	// LIST MANIPULATION METHODS
	//
	
	public inline function add (item:DataType, pos:Int = -1) : DataType
	{
		pos = insertAt( item, pos );
		events.added.send( item, pos );
		return item;
	}
	
	
	public inline function remove (item:DataType) : DataType
	{
		removeItem(item);
		events.removed.send( item, removeItem(item) );
		return item;
	}
	
	
	public inline function move (item:DataType, newPos:Int, curPos:Int = -1) : DataType
	{
		if (curPos == -1)
			curPos = indexOf( item );
		
		if (newPos > (length - 1))
			newPos = length - 1;
		
		if (curPos != newPos)
		{
			removeItem( item );
			insertAt( item, newPos );
			
			events.moved.send( item, curPos, newPos );
		}
		
		return item;
	}
	
	
	public inline function has (item:DataType) : Bool
	{
		var found:Bool	= false;
		for (list in lists) {
			if (list.has(item)) {
				found = true;
				break;
			}
		}
		return found;
	}
	
	
	public inline function indexOf (item:DataType) : Int
	{
		var pos:Int = 0;
		for (list in lists) {
			var index:Int = list.indexOf(item);
			if (index >= 0) {
				pos += index;
				break;
			}
			pos += list.length;
		}
		
		return pos;
	}
	
	
	/**
	 * Method does the same thing as the add method, except that it won't fire
	 * an 'added' event.
	 * 
	 * @param	item
	 * @param	pos
	 * @return	position where the cell is inserted
	 */
	private inline function insertAt (item:DataType, pos:Int = -1) : Int
	{
		//1. create a new list if the current lastlist is filled
		if (lists.length == 0 || lists.getItemAt(lists.length - 1).length == maxPerList)
			addList( new ChainedList<DataType>() );
		
		if (pos < 0 || pos > length)
			pos = length;
		
		//2. find corrent list to add item in
		var targetList	= getListForPosition( pos );
		//3. find correct position to add item to
		var itemPos		= calculateItemPosition( pos );
		//4. add the item to the correct list
		targetList.add( item, itemPos );
		//5. update length value
		_length++;
		return pos;
	}
	
	
	/**
	 * Method does the same thing as the remove method, except that it won't fire
	 * an 'removed' event.
	 * 
	 * @param	item
	 * @return	last position of the item
	 */
	private function removeItem (item:DataType) : Int
	{
		var itemPos = 0;
		
		for (list in lists) {
			if (list.has(item)) {
				itemPos += list.indexOf(item);
				list.remove( item );
				_length--;
				break;
			}
			itemPos += list.length;
		}
		return itemPos;
	}
	
	
	
	//
	// ITERATION METHODS
	//
	
	public inline function getItemAt (pos:Int) : DataType
	{
		var itemPos:Int	= calculateItemPosition( pos );		//calculate the position of the item in the list
		return getListForPosition(pos).getItemAt(itemPos);
	}
	
	
	public function iterator () : Iterator <DataType>	{ return getTypedIterator(); }
	public inline function getTypedIterator ()			{ return new ChainedListCollectionIterator<DataType>(this); }
	
	
	private inline function getListForPosition (globalPos:Int) : ChainedList<DataType> {
		return lists.getItemAt(getListNumForPosition(globalPos));
	}
	
	private inline function calculateItemPosition (globalPos:Int) : Int {
		if (globalPos < 0)
			globalPos = length - globalPos;
		
		var pos:Int = 0;
		if (maxPerList > -1)
		{
			//lists have a fixed length so finding the position of an item is quite easy
			pos = (globalPos < maxPerList)
				? globalPos
				: Std.int( globalPos % maxPerList );
		}
		else
		{
			//lists have dynamic length so it will cost some loops to find out where in a list the item is
			var listNum:Int = 0;
			var len			= lists.length;
			pos				= globalPos;
			for (list in lists)
			{
				if (pos < list.length || ((listNum + 1) == len && pos == list.length))
					break;
				
				pos -= list.length;
				listNum++;
			}
		}
		return pos;
	}
	
	
	private inline function getListNumForPosition (globalPos:Int) : Int {
		//calculate the number of the list in which the item will be
		var listNum = 0;
		if (globalPos < 0)
			globalPos = length - globalPos;
		
		if (maxPerList > -1)
		{
			//lists have a fixed length so finding the list of an item is quite easy
			listNum = globalPos.divFloor( maxPerList );
		}
		else
		{
			//lists have dynamic length so it will cost some loops to find out in which list the item is
			var len:Int = lists.length;
			for (list in lists) {
				//check if the position is within this list or if this list is the last list 
				if (globalPos < list.length || ((listNum + 1) == len && globalPos == list.length))
					break;
				
				globalPos -= list.length;
				listNum++;
			}
		}
		
		return listNum;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setMaxPerList (v) {
		for (list in lists)
			list.max = v;
		
		return maxPerList = v;
	}
	
	
	private inline function getLength () {
		return _length;
	}
	
	
#if debug
	public var name : String;

	public function toString ()
	{
		var str = "";
		var j = 0;
		var i = 0;
		var rows = [];
		for (list in lists) {
			var items = [];
			for (item in list) {
				items.push( "[ " + i + " = " + item + " ]" );
				i++;
			}
			rows.push( "row" + j + " - " + items.join(" ") + " ( "+list.length+" )" );
			j++;
		}
		return "#\n"+rows.join("\n");
	}
#end
}




/**
 * Iterator for the ChainedListCollection.
 * 
 * @creation-date	Jun 30, 2010
 * @author			Ruben Weijers
 */
class ChainedListCollectionIterator <DataType> #if (flash9 || cpp) implements haxe.rtti.Generic #end
{
	private var target			(default, null)					: ChainedListCollection<DataType>;
	private var currentList 	(default, setCurrentList)		: ChainedList<DataType>;
	private var listIterator	: Iterator<DataType>;
	public var currentPos		: Int;
	
	
	public function new (target:ChainedListCollection<DataType>) 
	{
		this.target	= target;
		currentPos	= 0;
		currentList	= target.lists.getItemAt(0);
	}
	
	
	public inline function hasNext () : Bool
	{
		return currentPos < target.length;
	}
	
	
	public function next () : DataType
	{
		var nextItem:DataType = null;
		
		if (listIterator != null) {
			if (listIterator.hasNext())
				nextItem = listIterator.next();
			else {
				currentList = currentList.nextList;
				nextItem = next();
			}
		}
		
		currentPos++;
		return nextItem;
	}
	
	
	private inline function setCurrentList (v) {
		currentList = v;
		if (v != null)	listIterator = v.iterator();
		else			listIterator = null;
		return v;
	}
}