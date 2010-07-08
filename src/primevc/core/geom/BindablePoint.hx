package primevc.core.geom;
 import primevc.core.Bindable;
 import primevc.core.IDisposable;


/**
 * Description
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class BindablePoint extends SimplePoint, implements IDisposable
{
	public var xProp (default, null)	: Bindable < Int >;
	public var yProp (default, null)	: Bindable < Int >;
	
	
	public function new (x = 0, y = 0)
	{
		xProp = new Bindable();
		yProp = new Bindable();
		super(x, y);
	}
	
	
	public function dispose () {
		xProp.dispose();
		yProp.dispose();
		xProp = yProp = null;
	}
	
	
	override private function getX ()	{ return xProp.value; }
	override private function setX (v)	{ return xProp.value = v; }
	override private function getY ()	{ return yProp.value; }
	override private function setY (v)	{ return yProp.value = v; }
}