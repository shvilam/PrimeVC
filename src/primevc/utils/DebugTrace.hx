package primevc.utils;
#if (AlconTrace && debug)
  using primevc.utils.NumberMath;
#end


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
	
	
	#if MonsterTrace
		
		private static inline function getTraceColor (name:String) : Int
		{
			var length	= name.length - 5; // remove .hx
			return name.charCodeAt(0) * name.charCodeAt( length >> 1 ) * name.charCodeAt( length - 1 );
		}
		
		
		public static function trace (v : Dynamic, ?infos : haxe.PosInfos)
		{
			if (!Assert.tracesEnabled)
				return;
			
			var name	= getClassName( infos );
			var color	= getTraceColor( name );
			nl.demonsters.debugger.MonsterDebugger.trace(name +':' + infos.lineNumber +'\t -> ' + infos.methodName, v, color);
		}
		
	#elseif AlconTrace
		private static var Tracer = com.hexagonstar.util.debug.Debug;
		
		
		private static inline function getLevel (name:String) : Int
		{
		//	var length	= name.length - 5; // remove .hx
			//A = 65, Z = 90 ==> 90 - 65 = 25 / 5 (traceLevels in alcon) = 5
			return ((name.charCodeAt(0) - 65) / 5).roundFloat();
		}
		
		
		public static function trace (v : Dynamic, ?infos : haxe.PosInfos)
		{
			if (!Assert.tracesEnabled)
				return;
			
			var name = getClassName( infos );
			Tracer.trace(name +':' + infos.lineNumber +'\t -> ' + infos.methodName + "\t " + v, getLevel(name));
		}
		
	#end
#end
}