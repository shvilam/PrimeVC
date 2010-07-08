package primevc.core.geom.constraints;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.Bindable;
 import primevc.core.Number;
 import primevc.utils.IntMath;
  using primevc.utils.IntUtil;


/**
 * This class can constraint the value of an int to the given min and max value.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class IntConstraint implements IConstraint<Int>
{
	public var change (default, null)	: Signal0;
	
	public var min	(default, setMin)	: Int;
	public var max	(default, setMax)	: Int;
	
	
	public function new( min = Number.INT_MIN, max = Number.INT_MAX )
	{
		change = new Signal0();
		this.min = min;
		this.max = max;
	}
	
	
	public function dispose () {
		change.dispose();
	}
	
	
	private inline function setMin (v) {
		if (v != min) {
			min = v;
			change.send();
		}
		return v;
	}
	
	private inline function setMax (v) {
		if (v != max) {
			max = v;
			change.send();
		}
		return v;
	}
	
	public inline function validate (v:Int) : Int {
		if (min.isSet() && max.isSet())
			v = v.within( min, max );
		else if (min.isSet())
			v = IntMath.max( v, min );
		else
			v = IntMath.min( v, max );
		
		return v;
	}
}