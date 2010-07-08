package primevc.core.states;
 import primevc.core.dispatcher.Signal2;
 import primevc.core.dispatcher.INotifier;
 import primevc.utils.FastArray;
  using primevc.utils.Bind;


/**
 * @author Ruben Weijers
 * @creation-date Jun 08, 2010
 */
class FiniteStateMachine implements IFiniteStateMachine
{
	//
	// PROPERTIES
	//
	
	public var current		(default, setCurrent)		: IState;
	public var defaultState	(default, setDefaultState)	: IState;
	
	public var states		(default, null)				: FastArray <IState>;
	public var change		(default, null)				: Signal2 < IState, IState >;
	private var enabled		: Bool;
	
	
	public function new ()
	{
		states	= FastArrayUtil.create();
		enabled	= true;
		change	= new Signal2();
	}
	
	
	public function dispose ()
	{
		defaultState	= null;
		current			= null;
		
		for (state in states)
			state.dispose();
		
		change.dispose();
		change = null;
		states = null;
	}
	
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	/**
	 * Setter will let the old state dispatch an exiting event and the new 
	 * state will dispatch an entering event.
	 * 
	 * The StateGroup itself will also dispatch an change event containing
	 * both the old and new state.
	 * 
	 * @private
	 */
	private function setCurrent (newState:IState) : IState
	{
		if (newState == null)
			newState = defaultState;
		
		if (!enabled)							return current;	//can't change states when we're not enabled
		if (current == newState)				return current;	//don't need to change since we're already in this state
		if (states[ newState.id ] != newState)	return current;	//can't go to a state that isn't part of this FSM
		
		//dispathc exiting event
		if (current != null)
			current.exiting.send();
		
		//set new state and dispatch change event
		change.send( current, newState );
		current = newState;
		
		//dispatch entering event
		if (current != null)
			current.entering.send();
		
		return current;
	}
	
	
	/**
	 * Setter for the defaultstate. When the currentstate is empty,
	 * it will be set to the default-state.
	 * @private
	 */
	private function setDefaultState (newState:IState) : IState
	{
		defaultState = newState;

		if (current == null)
			current = defaultState;
		
		return defaultState;
	}
	
	
	
	
	//
	// METHODS
	//
	
	
	public function enable ()							{ enabled = true; }
	public function disable ()							{ enabled = false; }
	
	public function enableInState (trigger:IState)		{ enable.on( trigger.entering, this ); }
	public function disableInState (trigger:IState)		{ disable.on( trigger.exiting, this ); }
	
	
	public function changeOn (event:INotifier<Dynamic>, toState:IState)
	{
		var t = this;
		event.observe( this, function () { t.setCurrent( toState ); } );
	}
}