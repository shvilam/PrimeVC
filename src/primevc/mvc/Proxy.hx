package primevc.mvc;


/**
 * A Proxy manages a portion of the Model. Usually it manages a single value-object.
 * It exposes methods and properties to allow other MVC-actors to manipulate it.
 * 
 * A Proxy does not know anything outside of it's own world, and does not respond to signals.
 * It however does send signals, for example when the value-object changes.
 * 
 * @author Danny Wilson
 * @creation-date Jun 22, 2010
 */
class Proxy <VO, EventsTypedef>
{
	public var events (default,null) : EventsTypedef;
	
	public function new( _events : EventsTypedef )
	{	
		Assert.that(_events != null);
		this.events = _events;
	}
}
