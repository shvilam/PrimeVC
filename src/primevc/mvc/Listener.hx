package primevc.mvc;
  using primevc.utils.BitUtil;



/**
 * Class is the base class for mediator and commands and defines that the object
 * is able to listen and to send events.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
class Listener <EventsTypeDef, ModelTypeDef, ViewTypeDef> extends Notifier <EventsTypeDef>
{
	//TODO: Ask Nicolas why the %$@#! you can't have typedefs as type constraint parameters...
	
	public var model	(default, null)		: ModelTypeDef;
	public var view		(default, null)		: ViewTypeDef;
	
	
	public function new (events:EventsTypeDef, model:ModelTypeDef, view:ViewTypeDef)
	{
		super( events );
		
		this.model	= model;
		this.view	= view;
		
		Assert.notNull(model, "Model cannot be null for "+this);
		Assert.notNull(view, "View cannot be null for "+this);
	}
	
	
	public function startListening () : Void		{ if (!isListening())	state = state.set( MVCState.LISTENING ); }
	public function stopListening () : Void			{ if (isListening())	state = state.unset( MVCState.LISTENING ); }
	private inline function isListening () : Bool	{ return state.has( MVCState.LISTENING ); }
	
	
	override public function dispose()
	{
		if (isDisposed())
			return;
		
		stopListening();
		
		model	= null;
		view	= null;
		super.dispose();
	}
}