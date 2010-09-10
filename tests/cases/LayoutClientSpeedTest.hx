package cases;
 import Benchmark;
 import primevc.core.geom.BindableBox;
 import primevc.core.geom.constraints.SizeConstraint;
 import primevc.core.geom.RangedFloat;
 import primevc.types.Number;
 import primevc.gui.events.LayoutEvents;
 import primevc.gui.layout.LayoutClient;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
 

/**
 * Description
 * 
 * @creation-date	Jun 20, 2010
 * @author			Ruben Weijers
 */
class LayoutClientSpeedTest 
{
	public static function main ()
	{
		var bench = new Benchmark();
		var test1 = new DynamicLayoutClientTest();
		var test2 = new ManualLayoutClientTest();
		var test3 = new SimpleManualLayoutClientTest();
		var test4 = new ManualIntLayoutClientTest();
		
		var group = new Comparison( "create", 100000 );
		bench.add( group );
		group.add( new Test( test1.testCreate,			"auto") );
		group.add( new Test( test2.testCreate,			"manual") );
		group.add( new Test( test3.testCreate,			"manual simple") );
		group.add( new Test( test4.testCreate,			"manual int") );
		
		var group = new Comparison( "Set Width", 1000000 );
		bench.add( group );
		group.add( new Test( test1.testSetWidth,		"auto") );
		group.add( new Test( test2.testSetWidth,		"manual") );
		group.add( new Test( test3.testSetWidth,		"manual simple") );
		group.add( new Test( test4.testSetWidth,		"manual int") );
		
		group = new Comparison( "Get Width", 1000000 );
		bench.add( group );
		group.add( new Test( test1.testGetWidth,		"auto") );
		group.add( new Test( test2.testGetWidth,		"manual") );
		group.add( new Test( test3.testGetWidth,		"manual simple") );
		group.add( new Test( test4.testGetWidth,		"manual int") );
		
		var group = new Comparison( "constrained width", 100000 );
		bench.add( group );
		group.add( new Test( test1.initConstraints,		"auto init constraints") );
		group.add( new Test( test1.setConstraints,		"auto set constraints") );
		group.add( new Test( test1.setMaxWidth,			"auto set max width") );
		
		group.add( new Test( test1.testSetWidth,		"auto set width") );
		group.add( new Test( test1.testSetX,			"auto set x") );
		group.add( new Test( test1.testSetLeft,			"auto set left") );
		group.add( new Test( test1.testSetRight,		"auto set right") );
		
		group.add( new Test( test1.testSetPosConstrains,"auto set pos constraints") );
		group.add( new Test( test1.testSetX,			"auto set x") );
		group.add( new Test( test1.testSetLeft,			"auto set left") );
		group.add( new Test( test1.testSetRight,		"auto set right") );
		group.add( new Test( test1.testGetWidth,		"auto get width") );
		group.add( new Test( test1.initAspectRatio,		"init aspect ratio") );
		group.add( new Test( test1.testAspectRatio,		"auto set aspect width") );
		
		bench.start();
	}
}



class DynamicLayoutClientTest
{
	public var nextNum	: Int;
	public var client	: LayoutClient;
	
	public function new ()			{ nextNum = 1; }
	public function testCreate ()	{ client = new LayoutClient(); }
	
	public function initConstraints () {
		nextNum = 1;
		client.sizeConstraint = new SizeConstraint();
	}
	public function setConstraints () {
		var c = client.sizeConstraint;
		c.width.min = 10;
		c.width.max = 1000000;
	}
	
	public function testSetWidth () {
		client.width = nextNum++;
	}
	
	public function testSetX () {
		client.x = nextNum++;
	}
	
	public function testSetLeft () {
		client.bounds.left = nextNum++;
	}
	
	public function testSetRight () {
		client.bounds.right = nextNum++;
	}
	
	public function testSetPosConstrains () {
		client.bounds.constraint = new BindableBox();
	}
	
	public function testGetWidth () {
		var a = client.width;
	}
	
	public function setMaxWidth () {
		client.sizeConstraint.width.max++;
	}
	
