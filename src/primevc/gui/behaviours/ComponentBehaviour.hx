package primevc.gui.behaviours;
 import primevc.gui.core.IUIComponentBase;
  using primevc.utils.Bind;
 

/**
 * Description
 * 
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
class ComponentBehaviour extends BehaviourBase < IUIComponentBase >
{
	override private function init ()
	{
		target.init.on( target.componentState.initialized.entering, target );
	}
	
	
	override private function reset ()
	{
		target.componentState.initialized.entering.unbind( target );
	}
}