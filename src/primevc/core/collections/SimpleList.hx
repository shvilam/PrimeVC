package primevc.core.collections;
 import primevc.core.events.ListEvents;
 import primevc.core.DoubleFastCell;
  using primevc.utils.IntMath;
 

/**
 * IList implementation as FastList. When this list is iterated it will
 * start with the first added item instead of the last added item as with
 * FastList.
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class SimpleList <DataType> implements IList <DataType> 
	#if (flash9 || cpp) ,implements haxe.rtti.Generic #end
{
	public var events		(default, null)		: ListEvents < DataType >;
	
	private var _length		: Int;
	public var length		(getLength, never)	: Int;
	/**
	 * Pointer to the first added cell
	 */
	public var first		(default, null)		: DoubleFastCell < DataType >;
	/**
	 * Pointer to the last added cell
	 */
	public var last			(default, null)		: DoubleFastCell < DataType >;
	
	
	public function new()
	{
		events	= new ListEvents();
		_length	= 0;
	}
	
	
	public inline function removeAll ()
	{
		var current = first;
		var prev;
		
		while (current != null) {
			prev			= current;
			current 		= current.next;
			current.prev	= null;
			prev.next		= null;
		}
		
		first	= null;
		last	= null;
		_length	= 0;
		events.reset.send();
	}
	
	
	public function dispose ()
	{
		if (events == null)
			return;
		
		removeAll();
		events.dispose();
		events	= null;
	}
	
	
	private inline function getLength () {
		return _length;
	}
	
	
	public function iterator () : Iterator < DataType > {
		return new SimpleListIterator<DataType>(this);
	}
	
	
	/**
	 * Returns the item at the given position. It is allowed to give negative values.
	 * The returned item will then be on position -> length - askedPosition
	 * 
	 * @param	pos
	 * @return
	 */
	public function getItemAt (pos:Int) : DataType {
		return getCellAt(pos).data;
	}
	
	
	public function add (item:DataType, pos:Int = -1) : DataType
	{
		pos = insertAt( item, pos );
		events.added.send( item, pos );
		return item;
	}
	
	
	public function remove (item:DataType) : DataType
	{
		var itemPos = removeItem( item );
		events.removed.send( item, itemPos );
		return item;
	}
	
	
	public function move (item:DataType, newPos:Int, curPos:Int = -1) : DataType
	{
		if (curPos == -1)
			curPos = indexOf(item);
		
		if (curPos == newPos)
			return item;
		
		if (curPos < newPos) {
			insertAt( item, newPos );
			removeItem( item );
		} else {
			removeItem( item );
			insertAt( item, newPos );
		}
		
		events.moved.send( item, curPos, newPos );
		return item;
	}
	
	
	public function indexOf (item:DataType) : Int
	{
		var nextCell	= first;
		var index:Int	= -1;
		var current:Int	= 0;
		while (nextCell != null) {
			if (nextCell.data == item) {
				index = current;
				break;
			}
			
			nextCell = nextCell.next;
			current++;
		}
		return index;
	}
	
	
	public function has (item:DataType) : Bool
	{
		var found		= false;
		var nextCell	= first;
		while (nextCell != null) {
			if (nextCell.data == item) {
				found = true;
				break;
			}
			nextCell = nextCell.next;
		}
		return found;
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
		var cell = new DoubleFastCell<DataType>( item, null );
		if (pos < 0)
			pos = length;
		
		if (pos == 0)
		{
			//add at beginning of list
			if (first != null) {
				first.prev	= cell;
				cell.next	= first;
			}
			
			if (first == last)
				last = cell;
			
			first = cell;
		}
		else if (pos >= length)
		{
			//add at the end of the list
			last.next	= cell;
			cell.prev	= last;
			last		= cell;
			pos			= length;
		}
		else
		{
			//insert item in the middle
			cell.next			= getCellAt(pos);
			cell.prev			= cell.next.prev;
			
			if (cell.next != null)
				cell.next.prev	= cell;
			if (cell.prev != null)
				cell.prev.next	= cell;
		}
		
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
	private inline function removeItem (item:DataType) : Int
	{
		return removeCell( getCellFor(item) );
	}
	
	
	private function getCellAt (pos:Int) : DoubleFastCell<DataType>
	{
		var currentCell:DoubleFastCell<DataType> = first;
		pos = pos < 0 ? length + pos : pos;
		
		//find out if it's faster to loop forward or backwards through the list
		if (pos < length.divFloor(2))
		{
			//loop forward through list
			for ( i in 0...pos )
				if (currentCell != null)
					currentCell = currentCell.next;
		}
		else
		{
			//loop backwards through list
			currentCell = last;
			pos = length - pos - 1;
			
			for ( i in 0...pos )
				if (currentCell != null)
					currentCell = currentCell.prev;
		}
		
		return currentCell;
	}
	
	
	private inline function getCellFor (item:DataType) : DoubleFastCell<DataType>
	{
		var currentCell:DoubleFastCell<DataType> = first;
		while (currentCell != null) {
			if (currentCell.data == item)
				break;
			currentCell = currentCell.next;
		}
		
		return currentCell;
	}
	
	
	private inline function removeCell (cell:DoubleFastCell<DataType>) : Int
	{
		var itemPos = indexOf(cell.data);
		if (cell.prev != null)		cell.prev.next = cell.next;
		else						first = cell.next;
		
		if (cell.next != null)		cell.next.prev = cell.prev;
		else						last = cell.prev;
		
		cell.next = cell.prev = null;
		cell.data = null;
		_length--;
		return itemPos;
	}
}




/**
 * Iterate object for the SimpleList implementation
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class SimpleListIterator <DataType> #if (flash9 || cpp) implements haxe.rtti.Generic #end
{
	private var list (default, null)	: SimpleList<DataType>;
	public var current (default, null)	: DoubleFastCell<DataType>;
	
	
	public function new (list:SimpleList<DataType>) 
	{
		this.list	= list;
		rewind();
	}
	
	
	public function rewind ()	{ current = list.first; }
	public function forward ()	{ current = list.last; }
	
	
	public inline function hasNext () : Bool
	{
		return current != null;
	}
	
	
	public inline function hasPrev () : Bool
	{
		return current != null;
	}
	
	
	public inline function prev () : DataType
	{
		var c = current;
		current = current.prev;
		return c.data;
	}
	
	
	public inline function next () : DataType
	{
		var c = current;
	//	trace("simplelistitr.next "+current.data);
		current = current.next;
		return c.data;
	}
}