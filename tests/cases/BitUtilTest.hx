package cases;
 import primevc.types.Number;
 import Benchmark;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;

/**
 * @creation-date	Jun 15, 2010
 * @author			Ruben Weijers
 */
class BitUtilTest 
{
	public static function main ()
	{
		//assertions
		var assertions = new UtilFlagAssertTest();
		
		//speed tests
		var test1 = new ManualFlagsSpeedTest();
		var test2 = new UtilFlagsSpeedTest();
		var test3 = new PropertyCompareSpeedTest();
		var bench = new Benchmark();
		
		var group = new Comparison( "setFlag", 1000000 );
		bench.add( group );
		group.add( new Test( test1.setFlag,				"manual") );
		group.add( new Test( test2.setFlag,				"util") );
		group.add( new Test( test3.checkEmptyString,	"is string empty") );
		group.add( new Test( test3.checkEmptyInt,		"is int empty") );
		group.add( new Test( test3.checkEmptyFloat,		"is float empty") );
		group.add( new Test( test3.checkEmptyFloat2,	"is float empty2") );
		group.add( new Test( test3.checkEmptyObject,	"is object empty") );
		group.add( new Test( test3.checkEmptyFlag,		"is flag not set") );
		
		group.add( new Test( test3.checkFilledString,	"is string filled") );
		group.add( new Test( test3.checkFilledInt,		"is int filled") );
		group.add( new Test( test3.checkFilledFloat,	"is float filled") );
		group.add( new Test( test3.checkFilledFloat2,	"is float filled2") );
		group.add( new Test( test3.checkFilledObject,	"is object filled") );
		group.add( new Test( test3.checkFilledFlag,		"is flag set") );
		
		group = new Comparison( "unsetFlag", 1000000 );
		bench.add( group );
		group.add( new Test( test1.unsetFlag,	"manual") );
		group.add( new Test( test1.unsetFlag2,	"manual2") );
		group.add( new Test( test2.unsetFlag,	"util") );
		
		bench.start();
	}
}


class Flags {
	public static inline var FLAG_1 : UInt	= 1;
	public static inline var FLAG_2 : UInt	= 2;
	public static inline var FLAG_3 : UInt	= 4;
	public static inline var FLAG_4 : UInt	= 8;
	public static inline var FLAG_5 : UInt	= 16;
}


