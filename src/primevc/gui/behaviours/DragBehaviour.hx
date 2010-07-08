package primevc.gui.behaviours;
 import primevc.gui.core.ISkin;
  using primevc.utils.Bind;
 

/**
 * Behaviour which will an UI-element draggable.
 * 
 * @creation-date	Jul 8, 2010
 * @author			Ruben Weijers
 */
class DragBehaviour extends BehaviourBase <ISkin>
{
	override private function init ()
	{
		startDrag.on( target.userEvents.mouse.down, this );
		stopDrag.on( target.userEvents.mouse.up, this );
	}
	
	
	override private function reset ()
	{
		target.userEvents.mouse.unbind( this );
	}
	
	
	private function startDrag ()
	{
		target.startDrag();
	}
	
	
	private function stopDrag ()
	{
		target.stopDrag();
	}
}