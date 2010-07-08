package primevc.gui.events;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.dispatcher.Signals;


/**
 * Two events used for invalidating and validating the layout.
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class LayoutEvents extends Signals
{
	/**
	 * Event that is called when the size of a layout is changed after the
	 * layout is validated.
	 */
	public var sizeChanged (default, null)	: Signal0;
	/**
	 * Event that is called when the position of a layouyt is changed after the
	 * layout is validated.
	 */
	public var posChanged (default, null)	: Signal0;
	
	
	public function new() 
	{
		sizeChanged		= new Signal0();
		posChanged		= new Signal0();
	}
}