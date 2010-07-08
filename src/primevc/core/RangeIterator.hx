package primevc.core;
 

/**
 * Iterator object
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class RangeIterator 
{
	public var start	(default, setStart) : Int;
	public var max		: Int;
	public var stepSize	: Int;
	public var current	: Int;
	
	
	public function new(max:Int, stepSize:Int = 1, start:Int = 0) 
	{
		if (max == 0)
			max = Number.INT_MAX;
		
		set(max, stepSize, start);
	}
	
	
	public inline function set (max:Int, stepSize:Int = 1, start:Int = 0) {
		this.max		= max;
		this.stepSize	= stepSize;
		this.start		= start;
	}
	
	
	public inline function hasNext () : Bool {
		return current < max;
	}
	
	
	public inline function next () {
		var c = current;
		current = current + stepSize;
		if (current > max)
			current = max;
		return c;
	}
	
	
	private inline function setStart (v) {
		return start = current = v;
	}
	
	
#if debug
	public function toString () {
		return "iterating from " + start + " to " + max + " with steps of " + stepSize;
	}
#end
}