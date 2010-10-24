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
 using  primevc.utils.FastArray;
  using Std;

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
#elseif flash
		return untyped __new__(Array, size);
#elseif neko
		return untyped Array.new1(neko.NativeArray.alloc(size), size);
#end
	}
	
	
#if !flash10
	public static inline function indexOf<T> ( list:FastArray<T>, item:T, ?startPos:Int = 0 ) : Int
	{
		var pos:Int = -1;
		for (i in startPos...list.length) {
			if (list[i] == item) {
				pos = i;
				break;
			}
		}
		return pos;
	}
#end
	
	
	public static inline function insertAt<T>( list:FastArray<T>, item:T, pos:Int ) : Int
	{
		var newPos:Int = 0;
		if (pos < 0 || pos == list.length.int())
		{
			newPos = list.push( item ) - 1;
		}
		else
		{
			var len = list.length.int();
			if (pos > len)
				pos = len;
			
			//move all items in the list one place down
			var i = len;
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
		
		var len = list.length.int();
#if debug
		if ( newPos > len ) throw "Moving from " + curPos + " to position "+newPos+", but it is bigger then the list length ("+list.length+")..";
#end
		if (newPos > len)
			newPos = len;

		if (curPos < 0)				throw "Item is not part of list so cannot be moved";
		
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
		return removeAt(list, pos);
	}
	
	
	public static inline function removeAt < T > (list:FastArray<T>, pos:Int) : Bool {
		if (pos >= 0)
		{
			if		(pos == 0)						list.shift();
			else if	(pos == (list.length - 1))		list.pop();
			else									list.splice(pos, 1);
		}
		return pos >= 0;
	}
	
	
	public static inline function removeAll <T> (list:FastArray<T>) : Void {
		while (list.length > 0)
			list.pop();
	}
	
	
	public static inline function has<T>( list:FastArray<T>, item:T ) : Bool {
		return list.indexOf( item ) >= 0;
	}
	
	
#if debug
	public static inline function asString<T>( list:FastArray<T> )
	{
		var items:FastArray<String> = FastArrayUtil.create();
		var i = 0;
		for (item in list) {
			items.push( "[ " + i + " ] = " + item );
			i++;
		}
		return "FastArray ("+items.length+")\n" + items.join("\n");
	}
#end
	
/*	
	public static inline function insert<T> ( list:FastArray<T>, arg0:T, ?arg1:T, ?arg2:T, ?arg3:T, ?arg4:T, ?arg5:T, ?arg6:T, ?arg7:T, ?arg8:T, ?arg9:T, ?arg10:T, ?arg11:T )
	{
		list.push( arg0 );
		
		if (arg1 != null) {
			list.push(arg1);
			if (arg2 != null)
			{
				list.push(arg2);
				if (arg3 != null)
				{
					list.push(arg3);
					if (arg4 != null)
					{
						list.push(arg4);
						if (arg5 != null)
						{
							list.push(arg5);
							if (arg6 != null)
							{
								list.push(arg6);
								if (arg7 != null)
								{
									list.push(arg7);
									if (arg8 != null)
									{
										list.push(arg8);
										if (arg9 != null)
										{
											list.push(arg9);
											if (arg10 != null)
											{
												list.push(arg10);
												if (arg11 != null)
													list.push(arg11);
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	*/
}