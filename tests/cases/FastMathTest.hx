package cases;
 import apparat.math.FastMath;
 import primevc.utils.NumberMath;
 import Benchmark;



/**
 * @author Ruben Weijers
 * @creation-date Dec 16, 2010
 */
class FastMathTest extends Benchmark
{
	public static function main ()	{ new FastMathTest().start(); }
	
	
	public function new ()
	{
		super();
		
		Assert.equal( Math.round(.5)  , 1 );
		Assert.equal( Math.round(.3)  , 0 );
		Assert.equal( Math.round(.1)  , 0 );
		Assert.equal( Math.round(.6)  , 1 );
		Assert.equal( Math.round(-.5) , 0 );
		Assert.equal( Math.round(-.3) , 0 );
		Assert.equal( Math.round(-.6) , -1 );
		
		Assert.equal( IntMath.roundFloat(.5)  , 1 );
		Assert.equal( IntMath.roundFloat(.3)  , 0 );
		Assert.equal( IntMath.roundFloat(.1)  , 0 );
		Assert.equal( IntMath.roundFloat(.6)  , 1 );
		Assert.equal( IntMath.roundFloat(-.5) , -1 );
		Assert.equal( IntMath.roundFloat(-.3) , 0 );
		Assert.equal( IntMath.roundFloat(-.6) , -1 );
		
		Assert.equal( Math.floor(.5)  , 0 );
		Assert.equal( Math.floor(.3)  , 0 );
		Assert.equal( Math.floor(.1)  , 0 );
		Assert.equal( Math.floor(.6)  , 0 );
		Assert.equal( Math.floor(-.5) , -1 );
		Assert.equal( Math.floor(-.3) , -1 );
		Assert.equal( Math.floor(-.6) , -1 );
		Assert.equal( Math.floor(-2) , -2 );
		Assert.equal( Math.floor(-2.1) , -3 );
		
		Assert.equal( IntMath.floorFloat(.5)  , 0 );
		Assert.equal( IntMath.floorFloat(.3)  , 0 );
		Assert.equal( IntMath.floorFloat(.1)  , 0 );
		Assert.equal( IntMath.floorFloat(.6)  , 0 );
		Assert.equal( IntMath.floorFloat(-.5) , -1 );
		Assert.equal( IntMath.floorFloat(-.3) , -1 );
		Assert.equal( IntMath.floorFloat(-.6) , -1 );
		Assert.equal( IntMath.floorFloat(-2) , -2 );
		Assert.equal( IntMath.floorFloat(-2.1) , -3 );
		
		var group = new Comparison( "divide by two", 1000000 );
		add( group );
		group.add( new Test( divideByDividing,		"dividing by 2") );
		group.add( new Test( divideByMultiplying,	"times .5") );
		group.add( new Test( divideByBitshifting,	"bitshifting") );
		
		var group = new Comparison( "compare round", 100000 );
		add( group );
		group.add( new Test( roundFlash,		"Flash") );
		group.add( new Test( roundNumberMath,	"NumberMath") );
		group.add( new Test( roundCustom1,		"Custom1") );
		group.add( new Test( roundCustom2,		"Custom2") );
		
		var group = new Comparison( "compare ceil", 100000 );
		add( group );
		group.add( new Test( ceilFlash,			"Flash") );
		group.add( new Test( ceilNumberMath,	"NumberMath") );
		
		var group = new Comparison( "compare floor", 100000 );
		add( group );
		group.add( new Test( floorFlash,		"Flash") );
		group.add( new Test( floorNumberMath,	"NumberMath") );
		
		var group = new Comparison( "compare abs", 1000000 );
		add( group );
		group.add( new Test( absFlash,			"Flash") );
		group.add( new Test( absFastMath,		"FastMath") );
		group.add( new Test( absCustom,			"Custom") );
		
		var group = new Comparison( "compare sin", 100000 );
		add( group );
		group.add( new Test( sinFlash,			"Flash") );
		group.add( new Test( sinFastMath,		"FastMath") );
		
		var group = new Comparison( "compare cos", 100000 );
		add( group );
		group.add( new Test( cosFlash,			"Flash") );
		group.add( new Test( cosFastMath,		"FastMath") );
		
		var group = new Comparison( "compare atan2", 100000 );
		add( group );
		group.add( new Test( atan2Flash,		"Flash") );
		group.add( new Test( atan2FastMath,		"FastMath") );
		
		var group = new Comparison( "compare sqrt", 100000 );
		add( group );
		group.add( new Test( sqrtFlash,			"Flash") );
		group.add( new Test( sqrtFastMath,		"FastMath") );
		
		var group = new Comparison( "compare sign", 1000000 );
		add( group );
		group.add( new Test( signCustom,		"Custom") );
		group.add( new Test( signFastMath,		"FastMath") );
	}
	
	
	public function divideByDividing ()		{ var a = Std.int(12400 / 2); var b = Std.int(45327923 / 2); var c = Std.int(859406 / 2); }
	public function divideByMultiplying ()	{ var a = Std.int(12400 * .5); var b = Std.int(45327923 * .5); var c = Std.int(859406 *.5); }
	public function divideByBitshifting ()	{ var a = 12400 >> 1; var b = 45327923 >> 1; var c = 859406 >> 1; }
	
	
	
