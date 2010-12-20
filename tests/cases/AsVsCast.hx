package cases;
 import Benchmark;
 import primevc.utils.TypeUtil;
  using primevc.utils.TypeUtil;
 

/**
 * Description
 * 
 * @creation-date	Jun 15, 2010
 * @author			Ruben Weijers
 */
class AsVsCast 
{
	public static function main ()
	{
		var test1 = new TestAs();
		var test2 = new TestCast();
		var test3 = new TestTypeAs();
		var bench = new Benchmark();
		
		var group = new Comparison( "Interface", 1000000 );
		bench.add( group );
		group.add( new Test( test1.interfaceTest,		"func.as") );
		group.add( new Test( test2.interfaceTest,		"cast") );
		group.add( new Test( test3.interfaceTest,		"Type.as") );
		
		group = new Comparison( "topSuperClass", 1000000 );
		bench.add( group );
		group.add( new Test( test1.topSuperClassTest,	"func.as") );
		group.add( new Test( test2.topSuperClassTest,	"cast") );
		group.add( new Test( test3.topSuperClassTest,	"Type.as") );
		
		group = new Comparison( "superClass", 1000000 );
		bench.add( group );
		group.add( new Test( test1.superClassTest,		"func.as") );
		group.add( new Test( test2.superClassTest,		"cast") );
		group.add( new Test( test3.superClassTest,		"Type.as") );
		
		group = new Comparison( "ownerClass", 1000000 );
		bench.add( group );
		group.add( new Test( test1.ownerClassTest,		"func.as") );
		group.add( new Test( test2.ownerClassTest,		"cast") );
		group.add( new Test( test3.ownerClassTest,		"Type.as") );
		
		bench.start();
	}
}


interface IA {}
class A { public function new (); }
class B extends A, implements IA { }
class C extends B { }



class TypeTest {
	private var c : A;
	
	public function new() {
		c = new C();
	}
}


class TestAs extends TypeTest
{
	public function interfaceTest ()		{ var test = c.as( IA ); }
	public function topSuperClassTest ()	{ var test = c.as( A ); }
	public function superClassTest ()		{ var test = c.as( B ); }
	public function ownerClassTest ()		{ var test = c.as( C ); }
}

class TestCast extends TypeTest
{
	public function interfaceTest ()		{ var test = cast(c, IA); }
	public function topSuperClassTest ()	{ var test = cast(c, A); }
	public function superClassTest ()		{ var test = cast(c, B); }
	public function ownerClassTest ()		{ var test = cast(c, C); }
}

class TestTypeAs extends TypeTest
{
	public function interfaceTest ()		{ var test = TypeUtil.as(c, IA); }
	public function topSuperClassTest ()	{ var test = TypeUtil.as(c, A); }
	public function superClassTest ()		{ var test = TypeUtil.as(c, B); }
	public function ownerClassTest ()		{ var test = TypeUtil.as(c, C); }
}