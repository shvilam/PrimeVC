package primevc.core.geom.constraints;
import primevc.core.Number;
 

/**
 * Description
 * 
 * @creation-date	Jun 19, 2010
 * @author			Ruben Weijers
 */
class SizeConstraint //implements IConstraint <Dynamic>
{
	public var width (default, null)	: IntConstraint;
	public var height (default, null)	: IntConstraint;
	
	
	public function new(minW = Number.INT_MIN, maxW = Number.INT_MAX, minH = Number.INT_MIN, maxH = Number.INT_MAX) 
	{
		width	= new IntConstraint(minW, maxW);
		height	= new IntConstraint(minH, maxH);
	}
}