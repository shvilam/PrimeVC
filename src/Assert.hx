#if flash9
import flash.Error;
#end

class Assert
{
	static inline public function abstract(?pos:haxe.PosInfos)
	{
		#if debug
		throw #if flash9 new Error( #end
			"Abstract method: "+ pos.className + "::" + pos.methodName +"() not overridden"
			#if flash9 ) #end ;
		#end
	}
	
	
	static inline public function that(expr:Bool, msg:String = "", ?pos:haxe.PosInfos)
	{
		#if debug
		if (!expr) throw #if flash9 new Error( #end
			"Assertion failed: " + msg + " in " + pos.className + "::" + pos.methodName + " @ " + pos.fileName + ":" + pos.lineNumber
			#if flash9 ) #end ;
		#end
	}
	
	
	static inline public function notThat(expr:Bool, msg:String = "", ?pos:haxe.PosInfos)
	{
		#if debug
		if (expr) throw #if flash9 new Error( #end
			"Assertion failed: " + msg + " in " + pos.className + "::" + pos.methodName + " @ " + pos.fileName + ":" + pos.lineNumber
			#if flash9 ) #end ;
		#end
	}
	
	
	static inline public function equal( var1:Dynamic, var2:Dynamic, msg:String = "", ?pos:haxe.PosInfos)
	{
		#if debug
		if (var1 != var2) {
			trace(pos.className + "::" + pos.lineNumber+": "+var1+" should be "+var2);
			throw #if flash9 new Error( #end
			"Assertion failed: " + var1 + " != " + var2+"; msg: " + msg + " in " + pos.className + "::" + pos.methodName + " @ " + pos.fileName + ":" + pos.lineNumber
			#if flash9 ) #end;
		}
		else
			trace(pos.className + "::" + pos.lineNumber+": "+var1+" == "+var2);
		#end
	}
	
	
	static inline public function notEqual( var1:Dynamic, var2:Dynamic, msg:String = "", ?pos:haxe.PosInfos)
	{
		#if debug
		if (var1 == var2) {
			trace(pos.className + "::" + pos.lineNumber+": "+var1+" should not be "+var2);
			throw #if flash9 new Error( #end
			"Assertion failed: " + var1 + " == " + var2+"; msg: " + msg + " in " + pos.className + "::" + pos.methodName + " @ " + pos.fileName + ":" + pos.lineNumber
			#if flash9 ) #end;
		}
		else
			trace(pos.className + "::" + pos.lineNumber+": "+var1+" != "+var2);
		#end
	}
}