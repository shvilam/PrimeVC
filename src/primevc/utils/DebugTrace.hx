package primevc.utils;



/**
 * Helper functions for the monster-debugger and the alcon-debugger
 * 
 * @see http://blog.hexagonstar.com/downloads/alcon/
 * @see http://www.monsterdebugger.com/
 * 
 * @author Ruben Weijers
 * @creation-date Nov 15, 2010
 */
class DebugTrace
{
#if (flash9 && debug)
	private static inline function getClassName (infos : haxe.PosInfos) : String
	{
		return infos.className.split(".").pop(); //infos.fileName;
	}


	private static inline function getTraceColor (name:String) : Int
	{
		var length	= name.length - 5; // remove .hx
		return name.charCodeAt(0) * name.charCodeAt( length >> 1 ) * name.charCodeAt( length - 1 );
	}
	
	#if MonsterTrace
	
		public static function trace (v : Dynamic, ?infos : haxe.PosInfos)
		{
			var name	= getClassName( infos );
			var color	= getTraceColor( name );
			nl.demonsters.debugger.MonsterDebugger.trace(name +':' + infos.lineNumber +'\t -> ' + infos.methodName, v, color);
		}
		
	#elseif AlconTrace
	
		public static function trace (v : Dynamic, ?infos : haxe.PosInfos)
		{
			var name = getClassName( infos );
			com.hexagonstar.util.debug.Debug.trace(name +':' + infos.lineNumber +'\t -> ' + infos.methodName + "\t" + v);
		}
		
	#end
#end
}