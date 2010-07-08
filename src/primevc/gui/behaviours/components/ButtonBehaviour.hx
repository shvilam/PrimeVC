package primevc.gui.behaviours.components;
 import primevc.gui.behaviours.Behaviour;
 import primevc.gui.core.UIComponent;
 import primevc.gui.states.ButtonStates;


typedef ButtonObject = { >UIComponent,
	var buttonStates : ButtonStates;
}


/**
 * Behaviour that will bind the states of a button to the default 
 * Mouse-events.
 * 
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
class ButtonBehaviour extends Behaviour < ButtonObject >
{
	override private function init ()
	{
		var states = target.buttonStates;
		var events = target.skin.userEvents.mouse;
		
		states.changeOn( events.down,		states.down );
		states.changeOn( events.up,			states.hover );
		states.changeOn( events.rollOver,	states.hover );
		states.changeOn( events.rollOut,	states.normal );
	}
	
	
	override private function reset ()
	{
		var states = target.buttonStates;
		var events = target.skin.userEvents.mouse;
		
		//FIXME: Dit ruimt alle handlers op van "states". Als er 2 behaviours gekoppeld zijn aan hetzelfde states object gaat de boel kaput.
		events.down.unbind( states );
		events.up.unbind( states );
		events.rollOver.unbind( states );
		events.rollOut.unbind( states );
	}
}