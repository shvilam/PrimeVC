package primevc.gui.states;
 import primevc.core.states.AutoFiniteStateMachine;
 import primevc.core.states.IState;


/**
 * States that describe what a component is doing.
 * 
 * @author Ruben Weijers
 * @creation-date Jun 07, 2010
 */
class UIComponentStates extends AutoFiniteStateMachine
{
	/**
	 * Component is constructed when:
	 *  - states are created
	 *  - behaviours are set
	 *  - skin is created
	 *  - children are created
	 */
	public var constructed	: IState;
	/**
	 * State of component when data is set.
	 * This state can only be reached when the componentstate
	 * is constructed.
	 */
	public var initialized	: IState;
	/**
	 * State si set when the component is disposed.
	 */
	public var disposed		: IState;
	
	
	public function new ()
	{
		super();
		defaultState = constructed;
	}
}