package primevc.utils;
 

/**
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class FloatUtil 
{
	/**
	 * Helper function which will return the float-value of the first parameter 
	 * as long as it is between the min and max values.
	 * 
	 * @param	value
	 * @param	min
	 * @param	max
	 */
	public static inline function within (value:Float, min:Float, max:Float) : Float {
		if (value < min)		value = min;
		else if (value > max)	value = max;
		return value;
	}
	
	
	/**
	 * Helper function to check of the given value is between the min and max 
	 * value.
	 * 
	 * @param	value
	 * @param	min
	 * @param	max
	 * @return	true or false
	 */
	public static inline function isWithin (value:Float, min:Float, max:Float) : Bool {
		return value >= min && value <= max;
	}
}