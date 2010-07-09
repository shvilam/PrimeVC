package primevc.gui.layout.algorithms;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.IDisposable;
 import primevc.gui.layout.ILayoutGroup;
 import primevc.gui.layout.LayoutClient;


/**
 * @since	mar 20, 2010
 * @author	Ruben Weijers
 */
interface ILayoutAlgorithm implements IDisposable
{
	/**
	 * Signal that will be dispatched when properties of the algorithm have 
	 * been changed and the layout needs to be validated again.
	 */
	public var algorithmChanged (default, null)				: Signal0;
	public var group			(default, setGroup)			: ILayoutGroup<LayoutClient>;
	
	
	/**
	 * The maximum width of each child. Their orignal width will be ignored if
	 * the child is bigger then this number (it won't get resized).
	 * 
	 * @default		Number.NOT_SET
	 */
	public var childWidth		(default, setChildWidth)	: Int;
	/**
	 * The maximum height of each child. Their orignal height will be ignored if
	 * the child is heigher then this number (it won't get resized).
	 * 
	 * @default		Number.NOT_SET
	 */
	public var childHeight		(default, setChildHeight)	: Int;
	
	
	
	/**
	 * Method indicating if the size is invalidated or not.
	 */
	public function isInvalid (changes:Int)					: Bool;
	/**
	 * Method will measure the given target according to the algorithms
	 * rules. The result of the measuring should be put in 
	 * 		Layoutgroup.MeasuredWidth
	 * 		Layoutgroup.MeasuredHeight
	 */
	public function measure ()								: Void;
	
	public function measureHorizontal ()					: Void;
	public function measureVertical ()					 	: Void;
	
	/**
	 * Method will apply it's layout algorithm on the given target.
	 */
	public function apply ()								: Void;
}