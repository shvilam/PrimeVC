package primevc.core.collections;
 import primevc.core.events.ListEvents;
 import primevc.core.IDisposable;
 

/**
 * Description
 *
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
interface IList <DataType> implements IDisposable
{
	public var events		(default, null)									: ListEvents <DataType>;
	public var length		(getLength, never)								: Int;
	
	
	//
	// LIST MANIPULATION METHODS
	//
	
	/**
	 * Method will add the item on the given position. It will add the 
	 * item at the end of the childlist when the value is equal to -1.
	 * 
	 * @param	item
	 * @param	pos		default-value: -1
	 * @return	item
	 */
	public function add		(item:DataType, pos:Int = -1)						: DataType;
	/**
	 * Method will try to remove the given item from the childlist.
	 * 
	 * @param	item
	 * @return	item
	 */
	public function remove	(item:DataType)										: DataType;
	/**
	 * Method will change the depth of the given item.
	 * 
	 * @param	item
	 * @param	newPos
	 * @param	curPos	Optional parameter that can be used to speed up the 
	 * 					moving process since the list doesn't have to search 
	 * 					for the original location of the item.
	 * @return	item
	 */
	public function move	(item:DataType, newPos:Int, curPos:Int = -1)		: DataType;
	
	/**
	 * Method will check if the requested item is in this collection
	 * @param	item
	 * @return	true if the item is in the list, otherwise false
	 */
	public function has		(item:DataType)										: Bool;
	
	/**
	 * Method will return the index of the requested item or -1 of the item is 
	 * not in the list.
	 * @param	item
	 * @return	position of the requested item
	 */
	public function indexOf	(item:DataType)										: Int;
	
	
	//
	// ITERATION METHODS
	//
	
	public function getItemAt (pos:Int) : DataType;
	public function iterator () : Iterator <DataType>;
}