package primevc.gui.layout.algorithms.float;
 import primevc.gui.layout.algorithms.directions.Horizontal;
 import primevc.gui.layout.algorithms.IHorizontalAlgorithm;
 import primevc.gui.layout.algorithms.LayoutAlgorithmBase;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.utils.IntMath;
  using primevc.utils.BitUtil;
  using primevc.utils.IntMath;
  using primevc.utils.IntUtil;
  using primevc.utils.TypeUtil;
 

/**
 * Floating algorithm for horizontal layouts
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class HorizontalFloatAlgorithm extends LayoutAlgorithmBase, implements IHorizontalAlgorithm
{
	public var direction			(default, setDirection)	: Horizontal;
	
	/**
	 * Measured point of the right side of the middlest child (rounded above) 
	 * when the direction is center.
	 */
	private var halfWidth			: Int;
	
	
	public function new ( ?direction )
	{
		super();
		this.direction = direction == null ? Horizontal.left : direction;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	/**
	 * Setter for direction property. Method will change the apply method based
	 * on the given direction. After that it will dispatch a 'directionChanged'
	 * signal.
	 */
	private inline function setDirection (v:Horizontal)
	{
		if (v != direction) {
			direction = v;
			switch (v) {
				case Horizontal.left:		apply = applyLeftToRight;
				case Horizontal.center:		apply = applyCentered;
				case Horizontal.right:		apply = applyRightToLeft;
			}
			algorithmChanged.send();
		}
		return v;
	}
	
	
	
	//
	// LAYOUT
	//
	
	/**
	 * Method indicating if the size is invalidated or not.
	 */
	public inline function isInvalid (changes:Int)	: Bool
	{
		return changes.has( LayoutFlags.WIDTH_CHANGED ) && childWidth.notSet();
	}
	
	
	public inline function measure ()
	{
		if (group.children.length == 0)
			return;
		
		measureHorizontal();
		measureVertical();
	}
	
	
	public inline function measureVertical ()
	{
		var height:Int = childHeight;
		
		if (childHeight.notSet())
		{
			for (child in group.children)
				if (child.bounds.height > height)
					height = child.bounds.height;
		}
		
		setGroupHeight(height);
	}
	
	
	/**
	 * Method will return the total width of all the children.
	 */
	public inline function measureHorizontal ()
	{
		var width:Int	= halfWidth = 0;
		
		if (childWidth.notSet())
		{
			var i:Int = 0;
			
			for (child in group.children) {
				width += child.bounds.width;
				
				//only count even children
				if (i % 2 == 0)
					halfWidth += child.bounds.width;
				
				i++;
			}
		}
		else
		{
			width		= childWidth * group.children.length;
			halfWidth	= childWidth * group.children.length.divCeil(2);
		}
		
		setGroupWidth(width);
	}
	
	
	private inline function applyLeftToRight () : Void
	{
		if (group.children.length == 0)
			return;
		
		trace("applyLeftToRight for " + group);
		var next = getLeftStartValue();
		
		//use 2 loops for algorithms with and without a fixed child-width. This is faster than doing the if statement inside the loop!
		if (childWidth.notSet())
		{
			for (child in group.children) {
				trace(child +".left = " + next);
				child.bounds.left	= next;
				next				= child.bounds.right;
			}
		} 
		else
		{
			for (child in group.children) {
				child.bounds.left	 = next;
				next				+= childWidth;
			}
		}
	}
	
	
	private inline function applyCentered () : Void
	{
		if (group.children.length == 0)
			return;
		
		var i:Int = 0;
		var evenPos:Int, oddPos:Int;
		evenPos = oddPos = halfWidth + getLeftStartValue();
		
		//use 2 loops for algorithms with and without a fixed child-width. This is faster than doing the if statement inside the loop!
		if (childWidth.notSet())
		{
			for (child in group.children) {
				if (i % 2 == 0) {
					//even
					child.bounds.right	= evenPos;
					evenPos				= child.bounds.left;
				} else {
					//odd
					child.bounds.left	= oddPos;
					oddPos				= child.bounds.right;
				}
				i++;
			}
		}
		else
		{
			for (child in group.children) {
				if (i % 2 == 0) {
					//even
					child.bounds.right	 = evenPos;
					evenPos				-= childWidth;
				} else {
					//odd
					child.bounds.left	 = oddPos;
					oddPos				+= childWidth;
				}
				i++;
			}
		}
	}
	
	
	private inline function applyRightToLeft () : Void
	{
		if (group.children.length == 0)
			return;
		
		var next = getRightStartValue();
		
		//use 2 loops for algorithms with and without a fixed child-width. This is faster than doing the if statement inside the loop!
		if (childWidth.notSet())
		{
			for (child in group.children) {
				child.bounds.right	= next;
				next				= child.bounds.left;
			}
		}
		else
		{
			next -= childWidth;
			for (child in group.children) {
				child.bounds.left	= next;
				next				= child.bounds.left - childWidth;
			}
		}
	}
	
	
	
	
	//
	// START VALUES
	//
	
	private inline function getLeftStartValue ()	: Int
	{
		var left:Int = 0;
		if (group.padding != null)
			left = group.padding.left;
		
		return left;
	}
	
	
	private inline function getRightStartValue ()	: Int
	{
		var w = group.width;
		if (group.is(AdvancedLayoutClient))
			w = IntMath.max(group.as(AdvancedLayoutClient).measuredWidth, w);
		
		if (group.padding != null)
			w += group.padding.left; // + group.padding.right;
		return w;
	}
	
	
#if debug
	public function toString ()
	{
		var start	= direction == Horizontal.left ? "left" : "right";
		var end		= direction == Horizontal.left ? "right" : "left";
		return "float.hor " + start + " -> " + end;
	}
#end
}