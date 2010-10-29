package cases;
import Benchmark;
 

/**
 * @creation-date	Oct 28, 2010
 * @author			Ruben Weijers
 */
class IfElseVsTernery
{
	public static function main ()
	{
		var bench = new Benchmark();
		var test1 = new IfTest();
		var test2 = new TerneryTest();
		
		var group = new Comparison( "If/else test", 10000000 );
		bench.add( group );
		
		group.add( new Test( test1.test,		"IfElse") );
		group.add( new Test( test2.test,		"Ternery") );
		
		bench.start();
	}
}


class BaseTest
{
	private var name:String;
	public function new ()
	{
		name = "test";
	}
}


class IfTest extends BaseTest
{
	public function test ()
	{
		if (name == "test")	{ var result = false; }
		else				{ var result = true; }
	}
}


class TerneryTest extends BaseTest
{
	public function test ()
	{
		var result = (name == "test") ? false : true;
	}
}