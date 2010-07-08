package primevc.gui.states;
import primevc.core.states.IState;
 

/**
 * ToggleState
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class ToggleState extends AutoFiniteStateMachine
{
	public var on	: IState;
	public var off	: IState;
}