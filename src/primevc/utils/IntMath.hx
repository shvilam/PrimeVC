package primevc.utils;
 

/**
 * Math class for integers.
 * 
 * @creation-date	Jun 25, 2010
 * @author			Ruben Weijers
 */
class IntMath 
{
	/**
	 * Returns the biggest integer of the two given integers
	 * @param	var1
	 * @param	var2
	 * @return	biggest integer
	 */
	public static inline function max (var1:Int, var2:Int) : Int 
	{
		return var1 > var2 ? var1 : var2;
	}
	
	
	/**
	 * Returns the smallest integer of the two given integers
	 * @param	var1
	 * @param	var2
	 * @return	smallest integer
	 */
	public static inline function min (var1:Int, var2:Int) : Int
	{
		return var1 < var2 ? var1 : var2;
	}
	
	
	/**
	 * Math function to divide var1 with var2 and returning an floored integer.
	 * 
	 * @param	var1	Integer to divide
	 * @param	var2	Integer to divide with
	 * @return	result of the floored division
	 */
	public static inline function divFloor (var1:Int, var2:Int) : Int
	{
		return Std.int(var1 / var2);
	}
	
	
	
	/**
	 * Math function to divide var1 with var2 and returning an ceiled integer.
	 * 
	 * @param	var1	Integer to divide
	 * @param	var2	Integer to divide with
	 * @return	result of the ceiled division
	 */
	public static inline function divCeil (var1:Int, var2:Int) : Int
	{
		var intResult	= IntMath.divFloor(var1, var2);
		var floatResult	= var1 / var2;
		return (floatResult - intResult) > 0 ? intResult + 1 : intResult;
	}
	
	
	
	/**
	 * Math function to divide var1 with var2 and returning an rounded integer.
	 * 
	 * @param	var1	Integer to divide
	 * @param	var2	Integer to divide with
	 * @return	result of the rounded division
	 */
	public static inline function divRound (var1:Int, var2:Int) : Int
	{
		var intResult	= IntMath.divFloor(var1, var2);
		var floatResult	= var1 / var2;
		return (floatResult - intResult) >= 0.5 ? intResult + 1 : intResult;
	}
}