	public function roundFlash ()
	{
		Math.round( -.1 );
		Math.round( -.2 );
		Math.round( -.3 );
		Math.round( -.4 );
		Math.round( -.5 );
		Math.round( -.6 );
		Math.round( -.7 );
		Math.round( -.8 );
		Math.round( -.9 );
		Math.round( -1 );
		Math.round( 0 );
		Math.round( .1 );
		Math.round( .2 );
		Math.round( .3 );
		Math.round( .4 );
		Math.round( .5 );
		Math.round( .6 );
		Math.round( .7 );
		Math.round( .8 );
		Math.round( .9 );
		Math.round( 1 );
	}
	
	
	public function roundNumberMath ()
	{
		IntMath.roundFloat( -.1 );
		IntMath.roundFloat( -.2 );
		IntMath.roundFloat( -.3 );
		IntMath.roundFloat( -.4 );
		IntMath.roundFloat( -.5 );
		IntMath.roundFloat( -.6 );
		IntMath.roundFloat( -.7 );
		IntMath.roundFloat( -.8 );
		IntMath.roundFloat( -.9 );
		IntMath.roundFloat( -1 );
		IntMath.roundFloat( 0 );
		IntMath.roundFloat( .1 );
		IntMath.roundFloat( .2 );
		IntMath.roundFloat( .3 );
		IntMath.roundFloat( .4 );
		IntMath.roundFloat( .5 );
		IntMath.roundFloat( .6 );
		IntMath.roundFloat( .7 );
		IntMath.roundFloat( .8 );
		IntMath.roundFloat( .9 );
		IntMath.roundFloat( 1 );
	}
	
	private inline function customRoundF1 (val:Float) : Float
	{
		return val < 0 ? IntMath.ceilFloat( val - .5 ) : IntMath.floorFloat( val + .5 );
	}
	
