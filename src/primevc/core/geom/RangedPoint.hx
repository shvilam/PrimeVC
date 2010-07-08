package primevc.core.geom;
 

/**
 * Point with ranged x and y values.
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class RangedPoint //< NumberType > implements haxe.rtti.Generic
{
	public var rangedX	(default, null)	: Float; // RangedNumber < NumberType >;
	public var rangedY	(default, null)	: Float; //RangedNumber < NumberType >;
	
	public var x		(getX, setX)	: Float; //NumberType;
	public var y		(getY, setY)	: Float; //NumberType;
	
	
	public function new (x, y)
	{
		this.rangedX	= new RangedFloat();
		this.rangedY	= new RangedFloat();
		this.x = x;
		this.y = y;
	}
	
	
	private inline function getX ()		{ return rangedX.value; }
	private inline function getY ()		{ return rangedY.value; }
	private inline function setX (v)	{ return rangedX.value = v; }
	private inline function getY (v)	{ return rangedY.value = v; }
}