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
 import primevc.core.collections.IEditableList;
 

/**
 * @creation-date	Jul 1, 2010
 * @author			Ruben Weijers
 */
class BalancingList <DataType> extends SimpleList <DataType>
	#if (flash9 || cpp) ,implements haxe.rtti.Generic #end
{
	public var nextList : BalancingList<DataType>;
	public var listNum	: Int;
	public var maxLists	: Int;
	
	
	override public function dispose ()
	{
		nextList = null;
		super.dispose();
	}
	
	
	override public function add (item:DataType, pos:Int = -1) : DataType
	{
		if (nextList != null && pos < length)
		{
			//if this list is the last list, raise the depth with one since the nextlist is gonna be the first list
			var nextListPos = pos;
			if (listNum == maxLists)
				nextListPos++;
			
			//move the item who is currently at the position 'pos' to the next list
			var curCell = getCellAt(pos);
			nextList.add(curCell.data, nextListPos);
			change.send( ListChange.removed( curCell.data, pos ) );
			
			//set the item in the current cell
			curCell.data = item;
			change.send( ListChange.added( item, pos ) );
			return item;
		}
		else
		{
			return super.add(item, pos);
		}
	}
	
	
	override public function remove (item:DataType, oldDepth:Int = -1) : DataType
	{
		if (oldDepth == -1)
			oldDepth	= indexOf(item);
		
		var nextDepth	= (listNum == maxLists) ? oldDepth + 1 : oldDepth;
		
		if (nextList != null && nextDepth < nextList.length)
		{
			var cell	= getCellAt(oldDepth);
			//move the item at this depth from the nextlist to this list if the removed item isn't the last item.
			//1. get the next item from the next list
			var newCell = nextList.getCellAt(nextDepth);
			var newData = newCell.data;
			//2. remove the item from the next list
			nextList.remove(newData);
			change.send( ListChange.removed( cell.data, oldDepth ) );
			
			//3. add the item to this list without moving the next list
			cell.data = newData;
			change.send( ListChange.added( cell.data, oldDepth ) );
			
			return item;
		}
		else
		{
			return super.remove(item);
		}
	}
	
	
	public inline function swapAtDepth (newItem:DataType, toDepth:Int)
	{
		var curCell		= getCellAt(toDepth);
		var oldData		= curCell.data;
		curCell.data	= newItem;
		
		change.send( ListChange.added( newItem, toDepth ) );
		change.send( ListChange.removed( oldData, toDepth ) );
		
		return oldData;
	}
	
	
#if debug
	override public function toString()
	{
		var items = [];
		var i = 0;
		for (item in this) {
			items.push( "[ " + i + " ] = " + item ); // Type.getClassName(Type.getClass(item)));
			i++;
		}
		return name + "BalancingList" + listNum + " ("+items.length+")\n" + items.join("\n");
	}
#end
}