package cases;
 import Benchmark;
  using Type;

/**
 * @creation-date	Okt 20, 2010
 * @author			Ruben Weijers
 */
class EnumCastSpeedTest 
{
	public static function main ()
	{
		//speed tests
		var test = new CompareTest();
		var bench = new Benchmark();
		
		var group = new Comparison( "compare bigger", 1000000 );
		bench.add( group );
		group.add( new Test( test.compareEnumBigger,	"enums") );
		group.add( new Test( test.compareFlagsBigger,	"flags") );
		
		var group = new Comparison( "compare smaller", 1000000 );
		bench.add( group );
		group.add( new Test( test.compareEnumSmaller,	"enums") );
		group.add( new Test( test.compareFlagsSmaller,	"flags") );
		
		var group = new Comparison( "compare equal", 1000000 );
		bench.add( group );
		group.add( new Test( test.compareEnumEqual,		"enums") );
		group.add( new Test( test.compareFlagsEqual,	"flags") );
		
		
		bench.start();
	}
}


enum TestEnum {
	value1;
	value2;
	value3;
}



class TestFlags
{
	public static inline var VALUE1 : UInt = 1;
	public static inline var VALUE2 : UInt = 2;
	public static inline var VALUE3 : UInt = 3;
}



class CompareTest
{
	public function new () {}
	
	
	public function compareEnumBigger ()
	{
		//correct
		var r = TestEnum.value2.enumIndex() > TestEnum.value1.enumIndex();
		var r = TestEnum.value3.enumIndex() > TestEnum.value1.enumIndex();
		var r = TestEnum.value3.enumIndex() > TestEnum.value2.enumIndex();
		
		//wrong
		var r = TestEnum.value1.enumIndex() > TestEnum.value2.enumIndex();
		var r = TestEnum.value1.enumIndex() > TestEnum.value3.enumIndex();
		var r = TestEnum.value2.enumIndex() > TestEnum.value3.enumIndex();
		
		var r = TestEnum.value1.enumIndex() > TestEnum.value1.enumIndex();
		var r = TestEnum.value2.enumIndex() > TestEnum.value2.enumIndex();
		var r = TestEnum.value3.enumIndex() > TestEnum.value3.enumIndex();
	}
	
	
	public function compareEnumSmaller ()
	{
		//correct
		var r = TestEnum.value1.enumIndex() < TestEnum.value2.enumIndex();
		var r = TestEnum.value1.enumIndex() < TestEnum.value3.enumIndex();
		var r = TestEnum.value2.enumIndex() < TestEnum.value3.enumIndex();
		
		//wrong
		var r = TestEnum.value1.enumIndex() < TestEnum.value1.enumIndex();
		var r = TestEnum.value2.enumIndex() < TestEnum.value2.enumIndex();
		var r = TestEnum.value3.enumIndex() < TestEnum.value3.enumIndex();
		
		var r = TestEnum.value2.enumIndex() < TestEnum.value1.enumIndex();
		var r = TestEnum.value3.enumIndex() < TestEnum.value1.enumIndex();
		var r = TestEnum.value3.enumIndex() < TestEnum.value2.enumIndex();
	}
	
	
	public function compareEnumEqual ()
	{
		//correct
		var r = TestEnum.value1.enumIndex() == TestEnum.value1.enumIndex();
		var r = TestEnum.value2.enumIndex() == TestEnum.value2.enumIndex();
		var r = TestEnum.value3.enumIndex() == TestEnum.value3.enumIndex();
		
		//wrong
		var r = TestEnum.value1.enumIndex() == TestEnum.value2.enumIndex();
		var r = TestEnum.value1.enumIndex() == TestEnum.value3.enumIndex();
		var r = TestEnum.value2.enumIndex() == TestEnum.value3.enumIndex();
		
		var r = TestEnum.value2.enumIndex() == TestEnum.value1.enumIndex();
		var r = TestEnum.value3.enumIndex() == TestEnum.value1.enumIndex();
		var r = TestEnum.value3.enumIndex() == TestEnum.value2.enumIndex();
	}
	
	
	public function compareFlagsBigger ()
	{
		//correct
		var r = TestFlags.VALUE3 > TestFlags.VALUE1;
		var r = TestFlags.VALUE3 > TestFlags.VALUE2;
		var r = TestFlags.VALUE2 > TestFlags.VALUE1;
		
		//wrong
		var r = TestFlags.VALUE1 > TestFlags.VALUE2;
		var r = TestFlags.VALUE1 > TestFlags.VALUE3;
		var r = TestFlags.VALUE2 > TestFlags.VALUE3;
		
		var r = TestFlags.VALUE1 > TestFlags.VALUE1;
		var r = TestFlags.VALUE2 > TestFlags.VALUE2;
		var r = TestFlags.VALUE3 > TestFlags.VALUE3;
	}
	
	
	public function compareFlagsSmaller ()
	{
		//correct
		var r = TestFlags.VALUE1 < TestFlags.VALUE2;
		var r = TestFlags.VALUE1 < TestFlags.VALUE3;
		var r = TestFlags.VALUE2 < TestFlags.VALUE3;
		
		//wrong
		var r = TestFlags.VALUE3 < TestFlags.VALUE1;
		var r = TestFlags.VALUE3 < TestFlags.VALUE2;
		var r = TestFlags.VALUE2 < TestFlags.VALUE1;
		
		var r = TestFlags.VALUE1 < TestFlags.VALUE1;
		var r = TestFlags.VALUE2 < TestFlags.VALUE2;
		var r = TestFlags.VALUE3 < TestFlags.VALUE3;
	}
	
	
	public function compareFlagsEqual ()
	{
		//correct
		var r = TestFlags.VALUE1 == TestFlags.VALUE1;
		var r = TestFlags.VALUE2 == TestFlags.VALUE2;
		var r = TestFlags.VALUE3 == TestFlags.VALUE3;
		
		//wrong
		var r = TestFlags.VALUE3 == TestFlags.VALUE1;
		var r = TestFlags.VALUE3 == TestFlags.VALUE2;
		var r = TestFlags.VALUE2 == TestFlags.VALUE1;
		
		var r = TestFlags.VALUE1 == TestFlags.VALUE2;
		var r = TestFlags.VALUE1 == TestFlags.VALUE3;
		var r = TestFlags.VALUE2 == TestFlags.VALUE3;
	}
}