	private inline function customRoundF2 (val:Float) : Float
	{
		return val < 0 ? -1 * IntMath.floorFloat( -1 * val + .5) : IntMath.floorFloat(val+.5);
	}
	
	
	public function roundCustom1 ()
	{
		customRoundF1( -.1 );
		customRoundF1( -.2 );
		customRoundF1( -.3 );
		customRoundF1( -.4 );
		customRoundF1( -.5 );
		customRoundF1( -.6 );
		customRoundF1( -.7 );
		customRoundF1( -.8 );
		customRoundF1( -.9 );
		customRoundF1( -1 );
		customRoundF1( 0 );
		customRoundF1( .1 );
		customRoundF1( .2 );
		customRoundF1( .3 );
		customRoundF1( .4 );
		customRoundF1( .5 );
		customRoundF1( .6 );
		customRoundF1( .7 );
		customRoundF1( .8 );
		customRoundF1( .9 );
		customRoundF1( 1 );
	}
	
	
	public function roundCustom2 ()
	{
		customRoundF2( -.1 );
		customRoundF2( -.2 );
		customRoundF2( -.3 );
		customRoundF2( -.4 );
		customRoundF2( -.5 );
		customRoundF2( -.6 );
		customRoundF2( -.7 );
		customRoundF2( -.8 );
		customRoundF2( -.9 );
		customRoundF2( -1 );
		customRoundF2( 0 );
		customRoundF2( .1 );
		customRoundF2( .2 );
		customRoundF2( .3 );
		customRoundF2( .4 );
		customRoundF2( .5 );
		customRoundF2( .6 );
		customRoundF2( .7 );
		customRoundF2( .8 );
		customRoundF2( .9 );
		customRoundF2( 1 );
	}
	
	
	public function ceilFlash ()
	{
		Math.ceil( -.1 );
		Math.ceil( -.2 );
		Math.ceil( -.3 );
		Math.ceil( -.4 );
		Math.ceil( -.5 );
		Math.ceil( -.6 );
		Math.ceil( -.7 );
		Math.ceil( -.8 );
		Math.ceil( -.9 );
		Math.ceil( -1 );
		Math.ceil( 0 );
		Math.ceil( .1 );
		Math.ceil( .2 );
		Math.ceil( .3 );
		Math.ceil( .4 );
		Math.ceil( .5 );
		Math.ceil( .6 );
		Math.ceil( .7 );
		Math.ceil( .8 );
		Math.ceil( .9 );
		Math.ceil( 1 );
	}
	
	
	public function ceilNumberMath ()
	{
		IntMath.ceilFloat( -.1 );
		IntMath.ceilFloat( -.2 );
		IntMath.ceilFloat( -.3 );
		IntMath.ceilFloat( -.4 );
		IntMath.ceilFloat( -.5 );
		IntMath.ceilFloat( -.6 );
		IntMath.ceilFloat( -.7 );
		IntMath.ceilFloat( -.8 );
		IntMath.ceilFloat( -.9 );
		IntMath.ceilFloat( -1 );
		IntMath.ceilFloat( 0 );
		IntMath.ceilFloat( .1 );
		IntMath.ceilFloat( .2 );
		IntMath.ceilFloat( .3 );
		IntMath.ceilFloat( .4 );
		IntMath.ceilFloat( .5 );
		IntMath.ceilFloat( .6 );
		IntMath.ceilFloat( .7 );
		IntMath.ceilFloat( .8 );
		IntMath.ceilFloat( .9 );
		IntMath.ceilFloat( 1 );
	}
	
	
	
