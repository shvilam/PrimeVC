package primevc.gui.layout.algorithms;
 import primevc.gui.layout.algorithms.directions.Direction;
 import primevc.gui.layout.algorithms.directions.Horizontal;
 import primevc.gui.layout.algorithms.directions.Vertical;
  using primevc.utils.Bind;
 

/**
 * Dynamic layout algorithm allows to specify different sub-algorithms for
 * horizontal and vertical layouts.
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class DynamicLayoutAlgorithm extends LayoutAlgorithmBase, implements ILayoutAlgorithm
{
	
	/**
	 * Defines the start position on the horizontal axis.
	 * @default		Horizontal.left
	 */
	public var horizontalDirection		(default, setHorizontalDirection)	: Horizontal;
	/**
	 * Defines the start position on the vertical axis.
	 * @default		Vertical.top
	 */
	public var verticalDirection		(default, setVerticalDirection)		: Vertical;
	
	
	public var horAlgorithm				(default, setHorAlgorithm)			: IHorizontalAlgorithm;
	public var verAlgorithm				(default, setVerAlgorithm)			: IVerticalAlgorithm;
	
	
	public function new (horAlgorithm:IHorizontalAlgorithm, verAlgorithm:IVerticalAlgorithm) 
	{
		super();
		this.horAlgorithm	= horAlgorithm;
		this.verAlgorithm	= verAlgorithm;
		apply = applyBoth;
	}
	
	
	override public function dispose ()
	{
		horAlgorithm.dispose();
		verAlgorithm.dispose();
		horAlgorithm	= null;
		verAlgorithm	= null;
		super.dispose();
	}
	
	
	
	//
	// ALGORITHM METHODS
	//
	
	
	public function measure ()
	{
		if (group.children.length == 0)
			return;
		
		measureHorizontal();
		measureVertical();
	}
	
	
	public function measureHorizontal ()	{ horAlgorithm.measureHorizontal(); }
	public function measureVertical ()		{ verAlgorithm.measureVertical(); }
	
	
	public inline function applyBoth ()
	{
		horAlgorithm.apply();
		verAlgorithm.apply();
	}
	
	
	public inline function isInvalid (changes:Int) : Bool
	{
		return horAlgorithm.isInvalid(changes) || verAlgorithm.isInvalid(changes);
	}
	
	
	private function invalidate (shouldbeResetted:Bool = true) : Void
	{
		algorithmChanged.send();
	}
	
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	override private function setGroup (v)
	{
		if (group != v)
		{
			if (group != null) {
				horAlgorithm.group = null;
				verAlgorithm.group = null;
			}
			
			v = super.setGroup(v);
			invalidate(true);
			
			if (v != null) {
				horAlgorithm.group	= v;
				verAlgorithm.group	= v;
			}
		}
		return v;
	}
	
	
	private inline function setHorAlgorithm (v)
	{
		if (horAlgorithm != null) {
			horAlgorithm.group = null;
			horAlgorithm.algorithmChanged.unbind(this);
		}
		
		horAlgorithm = v;
		invalidate(false);
		
		if (horAlgorithm != null) {
			horAlgorithm.group			= group;
			horAlgorithm.childWidth		= childWidth;
			horAlgorithm.childHeight	= childHeight;
			
			algorithmChanged.send.on( horAlgorithm.algorithmChanged, this );
		}
		return v;
	}
	
	
	private inline function setVerAlgorithm (v)
	{
		if (verAlgorithm != null) {
			verAlgorithm.group = null;
			verAlgorithm.algorithmChanged.unbind(this);
		}
		
		verAlgorithm = v;
		invalidate(false);
		
		if (verAlgorithm != null) {
			verAlgorithm.group			= group;
			verAlgorithm.childWidth		= childWidth;
			verAlgorithm.childHeight	= childHeight;
			
			algorithmChanged.send.on( verAlgorithm.algorithmChanged, this );
		}
		return v;
	}
	
	
	private inline function setHorizontalDirection (v:Horizontal)
	{
		if (v != horizontalDirection) {
			horizontalDirection		= v;
			horAlgorithm.direction	= v;
		}
		return v;
	}
	
	
	private inline function setVerticalDirection (v:Vertical)
	{
		if (v != verticalDirection) {
			verticalDirection		= v;
			verAlgorithm.direction	= v;
		}
		return v;
	}
	
	
	override private function setChildWidth (v)
	{
		v = super.setChildWidth(v);
		
		if (horAlgorithm != null)	horAlgorithm.childWidth = v;
		if (verAlgorithm != null)	verAlgorithm.childWidth = v;
		return v;
	}
	
	
	override private function setChildHeight (v)
	{
		v = super.setChildHeight(v);
		if (horAlgorithm != null)	horAlgorithm.childHeight = v;
		if (verAlgorithm != null)	verAlgorithm.childHeight = v;
		return v;
	}
}