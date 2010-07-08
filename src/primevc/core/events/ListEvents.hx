package primevc.core.events;
 import primevc.core.dispatcher.Signals;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.dispatcher.Signal2;
 import primevc.core.dispatcher.Signal3;
 

/**
 * Change events for a collection
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class ListEvents <DataType> extends Signals
{
	/**
	 * Signal which is dispatched when an item is added to the list.
	 * The event will contain the new item and the position on wich it is added.
	 */
	public var added	(default, null)		: Signal2 <DataType, Int>;
	/**
	 * Signal which is dispatched when an item is removed from the list. The 
	 * event will contain the removed item and the last position of the item.
	 */
	public var removed	(default, null)		: Signal2 <DataType, Int>;
	/**
	 * Signal which is dispatched when an item is moved to a different position.
	 * Event parameters:
	 * 		1. moved item
	 * 		2. old position
	 * 		3. new position
	 */
	public var moved	(default, null)		: Signal3 <DataType, Int, Int>;
	
	/**
	 * Signal which is dispatched when all of the items of the list have been 
	 * removed at once.
	 */
	public var reset	(default, null)		: Signal0;
	
	
	public function new ()
	{
		reset	= new Signal0();
		added	= new Signal2();
		removed	= new Signal2();
		moved	= new Signal3();
	}
}