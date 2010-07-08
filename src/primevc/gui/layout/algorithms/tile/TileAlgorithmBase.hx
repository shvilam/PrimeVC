package primevc.gui.layout.algorithms.tile;
 import primevc.gui.layout.algorithms.directions.Direction;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.DynamicLayoutAlgorithm;
 import primevc.gui.layout.LayoutFlags;
 

/**
 * Base class for tile algorithms
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class TileAlgorithmBase extends DynamicLayoutAlgorithm
{
	/**
	 * Defines in which direction the layout will start calculating.
	 * @default		Direction.horizontal
	 */
	public var startDirection			(default, setStartDirection)		: Direction;
	
	
	public function new() 
	{
		super(
			new HorizontalFloatAlgorithm(),
			new VerticalFloatAlgorithm()
		);
		
		horizontalDirection	= horAlgorithm.direction;
		verticalDirection	= verAlgorithm.direction;
		startDirection		= Direction.horizontal;
	}
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	private function setStartDirection (v) {
		if (v != startDirection) {
			startDirection = v;
			invalidate( false );
		}
		return v;
	}
}