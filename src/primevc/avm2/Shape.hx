package primevc.avm2;
 import primevc.gui.display.IShape;
 import primevc.gui.events.DisplayEvents;
 

/**
 * AVM2 Shape implementation
 * 
 * @creation-date	Jun 11, 2010
 * @author			Ruben Weijers
 */
class Shape extends flash.display.Shape, implements IShape
{
	public var displayEvents	: DisplayEvents;
	
	
	public function new() 
	{
		super();
		displayEvents = new DisplayEvents( this );
	}
	
	
	public function dispose()
	{
		if (displayEvents == null)
			return;		// already disposed
		
		displayEvents.dispose();
		displayEvents = null;
	}	
}