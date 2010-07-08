package primevc.core.geom.constraints;
 import primevc.core.geom.BindableBox;
 import primevc.core.IDisposable;
  using primevc.utils.Bind;


/**
 * Description
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class ConstrainedRect implements IDisposable
{
	public var constraint		(default, setConstraint)		: BindableBox;
	public var props			(default, null)					: BindableBox;
	
	public var top				(getTop, setTop)				: Int;
	public var bottom			(getBottom, setBottom)			: Int;
	public var left				(getLeft, setLeft)				: Int;
	public var right			(getRight, setRight)			: Int;
	public var centerX			(getCenterX, setCenterX)		: Int;
	public var centerY			(getCenterY, setCenterY)		: Int;
	
	public var width			(default, setWidth)				: Int;
	public var height			(default, setHeight)			: Int;
	
	
	public function new (top = 0, right = 0, bottom = 0, left = 0) 
	{
		props = new BindableBox();
		this.top	= top;
		this.right	= right;
		this.bottom	= bottom;
		this.left	= left;
		
		this.height	= bottom - top;
		this.width	= right - left;
	}
	
	
	public function dispose ()
	{
		props.dispose();
		props		= null;
		constraint	= null;
	}
	
	
	public function toString () {
		return "left " + left + "; right: " + right + "; top: " + top + "; bottom: " + bottom + "; width: " + width + "; height: " + height;
	}
	
	
	private inline function getLeft ()		{ return props.left.value; }
	private inline function getRight ()		{ return props.right.value; }
	private inline function getTop ()		{ return props.top.value; }
	private inline function getBottom ()	{ return props.bottom.value; }
	private inline function getCenterX ()	{ return left + Std.int(width * .5); }
	private inline function getCenterY ()	{ return top + Std.int(height * .5); }
	
	
	private inline function setWidth (v:Int) {
		width				= v;
		props.right.value	= left + width;
		return v;
	}
	
	
	private inline function setHeight (v:Int) {
		height				= v;
		props.bottom.value	= top + height;
		return v;
	}
	
	
	private inline function setTop (v:Int) {
		if (constraint != null && v < constraint.top.value)
			v = constraint.top.value;
		
		if (v != top) {
			props.top.value		= v;
			props.bottom.value	= v + height;
		}
		return v;
	}
	
	
	private inline function setBottom (v:Int) {
		if (constraint != null && v > constraint.bottom.value)
			v = constraint.bottom.value;
		
		if (v != bottom) {
			props.bottom.value	= v;
			props.top.value		= v - height;
		}
		
		return v;
	}
	
	
	private inline function setLeft (v:Int) {
		if (constraint != null && v < constraint.left.value)
			v = constraint.left.value;
		
		if (v != left) {
			props.left.value	= v;
			props.right.value	= v + width;
		}
		return v;
	}
	
	
	private inline function setRight (v:Int) {
		if (constraint != null && v > constraint.right.value)
			v = constraint.right.value;
		
		if (v != right) {
			props.right.value	= v;
			props.left.value	= v - width;
		}
		return v;
	}
	
	
	private inline function setCenterX (v:Int) {
		left = v - Std.int(width * .5);
		return centerX;
	}
	
	
	private inline function setCenterY (v:Int) {
		top = v - Std.int(height * .5);
		return centerY;
	}
	
	
	
	public inline function setConstraint (v) {
		if (constraint != null) {
			constraint.left		.change.unbind( this );
			constraint.right	.change.unbind( this );
			constraint.top		.change.unbind( this );
			constraint.bottom	.change.unbind( this );
		}
		
		constraint = v;
		
		if (constraint != null) {
			validateConstraints.on( constraint.left		.change, this );
			validateConstraints.on( constraint.right	.change, this );
			validateConstraints.on( constraint.top		.change, this );
			validateConstraints.on( constraint.bottom	.change, this );
			validateConstraints();
		}
		return v;
	}
	
	
	public inline function validateConstraints ()
	{
		setLeft(left);
		setRight(right);
		setTop(top);
		setBottom(bottom);
	}
	
	/*
	private inline function setBottom (v:Int)
	{
		bottomBoundary	= _bottom.value = v;
		var newY:Int	= v - height - getVerPadding();
		
		if (y != newY)
			y = newY;
		
		return bottomBoundary;
	}
	
	
	private inline function setLeft (v:Int)
	{
		leftBoundary = _left.value = v;
		if (x != leftBoundary)
			x = leftBoundary;
		
		return leftBoundary;
	}
	
	
	private inline function setRight (v:Int)
	{
		rightBoundary	= _right.value = v;
		var newX:Int	= v - width - getHorPadding();
		
		if (x != newX)
			x = newX;
		
		return rightBoundary;
	}*/
}