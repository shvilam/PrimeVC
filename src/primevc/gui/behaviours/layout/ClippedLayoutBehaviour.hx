package primevc.gui.behaviours.layout;
 import primevc.core.geom.Rectangle;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.ISkin;
 import primevc.gui.layout.LayoutGroup;
 import primevc.gui.states.LayoutStates;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;
 

/**
 * Clipped layout behaviour will clip a skin that contains a LayoutGroup to the
 * given width and height properties. All children that will fall outside of
 * the layout are not visible (unless the scrollX and scrollY properties of the
 * LayoutGroup is changed.
 * 
 * @creation-date	Jun 25, 2010
 * @author			Ruben Weijers
 */
class ClippedLayoutBehaviour extends BehaviourBase < ISkin >
{
	override private function init ()
	{
		//can only listen to changes in the layout when the layout object is created
		initLayout.onceOn( target.skinState.constructed.entering, this );
	}
	
	
	override private function reset ()
	{
		target.skinState.constructed.entering.unbind(this);
		
		if (target.layout != null)
			target.layout.events.sizeChanged.unbind(this);
	}
	
	
	/**
	 * Method will add signal-listeners to the layout object of the target to listen
	 * to changes in the size of the layout. If the size changes, it will adjust
	 * the scrollRect of the target.
	 */
	private function initLayout ()
	{
		if (target.layout == null)
			return;
		
		Assert.that(target.layout.is(LayoutGroup), "LayoutObject should be a LayoutGroup");
		
		target.scrollRect = new Rectangle();
		updateScrollRect.on( target.layout.events.sizeChanged, this );
	}
	
	
	private function updateScrollRect ()
	{
		var l:LayoutGroup	= target.layout.as(LayoutGroup);
		var r				= target.scrollRect;
		r.x					= l.scrollX;
		r.y					= l.scrollY;
		r.width				= l.bounds.width;
		r.height			= l.bounds.height;
		
		trace("updated scrollRect " + r);
		target.scrollRect = r;
	}
}