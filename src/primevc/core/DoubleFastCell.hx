package primevc.core;
 

/**
 * FastCell with a back- and forward reference.
 * 
 * @creation-date	Jul 1, 2010
 * @author			Ruben Weijers
 */
class DoubleFastCell <T> #if (flash9 || cpp) implements haxe.rtti.Generic #end
{
	public var data : T;
	public var prev : DoubleFastCell<T>;
	public var next : DoubleFastCell<T>;
	
	public function new (data, prev, ?next) {
		this.data = data;
		this.prev = prev;
		this.next = next;
	}
	
	
//	public function toString () { return data; }
	
}