	public function initAspectRatio () {
		client.width	= 500;
		client.height	= 300;
		client.maintainAspectRatio = true;
	}
	
	public function testAspectRatio () {
		client.width++;
	}
}


class ManualLayoutClientTest
{
	public var nextNum	: Float;
	public var client : ManualLayoutClient;
	
	public function new ()			{ nextNum = 1; }
	public function testCreate ()	{ client = new ManualLayoutClient(); }
	
	public function testSetWidth () {
		client.width = nextNum++;
	}
	
	public function testGetWidth () {
		var a = client.width;
	}
}



class ManualLayoutClient
{
	
	public static inline var WIDTH_CHANGED		= 1;
	public static inline var HEIGHT_CHANGED		= 2;
	public static inline var X_CHANGED			= 4;
	public static inline var Y_CHANGED			= 8;
	public static inline var INCLUDE_CHANGED	= 16;
	
	public var width	(default, setWidth)		: Float;
	public var height	(default, setHeight)	: Float;
	public var x		(default, setX)			: Float;
	public var y		(default, setY)			: Float;
	
	public var maxWidth		(default, setMaxWidth)			: Float;
	public var maxHeight	(default, setMaxHeight)			: Float;
	public var minWidth		(default, setMinWidth)			: Float;
	public var minHeight	(default, setMinHeight)			: Float;
	
	private var rangedWidth		(default, null)				: RangedFloat; // RangedNumber < Float >;
	private var rangedHeight	(default, null)				: RangedFloat; // RangedNumber < Float >;
	
	public var events			(default, null)				: LayoutEvents;
	public var changes 			(default, setChanges)		: Int;
	
	public function new ()
	{
		events			= new LayoutEvents();
		rangedWidth		= new RangedFloat(0, 0);
		rangedHeight	= new RangedFloat(0, 0);
		width	= 0;
		height	= 0;
		x		= 0;
		y		= 0;
	}
	
	
//	private inline function setWidth (v)	{ return width = v; }
//	private inline function setHeight (v)	{ return width = v; }
//	private inline function setX (v)		{ return width = v; }
//	private inline function setY (v)		{ return width = v; }
	
	
	private inline function setX (v:Float)
	{
		if (x != v) {
			x = v;
			changes = changes.set( X_CHANGED );
		}
		return v;
	}
	
	private inline function setY (v:Float)
	{
		if (y != v) {
			y = v;
			changes = changes.set( Y_CHANGED );
		}
		return v;
	}
	
	
	private function setWidth (v:Float)
	{
		if (v != width) {
			width	= rangedWidth.value = v;
			changes	= changes.set( WIDTH_CHANGED );
		}
		return width;
	}
	
	
	private function setHeight (v:Float)
	{
		if (v != height) {
			height	= rangedHeight.value = v;
			changes	= changes.set( HEIGHT_CHANGED );
		}
		return height;
	}
	
	
	private function setMaxWidth (v:Float)
	{
		if (v != maxWidth) {
			maxWidth	= rangedWidth.max = v;
			width		= rangedWidth.value;
		}
		return maxWidth;
	}
	
	
	private function setMaxHeight (v:Float)
	{
		if (v != maxHeight) {
			maxHeight	= rangedHeight.max = v;
			height		= rangedHeight.value;
		}
		return maxHeight;
	}
	
	
	private function setMinWidth (v:Float)
	{
		if (v != minWidth) {
			minWidth	= rangedWidth.min = v;
			width		= rangedWidth.value;
		}
		return minWidth;
	}
	
	
	private function setMinHeight (v:Float)
	{
		if (v != minHeight) {
			minHeight	= rangedHeight.min = v;
			height		= rangedHeight.value;
		}
		return minHeight;
	}
	
	
	private inline function setChanges (v:Int)
	{
		var oldVal	= v;
		changes		= v;
		if (changes > 0) {
		//	if (parent != null)
		//		parent.invalidate( changes );
			
		//	else if (validateOnPropertyChange)
				validate();
			
		//	if (oldVal == 0)
		//		events.invalidated.send();
		}
		return changes;
	}
	
	
	public function validate () {
		if (changes == 0)
			return;
		
		if (changes.has(WIDTH_CHANGED) || changes.has(HEIGHT_CHANGED))
			events.sizeChanged.send();
		
		if (changes.has(X_CHANGED) || changes.has(Y_CHANGED))
			events.posChanged.send();
		
		(untyped this).changes = 0;
	}
}






