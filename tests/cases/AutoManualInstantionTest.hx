package cases;
 import Benchmark;
 import flash.Vector;


/**
 * Description
 * 
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
class AutoManualInstantionTest 
{
	public static function main ()
	{
		var bench = new Benchmark();
		
		var test1 = new ManualFSM();
		var test2 = new TestAutoFSM();
		var test3 = new TestShortAutoFSM();
		var test4 = new TestShortAutoFSM2();
		
		var group = new Comparison( "Instantiate", 20000 );
		bench.add( group );
		
		group.add( new Test( test2.init, "Auto FSM") );
		group.add( new Test( test3.init, "Short Auto FSM1") );
		group.add( new Test( test4.init, "Short Auto FSM2") );
		group.add( new Test( test1.init, "Manual FSM") );
		
		bench.start();
		
	//	new AutoManualInstantionTest();
	}
	
/*	public function new ()
	{
		var test1 = new ManualFSM();
		var test2 = new TestAutoFSM();
		var test3 = new TestShortAutoFSM();
		
		test1.init();
		test2.init();
		test3.init();
		
		trace("test1 " + test1.state8.id);
		trace("test2 " + test2.state8.id);
		trace("test3 " + test3.state8.id);
	}*/
}



class State
{
	public var id:Int;
	var entering : Int;
	var exiting : Int;
	
	public function new (id:Int)
	{
		this.id = id; 
		entering = 0;
		exiting = 1;
	}
}



class TestFSM
{
	public var state0 : State;
	public var state1 : State;
	public var state2 : State;
	public var state3 : State;
	public var state4 : State;
	public var state5 : State;
	public var state6 : State;
	public var state7 : State;
	public var state8 : State;
	public var state9 : State;
	
	public var states : Vector < State >;
	
	public function new () {
	}
	
	public function init () {
		states = new Vector<State>();
	}
}



class AutoFSM implements haxe.rtti.Infos
{
	public var states : Vector < State >;
	
	public function new () {
	}
	
	public function init () {
		states						= new Vector<State>();
		var cl						= Type.getClass(this);
		var fields:Vector<String>	= untyped cl.fields;
		
		var struct	= Xml.parse(untyped cl.__rtti).firstElement().elements();
		var element:Xml;
		var prop:Xml;
		
		if (fields == null) {
			fields = untyped cl.fields = new Vector<String>();
			for (element in struct)
			{
				prop = element.firstElement();
				if (prop != null && prop.nodeName == 'c' && prop.get('path') == 'cases.State')
				{
					fields.push(element.nodeName);
					setField( element.nodeName );
				}
			}
		} else {
			for (field in fields) {
				setField( field );
			}
		}
	}
	
	private inline function setField ( name:String ) : Void {
		if (Reflect.field(this, name ) == null) {
			var state = new State( states.length );
			Reflect.setField(this, name, state);
			states.push( state );
		}
	}
}

class TestAutoFSM extends AutoFSM
{
	public var state0 : State;
	public var state1 : State;
	public var state2 : State;
	public var state3 : State;
	public var state4 : State;
	public var state5 : State;
	public var state6 : State;
	public var state7 : State;
	public var state8 : State;
	public var state9 : State;
}



class ShortAutoFSM implements haxe.rtti.Infos
{
	public var states : Vector < State >;
	
	public function new () {
	}
	
	public function init () {
		states					= new Vector<State>();
		var cl					= Type.getClass(this);
		var fi:Vector<String>	= untyped cl.fields;
		
		var st = Xml.parse(untyped cl.__rtti).firstElement().elements();
		var el:Xml;
		var pr:Xml;
		
		if (fi == null) {
			fi =  untyped cl.fields = new Vector<String>();
			for (el in st)
			{
				pr = el.firstElement();
				if (pr != null && pr.nodeName == 'c' && pr.get('path') == 'cases.State')
				{
					fi.push(el.nodeName);
					setField( el.nodeName );
				}
			}
		} else {
			for (field in fi) {
				setField( field );
			}
		}
		
	}
	
	private inline function setField ( n:String ) : Void {
		if (Reflect.field(this, n ) == null) {
			var st = new State( states.length );
			Reflect.setField(this, n, st);
			states.push( st );
		}
	}
}


class TestShortAutoFSM extends ShortAutoFSM
{
	public var state0 : State;
	public var state1 : State;
	public var state2 : State;
	public var state3 : State;
	public var state4 : State;
	public var state5 : State;
	public var state6 : State;
	public var state7 : State;
	public var state8 : State;
	public var state9 : State;
}




class ShortAutoFSM2 implements haxe.rtti.Infos
{
	public var sts : Vector < State >;
	
	public function new () {
	}
	
	public function init () {
		sts					= new Vector<State>();
		var cl					= Type.getClass(this);
		var fi:Vector<String>	= untyped cl.fields;
		
		var st = Xml.parse(untyped cl.__rtti).firstElement().elements();
		var el:Xml;
		var pr:Xml;
		var r = Reflect;
		
		if (fi == null) {
			fi =  untyped cl.fields = new Vector<String>();
			for (el in st)
			{
				pr = el.firstElement();
				if (pr != null && pr.nodeName == 'c' && pr.get('path') == 'cases.State')
				{
					fi.push(el.nodeName);
					setField( el.nodeName, r );
				}
			}
		} else {
			for (field in fi) {
				setField( field, r );
			}
		}
		
	}
	
	private inline function setField ( n:String, r ) : Void {
		if (r.field(this, n ) == null) {
			var st = new State( sts.length );
			r.setField(this, n, st);
			sts.push( st );
		}
	}
}


class TestShortAutoFSM2 extends ShortAutoFSM2
{
	public var state0 : State;
	public var state1 : State;
	public var state2 : State;
	public var state3 : State;
	public var state4 : State;
	public var state5 : State;
	public var state6 : State;
	public var state7 : State;
	public var state8 : State;
	public var state9 : State;
}




class ManualFSM extends TestFSM
{
	override public function init () {
		super.init();
		states.push( state0	= new State(0) );
		states.push( state1	= new State(1) );
		states.push( state2	= new State(2) );
		states.push( state3	= new State(3) );
		states.push( state4	= new State(4) );
		states.push( state5	= new State(5) );
		states.push( state6	= new State(6) );
		states.push( state7	= new State(7) );
		states.push( state8	= new State(8) );
		states.push( state9	= new State(9) );
	}
}