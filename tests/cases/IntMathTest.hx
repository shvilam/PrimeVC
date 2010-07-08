package cases;
 import Benchmark;
  using primevc.utils.IntMath;
 

/**
 * Description
 * 
 * @creation-date	Jun 28, 2010
 * @author			Ruben Weijers
 */
class IntMathTest 
{
	public static function main ()
	{
		var test = new IntMathTest();
		var bench = new Benchmark();
		
		var group = new Comparison( "Division", 1000000 );
		bench.add( group );
		group.add( new Test( test.floorMathIntDivTest,	"intMathFloor") );
		group.add( new Test( test.floorIntDivTest,		"floor int") );
		group.add( new Test( test.floorFloatDivTest,	"floor number") );
		group.add( new Test( test.ceilMathIntDivTest,	"intMathCeil") );
		group.add( new Test( test.ceilIntDivTest,		"ceil int") );
		group.add( new Test( test.ceilFloatDivTest,		"ceil number") );
		group.add( new Test( test.floatDivTest,			"number") );
		
		bench.start();
	}
	
	
	private var a:Int;
	private var b:Int;
	
	
	public function new () {
		a = 500;
		b = 33;
	}
	
	
	public function floorMathIntDivTest ()	{ var c:Int = a.divFloor(b); }
	public function ceilMathIntDivTest ()	{ var c:Int = a.divCeil(b); }
	public function floorIntDivTest ()		{ var c:Int = cast Math.floor( a / b ); }
	public function ceilIntDivTest ()		{ var c:Int = cast Math.ceil( a / b ); }
	public function floorFloatDivTest ()	{ var c:Float = Math.floor( a / b ); }
	public function ceilFloatDivTest ()		{ var c:Float = Math.ceil( a / b ); }
	public function floatDivTest ()			{ var c:Float = a / b; }
}
