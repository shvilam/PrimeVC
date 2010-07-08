package primevc.core.collections;
 import primevc.utils.FastArray;


/**
 * Description
 * 
 * @creation-date	Jul 1, 2010
 * @author			Ruben Weijers
 */
class FastArrayIterator <DataType> 
	#if (flash9 || cpp) implements haxe.rtti.Generic #end
{
	private var list (default, null)	: FastArray<DataType>;
	public var current 					: UInt;
	
	
	public function new (list:FastArray<DataType>) {
		this.list = list;
	}
	
	
	public function rewind () { current = 0; }
	public function forward () { current = list.length; }
	
	
	public inline function hasNext () { return current < list.length; }
	public inline function hasPrev () { return current > 0; }
	
	
	public inline function next () { return list[current++]; }
	public inline function prev () { return list[current--]; }
}