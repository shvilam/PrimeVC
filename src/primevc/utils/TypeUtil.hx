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
  using Type;


extern class TypeUtil
{
	/**
	 * Optimized simple instanceof check. Compiles to bytecode or Useful to quickly check if an object implements some interface.
	 *  
	 * Warning: Use Std.is() for checking enums and stuff.
	 */
	static public inline function is(o:Dynamic, t:Class<Dynamic>) : Bool
	{
		#if flash9
			return untyped __is__(o, t);
		#elseif flash
			return untyped __instanceof__(o, t);
		#elseif js {
			var __o = o, __t = t;
			return untyped __js__("__o instanceof __t");
		}
		#else
			return Std.is(o, t);
		#end
	}
	
	
	/**
	 * Optimized simple instanceof check. Compiles to bytecode or Useful to quickly cast an object.
	 */
	static public inline function as<T>(o:Dynamic, t:Class<T>) : T
	{
		return cast o;
	}
	
	
	static public inline function className (o:Dynamic) : String
	{
		return o == null ? null : o.getClass().getClassName();
	}
}


#if debug
class IDUtil
{
	private static var objCounter : Int = 0;
	
	public static inline function getReadableId (obj:Dynamic) : String
	{
		return Type.getClass( obj ).getClassName().split(".").pop() + objCounter++;
	}
}	
#end


/**
 * @author	Ruben Weijers
 * @since	Dec 15, 2010
 */
extern class IntTypeUtil
{
	public static inline function int (v:Bool) : Int
	{
		return v ? 1 : 0;
	}
}



/**
 * @author	Ruben Weijers
 * @since	Dec 15, 2010
 */
extern class FloatTypeUtil
{
	public static inline function float (v:Bool) : Float
	{
		return v ? 1.0 : 0.0;
	}
}