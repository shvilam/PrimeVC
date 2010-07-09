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
 * A chained list is a ListCollection with a maximum number of elements.
 * 
 * If an item is added to the list while the max amount of elements is reached
 * it will automaticly move it's last child to the next chained-list.
 * 
 * If an item is removed from the list it will try to add the first element of
 * the next chained-list at the end of his list.
 * 
 * @creation-date	Jun 30, 2010
 * @author			Ruben Weijers
 */
class ChainedList <DataType> extends SimpleList <DataType> #if (flash9 || cpp) ,implements haxe.rtti.Generic #end
{
	public var nextList							: ChainedList < DataType >;
	/**
	 * Maximum number of items. If there are more items, they will be moved to
	 * the next list
	 */
	public var max			(default, setMax)	: Int;
	
	
	public function new( max:Int = -1 )
	{
		super();
		this.max = max;
	}
	
	
	override public function add (item:DataType, pos:Int = -1) : DataType
	{
		if (length < max || max == -1)
		{
			return super.add( item, pos );
		}
		else
		{
			//create next list if it doesn't exist yet
			if (nextList == null)
				nextList = new ChainedList<DataType>(max);
			
			nextList.add(last.data, 0);		//1. add our last item to the beginning of the next list
			super.remove(last.data);		//2. remove the last item
			super.add(item, pos);			//3. add the new item to this list
			return item;
		}
	}
	
	
	override public function remove (item:DataType) : DataType
	{
		super.remove(item);
		
		if (nextList != null && nextList.length > 0)
		{
			//it's not the last chained list, so we have to move the first item of the next list into this list
			var newLast = nextList.remove( nextList.first.data );	//1. remove fist item from next list
			super.add( newLast, -1 );								//2. add first item of the next list at the end of this list
		}
		return item;
	}
	
	
	
	private function setMax (v) : Int
	{
		if (max == 0)
			max = v;
		
		if (max != v)
		{
			var oldMax = max;
			max = v;
			
			if (oldMax > max && length > max)
			{
				//move items from this list to the next list
				if (nextList == null)
					nextList = new ChainedList<DataType>(max);
				
				var removedCell = getCellAt(max);
				var posCounter	= 0;
				
				while (removedCell != null)
				{
					nextList.add( removedCell.data, posCounter );
					removedCell = removedCell.next;
					posCounter++;
				}
			}
			else if (oldMax < max && nextList != null && nextList.length > 0)
			{
				//move items from the next list to this list
				for ( i in max...oldMax ) {
					var itemToAdd = nextList.getItemAt(0);
					nextList.remove( itemToAdd );
					add( itemToAdd );
				}
			}
		}
		return v;
	}
	
	
#if debug
	public function toString()
	{
		var items = [];
		var i = 0;
		for (item in this) {
			items.push( "[ " + i + " ] = " + item ); // Type.getClassName(Type.getClass(item)));
			i++;
		}
		return "ChainedList("+items.length+")\n" + items.join("\n");
	}
#end
}