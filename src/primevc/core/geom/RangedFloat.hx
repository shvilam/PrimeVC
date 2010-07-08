package primevc.core.geom;
 import primevc.core.Number;
  using primevc.utils.FloatUtil;
 

/**
 * Float value with a min and max value
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class RangedFloat //< NumberType:Float > implements haxe.rtti.Generic
{
	public var value	(default, setValue)		: Float;
	public var min		(default, setMin)		: Float;
	public var max		(default, setMax)		: Float;
	
	
	public function new( value, min = Number.FLOAT_MIN, max = Number.FLOAT_MAX ) 
	{
		this.min	= min;
		this.max	= max;
		this.value	= value;
	}
	
	
	private inline function setValue (v:Float) {
		return value = v.within( min, max );
	}
	
	
	private inline function setMin (v:Float) {
		Assert.that( Math.isNaN(min) || v < min, "v: "+v+"; min: "+min );
		if (v != min)
		{
			min = v;
			if (value < min)
				value = min;
		}
		return v;
	}
	
	
	private inline function setMax (v:Float) {
		Assert.that( Math.isNaN(max) || v > max, "v: "+v+"; max: "+max );
		if (v == max)
		{
			max = v;
			if (value > max)
				value = max;
		}		
		return v;
	}
}