class UtilFlagAssertTest
{
	public function new ()
	{
		var flags:Int = 0;
		trace( "flags: " + flags);
		Assert.that( !flags.has( Flags.FLAG_1 ) );
		Assert.that( !flags.has( Flags.FLAG_2 ) );
		Assert.that( !flags.has( Flags.FLAG_3 ) );
		Assert.that( !flags.has( Flags.FLAG_4 ) );
		Assert.that( !flags.has( Flags.FLAG_5 ) );
		
		flags = flags.set( Flags.FLAG_1 );
		trace( "flags: " + flags);
		Assert.that(  flags == 1 );
		Assert.that(  flags.has( Flags.FLAG_1 ) );
		Assert.that( !flags.has( Flags.FLAG_2 ) );
		Assert.that( !flags.has( Flags.FLAG_3 ) );
		Assert.that( !flags.has( Flags.FLAG_4 ) );
		Assert.that( !flags.has( Flags.FLAG_5 ) );
		
		flags = flags.set( Flags.FLAG_2 );
		trace( "flags: " + flags);
		Assert.that(  flags == 3 );
		Assert.that(  flags.has( Flags.FLAG_1 ) );
		Assert.that(  flags.has( Flags.FLAG_2 ) );
		Assert.that( !flags.has( Flags.FLAG_3 ) );
		Assert.that( !flags.has( Flags.FLAG_4 ) );
		Assert.that( !flags.has( Flags.FLAG_5 ) );
		
		flags = flags.unset( Flags.FLAG_2 );
		Assert.that(  flags == 1 );
		Assert.that(  flags.has( Flags.FLAG_1 ) );
		Assert.that( !flags.has( Flags.FLAG_2 ) );
		Assert.that( !flags.has( Flags.FLAG_3 ) );
		Assert.that( !flags.has( Flags.FLAG_4 ) );
		Assert.that( !flags.has( Flags.FLAG_5 ) );
		
		flags = flags.unset( Flags.FLAG_5 );
		trace( "flags: " + flags);
		Assert.that( flags == 1 );
		Assert.that(  flags.has( Flags.FLAG_1 ) );
		Assert.that( !flags.has( Flags.FLAG_2 ) );
		Assert.that( !flags.has( Flags.FLAG_3 ) );
		Assert.that( !flags.has( Flags.FLAG_4 ) );
		Assert.that( !flags.has( Flags.FLAG_5 ) );
		
		flags = flags.set( Flags.FLAG_5 );
		Assert.that(  flags == 17 );
		Assert.that(  flags.has( Flags.FLAG_1 ) );
		Assert.that( !flags.has( Flags.FLAG_2 ) );
		Assert.that( !flags.has( Flags.FLAG_3 ) );
		Assert.that( !flags.has( Flags.FLAG_4 ) );
		Assert.that(  flags.has( Flags.FLAG_5 ) );
		
		flags = flags.set( Flags.FLAG_4 );
		trace( "flags: " + flags);
		Assert.that( flags == 25 );
		Assert.that(  flags.has( Flags.FLAG_1 ) );
		Assert.that( !flags.has( Flags.FLAG_2 ) );
		Assert.that( !flags.has( Flags.FLAG_3 ) );
		Assert.that(  flags.has( Flags.FLAG_4 ) );
		Assert.that(  flags.has( Flags.FLAG_5 ) );
		
		flags = flags.set( Flags.FLAG_5 );
		Assert.that( flags == 25 );
		Assert.that(  flags.has( Flags.FLAG_1 ) );
		Assert.that( !flags.has( Flags.FLAG_2 ) );
		Assert.that( !flags.has( Flags.FLAG_3 ) );
		Assert.that(  flags.has( Flags.FLAG_4 ) );
		Assert.that(  flags.has( Flags.FLAG_5 ) );
		
		flags = flags.unset( Flags.FLAG_5 );
		trace( "flags: " + flags);
		Assert.that( flags == 9 );
		Assert.that(  flags.has( Flags.FLAG_1 ) );
		Assert.that( !flags.has( Flags.FLAG_2 ) );
		Assert.that( !flags.has( Flags.FLAG_3 ) );
		Assert.that(  flags.has( Flags.FLAG_4 ) );
		Assert.that( !flags.has( Flags.FLAG_5 ) );
		
		flags = flags.set( Flags.FLAG_2 | Flags.FLAG_3 );
		trace( "flags: " + flags);
		Assert.that( flags == 15 );
		Assert.that(  flags.has( Flags.FLAG_1 ) );
		Assert.that(  flags.has( Flags.FLAG_2 ) );
		Assert.that(  flags.has( Flags.FLAG_3 ) );
		Assert.that(  flags.has( Flags.FLAG_4 ) );
		Assert.that( !flags.has( Flags.FLAG_5 ) );
		
		trace("unset test");
		flags  = 31;
		flags &= 0xffffffff ^ Flags.FLAG_1;
		Assert.that( flags == 30 );
		flags &= 0xffffffff ^ Flags.FLAG_2;
		Assert.that( flags == 28 );
		flags &= 0xffffffff ^ Flags.FLAG_3;
		Assert.that( flags == 24 );
		flags &= 0xffffffff ^ Flags.FLAG_4;
		Assert.that( flags == 16 );
		flags &= 0xffffffff ^ Flags.FLAG_5;
		Assert.that( flags == 0 );
		
		flags = 15;
		flags &= 0xffffffff ^ Flags.FLAG_5;
		Assert.that( flags == 15 );
	}
}


class ManualFlagsSpeedTest
{
	public var flags : Int;
	
	public function new () {
		flags = 0;
	}
	
