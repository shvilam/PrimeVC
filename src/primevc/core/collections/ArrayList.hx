package primevc.core.collections;
 import primevc.core.events.ListEvents;
 import primevc.utils.FastArray;
  using primevc.utils.FastArray;
 

/**
 * Description
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class ArrayList <DataType> implements IList <DataType>
	#if (flash9 || cpp) ,implements haxe.rtti.Generic #end
{
	public var events		(default, null)		: ListEvents < DataType >;
	private var list		(default, null)		: FastArray < DataType >;
	public var length		(getLength, never)	: Int;
	
	
	public function new( ?wrapAroundList:FastArray < DataType > )
	{
		events = new ListEvents();
		if (wrapAroundList != null)
			list = wrapAroundList;
		else
			list = FastArrayUtil.create();
	}
	
	
	public inline function removeAll ()
	{
		while (list.length > 0)
			list.pop();
		
		events.reset.send();
	}
	
	
	public function dispose ()
	{
		removeAll();
		events.dispose();
		list	= null;
		events	= null;
	}
	
	
	private inline function getLength () {
		return list.length;
	}
	
	
	public function iterator () : Iterator <DataType> {
		return new FastArrayIterator<DataType>(list);
	}
	
	
	/**
	 * Returns the item at the given position. It is allowed to give negative values.
	 * The returned item will then be on position -> length - askedPosition
	 * 
	 * @param	pos
	 * @return
	 */
	public inline function getItemAt (pos:Int) : DataType {
		var i:UInt = pos < 0 ? length + pos : pos;
		return list[i];
	}
	
	
	public function add (item:DataType, pos:Int = -1) : DataType
	{
		pos = list.insertAt(item, pos);
		events.added.send( item, pos );
		return item;
	}
	
	
	public inline function remove (item:DataType) : DataType
	{
		var oldPos = list.indexOf(item);
		if (list.remove(item))
			events.removed.send( item, oldPos );
		return item;
	}
	
	
	public inline function move (item:DataType, newPos:Int, curPos:Int = -1) : DataType
	{
		if (curPos == -1)
			curPos = list.indexOf(item);
		
		if (curPos != newPos && list.move(item, newPos))
			events.moved.send( item, curPos, newPos );
		
		return item;
	}
	
	
	public inline function indexOf (item:DataType) : Int {
		return list.indexOf(item);
	}
	
	
	public inline function has (item:DataType) : Bool {
		return list.indexOf(item) >= 0;
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
		return "ArrayCollection ("+items.length+")\n" + items.join("\n");
	}
#end
}