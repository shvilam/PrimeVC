package cases;
/*
 import BenchmarkProfiler;
/*/
 import Benchmark;
//*/
 import primevc.core.geom.Point;
 

/**
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class PointVsFloatTest 
{
	public static function main ()
	{
		var bench = new Benchmark();
		
		var floatTest		= new FloatTest();
		var pointTest		= new PointTest();
		var customPointTest	= new CustomPointTest();
		var intPointTest	= new CustomIntPointTest();
		
		var group = new Comparison( "Instantiate", 10000 );
		bench.add( group );
		group.add( new Test( pointTest.init,			"Points" ) );
		group.add( new Test( floatTest.init,			"Floats" ) );
		group.add( new Test( customPointTest.init,		"Custom Points" ) );
		group.add( new Test( intPointTest.init,			"Integer Points" ) );
		
		
		group = new Comparison( "Raise one", 1000000 );
		bench.add( group );
		group.add( new Test( pointTest.raiseOne,		"Points" ) );
		group.add( new Test( floatTest.raiseOne,		"Floats" ) );
		group.add( new Test( customPointTest.raiseOne,	"Custom Points" ) );
		group.add( new Test( intPointTest.raiseOne,		"Integer Points" ) );
		
		
		group = new Comparison( "Lower one", 1000000 );
		bench.add( group );
		group.add( new Test( customPointTest.lowerOne,	"Custom Points" ) );
		group.add( new Test( intPointTest.lowerOne,		"Integer Points" ) );
		group.add( new Test( pointTest.lowerOne,		"Points" ) );
		group.add( new Test( floatTest.lowerOne,		"Floats" ) );
		
		bench.start();
	}
}



/**
 * POINT TEST
 */

class PointTest
{
	public var boundries	: PointBoundries;
	
	public function new ()		{ boundries = new PointBoundries(); }
	public function init ()		{ boundries.init(); }
	public function raiseOne ()	{ boundries.width += 0.1; }
	public function lowerOne ()	{ boundries.width -= 0.1; }
}

class PointBoundries
{
	public var size		: Point;
	public var maxSize	: Point;
	public var minSize	: Point;
	public var width	(getWidth, setWidth)	: Float;
	public var height	(getHeight, setHeight)	: Float;
	
	
	public function new () { }
	
	
	public function init () {
		size = new Point( 50, 50 );
		maxSize	= new Point( 10000, 10000 );
		minSize = new Point( 10, 10 );
	}
	
	
	private inline function getWidth ()		{ return size.x; }
	private inline function getHeight ()	{ return size.y; }
	
	
	private inline function setWidth (v:Float) {
		if (v < minSize.x)	v = minSize.x;
		if (v > maxSize.x)	v = maxSize.x;
		return size.x = v;
	}
	
	private inline function setHeight (v:Float) {
		if (v < minSize.y)	v = minSize.y;
		if (v > maxSize.y)	v = maxSize.y;
		return size.y = v;
	}
}


/**
 * FLOAT TEST
 */


class FloatTest
{
	public var boundries	: FloatBoundries;
	
	public function new ()		{  }
	public function init ()		{ boundries = new FloatBoundries();  }
	public function raiseOne ()	{ boundries.width += 0.1; }
	public function lowerOne ()	{ boundries.width -= 0.1; }
}


class FloatBoundries
{
	private var maxWidth	: Float;
	private var maxHeight	: Float;
	private var minWidth	: Float;
	private var minHeight	: Float;
	
	private var _width		: Float;
	private var _height		: Float;
	
	public var width	(getWidth, setWidth)	: Float;
	public var height	(getHeight, setHeight)	: Float;
	
	
	public function new () { }
	
	
	public function init () {
		_width		= 50;
		_height		= 50;
		maxWidth	= 10000;
		maxHeight	= 10000;
		minWidth	= 10;
		minHeight	= 10;
	}
	
	
	private inline function getWidth ()		{ return _width; }
	private inline function getHeight ()	{ return _height; }
	
	
	private inline function setWidth (v:Float) {
		if (v < minWidth)	v = minWidth;
		if (v > maxWidth)	v = maxWidth;
		return _width = v;
	}
	