class SimpleManualLayoutClientTest
{
	public var nextNum	: Float;
	public var client	: SimpleManualLayoutClient;
	
	public function new ()			{ nextNum = 1; }
	public function testCreate ()	{ client = new SimpleManualLayoutClient(); }
	
	public function testSetWidth () {
		client.width = nextNum++;
	}
	
	public function testGetWidth () {
		var a = client.width;
	}
}



class SimpleManualLayoutClient
{
	
	public static inline var WIDTH_CHANGED		= 1;
	public static inline var HEIGHT_CHANGED		= 2;
	public static inline var X_CHANGED			= 4;
	public static inline var Y_CHANGED			= 8;
	public static inline var INCLUDE_CHANGED	= 16;
	
	public var width	(default, setWidth)		: Float;
	public var height	(default, setHeight)	: Float;
	public var x		(default, setX)			: Float;
	public var y		(default, setY)			: Float;
	
	public var events			(default, null)				: LayoutEvents;
	public var changes 			(default, setChanges)		: Int;
	
	public function new ()
	{
		events			= new LayoutEvents();
		width	= 0;
		height	= 0;
		x		= 0;
		y		= 0;
	}
	
	private inline function setX (v:Float)
	{
		if (x != v) {
			x = v;
			changes = changes.set( X_CHANGED );
		}
		return v;
	}
	
	private inline function setY (v:Float)
	{
		if (y != v) {
			y = v;
			changes = changes.set( Y_CHANGED );
		}
		return v;
	}
	
	
	private function setWidth (v:Float)
	{
		if (v != width) {
			width	= v;
			changes	= changes.set( WIDTH_CHANGED );
		}
		return width;
	}
	
	
	private function setHeight (v:Float)
	{
		if (v != height) {
			height	= v;
			changes	= changes.set( HEIGHT_CHANGED );
		}
		return height;
	}
	
	
	private inline function setChanges (v:Int)
	{
		var oldVal	= v;
		changes		= v;
		if (changes > 0) {
		//	if (parent != null)
		//		parent.invalidate( changes );
			
		//	else if (validateOnPropertyChange)
				validate();
			
		//	if (oldVal == 0)
		//		events.invalidated.send();
		}
		return changes;
	}
	
	
	public function validate () {
		if (changes == 0)
			return;
		
		if (changes.has(WIDTH_CHANGED) || changes.has(HEIGHT_CHANGED))
			events.sizeChanged.send();
		
		if (changes.has(X_CHANGED) || changes.has(Y_CHANGED))
			events.posChanged.send();
		
		(untyped this).changes = 0;
	}
}








class ManualIntLayoutClientTest
{
	public var nextNum	: Int;
	public var client : ManualIntLayoutClient;
	
	public function new ()			{ nextNum = 1; }
	public function testCreate ()	{ client = new ManualIntLayoutClient(); }
	
	public function testSetWidth () {
		client.width = nextNum++;
	}
	
	public function testGetWidth () {
		var a = client.width;
	}
}



class ManualIntLayoutClient
{
	public static inline var WIDTH_CHANGED		= 1;
	public static inline var HEIGHT_CHANGED		= 2;
	public static inline var X_CHANGED			= 4;
	public static inline var Y_CHANGED			= 8;
	public static inline var INCLUDE_CHANGED	= 16;
	
	public var width	(default, setWidth)		: Int;
	public var height	(default, setHeight)	: Int;
	public var x		(default, setX)			: Int;
	public var y		(default, setY)			: Int;
	
	public var maxWidth		(default, setMaxWidth)			: Int;
	public var maxHeight	(default, setMaxHeight)			: Int;
	public var minWidth		(default, setMinWidth)			: Int;
	public var minHeight	(default, setMinHeight)			: Int;
	
