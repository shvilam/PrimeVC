package primevc.core;

class ListNode <T> implements haxe.rtti.Generic
{
	/** Access helper for friend classes */
	static public inline function next<T>(b:ListNode<T>) { return b.n; }
	
	/** Pointer to the next ListNode object **/
	private var n : T;
}