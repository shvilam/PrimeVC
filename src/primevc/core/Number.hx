package primevc.core;
 

/**
 * Defines the min and max values of integers
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class Number 
{
	//floats can actually be a lot bigger (64 bit) but this will work for now
	public static inline var FLOAT_MIN:Float	= -2147483647;
	public static inline var FLOAT_MAX:Float	=  2147483647;
	
	public static inline var INT_MIN:Int		= -2147483647;
	public static inline var INT_MAX:Int		=  2147483647;
	
	/**
	 * Value defining an undefined Int. Is needed since there's no value like
	 * Math.NaN for integers..
	 */
	public static inline var NOT_SET:Int		=  -2147483647;
}