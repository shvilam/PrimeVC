/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 *
 * Authors:
 *  Danny Wilson	<danny @ onlinetouch.nl>
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.utils;
 

/**
 * Helper class for working with bit flags
 * 
 * @creation-date	Jun 15, 2010
 * @author			Ruben Weijers
 */
extern class BitUtil 
{
	/**
	 * Checks if any of the bits in 'flag' are set.
	 */
	public static inline function has (bits:UInt, flag:UInt) : Bool
	{
		return (bits & flag) != 0;
	}
	
	
	/**
	 * Checks if all of the bits in 'flags' are set.
	 */
	public static inline function hasAll (bits:UInt, flags:Int) : Bool
	{
		return (bits & flags) == flags;
	}
	
	
	/**
	 * Checks if none of the bits in 'flag' are set.
	 */
	public static inline function hasNone (bits:UInt, flag:UInt) : Bool
	{
		return (bits & flag) == 0;
	}
	
	/**
	 * Returns an UInt with the bits set in 'flag' added to 'bits'.
	 */
	public static inline function set (bits:UInt, flag:UInt) : UInt
	{
#if neko
		Assert.that(bits != null);
		Assert.that(flag != null);
#end
		return bits |= flag;
	}
	
	/**
	 * Returns an UInt with the bits set in 'flag' removed from 'bits'.
	 */
	public static inline function unset (bits:UInt, flag:UInt) : UInt
	{
		//is faster and better predictable than the commented code since there's one if statement less (6 ms faster on 7.000.000 iterations)
		return bits &= 0xffffffff ^ flag; // has(bits, flag) ? bits ^= flag : bits;
		//or what about (bits & -flag)
	}
	
	
	/**
	 * Returns an UInt where only the bits that both parameters share are set. (AND operator..)
	 */
	public static inline function filter (bits:UInt, allowedBits:UInt) : UInt
	{
		return bits & allowedBits;
	}
	
	
	/**
	 * method will return bits with the flags in bitsToFlip flipped
	 * If one the bits is set it will be unset, if one of the bits isn't set
	 * it will be set.
	 */
	public static inline function flip (bits:UInt, bitsToFlip:UInt) : UInt
	{
		return bits ^ bitsToFlip;
	}
	
	
	/**
	 * Method will change all 1's to 0's and 0's to 1's
	 */
	public static inline function invert (bits:UInt) : UInt
	{
		return bits ^ 0xffffffff;
	}
}