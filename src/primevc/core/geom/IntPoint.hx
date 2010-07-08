package primevc.core.geom;
 

/**
 * Simple point class
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class IntPoint
{
	public var x (getX, setX)	: Int;
	public var y (getY, setY)	: Int;
	
	
	public function new(x = 0, y = 0)
	{
		this.x = x;
		this.y = y;
	}
	
	
	private function getX()		{ return x; }
	private function setX(v)	{ return x = v; }
	private function getY()		{ return y; }
	private function setY(v)	{ return y = v; }
}