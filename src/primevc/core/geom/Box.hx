package primevc.core.geom;


/**
 * @since	mar 22, 2010
 * @author	Ruben Weijers
 */
class Box
{
	public var top		: Int;
	public var bottom	: Int;
	public var left		: Int;
	public var right	: Int;
	
	public function new ( top:Int = 0, right:Int = -100, bottom:Int = -100, left:Int = -100 )
	{
		this.top	= top;
		this.right	= (right == -100) ? this.top : right;
		this.bottom	= (bottom == -100) ? this.top : bottom;
		this.left	= (left == -100) ? this.right : left;
	}
	
	public function toString ()
	{
		return "t: " + top + "; r: " + right + "; b: " + bottom + "; l: " + left + ";";
	}
}