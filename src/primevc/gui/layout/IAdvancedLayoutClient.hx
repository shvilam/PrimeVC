package primevc.gui.layout;
 

/**
 * Description
 *
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
interface IAdvancedLayoutClient implements ILayoutClient
{
	public var explicitWidth	(default, setExplicitWidth)		: Int;
	public var explicitHeight	(default, setExplicitHeight)	: Int;
	
	public var measuredWidth	(default, setMeasuredWidth) 	: Int;
	public var measuredHeight	(default, setMeasuredHeight)	: Int;
	
	public var scrollX			: Int;
	public var scrollY			: Int;
}