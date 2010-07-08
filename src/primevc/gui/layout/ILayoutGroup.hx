package primevc.gui.layout;
 import primevc.core.collections.IList;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;


/**
 * @since	mar 19, 2010
 * @author	Ruben Weijers
 */
interface ILayoutGroup <ChildType:LayoutClient> implements ILayoutClient
{
	public var algorithm (default, setAlgorithm)				: ILayoutAlgorithm;
	/**
	 * Method that is called by a child of the layoutgroup to let the group
	 * know that the child is changed. The layoutgroup can than decide, based 
	 * on the used algorithm, if the group should be invalidated as well or
	 * if the change in the child is not important.
	 * 
	 * @param	change		integer containing the change flags of the child
	 * 			that is changed
	 * @return	true if the change invalidates the parent as well, otherwise 
	 * 			false
	 */
	public function childInvalidated (childChanges:Int)			: Bool;
	
	/**
	 * List with all the children of the group
	 */
	public var children	(default, null)							: IList<ChildType>;
}