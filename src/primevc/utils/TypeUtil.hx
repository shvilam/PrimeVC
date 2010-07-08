package primevc.utils;

class TypeUtil
{
	
	/**
	 * Optimized simple instanceof check. Compiles to bytecode or Useful to quickly check if an object implements some interface.
	 *  
	 * Warning: Use Std.is() for checking enums and stuff.
	 */
	static public inline function is(o:Dynamic, t:Class<Dynamic>)
	{
		return
		#if flash9
			untyped __is__(o, t)
		#elseif flash
			untyped __instanceof__(o, t)
		#elseif js {
			var __f = o, __t = t;
			__js__("__f instanceof __t")
		}
		#else
			Std.is(o, t)
		#end
		;
	}
	
	
	/**
	 * Optimized simple instanceof check. Compiles to bytecode or Useful to quickly cast an object.
	 */
	static public inline function as<T>(o:Dynamic, t:Class<T>) : T
	{
		return
		#if flash9
			untyped __as__(o, t)
		#else
			cast t
		#end
		;
	}
}