	public function floorFlash ()
	{
		Math.floor( -.1 );
		Math.floor( -.2 );
		Math.floor( -.3 );
		Math.floor( -.4 );
		Math.floor( -.5 );
		Math.floor( -.6 );
		Math.floor( -.7 );
		Math.floor( -.8 );
		Math.floor( -.9 );
		Math.floor( -1 );
		Math.floor( 0 );
		Math.floor( .1 );
		Math.floor( .2 );
		Math.floor( .3 );
		Math.floor( .4 );
		Math.floor( .5 );
		Math.floor( .6 );
		Math.floor( .7 );
		Math.floor( .8 );
		Math.floor( .9 );
		Math.floor( 1 );
	}
	
	
	public function floorNumberMath ()
	{
		IntMath.floorFloat( -.1 );
		IntMath.floorFloat( -.2 );
		IntMath.floorFloat( -.3 );
		IntMath.floorFloat( -.4 );
		IntMath.floorFloat( -.5 );
		IntMath.floorFloat( -.6 );
		IntMath.floorFloat( -.7 );
		IntMath.floorFloat( -.8 );
		IntMath.floorFloat( -.9 );
		IntMath.floorFloat( -1 );
		IntMath.floorFloat( 0 );
		IntMath.floorFloat( .1 );
		IntMath.floorFloat( .2 );
		IntMath.floorFloat( .3 );
		IntMath.floorFloat( .4 );
		IntMath.floorFloat( .5 );
		IntMath.floorFloat( .6 );
		IntMath.floorFloat( .7 );
		IntMath.floorFloat( .8 );
		IntMath.floorFloat( .9 );
		IntMath.floorFloat( 1 );
	}
	
	
	public function absFlash ()
	{
		Math.abs( Math.random() );
		Math.abs( -1 * Math.random() );
	}
	
	
	public function absFastMath ()
	{
		FastMath.abs( Math.random() );
		FastMath.abs( -1 * Math.random() );
	}
	
	
	private inline function customAbsF (val:Float) : Float
	{
		return val < 0 ? val * -1 : val;
	}
	
	
	public function absCustom ()
	{
		customAbsF( Math.random() );
		customAbsF( -1 * Math.random() );
	}
	
	
	public function sinFlash ()
	{
		Math.sin( -.1 );
		Math.sin( -.2 );
		Math.sin( -.3 );
		Math.sin( -.4 );
		Math.sin( -.5 );
		Math.sin( -.6 );
		Math.sin( -.7 );
		Math.sin( -.8 );
		Math.sin( -.9 );
		Math.sin( -1 );
		Math.sin( 0 );
		Math.sin( .1 );
		Math.sin( .2 );
		Math.sin( .3 );
		Math.sin( .4 );
		Math.sin( .5 );
		Math.sin( .6 );
		Math.sin( .7 );
		Math.sin( .8 );
		Math.sin( .9 );
		Math.sin( 1 );
	}
	
	
	public function sinFastMath ()
	{
		FastMath.sin( -.1 );
		FastMath.sin( -.2 );
		FastMath.sin( -.3 );
		FastMath.sin( -.4 );
		FastMath.sin( -.5 );
		FastMath.sin( -.6 );
		FastMath.sin( -.7 );
		FastMath.sin( -.8 );
		FastMath.sin( -.9 );
		FastMath.sin( -1 );
		FastMath.sin( 0 );
		FastMath.sin( .1 );
		FastMath.sin( .2 );
		FastMath.sin( .3 );
		FastMath.sin( .4 );
		FastMath.sin( .5 );
		FastMath.sin( .6 );
		FastMath.sin( .7 );
		FastMath.sin( .8 );
		FastMath.sin( .9 );
		FastMath.sin( 1 );
	}
	
	
	public function cosFlash ()
	{
		Math.cos( -.1 );
		Math.cos( -.2 );
		Math.cos( -.3 );
		Math.cos( -.4 );
		Math.cos( -.5 );
		Math.cos( -.6 );
		Math.cos( -.7 );
		Math.cos( -.8 );
		Math.cos( -.9 );
		Math.cos( -1 );
		Math.cos( 0 );
		Math.cos( .1 );
		Math.cos( .2 );
		Math.cos( .3 );
		Math.cos( .4 );
		Math.cos( .5 );
		Math.cos( .6 );
		Math.cos( .7 );
		Math.cos( .8 );
		Math.cos( .9 );
		Math.cos( 1 );
	}
	
	
	public function cosFastMath ()
	{
		FastMath.cos( -.1 );
		FastMath.cos( -.2 );
		FastMath.cos( -.3 );
		FastMath.cos( -.4 );
		FastMath.cos( -.5 );
		FastMath.cos( -.6 );
		FastMath.cos( -.7 );
		FastMath.cos( -.8 );
		FastMath.cos( -.9 );
		FastMath.cos( -1 );
		FastMath.cos( 0 );
		FastMath.cos( .1 );
		FastMath.cos( .2 );
		FastMath.cos( .3 );
		FastMath.cos( .4 );
		FastMath.cos( .5 );
		FastMath.cos( .6 );
		FastMath.cos( .7 );
		FastMath.cos( .8 );
		FastMath.cos( .9 );
		FastMath.cos( 1 );
	}
	
	
	
