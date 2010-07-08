package primevc.utils;
 using primevc.utils.FastArray;

typedef FastArray<T> =
	#if flash10		flash.Vector<T>
	#else			Array<T>;
	#end


/**
 * Class provides some additional methods for a FastArray
 * 
 * @author			Ruben Weijers
 * @author			Danny Wilson
 */
class FastArrayUtil
{
	static public inline function create<T>(?size:Int = 0, ?fixed:Bool = false) : FastArray<T>
	{
#if flash10
		return new flash.Vector<T>(size, fixed);
#else
		return untyped __new__(Array, size);
#end
	}
	
	
	public static inline function insertAt<T>( list:FastArray<T>, item:T, pos:Int ) : Int
	{
		var newPos:Int = 0;
		if (pos < 0)
		{
			newPos = list.push( item ) - 1;
		}
		else
		{
			var len = list.length;
			if (pos > len)
				pos = len;
			
			//move all items in the list one place down
			for (i in (list.length + 1)...pos)
				list[i] = list[i - 1];
			
			list[pos] = item;
			newPos = pos;
		}
		return newPos;
	}
	
	
	public static inline function move<T>( list:FastArray<T>, item:T, newPos:Int ) : Bool
	{
		var curPos:Int = list.indexOf(item);
		
		if (newPos > list.length)		throw "Position is bigger then the list length";
		if (curPos < 0)					throw "Item is not part of list so cannot be moved";
			
		if (curPos != newPos)
		{
			if (curPos > newPos) {
				for (i in newPos...curPos)
					list[i] = list[i - 1];
				
				list[newPos] = item;
			} else {
				for (i in newPos...curPos)
					list[i] = list[i + 1];
				
				list[newPos] = item;
			}
		}
		return curPos != newPos;
	}
	
	
	public static inline function swap <T> (list:FastArray<T>, item1:T, item2:T ) : Void
	{
		if (!list.has(item1))		throw "item1 is not in list";
		if (!list.has(item2))		throw "item2 is not in list";
		
		var item1Pos:Int = list.indexOf( item1 );
		var item2Pos:Int = list.indexOf( item2 );
		list[ item1Pos ] = item2;
		list[ item2Pos ] = item1;
	}
	
	
	public static inline function remove < T > (list:FastArray<T>, item:T) : Bool {
		var pos = list.indexOf(item);
		if (pos >= 0) {
			list.splice(pos, 1);
		}
		return pos >= 0;
	}
	
	
	public static inline function has<T>( list:FastArray<T>, item:T ) : Bool {
		return list.indexOf( item ) >= 0;
	}
}