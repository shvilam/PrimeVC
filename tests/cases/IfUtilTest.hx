package cases;
 import Benchmark;
  using primevc.utils.IfUtil;
 

/**
 * @creation-date	Feb 9, 2011
 * @author			Ruben Weijers
 */
class IfUtilTest
{
	public static function main ()
	{
		var test = new IfUtilTest();
		var bench = new Benchmark();
		
		var group = new Comparison( "not null", 1000000 );
		bench.add( group );
		group.add( new Test( test.ifUtilNotNull,	"if util") );
		group.add( new Test( test.stdNotNull,		"std way") );
		
		var group = new Comparison( "is null", 1000000 );
		bench.add( group );
		group.add( new Test( test.ifUtilIsNull,	"if util") );
		group.add( new Test( test.stdIsNull,	"std way") );
		
		bench.start();
	}
	
	
	private var a:String;
	private var b:String;
	
	
	public function new () {
		a = null;
		b = "sdfk sdf skekrk;l sdf";
	}
	
	
	public function ifUtilNotNull ()
	{
		var c = a.notNull();
		var c = b.notNull();
	}
	
	
	public function stdNotNull ()
	{
		var c = a != null;
		var c = b != null;
	}
	
	
	public function ifUtilIsNull ()
	{
		var c = a.notNull();
		var c = b.notNull();
	}
	
	
	public function stdIsNull ()
	{
		var c = a == null;
		var c = b == null;
	}
}
		