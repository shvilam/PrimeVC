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
 using primevc.utils.FastArray;

typedef FastArray<T> =
	#if flash10		flash.Vector<T>
	#else			Array<T>;
	#end


/**
 * Class provides some additional methods for a FastArray
 * 
 * @author			Ruben Weijers
 * @author			Danny Wilson
 */
class FastArrayUtil
{
	static public inline function create<T>(?size:Int = 0, ?fixed:Bool = false) : FastArray<T>
	{
#if flash10
		return new flash.Vector<T>(size, fixed);
#else
		return untyped __new__(Array, size);
#end
	}
	
	
	public static inline function insertAt<T>( list:FastArray<T>, item:T, pos:Int ) : Int
	{
		var newPos:Int = 0;
		if (pos < 0 || pos == Std.int(list.length))
		{
			newPos = list.push( item ) - 1;
		}
		else
		{
			var len = list.length;
			if (pos > len)
				pos = len;
			
			//move all items in the list one place down
			var i = list.length;
			while ( i > pos ) {
				list[i] = list[i - 1];
				i--;
			}
			
			list[pos] = item;
			newPos = pos;
		}
		return newPos;
	}
	
	
	public static inline function move<T>( list:FastArray<T>, item:T, newPos:Int, curPos:Int = -1 ) : Bool
	{
		if (curPos == -1)
			curPos = list.indexOf(item);
		
		if (newPos > list.length)		throw "Position is bigger then the list length";
		if (curPos < 0)					throw "Item is not part of list so cannot be moved";
		
		if (curPos != newPos)
		{
			if (curPos > newPos) {
				var i = curPos;
				while ( i > newPos ) {
					list[i] = list[i - 1];
					i--;
				}
				
				list[newPos] = item;
			} else {
				for (i in curPos...newPos)
					list[i] = list[i + 1];
				
				list[newPos] = item;
			}
		}
		return curPos != newPos;
	}
	
	
	public static inline function swap <T> (list:FastArray<T>, item1:T, item2:T ) : Void
	{
		if (!list.has(item1))		throw "item1 is not in list";
		if (!list.has(item2))		throw "item2 is not in list";
		
		var item1Pos:Int = list.indexOf( item1 );
		var item2Pos:Int = list.indexOf( item2 );
		list[ item1Pos ] = item2;
		list[ item2Pos ] = item1;
	}
	
	
	public static inline function remove < T > (list:FastArray<T>, item:T) : Bool {
		var pos = list.indexOf(item);
		if (pos >= 0) {
			list.splice(pos, 1);
		}
		return pos >= 0;
	}
	
	
	public static inline function has<T>( list:FastArray<T>, item:T ) : Bool {
		return list.indexOf( item ) >= 0;
	}
}