	public function setFlag () {
		flags |= Flags.FLAG_1;
		flags |= Flags.FLAG_2;
		flags |= Flags.FLAG_3;
		flags |= Flags.FLAG_4;
		flags |= Flags.FLAG_5;
	}
	
	public function unsetFlag () {
		flags = 31;
		if (hasFlag(Flags.FLAG_1))	flags ^= Flags.FLAG_1;
		if (hasFlag(Flags.FLAG_2))	flags ^= Flags.FLAG_2;
		if (hasFlag(Flags.FLAG_3))	flags ^= Flags.FLAG_3;
		if (hasFlag(Flags.FLAG_4))	flags ^= Flags.FLAG_4;
		if (hasFlag(Flags.FLAG_5))	flags ^= Flags.FLAG_5;
	}
	
	public inline function hasFlag (flag:Int) : Bool {
		return (flags & flag) > 0;
	}
	
	public function unsetFlag2 () {
		flags = 31;
		flags &= 0xffffffff ^ Flags.FLAG_1;
		flags &= 0xffffffff ^ Flags.FLAG_2;
		flags &= 0xffffffff ^ Flags.FLAG_3;
		flags &= 0xffffffff ^ Flags.FLAG_4;
		flags &= 0xffffffff ^ Flags.FLAG_5;
	}
}


class UtilFlagsSpeedTest
{
	public var flags : Int;
	
	public function new () {
		flags = 0;
	}
	
	public function setFlag () {
		flags = flags.set( Flags.FLAG_1 );
		flags = flags.set( Flags.FLAG_2 );
		flags = flags.set( Flags.FLAG_3 );
		flags = flags.set( Flags.FLAG_4 );
		flags = flags.set( Flags.FLAG_5 );
	}
	
	public function unsetFlag () {
		flags = 31;
		flags = flags.unset( Flags.FLAG_1 );
		flags = flags.unset( Flags.FLAG_2 );
		flags = flags.unset( Flags.FLAG_3 );
		flags = flags.unset( Flags.FLAG_4 );
		flags = flags.unset( Flags.FLAG_5 );
	}
}


class PropertyCompareSpeedTest
{
	private var emptyString		: String;
	private var emptyInt		: Int;
	private var emptyFloat		: Float;
	private var emptyObject		: UtilFlagsSpeedTest;
	
	private var filledString	: String;
	private var filledInt		: Int;
	private var filledFloat		: Float;
	private var filledObject	: UtilFlagsSpeedTest;
	
	
	public function new ()
	{
		emptyString		= null;
		emptyObject		= null;
		emptyInt		= Number.INT_NOT_SET;
		emptyFloat		= Number.FLOAT_NOT_SET;
		
		filledString	= "nullladielasda";
		filledObject	= new UtilFlagsSpeedTest();
		filledInt		= Flags.FLAG_1 | Flags.FLAG_3 | Flags.FLAG_5;
		filledFloat		= 513145.1237;
		
		Assert.that( emptyFloat.notSet() );
		Assert.that( filledFloat.isSet() );
	}
	
	
	public function checkEmptyString ()		{ var r = emptyString == null; }
	public function checkEmptyInt ()		{ var r = emptyInt.notSet(); }
	public function checkEmptyFloat ()		{ var r = emptyFloat.notSet(); }
	public function checkEmptyFloat2 ()		{ var r = Math.isNaN( emptyFloat ); }
	public function checkEmptyObject ()		{ var r = emptyObject == null; }
	public function checkEmptyFlag ()		{ var r = !emptyInt.has(Flags.FLAG_5); }
	
	public function checkFilledString ()	{ var r = filledString != null; }
	public function checkFilledInt ()		{ var r = filledInt.isSet(); }
	public function checkFilledFloat ()		{ var r = filledFloat.isSet(); }
	public function checkFilledFloat2 ()	{ var r = !Math.isNaN( emptyFloat ); }
	public function checkFilledObject ()	{ var r = filledObject != null; }
	public function checkFilledFlag ()		{ var r = filledInt.has(Flags.FLAG_5); }
}