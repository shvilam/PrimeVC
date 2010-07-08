package primevc.gui.states;
 import primevc.core.states.AutoFiniteStateMachine;
 import primevc.core.states.IState;
 

/**
 * Skin states.
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class SkinStates extends AutoFiniteStateMachine
{
	/**
	 * Default state when the skin hasn't done anything.
	 * To see in which state the constructor is, take a look at 
	 * SkinConstructingStates.
	 */
	public var empty				: IState;
	
	/**
	 * State when the constructor is finished
	 */
	public var constructed			: IState;
	
	/**
	 * State of component when the displayObject is added to the stage and the
	 * children of the skin are created.
	 */
	public var initialized			: IState;
	/**
	 * State si set when the component is disposed.
	 */
	public var disposed				: IState;
	
	
	public function new ()
	{
		super();
		defaultState = empty;
		
		Assert.that( empty != null );
		Assert.that( constructed != null );
		Assert.that( initialized != null );
		Assert.that( disposed != null );
	}
}
