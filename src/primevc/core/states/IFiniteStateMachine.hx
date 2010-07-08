package primevc.core.states;
 import primevc.core.IDisposable;
 import primevc.core.dispatcher.Signal2;
 import primevc.utils.FastArray;


/**
 * Interface describing the FiniteStateMachine
 * 
 * @creation-date	Jun 9, 2010
 * @author			Ruben Weijers
 */
interface IFiniteStateMachine implements haxe.rtti.Infos, implements IDisposable
{
	//
	// PROPERTIES
	//
	
	/**
	 * Collection of states that the current statemachine can have.
	 */
	var states			(default, null)				: FastArray < IState >;
	/**
	 * Current state of the group. State must be in the <code>states</code>
	 * list.
	 */
	var current			(default, setCurrent)		: IState;
	/**
	 * State that will be used when there is no state set.
	 */
	var defaultState	(default, setDefaultState)	: IState;
	/**
	 * Change dispatcher. First parameter is the old state, the second parameter
	 * is the new state.
	 */
	var change			(default, null)				: Signal2 < IState, IState >;
	
	
	
	
	//
	// METHODS
	//
	
	/*
	 * Method will add a new state to the list with available states.
	 * It is recommended that the state is also declared as class
	 * variable.
	 * @param	state
	 */
//	function add (state:IState) : Void;
//	function remove (state:IState) : Void;
	
	/**
	 * Enabel the current state group. The group will be allowed to siwtch from states
	 * again when it's enabled.
	 */
	function enable ()	: Void;
	
	/**
	 * Disable the current state group. It's not posible to switch from states when
	 * the group is disabled.
	 */
	function disable ()	: Void;
	
	/**
	 * Method will enable the stategroup when the given state is entered.
	 * The StateGroup won't be automaticly disabled when the given state is
	 * exited.
	 * 
	 * @param	trigger
	 */
	function enableInState (trigger:IState) : Void;
	
	/**
	 * Method will disable the stategroup when the given state is entered.
	 * The StateGroup won't be automaticly enabled when the given state is
	 * exited.
	 * 
	 * @param	trigger
	 */
	function disableInState (trigger:IState) : Void;
}