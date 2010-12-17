package cases;
 import primevc.core.geom.Matrix2D;
 import primevc.core.geom.IntMatrix2D;
 import primevc.gui.display.Sprite;
 import Benchmark;
  using primevc.utils.Bind;


class MatrixTest extends Sprite
{
	public static function main ()
	{
		flash.Lib.current.stage.addChild( new MatrixTest() );
	}
	
	
	private var sprite		: Sprite;
	private var matrix2D	: Matrix2D;
	private var intMatrix	: IntMatrix2D;
	private var bench		: Benchmark;
	
	public function new ()
	{
		super();
		bench		= new Benchmark();
		sprite		= new Sprite();
		var g		= sprite.graphics;
		
		children.add( sprite );
		g.beginFill(0xff00ff);
		g.drawRect( 0, 0, 50, 50 );
		g.endFill();
		
		matrix2D	= new Matrix2D();
		intMatrix	= new IntMatrix2D();
	//	matrix.translate( 3, 3 );
		
		var group = new Comparison( "compare moving matrix classes", 100000 );
		bench.add( group );
		group.add( new Test( moveMatrix2D,		"Matrix2D") );
		group.add( new Test( moveIntMatrix,		"IntMatrix") );
		
		var group = new Comparison( "compare scaling matrix classes", 100000 );
		bench.add( group );
		group.add( new Test( scaleMatrix2D,		"Matrix2D") );
		group.add( new Test( scaleIntMatrix,	"IntMatrix") );
		
		var group = new Comparison( "compare rotating matrix classes", 100000 );
		bench.add( group );
		group.add( new Test( rotateMatrix2D,	"Matrix2D") );
		group.add( new Test( rotateIntMatrix,	"IntMatrix") );
		
		var group = new Comparison( "compare concatinating matrix classes", 100000 );
		bench.add( group );
		group.add( new Test( concatMatrix2D,	"Matrix2D") );
		group.add( new Test( concatIntMatrix,	"IntMatrix") );
		
		
		
	//	var group = new Comparison( "compare moving", 100000 );
	//	bench.add( group );
	//	group.add( new Test( moveChildWithMatrix,	"matrix") );
	//	group.add( new Test( moveChildCoordinates,	"coordinates") );
		
		runTest.on( displayEvents.addedToStage, this );
	}
	
	
	public function moveChildWithMatrix ()
	{
		var m = sprite.transform.matrix;
		m.translate( 1, 1 );
	//	m.resize( 100, 100 );
		m.rotate( 1 );
		sprite.transform.matrix = m;
	}
	
	
	public function moveChildCoordinates ()
	{
		sprite.x += 1;
		sprite.y += 1;
	//	sprite.rotation += 1;
		sprite.width = 100;
		sprite.height = 100;
	}
	
	
	public function scaleMatrix2D ()	{ matrix2D.scale( .234, .812 ); }
	public function scaleIntMatrix ()	{ intMatrix.scale( .234, .812 ); }
	
	public function rotateMatrix2D ()	{ matrix2D.rotate( 9 ); }
	public function rotateIntMatrix ()	{ intMatrix.rotate( 9 ); }
	
	public function moveMatrix2D ()		{ matrix2D.translate( .3, 9.1 ); }
	public function moveIntMatrix ()	{ intMatrix.translate( .3, 9.1 ); }
	
	public function concatMatrix2D ()	{ matrix2D.concat( new Matrix2D() ); }
	public function concatIntMatrix ()	{ intMatrix.concatMatrix( new IntMatrix2D() ); }
	
	
	private function runTest () { bench.start(); }
}

