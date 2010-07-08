package primevc.mvc;
// import primevc.core.dispatcher.Signals;

/**
 * Abstract Mediator class.
 * 
 * The Mediator translates requests between components.
 * Usually it acts as a layer between application-requests and the View.
 * 
 * A Mediator is not allowed to change Value-objects.
 * It can however request changes from a Proxy (defined within Model).
 * 
 * @author Danny Wilson
 * @creation-date Jun 22, 2010
 */
class Mediator <EventsTypedef/* : Signals*/, ModelTypedef/* : Model*/> implements IMediator
{
	//TODO: Ask Nicolas why the %$@#! you can't have typedefs as type constraint parameters...
	
	var facade	: { var events (default,null):EventsTypedef; var model (default,null):ModelTypedef; };
	
	public var events	: EventsTypedef;
	public var model	: ModelTypedef;
	
	public function new (dependencies :{ var events (default,null):EventsTypedef; var model (default,null):ModelTypedef; })
	{
		Assert.that(dependencies != null);
		
		facade = dependencies;
		events = dependencies.events;
		model  = dependencies.model;
		
		Assert.that(events != null);
		Assert.that(model  != null);
	}
	
	public function dispose()
	{
		if (events == null) return; // already disposed
		
		untyped events.unbind(this);
		events = null;
		facade = null;
		model  = null;
	}
}
