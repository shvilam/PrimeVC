package primevc.mvc;



/**
 * Class is the base class for mediator and commands and defines that the object
 * is able to listen and to send events.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
class Listener <EventsTypedef, ModelTypedef, ViewTypeDef> extends Notifier <EventsTypedef>
{
	//TODO: Ask Nicolas why the %$@#! you can't have typedefs as type constraint parameters...

	private var facade	: { var events (default,null):EventsTypedef; var model (default,null):ModelTypedef; var view (default,null):ViewTypeDef; };
	public var model	(default, null)		: ModelTypedef;
	public var view		(default, null)		: ViewTypeDef;
	
	
	public function new (dependencies :{ var events (default,null):EventsTypedef; var model (default,null):ModelTypedef; var view (default,null):ViewTypeDef; })
	{
		Assert.that(dependencies != null);
		
		super( dependencies.events );
		facade	= dependencies;
		model	= dependencies.model;
		view	= dependencies.view;
		
		Assert.notNull(model, "Model cannot be null");
	}
	
	
	override public function dispose()
	{
		if (events == null)
			return; // already disposed
		
		facade	= null;
		model	= null;
		view	= null;
		super.dispose();
	}
}