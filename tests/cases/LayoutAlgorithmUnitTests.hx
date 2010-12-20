package cases;
 import primevc.core.geom.Point;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutContainer;



/**
 * Class description
 * 
 * @author Ruben Weijers
 * @creation-date Jul 24, 2010
 */
class LayoutAlgorithmUnitTests
{
	public static function main ()
	{
		trace("START TEST");
		//assertions
		var hTest = new HorizontalLayoutAlgorithmTest();
		hTest.testGetDepthForPosition();
		trace("END TEST");
	}
}

class HorizontalLayoutAlgorithmTest extends LayoutAlgorithmTest
{
	var algorithm : ILayoutAlgorithm;
	
	public function testGetDepthForPosition ()
	{
		trace("HorizontalLayoutAlgorithmTest.testGetDepthForPosition");
		algorithm = new HorizontalFloatAlgorithm();
		
		//
		// TEST LEFT TO RIGHT WITH FIXED CHILD-WIDTH
		//
		
		//   5   5   5   5   5   5   5   5  
		// +---+---+---+---+---+---+---+---+
		// | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
		// +---+---+---+---+---+---+---+---+
		//10   15  20  25  30  35  40  45  50
		
		trace("get depth ltr for fixed width");
		setup( algorithm, false, 8 );
		group.padding.left	= 10;
		Assert.equal( 1, algorithm.getDepthForPosition( new Point( 17, 0 ) ) );
		Assert.equal( 2, algorithm.getDepthForPosition( new Point( 19, 0 ) ) );
		Assert.equal( 1, algorithm.getDepthForPosition( new Point( 17, 0 ) ) );
		Assert.equal( 0, algorithm.getDepthForPosition( new Point(  8, 0 ) ) );
		Assert.equal( 6, algorithm.getDepthForPosition( new Point( 38, 0 ) ) );
		Assert.equal( 2, algorithm.getDepthForPosition( new Point( 21, 0 ) ) );
		Assert.equal( 5, algorithm.getDepthForPosition( new Point( 34, 0 ) ) );
		
		
		//
		// TEST LEFT TO RIGHT WITH DYNAMIC CHILD-WIDTH
		//
		
		//   5    10       15         20            25                30				  35					  40
		// +---+------+---------+------------+---------------+------------------+---------------------+------------------------+
		// | 0 |   1  |    2    |     3      |       4       |         5        |          6          |			  7			   |
		// +---+------+---------+------------+---------------+------------------+---------------------+------------------------+
		// 0   5     15        30           50              75				   105					 140					  180
		
		trace("get depth ltr for dynamic width");
		setup( algorithm, true, 8 );
		group.padding.left	= 0;
		Assert.equal( 0, algorithm.getDepthForPosition( new Point(   1, 0 ) ) );
		Assert.equal( 1, algorithm.getDepthForPosition( new Point(   3, 0 ) ) );
		Assert.equal( 1, algorithm.getDepthForPosition( new Point(   9, 0 ) ) );
		Assert.equal( 2, algorithm.getDepthForPosition( new Point(  12, 0 ) ) );
		Assert.equal( 2, algorithm.getDepthForPosition( new Point(  22, 0 ) ) );
		Assert.equal( 3, algorithm.getDepthForPosition( new Point(  23, 0 ) ) );
		Assert.equal( 3, algorithm.getDepthForPosition( new Point(  39, 0 ) ) );
		Assert.equal( 5, algorithm.getDepthForPosition( new Point(  72, 0 ) ) );
		Assert.equal( 5, algorithm.getDepthForPosition( new Point(  89, 0 ) ) );
		Assert.equal( 7, algorithm.getDepthForPosition( new Point( 123, 0 ) ) );
		Assert.equal( 7, algorithm.getDepthForPosition( new Point( 159, 0 ) ) );
	}
}




class LayoutClientMockup extends LayoutClient
{
	public function new (num:Int = 0)
	{
		super();
		width	= 5 + (num * 5);
		height	= 5 + (num * 5);
	}
}


class LayoutAlgorithmTest
{
	private var group : LayoutContainer;

	public function new () {}
	
	public function setup ( algorithm:ILayoutAlgorithm, dynamicSize:Bool = false, items:Int = 8 )
	{
		group = new LayoutContainer();
		
		for (i in 0...items)
		{
			if (dynamicSize)
				group.children.add( new LayoutClientMockup(i) );
			else
				group.children.add( new LayoutClientMockup() );
		}
		
		if (!dynamicSize)
			group.childWidth = 5;
		
		group.algorithm = algorithm;
		group.measure();
		group.validate();
	}
}