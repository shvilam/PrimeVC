package primevc.core.states;
 import primevc.core.dispatcher.Signal2;
 import primevc.core.IDisposable;
 

/**
 * SimpleStateMachine is another implementation of the FiniteStateMachine 
 * design-pattern but simpler. It doesn't use State objects to define the
 * state but just uses enum values to change the currentState.
 * 
 * Instead firing 3 signals when the state changes (exiting old state, changing
 * states) there will be only one event, the change event.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class SimpleStateMachine <StateType> implements IDisposable
{
	public var current		(default, setCurrent)	: StateType;
	public var defaultState	(default, setDefault)	: StateType;
	
	public var change		(default, null)			: Signal2 < StateType, StateType >;
	
	
	public function new(defaultState:StateType) {
		this.change			= new Signal2();
		this.defaultState	= defaultState;
	}
	
	
	public function dispose () {
		defaultState	= null;
		current			= null;
		change.dispose();
	}
	
	
	private inline function setDefault (v:StateType) {
		defaultState = v;
		if (current == null)
			current = v;
		
		return v;
	}
	
	
	private inline function setCurrent (v:StateType) {
		if (current != v) {
			change.send( current, v );
			current = v;
		}
		return v;
	}
	
	
	
	public inline function is (state : StateType) : Bool {
		return switch (current) {
			case state:	true;
			default:	false;
		}
	}
}