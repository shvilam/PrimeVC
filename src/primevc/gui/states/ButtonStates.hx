package primevc.gui.states;
 import primevc.core.states.AutoFiniteStateMachine;
 import primevc.core.states.IState;
 

/**
 * The states button alike components can be in
 * 
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
class ButtonStates extends AutoFiniteStateMachine
{
	/**
	 * Button is currently not used
	 */
	public var normal	: IState;
	/**
	 * Button is hovered.
	 */
	public var hover	: IState;
	/**
	 * Button  is currently pressed down using the keyboard or the mouse
	 */
	public var down		: IState;
	
	
	public function new ()
	{
		super();
		defaultState = normal;
	}
}