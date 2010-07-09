package primevc.gui.behaviours.layout;
 import primevc.core.dispatcher.Wire;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.ISkin;
 import primevc.gui.states.LayoutStates;
  using primevc.utils.Bind;
 

/**
 * Class defines the default skin behaviour.
 * It will do the following things:
 * 	- trigger skin.createChildren when the skin is added to the stage
 *  - trigger layout.validate on a 'enterFrame event' when the layout is invalidated
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class SkinLayoutBehaviour extends BehaviourBase < ISkin >
{
	override private function init ()
	{
		if (target.parent == null) {
			target.init	.onceOn( target.displayEvents.addedToStage, this );
			initLayout	.onceOn( target.skinState.constructed.entering, this );
		}
	}
	
	
	override private function reset ()
	{
		//unbind the addedToStage eventlistener in case the skin is never added to the stage
		target.displayEvents.unbind( this );
		target.skinState.constructed.entering.unbind( this );
		
		if (target.layout != null)
			target.layout.states.change.unbind( this );
	}
	
	
	/**
	 * Reference to the last used enterFrame binding. If the state of a 
	 * layoutclient changes to parentInvalidated, this enterFrame binding
	 * should be removed.
	 */
	private var enterFrameBinding : Wire <Dynamic>;
	
	private function layoutStateChangeHandler (oldState:LayoutStates, newState:LayoutStates)
	{
		switch (newState) {
			case LayoutStates.invalidated:
				enterFrameBinding = target.layout.measure.onceOn( target.displayEvents.enterFrame, this );
			
			case LayoutStates.measuring:
				removeEnterFrameBinding();
			
			/**
			 * When the state of the layout is changed from invalidated to parent_invalidated so the parent skin
			 * will add a enterFrame to validate this layout as well.
			 */
			case LayoutStates.parent_invalidated:
				removeEnterFrameBinding();
			
			case LayoutStates.validated:
				removeEnterFrameBinding();
		}
	}
	
	
	private function removeEnterFrameBinding ()
	{
		if (enterFrameBinding != null) {
			enterFrameBinding.dispose();
			enterFrameBinding = null;
		}
	}
	
	
	/**
	 * Method is called when the skin is constructed. The skin should now have 
	 * a layout object.
	 */
	private function initLayout ()
	{
		if (target.layout == null)
			return;
		
		layoutStateChangeHandler.on( target.layout.states.change, this );
		applyPosition			.on( target.layout.events.posChanged, this );
		
		//trigger the event handler for the current state as well
		layoutStateChangeHandler( null, target.layout.states.current );
	}
	
	
	private function applyPosition ()
	{
		var l = target.layout;
		trace("applyPosition " + target.name + " / " + l + " - pos: " + l.x + ", " + l.y + " - old pos "+target.x+", "+target.y);
	//	target.width	= l.width;
	//	target.height	= l.height;
		target.x		= l.x;
		target.y		= l.y;
	}
}