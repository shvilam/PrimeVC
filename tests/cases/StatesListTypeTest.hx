package cases;
import flash.Vector;
import haxe.FastList;
import Benchmark;
 

/**
 * @creation-date	Jun 9, 2010
 * @author			Ruben Weijers
 */
class StatesListTypeTest 
{
	public static function main ()
	{
		var bench = new Benchmark();
		
		var test1 = new FSMWithList();
		var test2 = new FSMWithFastList();
		var test3 = new FSMWithDynamicVector();
		var test4 = new FSMWithStaticVector();
		var test5 = new FSMWithArray();
		var test6 = new FSMVectorIndexedSearch();
		
		var group = new Comparison( "Create with 2001 children", 1 );
		bench.add( group );
		
		group.add( new Test( test2.init,			"FastList") );
		group.add( new Test( test3.init,			"Dynamic Vector") );
		group.add( new Test( test6.init,			"Indexed Static Vector") );
		group.add( new Test( test4.init,			"Static Vector") );
		group.add( new Test( test1.init,			"List") );
		group.add( new Test( test5.init,			"Array") );
		
		group = new Comparison("Find first state", 20000);
		bench.add( group );
		
		group.add( new Test( test2.searchFirst,		"FastList") );
		group.add( new Test( test3.searchFirst,		"Dynamic Vector") );
		group.add( new Test( test6.searchFirst,		"Indexed Static Vector") );
		group.add( new Test( test4.searchFirst,		"Static Vector") );
		group.add( new Test( test1.searchFirst,		"List") );
		group.add( new Test( test5.searchFirst,		"Array") );
		
		group = new Comparison("Find last state", 20000);
		bench.add( group );
		
		group.add( new Test( test2.searchLast,		"FastList") );
		group.add( new Test( test3.searchLast,		"Dynamic Vector") );
		group.add( new Test( test3.searchLast2,		"Dynamic Vector2") );
		group.add( new Test( test6.searchLast,		"Indexed Static Vector") );
		group.add( new Test( test4.searchLast,		"Static Vector") );
		group.add( new Test( test1.searchLast,		"List") );
		group.add( new Test( test5.searchLast,		"Array") );
		
		
		bench.start();
	}
}


class State
{
	var entering : Int;
	var exiting : Int;
	
	public function new ()
	{
		entering = 0;
		exiting = 1;
	}
}


class FSMWithList
{
	var states		: List < State >;
	var firstState	: State;
	var lastState	: State;
	
	public function new () {}
	
	public function init () {
		states = new List();
		states.add( firstState = new State() );
		for ( i in 0...2000 ) {
			states.add( lastState = new State() );
		}
	}
	
	public function searchLast () { findState(lastState); }
	public function searchFirst () { findState(firstState); }
	
	public inline function findState (query:State) {
		for (state in states)
			if (state == query)
				break;
	}
}


class FSMWithFastList
{
	var states		: FastList < State >;
	var firstState	: State;
	var lastState	: State;
	
	public function new () {}
	
	public function init () {
		states = new FastList <State>();
		states.add( firstState = new State() );
		for ( i in 0...2000 ) {
			states.add( lastState = new State() );
		}
	}
	
	public function searchLast () { findState(lastState); }
	public function searchFirst () { findState(firstState); }
	
	
	public inline function findState (query:State) {
		for (state in states)
			if (state == query)
				break;
	}
}


class FSMWithDynamicVector
{
	var states		: Vector < State >;
	var firstState	: State;
	var lastState	: State;
	
	public function new () {}
	
	public function init () {
		states = new Vector <State>();
		states.push( firstState = new State() );
		for ( i in 0...2000 ) {
			states.push( lastState = new State() );
		}
	}
	
	public function searchLast () { findState(lastState); }
	public function searchLast2 () { findState2(lastState); }
	public function searchFirst () { findState(firstState); }
	
	
	public inline function findState (query:State) {
		for (state in states)
			if (state == query) {
				break;
			}
	}
	public inline function findState2 (query:State) {
		var len = states.length;
		var state:State;
		for (i in 0...len) {
			state = states[i];
			if (state == query)
				break;
		}
	}
}


class FSMWithStaticVector
{
	var states		: Vector < State >;
	var firstState	: State;
	var lastState	: State;
	
	public function new () {}
	
	public function init () {
		states = new Vector <State>( 2001, true );
		states[0] = firstState = new State();
		for ( i in 1...2000 ) {
			states[i] = lastState = new State();
		}
	}
	
	public function searchLast () { findState(lastState); }
	public function searchFirst () { findState(firstState); }
	
	
	public inline function findState (query:State) {
		for (state in states)
			if (state == query)
				break;
	}
}


class FSMWithArray
{
	var states		: Array<State>;
	var firstState	: State;
	var lastState	: State;
	
	public function new () {}
	
	public function init () {
		states = new Array();
		states.push( firstState = new State() );
		for ( i in 0...2000 ) {
			states.push( lastState = new State() );
		}
	}
	
	public function searchLast () { findState(lastState); }
	public function searchFirst () { findState(firstState); }
	
	
	public inline function findState (query:State) {
		for (state in states)
			if (state == query) {
				break;
			}
	}
}


class IDState extends State
{
	public var id:Int;
	public function new (id:Int) { this.id = id; super(); }
}

class FSMVectorIndexedSearch
{
	var states		: Vector<IDState>;
	var firstState	: IDState;
	var lastState	: IDState;
	
	public function new () {}
	
	public function init () {
		states = new Vector <IDState>( 2001, true );
		states[0] = firstState = new IDState( 0 );
		for ( i in 1...2000 ) {
			states[i] = lastState = new IDState( i );
		}
	}
	
	public function searchLast () { findState(lastState); }
	public function searchFirst () { findState(firstState); }
	
	
	public inline function findState (query:IDState) {
		var searchedState = states[query.id];
	}
}