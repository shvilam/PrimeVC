package cases;
 import flash.Vector;
 import primevc.utils.MacroUtils;


/**
 * @author Ruben Weijers
 * @creation-date May 17, 2011
 */
class MacroTests
{
	public static function main ()
	{
		trace(" BEGIN  ");
		var b = new Test3();
		trace("=== traceValues");
		b.traceFields();
		trace("=== autoTraceMe");
	//	b.traceMe("blaaaaaaaa");
		trace("=== dispose");
		b.dispose();
		trace("=== traceValues");
		b.traceFields();
		trace("=== finish"); //*/
	}
}


interface IDisposable
{
	public function dispose() : Void;
}

interface IClient<T> implements IDisposable {
	public var list : Vector<T>;
}
interface IClient2 {}
class Client<T> implements IClient<T>, implements IClient2, implements haxe.rtti.Generic
{
	public var val (default, null) : Int;
	public var list : Vector<T>;
	
	public function new ()				{ this.val = Test1.counter++; list = new Vector<T>(); }
	public function dispose ()			{ this.val = -1; }
	public function toString ()			{ return ""+val; }
	public function traceMe(v:String)	{ trace(val+" - "+v); }
}

class A {}

/*@:build(primevc.utils.MacroUtils.autoDispose())
@:build(primevc.utils.MacroUtils.autoTraceFields())
@:build(primevc.utils.MacroUtils.autoTraceMe())*/
/*@:build(primevc.utils.MacroUtils.autoInstantiate("IDisposable", "Client"))
@:autoBuild(primevc.utils.MacroUtils.autoDispose())
@:autoBuild(primevc.utils.MacroUtils.autoTraceMe())
@:autoBuild(primevc.utils.MacroUtils.autoTraceFields())
@:autoBuild(primevc.utils.MacroUtils.autoInstantiate("IDisposable", "Client"))
class Test0
{
	public function new() {}
}*/
@:build(primevc.utils.MacroUtils.autoDispose())
@:build(primevc.utils.MacroUtils.autoTraceFields())
//@:build(primevc.utils.MacroUtils.autoTraceMe())
@:build(primevc.utils.MacroUtils.autoInstantiate("IDisposable", "Client"))
@:autoBuild(primevc.utils.MacroUtils.autoDispose())
//@:autoBuild(primevc.utils.MacroUtils.autoTraceMe())
@:autoBuild(primevc.utils.MacroUtils.autoTraceFields())
@:autoBuild(primevc.utils.MacroUtils.autoInstantiate("IDisposable", "Client"))
class Test1 //extends Test0
{
	public static var counter = 1;
	
	@manual public var clientA	: Client<Int>;
	public  var clientB	: IClient<String>;
	public  var clientC	: IClient<A>;
	private var clientD : Client<Bool>;
	public  var clientE	: IClient<A>;
	public  var testStr	: String;
	public function new () {}
//	public function new () { clientA = new Client(); testStr = "blaat1"; }
//	public function traceFields() {}
	
}

class Test2 extends Test1
{
	public var clientF : IClient<A>;
	public function new ()	{ super(); }
}

class Test3 extends Test2 {}





/*
@:autoBuild(primevc.utils.MacroUtils.autoBuildTest())
class Foo
{
	public var a : Test;
	public function new ()		{ a = new Test("test1"); }
	public function test ()		{ MacroUtils.testMacro(); }
}

class Bar extends Foo
{
	public var b : Test;
	public function new ()		{ super(); b = new Test("test2"); }
}


interface ITest {}
class Test implements ITest
{
	public var name : String;
	public function new (name:String) { this.name = name; }
}
*/

/*class MacroUtil
{
	@:macro public static function testMacro () : Expr
	{
		var local = Context.getLocalClass().get();
		var fields = local.fields.get();
		
		for (field in fields)
			switch (field.kind) {
				case FVar(read, write):
					switch (field.type) {
						case TInst(t, params): 
							trace(t.get().interfaces);
						default:
					}
				default:
			}
		
		return {expr: EBlock([]), pos: Context.currentPos() }
	}
	
	@:macro public static function autoBuildTest () : Array<Field>
	{
		trace(Context.getLocalClass().get().name);
		return Context.getBuildFields();
	}
}*/
