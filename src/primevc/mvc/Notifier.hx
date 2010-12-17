package primevc.mvc;
 import primevc.core.traits.IDisposable;
  using primevc.utils.BitUtil;


/**
 * Base class for controllers, mediators and proxy's. It defines that the objects
 * can send events.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
class Notifier < EventsTypedef > implements IDisposable
{
	public var state	(default, null)	: Int;
	public var events	(default, null)	: EventsTypedef;
	
	
	public function new( events:EventsTypedef )
	{
		Assert.notNull(events, "Events cannot be null");
		state		= 0;
		this.events	= events;
	}
	
	
	public function dispose ()
	{
		if (isDisposed())
			return;
		
		events	= null;
	}
	
	
	private inline function isDisposed ()
	{
		return state.has( MVCState.DISPOSED );
	}
}