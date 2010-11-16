package primevc.mvc;
 import primevc.core.IDisposable;


/**
 * Base class for commands, mediators and proxy's. It defines that the objects
 * can send events.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
class Notifier < EventsTypedef > implements IDisposable
{
	public var events	(default, null)	: EventsTypedef;
	
	
	public function new( events:EventsTypedef )
	{
		Assert.notNull(events, "Events cannot be null");
		this.events = events;
	}
	
	
	public function dispose ()
	{
		if (events == null)
			return;
		
	//	events.unbind(this);
		events	= null;
	}
}