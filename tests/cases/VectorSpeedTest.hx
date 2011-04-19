package cases;
 import flash.Vector;
 import Benchmark;


/**
 * @author Ruben Weijers
 * @creation-date Apr 18, 2011
 */
class VectorSpeedTest
{
	public static function main ()
	{
		var bench = new Benchmark();
		
		var test = new VectorSpeedTest();
		
		var group = new Comparison( "read float vs read int", 200000 );
		bench.add( group );
		
		group.add( new Test( test.readItemFloat,"Float") );
		group.add( new Test( test.readItemInt,	"Int") );
		
		group = new Comparison( "push vs insert", 200000 );
		bench.add( group );
		
		group.add( new Test( test.insertTest,	"Insert") );
		group.add( new Test( test.pushTest,		"Push") );
		
		bench.start();
		
	//	new AutoManualInstantionTest();
	}
	
	
	var list:Vector<String>;
	
	public function new ()
	{
		list = new Vector<String>();
		
		for (i in 0...100)
			list.push("test"+i);
	}
	
	
	public function pushTest ()		{ list.push("test"); }
	public function insertTest ()	{ list[list.length] = "test"; }
	
	
	public function readItemFloat ()	{ var a = list[55]; }
	public function readItemInt ()		{ var a = list[Std.int(55)]; }
}