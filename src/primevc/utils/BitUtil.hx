package primevc.utils;
 

/**
 * Helper class for working with bit flags
 * 
 * @creation-date	Jun 15, 2010
 * @author			Ruben Weijers
 */
class BitUtil 
{
	/**
	 * Checks if any of the bits in 'flag' are set.
	 */
	public static inline function has (bits:Int, flag:Int) : Bool {
		return (bits & flag) != 0; // == flag
	}
	
	public static inline function hasNot (bits:Int, flag:Int) : Bool {
		return (bits & flag) == 0; // != flag
	}
	
	public static inline function set (bits:Int, flag:Int) : Int {
		return bits |= flag;
	}
	
	public static inline function unset (bits:Int, flag:Int) : Int {
		//is faster and better predictable than the commented code since there's one if statement less (6 ms faster on 7.000.000 iterations)
		return bits &= 0xffffffff ^ flag; // has(bits, flag) ? bits ^= flag : bits;
	}
}