package primevc.core;
 import primevc.core.dispatcher.Signal1;

/**
 * Read-only interface for 'data-binding'.
 * 
 * @see Bindable
 * @author Danny Wilson
 * @creation-date Jun 25, 2010
 */
interface IBindableReadonly <DataType>
//	#if (flash9 || cpp) ,implements haxe.rtti.Generic #end
{
	/** 
	 * Dispatched just before "value" is set to a new value.
	 * Signal argument: The new value.
	 */
	public var change	(default, null)	: Signal1<DataType>;
	public var value	(default, null)	: DataType;
	
	/**
	 * Remove any connections between this IChangeNotifier and 'otherBindable'
	 * 
	 * @return true when a connection was removed
	 */
	public function unbind( otherBindable:IBindableReadonly<DataType> ) : Bool;
	
	/**
	 * Makes sure otherBindable.value is (and remains) equal
	 * to this.value
	 *
	 * In other words:
	 * - sets otherBindable.value to this.value
	 * - updates otherBindable.value when this.value changes
	 */
	private function keepUpdated( otherBindable:IBindable<DataType> ) : Void;
}