	private var rangedWidth		(default, null)				: RangedInt; // RangedNumber < Float >;
	private var rangedHeight	(default, null)				: RangedInt; // RangedNumber < Float >;
	
	public var events			(default, null)				: LayoutEvents;
	public var changes 			(default, setChanges)		: Int;
	
	public function new ()
	{
		events			= new LayoutEvents();
		rangedWidth		= new RangedInt(0, 0);
		rangedHeight	= new RangedInt(0, 0);
		width	= 0;
		height	= 0;
		x		= 0;
		y		= 0;
	}
	
	
//	private inline function setWidth (v)	{ return width = v; }
//	private inline function setHeight (v)	{ return width = v; }
//	private inline function setX (v)		{ return width = v; }
//	private inline function setY (v)		{ return width = v; }
	
	
	private inline function setX (v:Int)
	{
		if (x != v) {
			x = v;
			changes = changes.set( X_CHANGED );
		}
		return v;
	}
	
	private inline function setY (v:Int)
	{
		if (y != v) {
			y = v;
			changes = changes.set( Y_CHANGED );
		}
		return v;
	}
	
	
	private function setWidth (v:Int)
	{
		if (v != width) {
			width	= rangedWidth.value = v;
			changes	= changes.set( WIDTH_CHANGED );
		}
		return width;
	}
	
	
	private function setHeight (v:Int)
	{
		if (v != height) {
			height	= rangedHeight.value = v;
			changes	= changes.set( HEIGHT_CHANGED );
		}
		return height;
	}
	
	
	private function setMaxWidth (v:Int)
	{
		if (v != maxWidth) {
			maxWidth	= rangedWidth.max = v;
			width		= rangedWidth.value;
		}
		return maxWidth;
	}
	
	
	private function setMaxHeight (v:Int)
	{
		if (v != maxHeight) {
			maxHeight	= rangedHeight.max = v;
			height		= rangedHeight.value;
		}
		return maxHeight;
	}
	
	
	private function setMinWidth (v:Int)
	{
		if (v != minWidth) {
			minWidth	= rangedWidth.min = v;
			width		= rangedWidth.value;
		}
		return minWidth;
	}
	
	
	private function setMinHeight (v:Int)
	{
		if (v != minHeight) {
			minHeight	= rangedHeight.min = v;
			height		= rangedHeight.value;
		}
		return minHeight;
	}
	
	
	private inline function setChanges (v:Int)
	{
		var oldVal	= v;
		changes		= v;
		if (changes > 0) {
		//	if (parent != null)
		//		parent.invalidate( changes );
			
		//	else if (validateOnPropertyChange)
				validate();
			
		//	if (oldVal == 0)
		//		events.invalidated.send();
		}
		return changes;
	}
	
	
	public function validate () {
		if (changes == 0)
			return;
		
		if (changes.has(WIDTH_CHANGED) || changes.has(HEIGHT_CHANGED))
			events.sizeChanged.send();
		
		if (changes.has(X_CHANGED) || changes.has(Y_CHANGED))
			events.posChanged.send();
		
		(untyped this).changes = 0;
	}
}



class RangedInt
{
	public var value	(default, setValue)		: Int;
	public var min		(default, setMin)		: Int;
	public var max		(default, setMax)		: Int;
	
	
	public function new( value, min = Number.INT_MIN, max = Number.INT_MAX ) 
	{
		this.max	= max;
		this.min	= min;
		this.value	= value;
	}
	
	
	private inline function setValue (v:Int) {
		return value = v.within( min, max );
	}
	
	
	private inline function setMin (v:Int) {
		Assert.that( v < max, "v: "+v+"; max: "+max);
		if (v != min)
		{
			min = v;
			if (value < min)
				value = min;
		}
		return v;
	}
	
	
	private inline function setMax (v:Int) {
		Assert.that( v > min, "v: "+v+"; min: "+min);
		if (v != max)
		{
			max = v;
			if (value > max)
				value = max;
		}		
		return v;
	}
}