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

		group = new Comparison( "typed reading", 3 );
		bench.add( group );
		
		group.add( new Test( test.readNormal,		"normal") );
		group.add( new Test( test.readCasted,		"casted") );
		group.add( new Test( test.readCasted2,		"casted2") );
		
		bench.start();
		
	//	new AutoManualInstantionTest();
	}
	
	
	var list:Vector<TestVO>;
	
	public function new ()
	{
		list = new Vector<TestVO>();
		
		for (i in 0...10000)
			list.push(new TestVO(i));
	}
	
	
	public function pushTest ()		{ list.push(new TestVO(0)); }
	public function insertTest ()	{ list[list.length] = new TestVO(0); }
	
	
	public function readItemFloat ()	{ var a = list[550]; }
	public function readItemInt ()		{ var a = list[Std.int(550)]; }

	public function readNormal ()
	{
		var item:TestVO = null;
		for (i in 0...list.length)
			item = list[i];
	}


	public function readCasted ()
	{
		var item:TestVO = null;
		for (i in 0...list.length)
			item = cast(list[i], TestVO);
	}


	public function readCasted2 ()
	{
		var item:TestVO = null, len = list.length;
		for (i in 0...len)
			item = cast(list[i], TestVO);
	}
}


class TestVO
{
	private var num : Int;
	public function new (i)	num = i
}