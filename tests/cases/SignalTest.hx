package cases;
 import Benchmark;
 import primevc.core.dispatcher.Signal;
 import primevc.core.dispatcher.Signals;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.dispatcher.Signal2;
 import primevc.core.dispatcher.Signal3;
 import primevc.core.dispatcher.Signal4;
  using primevc.utils.Bind;

/**
 * Tests for the Pipe sub-system
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class SignalTest implements haxe.Public
{
	static function main()
	{
		var b = new Benchmark();
		var t = new SignalTest();
		
	//	t.testSend();
		
		b.add(new Test(t.testCreate,			"Create Signals",		1000000));
		b.add(new Test(t.testCreateEmptyClass,	"Create Empty class",	1000000));
		t.setup();
		b.add(new Test(t.testSend,				"Send Signals",			100000));
		t.setup();
		b.add(new Test(t.testUnbind,			"Unbind Signals",		100000));
		b.start();
	}
	
	
	var d1 : Signal1<String>;
	var d2 : Signal1<String>;
	var d3 : Signal0;
	
	function new() : Void {
		voidCalled = 0;
		d1Called = 0;
		d2Called = 0;
		d3Called = 0;
		d4Called = 0;
	}
	
	function setup() {
		testCreate();
		d1.observe(this,d4Handler);
		d2.on(d1, this);
		d3.on(d2, this);
		voidHandler.on(d3, this);
		d1Handler.on(d1, this);
		d2Handler.on(d1, this);
		d3Handler.onceOn(d1, this);
		d4Handler.onceOn(d1, this);
	}
	
	function testCreateEmptyClass ()
	{
		var a = new EmptyClass();
		var b = new EmptyClass();
		var c = new EmptyClass();
	}
	
	function testCreate () {
		d1 = new Signal1();
		d2 = new Signal1();
		d3 = new Signal0();
	}
	
	function testSend() {
		d1.send("one");
		d1.send("two");
	}
	
	function testUnbind() : Void {
	//	function(str:String) { trace("anon: "+str); }.on(d2, this);

		// Dispose Bindings to test freelist
		d1.unbind(this);
		d2.unbind(this);
		d3.unbind(this);
	}
	
	var voidCalled : Int;
	function voidHandler() : Int {
		voidCalled++;
	//	trace("void!");
		return 0;
	}
	
	var d1Called : Int;
	function d1Handler(str:String) {
		d1Called++;
	//	trace("d1: "+str);
	}
	
	var d2Called : Int;
	function d2Handler(str:String) : String {
		d2Called++;
	//	trace("d2: "+str);
		return str;
	}
	
	var d3Called : Int;
	function d3Handler(str:String) {
		d3Called++;
	//	trace("d3 once! "+str);
	}
	
	var d4Called : Int;
	function d4Handler() {
		d4Called++;
	//	trace("d4 once!");
	}
}


class Pipes extends Signals
{
	var on	: Signal0;
	var off	: Signal1<String>;
	
	var two : Signal2<Int,String>;
	var thr : Signal3<Int,String,Pipes>;
	var fur : Signal4<Pipes,Pipes,String,Pipes>;
	
	public function new() {
		super();
		on = new Signal0();
		off = new Signal1();
		
		two = new Signal2();
		thr = new Signal3();
		fur = new Signal4();
	}
}


class EmptyClass
{
	public function new () {}
}

/*
interface ProxyingSignal
{
	
}

class Test implements ProxyingSignal
{
	var flags : Int;
	
	static public function main(){
		trace("TEST");
		new Test();
	}
	
	function new() {
		for (i in 0 ... 3) test_is();
		for (i in 0 ... 3) test_hasLinkEnabled();
	}
	
	function test_is()
	{
		trace("is()");
		var start = flash.Lib.getTimer();
		var obj = this;
		var x = 0;
		
		for (i in 0...1000000) {
			if (untyped __is__(obj, ProxyingSignal))
			{
				var p:ProxyingSignal = cast obj;
				++x;
			}
		}
		
		var end = flash.Lib.getTimer();
		trace(end - start);
	}
	
	function test_hasLinkEnabled()
	{
		trace("try");
		var start = flash.Lib.getTimer();
		var obj = this;
		var x= 0;
		
		for (i in 0...1000000)
		{
			var o:ProxyingSignal = untyped __as__(obj, ProxyingSignal);
			if (o != null) ++x;
		}
		
		var end = flash.Lib.getTimer();
		trace(end - start);
	}
	
}

class FunctionCallTest
{
	static public function main(){
		trace("TEST");
		new FunctionCallTest();
	}
	
	function new() {
		fn1 = handler;
		fn2 = handler;
		
		for (i in 0 ... 3) dynamic_();
		for (i in 0 ... 3) baseline();
	}
	
	var fn1 : FunctionCallTest -> FunctionCallTest -> FunctionCallTest -> FunctionCallTest -> Void;
	var fn2 : Dynamic;
	
	function baseline()
	{
		trace("baseline");
		var start = flash.Lib.getTimer();
		var obj = this;
		var ar = fn1;
		
		for (i in 0...8000000) {
			handler(obj, obj, obj, obj);
		}
		
		var end = flash.Lib.getTimer();
		trace(end - start);
	}
	
 	function dynamic_()
	{
		trace("dynamic");
		var start = flash.Lib.getTimer();
		var obj = this;
		
		for (i in 0...8000000) {
			fn2(obj, obj, obj, obj);
		}
		
		var end = flash.Lib.getTimer();
		trace(end - start);
	}
	
	function handler(a,b,c,d);
}
*/