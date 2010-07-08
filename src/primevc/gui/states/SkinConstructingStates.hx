package primevc.gui.states;
 import primevc.core.states.AutoFiniteStateMachine;
 import primevc.core.states.IState;
 

/**
 * Unused class describing all the fases of the constructor of the skin.
 * 
 * @creation-date	Jun 18, 2010
 * @author			Ruben Weijers
 */
class SkinConstructingStates extends AutoFiniteStateMachine
{
	/**
	 * Default state when the skin hasn't done anything.
	 */
	public var constructing			: IState;
	/**
	 * State is set when the layout is created.
	 */
	public var layoutCreated		: IState;
	/**
	 * State is set when the skin has created it's states.
	 * State is part of the constructing fase.
	 */
	public var statesCreated		: IState;
	
	/**
	 * State is set when the skin has created it's behaviours.
	 * State is part of the constructing fase.
	 */
	public var behavioursCreated	: IState;
	
	/**
	 * Component is constructed when:
	 *  - layout is created
	 *  - states are created
	 *  - behaviours are set
	 */
	public var constructed			: IState;
	
	
	public function new ()
	{
		super();
		defaultState = constructing;
	}
}