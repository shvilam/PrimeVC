package primevc.utils;
#if (debug && flash10_1)
 import flash.display.DisplayObject;
 import flash.errors.Error;
 import flash.events.ErrorEvent;
 import flash.events.UncaughtErrorEvent;
#end
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


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
	public static inline function getClassName (infos : haxe.PosInfos) : String
	{
		return infos.className.split(".").pop(); //infos.fileName;
	}
	
	
	#if (Monster2Trace || Monster3Trace)
		
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
			
			if (infos.customParams != null)
				if (infos.customParams.length == 1)		v = infos.customParams[0];
				else									v = infos.customParams;
			else
				v = Std.string(v);
			
		#if Monster2Trace
			nl.demonsters.debugger.MonsterDebugger.trace(name +':' + infos.lineNumber +'\t -> ' + infos.methodName, v, color);
		#elseif Monster3Trace
			com.demonsters.debugger.MonsterDebugger.trace(name, v, Std.string(infos.lineNumber), infos.methodName, color, 4);
		#end
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
	
	
	#if flash10_1
		
		@:require(flash10_1) public static function traceUncaughtErrors (target:DisplayObject)
		{
			target.loaderInfo.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, handleUncaughtErrors, false, 0, true );
		}
		
		
		@:require(flash10_1) public static function handleUncaughtErrors (event:UncaughtErrorEvent) : Void
		{
			var error:Dynamic = event.error;
			
			if (error.is(ErrorEvent))
				error = error.error;
			
			if (error.is(Error))
			{
				var e = event.error.as(Error);
				trace("[ERROR] :: "+e.errorID+": "+e.message);
				trace(e.getStackTrace());
			}
			else
				trace("[Unkown ERROR] :: "+event.error);
		}
	#end
	
#end
}