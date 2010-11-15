package primevc.utils;



/**
 * Helper functions for the monster-debugger
 * 
 * @author Ruben Weijers
 * @creation-date Nov 15, 2010
 */
class MonsterTrace
{
#if (flash9 && debug && MonsterTrace)
	private static inline function getClassName (infos : haxe.PosInfos) : String
	{
		return infos.className.split(".").pop(); //infos.fileName;
	}


	private static inline function getTraceColor (name:String) : Int
	{
		var length	= name.length; // - 3; // remove .hx
		return name.charCodeAt(0) * name.charCodeAt( length >> 1 ) * name.charCodeAt( length - 1 );
	}
	

	public static function trace (v : Dynamic, ?infos : haxe.PosInfos)
	{
		var name	= getClassName( infos );
		var color	= getTraceColor( name );
		nl.demonsters.debugger.MonsterDebugger.trace(name +':' + infos.lineNumber +'\t -> ' + infos.methodName, v, color);
	}
#end
}