package primevc.core.collections;
// import primevc.utils.FastArray;
 

/**
 * Interface for collections containing other collections.
 *
 * @creation-date	Jul 1, 2010
 * @author			Ruben Weijers
 */
interface IListCollection <DataType, ListType:IList<DataType>> implements IList <DataType>
//	#if (flash9 || cpp) ,implements haxe.rtti.Generic #end
{
	public var lists		(default, null)		: ArrayList <ListType>;
	public function addList (list:ListType)		: ListType;
//	public function removeList (list:ListType)	: ListType;
}