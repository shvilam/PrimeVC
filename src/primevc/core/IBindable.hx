package primevc.core;
 import primevc.core.dispatcher.Signal1;

/**
 * Read/write interface for 'data-binding'.
 * 
 * @see Bindable
 * @author Danny Wilson
 * @creation-date Jun 25, 2010
 */
interface IBindable <DataType> implements IBindableReadonly<DataType>
//	#if (flash9 || cpp) ,implements haxe.rtti.Generic #end
{
	/**
	 * Value property with write access.
	 */
	public var value	(default, setValue)	: DataType;
	
	/**
	 * Makes sure this value is (and remains) equal
	 * to otherBindable.value
	 *	
	 * In other words: 
	 * - update this.value when otherBindable changes
	 */
	public function bind( otherBindable:IBindableReadonly<DataType> ) : Void;
	
	/**
	 * Internal function which tells this IBindable, another bindable is writing to it.
	 */
	private function registerBoundTo( otherBindable:IBindableReadonly<DataType> ) : Void;
}