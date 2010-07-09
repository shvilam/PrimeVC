package primevc.core.collections;
 

/**
 * Description
 * 
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
		if (pos < length)
		{
			//if this list is the last list, raise the depth with one since the nextlist is gonna be the first list
			if (listNum == maxLists)
				pos++;
			
			//move the item who is currently at the position 'pos' to the next list
			var curCell = getCellAt(pos);
			nextList.add(curCell.data, pos);
			events.removed.send( curCell.data, pos );
			
			//set the item in the current cell
			curCell.data = item;
			events.added.send( item, pos );
			return item;
		}
		else
		{		
			return super.add(item, pos);
		}
	}
	
	
	override public function remove (item:DataType) : DataType
	{
		var depth		= indexOf(item);
		var nextDepth	= listNum == maxLists ? depth + 1 : depth;
		
		if (nextDepth < nextList.length)
		{
			var cell		= getCellAt(depth);
			//move the item at this depth from the nextlist to this list if the removed item isn't the last item.
			//1. get the next item from the next list
			var newCell = nextList.getCellAt(nextDepth);
			var newData = newCell.data;
			//2. remove the item from the next list
			nextList.remove(newData);
			events.removed.send( cell.data, depth );
			
			//3. add the item to this list without moving the next list
			cell.data = newData;
			events.added.send( cell.data, depth );
			
			return item;
		}
		else
		{
			return super.remove(item);
		}
	}
	
	
	public function swapAtDepth (newItem:DataType, toDepth:Int)
	{
		var curCell		= getCellAt(toDepth);
		var oldData		= curCell.data;
		curCell.data	= newItem;
		
		events.added.send( newItem, toDepth );
		events.removed.send( oldData, toDepth );
		
		return oldData;
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
		return "BalancingList" + listNum + " ("+items.length+")\n" + items.join("\n");
	}
#end
}