package primevc.gui.layout;
 

/**
 * Every class that wants to make use of the layout-framework should
 * implement this interface. It doesn't matter if this is a display-object
 * or a graphical object.
 *
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
interface ILayoutOwner 
{
	public var width	: Float;
	public var height	: Float;
	public var x		: Float;
	public var y		: Float;
	
	/**
	 * Method to notifiy the layout-owner that properties of the layout are
	 * changed. This way the owner can update it's graphics.
	 */
//	public function invalidateDisplay();
}