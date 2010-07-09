package primevc.core.geom.constraints;
 import primevc.core.IDisposable;
 import primevc.core.Number;
 

/**
 * Description
 * 
 * @creation-date	Jun 19, 2010
 * @author			Ruben Weijers
 */
class SizeConstraint implements IDisposable //implements IConstraint <Dynamic>
{
	public var width (default, null)	: IntConstraint;
	public var height (default, null)	: IntConstraint;
	
	
	public function new(minW = Number.INT_MIN, maxW = Number.INT_MAX, minH = Number.INT_MIN, maxH = Number.INT_MAX) 
	{
		width	= new IntConstraint(minW, maxW);
		height	= new IntConstraint(minH, maxH);
	}
	
	
	public function reset ()
	{
		width.min = Number.INT_MIN;
		width.max = Number.INT_MAX;
		height.min = Number.INT_MIN;
		height.max = Number.INT_MAX;
	}
	
	
	public function dispose ()
	{
		if (width == null)
			return;
		
		width.dispose();
		height.dispose();
		width = null;
		height = null;
	}
}