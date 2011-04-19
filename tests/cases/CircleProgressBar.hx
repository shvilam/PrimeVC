package cases;
 import apparat.math.FastMath;
 import primevc.gui.display.Sprite;
 import primevc.gui.display.VectorShape;
 import primevc.utils.Formulas;
  using primevc.gui.utils.GraphicsUtil;


/**
 * @author Ruben Weijers
 * @creation-date Apr 18, 2011
 */
class CircleProgressBar extends Sprite
{
	public static function main ()
	{
		flash.Lib.current.stage.addChild( new CircleProgressBar() );
	}
	
	
	public function new ()
	{
		super();
		
		var radius	= 200;
		x			= 600;
		y			= 600;
		
		arc			= new Arc(radius);
		var mask	= new VectorShape();
		addChild( mask );
		addChild( arc );
		
		graphics.beginFill(0xff0000);
		graphics.drawCircle( 0, 0, radius );
		graphics.endFill();
		
		mask.graphics.beginFill(0xff0000);
		mask.graphics.drawCircle( 0, 0, radius );
		mask.graphics.endFill();
		
		//redraw percentage
		perc		= 0;
		timer		= new haxe.Timer(10);
		timer.run	= updateArc;
	//	arc.mask = mask;
	}
	
	
	private var arc:Arc;
	private var timer:haxe.Timer;
	private var perc:Float;
	
	private function updateArc ()
	{
		perc += 0.001;
	//	if (perc > 0.5)
	//		timer.stop();
		
		if (perc >= 1)
			perc = 0;
		
		arc.redraw(perc);
	}
}


class Arc extends VectorShape
{
	private var radius		: Float;
	private var sides		: Int;
	
	
	public function new (radius:Float, sides:Int = 5)
	{
		super();
		Assert.that(sides > 2);
		this.sides	= sides;
		this.radius	= Formulas.polygonRadiusForCircle( radius, sides );
	}
	
	
	public function redraw (perc:Float)
	{
		var g = graphics;
		g.clear();
		g.beginFill(0x00ff00);
		g.lineStyle(0x000000);
		this.drawPolygonFraction( sides, 0, 0, radius, perc );
		g.endFill();
	}
}