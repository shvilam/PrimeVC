package primevc.core.geom;
 import primevc.core.Bindable;
 import primevc.core.IDisposable;
 import primevc.core.Number;


/**
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class BindableBox implements IDisposable
{
	public var left		: Bindable <Int>;
	public var right	: Bindable <Int>;
	public var top		: Bindable <Int>;
	public var bottom	: Bindable <Int>;
//	public var centerX	: Bindable <Int>;
//	public var centerY	: Bindable <Int>;
	
	
	public function new (top = Number.INT_MIN, right = Number.INT_MAX, bottom = Number.INT_MAX, left = Number.INT_MIN) 
	{
		Assert.that(top <= bottom);
		Assert.that(left <= right);
		
		this.left		= new Bindable<Int>( left );
		this.right		= new Bindable<Int>( right );
		this.top		= new Bindable<Int>( top );
		this.bottom		= new Bindable<Int>( bottom );
	//	this.centerX	= new Bindable<Int>( (right - left) * .5 );
	//	this.centerY	= new Bindable<Int>( (bottom - top) * .5 );
	}
	
	
	public function dispose ()
	{
		left.dispose();
		right.dispose();
		top.dispose();
		bottom.dispose();
	//	centerX.dispose();
	//	centerY.dispose();
		
		left = right = top = bottom = null;
	//	centerX = centerY = null;
	}
}