	public function atan2Flash ()
	{
		Math.atan2( -.1, -.5 );
		Math.atan2( -.2, -.5 );
		Math.atan2( -.3, -.5 );
		Math.atan2( -.4, -.5 );
		Math.atan2( -.5, -.5 );
		Math.atan2( -.6, -.5 );
		Math.atan2( -.7, -.5 );
		Math.atan2( -.8, -.5 );
		Math.atan2( -.9, -.5 );
		Math.atan2( -1, -.5 );
		Math.atan2( 0, 0 );
		Math.atan2( .1, .5 );
		Math.atan2( .2, .5 );
		Math.atan2( .3, .5 );
		Math.atan2( .4, .5 );
		Math.atan2( .5, .5 );
		Math.atan2( .6, .5 );
		Math.atan2( .7, .5 );
		Math.atan2( .8, .5 );
		Math.atan2( .9, .5 );
		Math.atan2( 1, .5 );
	}
	
	
	public function atan2FastMath ()
	{
		FastMath.atan2( -.1, -.5 );
		FastMath.atan2( -.2, -.5 );
		FastMath.atan2( -.3, -.5 );
		FastMath.atan2( -.4, -.5 );
		FastMath.atan2( -.5, -.5 );
		FastMath.atan2( -.6, -.5 );
		FastMath.atan2( -.7, -.5 );
		FastMath.atan2( -.8, -.5 );
		FastMath.atan2( -.9, -.5 );
		FastMath.atan2( -1, -.5 );
		FastMath.atan2( 0, 0 );
		FastMath.atan2( .1, .5 );
		FastMath.atan2( .2, .5 );
		FastMath.atan2( .3, .5 );
		FastMath.atan2( .4, .5 );
		FastMath.atan2( .5, .5 );
		FastMath.atan2( .6, .5 );
		FastMath.atan2( .7, .5 );
		FastMath.atan2( .8, .5 );
		FastMath.atan2( .9, .5 );
		FastMath.atan2( 1, .5 );
	}
	
	
	public function sqrtFlash ()
	{
		Math.sqrt( 0 );
		Math.sqrt( 1 );
		Math.sqrt( 2 );
		Math.sqrt( 4 );
		Math.sqrt( 8 );
		Math.sqrt( 16 );
		Math.sqrt( 32 );
		Math.sqrt( 64 );
		Math.sqrt( 128 );
		Math.sqrt( 256 );
		Math.sqrt( 512 );
		Math.sqrt( 1024 );
		Math.sqrt( 2048 );
		Math.sqrt( 3 );
		Math.sqrt( 7 );
		Math.sqrt( 15 );
		Math.sqrt( 31 );
		Math.sqrt( 63 );
		Math.sqrt( 127 );
		Math.sqrt( 255 );
		Math.sqrt( 511 );
		Math.sqrt( 1023 );
		Math.sqrt( 2047 );
	}
	
	
	public function sqrtFastMath ()
	{
		FastMath.sqrt( 0 );
		FastMath.sqrt( 1 );
		FastMath.sqrt( 2 );
		FastMath.sqrt( 4 );
		FastMath.sqrt( 8 );
		FastMath.sqrt( 16 );
		FastMath.sqrt( 32 );
		FastMath.sqrt( 64 );
		FastMath.sqrt( 128 );
		FastMath.sqrt( 256 );
		FastMath.sqrt( 512 );
		FastMath.sqrt( 1024 );
		FastMath.sqrt( 2048 );
		FastMath.sqrt( 3 );
		FastMath.sqrt( 7 );
		FastMath.sqrt( 15 );
		FastMath.sqrt( 31 );
		FastMath.sqrt( 63 );
		FastMath.sqrt( 127 );
		FastMath.sqrt( 255 );
		FastMath.sqrt( 511 );
		FastMath.sqrt( 1023 );
		FastMath.sqrt( 2047 );
	}
	
	
	private inline function customSignF (val:Float) : Float
	{
		return val < 0 ? -1.0 : 1.0;
	}
	
	public function signCustom ()
	{
		customSignF( -3 );
		customSignF( 3 );
	}
	
	
	public function signFastMath ()
	{
		FastMath.sign( -3 );
		FastMath.sign( 3 );
	}
}
