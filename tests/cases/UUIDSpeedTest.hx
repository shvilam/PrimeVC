package cases;
 import Benchmark;
  using Std;
  using StringTools;
  using String;


/**
 * 
 * @author Ruben Weijers
 * @creation-date Sep 14, 2010
 */
class UUIDSpeedTest
{
	public static function main ()
	{
		var bench = new Benchmark();
		
		var group = new Comparison( "UUID generating", 100000 );
		bench.add( group );
		group.add( new Test( UUID.createUUIDHex,		"hexadecimal generation") );
		group.add( new Test( UUID.createUUIDHex2,		"hexadecimal generation2") );
		group.add( new Test( UUID.createUUIDHex3,		"hexadecimal generation3") );
		group.add( new Test( UUID.createUUIDHex4,		"hexadecimal generation4") );
		group.add( new Test( UUID.createUUIDString,		"sting based generation") );
		
#if debug
		UUID.createUUIDHex();
		UUID.createUUIDHex2();
		UUID.createUUIDHex3();
		UUID.createUUIDHex4();
		UUID.createUUIDString();
#else
		bench.start();
#end
	}
}



/**
 * UUID format
 * xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
 * 
 * x = any hexadecimal character
 * y = 8,9,a,b
 */
class UUID
{
	public static function createUUIDString ()
	{
		var str = new StringBuf();
		
		//first 8 chars	(xxxxxxxx)
		for (i in 0...8)
			str.add( randomUUIDChar() );
		
		//next 4 chars (xxxx)
		str.add("-");
		for (i in 0...4)
			str.add( randomUUIDChar() );
		
		//next 4 chars (4xxx)
		str.add("-4");
		for (i in 0...3)
			str.add( randomUUIDChar() );
		
		//next 4 chars (yxxx)
		str.add("-");
		str.add( randomChar('89ab', 4) );
		for (i in 0...3)
			str.add( randomUUIDChar() );
		
		//next 12 chars (xxxxxxxxxxxx)
		str.add("-");
		for (i in 0...12)
			str.add( randomUUIDChar() );
		
#if debug	
		trace(str.toString());
#end
	}
	
	
	public static function createUUIDHex ()
	{
		var str = new StringBuf();
		
		//first 8 chars	(xxxxxxxx)
		for (i in 0...8)
			str.add( randomHexStr() );
		
		//next 4 chars (xxxx)
		str.add("-");
		for (i in 0...4)
			str.add( randomHexStr() );
		
		//next 4 chars (4xxx)
		str.add("-4");
		for (i in 0...3)
			str.add( randomHexStr() );
		
		//next 4 chars (yxxx)
		str.add("-");
		str.add( randomChar('89ab', 4) );
		for (i in 0...3)
			str.add( randomHexStr() );
		
		//next 12 chars (xxxxxxxxxxxx)
		str.add("-");
		for (i in 0...12)
			str.add( randomHexStr() );
		
#if debug	
		trace(str.toString());
#end
	}
	
	
	public static function createUUIDHex2 ()
	{
		var str = new StringBuf();
		
		//first 8 chars	(xxxxxxxx)
		str.add( randomHexStr(0xffffff) );
		str.add( randomHexStr(0xff) );
		
		//next 4 chars (xxxx)
		str.add("-");
		str.add( randomHexStr(0xffff) );
		
		//next 4 chars (4xxx)
		str.add("-4");
		str.add( randomHexStr(0xfff) );
		
		//next 4 chars (yxxx)
		str.add("-");
		str.add( randomChar('89ab', 4) );
		str.add( randomHexStr(0xfff) );
		
		//next 12 chars (xxxxxxxxxxxx)
		str.add("-");
		str.add( randomHexStr(0xffffff) );
		str.add( randomHexStr(0xffffff) );
		
#if debug	
		trace(str.toString());
#end
	}
	
	
	public static function createUUIDHex3 ()
	{
		var str = new StringBuf();
		
		//first 8 chars	(xxxxxxxx)
		str.add( randomHexStr(0xffff) + randomHexStr(0xffff) );
		
		//next 4 chars (xxxx)
		str.add( "-" + randomHexStr(0xffff) );
		
		//next 4 chars (4xxx)
		str.add( "-4" + randomHexStr(0xfff) );
		
		//next 4 chars (yxxx)
		str.add( "-" + randomChar('89ab', 4) + randomHexStr(0xfff) );
		
		//next 12 chars (xxxxxxxxxxxx)
		str.add( "-" + randomHexStr(0xffffff) + randomHexStr(0xffffff) );
		
#if debug	
		trace(str.toString());
#end
	}
	
	
	public static function createUUIDHex4 ()
	{
		var str = randomHexStr(0xffff) + randomHexStr(0xffff) + "-" + randomHexStr(0xffff) + "-4" + randomHexStr(0xfff) + "-" + randomChar('89ab', 4) + randomHexStr(0xfff) + "-" + randomHexStr(0xffffff) + randomHexStr(0xffffff);
#if debug	
		trace(str);
#end
	}
	
	
	private static inline function randomHexStr (val:UInt = 0xF) : String
	{
		return val.random().hex();
	}
	
	
	private static inline var HEXCHARS = "0123456789abcdef";
	
	private static inline function randomUUIDChar () : String
	{
		return randomChar( HEXCHARS, 16 );
	}
	
	private static inline function randomChar( str:String, length:Int ) : String
	{
		return str.charAt( Std.random(length) );
	}
}