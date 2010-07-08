package primevc.utils;
import primevc.core.Number;
 

/**
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class IntUtil 
{
	/**
	 * Helper function which will return the int-value of the first parameter 
	 * as long as it is between the min and max values.
	 * 
	 * @param	value
	 * @param	min
	 * @param	max
	 */
	public static inline function within (value:Int, min:Int, max:Int) : Int {
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
	public static inline function isWithin (value:Int, min:Int, max:Int) : Bool {
		return value >= min && value <= max;
	}
	
	
	public static inline function notSet (value:Int) : Bool {
		return value == Number.NOT_SET;
	}
	
	
	public static inline function isSet (value:Int) : Bool {
		return value != Number.NOT_SET;
	}
}