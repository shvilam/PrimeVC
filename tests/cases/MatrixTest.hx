package cases;
 import primevc.core.geom.Matrix2D;
 import primevc.gui.display.Sprite;
 import Benchmark;
  using primevc.utils.Bind;


class MatrixTest extends Sprite
{
	public static function main ()
	{
		flash.Lib.current.stage.addChild( new MatrixTest() );
	}
	
	
	private var sprite	: Sprite;
//	private var matrix	: Matrix2D;
	private var bench	: Benchmark;
	
	public function new ()
	{
		super();
		bench		= new Benchmark();
	//	matrix		= new Matrix2D();
		sprite		= new Sprite();
		var g		= sprite.graphics;
		
		children.add( sprite );
		g.beginFill(0xff00ff);
		g.drawRect( 0, 0, 50, 50 );
		g.endFill();
		
	//	matrix.translate( 3, 3 );
		
		var group = new Comparison( "compare moving", 100000 );
		bench.add( group );
		group.add( new Test( moveChildWithMatrix,	"matrix") );
		group.add( new Test( moveChildCoordinates,	"coordinates") );
		
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
	
	
	private function runTest () { bench.start(); }
}

