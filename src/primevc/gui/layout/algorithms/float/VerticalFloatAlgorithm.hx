package primevc.gui.layout.algorithms.float;
 import primevc.gui.layout.algorithms.directions.Vertical;
 import primevc.gui.layout.algorithms.IVerticalAlgorithm;
 import primevc.gui.layout.algorithms.LayoutAlgorithmBase;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.utils.IntMath;
  using primevc.utils.BitUtil;
  using primevc.utils.IntMath;
  using primevc.utils.IntUtil;
  using primevc.utils.TypeUtil;


/**
 * Floating algorithm for vertical layouts
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class VerticalFloatAlgorithm extends LayoutAlgorithmBase, implements IVerticalAlgorithm
{
	public var direction	(default, setDirection)		: Vertical;
	
	/**
	 * Measured point of the bottom side of the middlest child (rounded above)
	 * when the direction is center.
	 */
	private var halfHeight	: Int;
	
	
	public function new (?direction)
	{
		super();
		this.direction = direction == null ? Vertical.top : direction;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	/**
	 * Setter for direction property. Method will change the apply method based
	 * on the given direction. After that it will dispatch a 'directionChanged'
	 * signal.
	 */
	private inline function setDirection (v:Vertical) {
		if (v != direction) {
			direction = v;
			switch (v) {
				case Vertical.top:		apply = applyTopToBottom;
				case Vertical.center:	apply = applyCentered;
				case Vertical.bottom:	apply = applyBottomToTop;
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
	public inline function isInvalid (changes:Int)	: Bool {
		return changes.has( LayoutFlags.HEIGHT_CHANGED ) && childHeight.notSet();
	}
	
	
	/**
	 * Method will return the total height of all the children.
	 */
	public inline function measure ()
	{
		if (group.children.length == 0)
			return;
		
		measureHorizontal();
		measureVertical();
	}
	
	
	public inline function measureHorizontal ()
	{
		var width:Int = childWidth;
		
		if (childWidth.notSet())
		{
			for (child in group.children)
				if (child.bounds.width > width)
					width = child.bounds.width;
		}
		
		setGroupWidth(width);
	}
	
	
	public inline function measureVertical ()
	{
		var height:Int = halfHeight = 0;
		
		if (childHeight.notSet())
		{
			var i:Int = 0;
			for (child in group.children) {
				height += child.bounds.height;
				
				//only count even children
				if (i % 2 == 0)
					halfHeight += child.bounds.height;
				
				i++;
			}
		}
		else
		{
			height		= childHeight * group.children.length;
			halfHeight	= childHeight * group.children.length.divCeil(2);
		}
		
		setGroupHeight(height);
	}
	
	
	
	private inline function applyTopToBottom () : Void
	{
		if (group.children.length == 0)
			return;
		
		var next = getTopStartValue();
		
		//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
		if (childHeight.notSet())
		{
			for (child in group.children) {
				child.bounds.top	= next;
				next				= child.bounds.bottom;
			}
		}
		else
		{
			for (child in group.children) {
				child.bounds.top	 = next;
				next				+= childHeight;
			}
		}
	}
	
	
	private inline function applyCentered () : Void
	{
		if (group.children.length == 0)
			return;
		
		var i:Int = 0;
		var evenPos:Int, oddPos:Int;
		evenPos = oddPos = halfHeight + getTopStartValue();
		
		//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
		if (childHeight.notSet())
		{
			for (child in group.children) {
				if (i % 2 == 0) {
					//even
					child.bounds.bottom	= evenPos;
					evenPos				= child.bounds.top;
				} else {
					//odd
					child.bounds.top	= oddPos;
					oddPos				= child.bounds.bottom;
				}
				i++;
			}
		}
		else
		{
			for (child in group.children) {
				if (i % 2 == 0) {
					//even
					child.bounds.bottom	 = evenPos;
					evenPos				-= childHeight;
				} else {
					//odd
					child.bounds.top	 = oddPos;
					oddPos				+= childHeight;
				}
				i++;
			}
		}
	}
	
	
	private inline function applyBottomToTop () : Void
	{
		if (group.children.length == 0)
			return;
		
		var next = getBottomStartValue();
		
		//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
		if (childHeight.notSet())
		{
			for (child in group.children) {
				child.bounds.bottom	= next;
				next				= child.bounds.top;
			}
		}
		else
		{
			next -= childHeight;
			for (child in group.children) {
				child.bounds.top	= next;
				next				= child.bounds.top - childHeight;
			}
		}
	}
	
	
	
	
	//
	// START VALUES
	//
	
	private inline function getTopStartValue ()		: Int
	{
		var top:Int = 0;
		if (group.padding != null)
			top = group.padding.top;
		
		return top;
	}
	
	
	private inline function getBottomStartValue ()	: Int	{
		var h:Int = group.height;
		if (group.is(AdvancedLayoutClient))
			h = IntMath.max(group.as(AdvancedLayoutClient).measuredHeight, h);
		
		if (group.padding != null)
			h += group.padding.top; // + group.padding.bottom;
		
		return h;
	}
	
	
#if debug
	public function toString ()
	{
		var start = direction == Vertical.top ? "top" : "bottom";
		var end = direction == Vertical.top ? "bottom" : "top";
		return "float.ver ( " + start + " -> " + end + " ) ";
	}
#end
}