	private inline function setHeight (v:Float) {
		if (v < minHeight)	v = minHeight;
		if (v > maxHeight)	v = maxHeight;
		return _height = v;
	}
}





/**
 * CLASS CUSTOM POINTS
 */

class CustomPointTest
{
	public var boundries	: CustomPointBoundries;
	
	public function new ()		{ boundries = new CustomPointBoundries(); }
	public function init ()		{ boundries.init(); }
	public function raiseOne ()	{ boundries.width += 0.1; }
	public function lowerOne ()	{ boundries.width -= 0.1; }
}

class CustomPointBoundries
{
	private var _width	: FloatBoundry;
	private var _height	: FloatBoundry;
	public var width	(getWidth, setWidth) 	: Float;
	public var height	(getHeight, setHeight)	: Float;
	
	
	public function new () { }
	
	
	public function init () {
		_width	= new FloatBoundry( 50, 10000, 10 );
		_height	= new FloatBoundry( 50, 10000, 10 );
	}
	
	
	private inline function getWidth ()		{ return _width.value; }
	private inline function getHeight ()	{ return _height.value; }
	private inline function setWidth (v)	{ return _width.value = v; }
	private inline function setHeight (v)	{ return _height.value = v; }
}

class FloatBoundry
{
	public static inline var MAX_VALUE:Float	= 2147483647;
	public static inline var MIN_VALUE:Float	= -2147483647;
	
	public var value	(default, setValue)		: Float;
	public var max		(default, setMax)		: Float;
	public var min		(default, setMin)		: Float;
	
	
	public function new (value:Float = 0, minValue:Float = MIN_VALUE, maxValue:Float = MAX_VALUE)
	{
		this.value	= value;
		this.min	= min;
		this.max	= max;
	}
	
	
	private inline function setValue (v) {
		if (v < min)	v = min;
		if (v > max)	v = max;
		return this.value = v;
	}
	
	
	private inline function setMax (v) {
		if (v < min)	v = min;
		if (value > v)	value = v;
		return this.max = v;
	}
	
	
	private inline function setMin (v) {
		if (v > max)	v = max;
		if (value < v)	value = v;
		return this.min = v;
	}
}





/**
 * CLASS CUSTOM INT POINTS
 */

class CustomIntPointTest
{
	public var boundries	: CustomIntBoundries;
	
	public function new ()		{ boundries = new CustomIntBoundries(); }
	public function init ()		{ boundries.init(); }
	public function raiseOne ()	{ boundries.width++; }
	public function lowerOne ()	{ boundries.width--; }
}

class CustomIntBoundries
{
	private var _width	: IntBoundry;
	private var _height	: IntBoundry;
	public var width	(getWidth, setWidth) 	: Int;
	public var height	(getHeight, setHeight)	: Int;
	
	
	public function new () { }
	
	
	public function init () {
		_width	= new IntBoundry( 50, 10000, 10 );
		_height	= new IntBoundry( 50, 10000, 10 );
	}
	
	
	private inline function getWidth ()		{ return _width.value; }
	private inline function getHeight ()	{ return _height.value; }
	private inline function setWidth (v)	{ return _width.value = v; }
	private inline function setHeight (v)	{ return _height.value = v; }
}


class IntBoundry
{
	public static inline var MAX_VALUE:Int	= 2147483647;
	public static inline var MIN_VALUE:Int	= -2147483647;
	
	public var value	(default, setValue)		: Int;
	public var max		(default, setMax)		: Int;
	public var min		(default, setMin)		: Int;
	
	
	public function new (value:Int = 0, minValue:Int = MIN_VALUE, maxValue:Int = MAX_VALUE)
	{
		this.value	= value;
		this.min	= min;
		this.max	= max;
	}
	
	
	private inline function setValue (v) {
		if (v < min)	v = min;
		if (v > max)	v = max;
		return this.value = v;
	}
	
	
	private inline function setMax (v) {
		if (v < min)	v = min;
		if (value > v)	value = v;
		return this.max = v;
	}
	
	
	private inline function setMin (v) {
		if (v > max)	v = max;
		if (value < v)	value = v;
		return this.min = v;
	}
}


