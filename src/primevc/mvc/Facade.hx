package primevc.mvc;
 import primevc.core.dispatcher.Signals;

/**
 * Abstract Façade class.
 * 
 * The Façade is responsible for initializing in order:
 * 1) Event-Signals
 * 2) Model-Proxies
 * 3) Controller-Commands
 * 4) and View-Mediators.
 * 
 * 
 * It acts as a hub of either an Application or a sub-system.
 * 
 * @author Danny Wilson
 * @creation-date Jun 22, 2010
 */
class Facade <E : Signals, M : Model, V: View> implements primevc.core.IDisposable
{
	public var events	(default,null) : E;
	public var model	(default,null) : M;
	public var view		(default,null) : V;
	
	function new ()
	{	
		setupEvents();
		Assert.that(events != null);
		
		setupModel();
		Assert.that(model != null);
		
		setupCommands();
		Assert.that(true); //FIXME: Is there anything we can assert here?
		
		setupView();
		Assert.that(view != null);
	}
	
	public function dispose()
	{
		if (events == null) return; // already disposed
		
		events.dispose();
		view   = null;
		model  = null;
		events = null;
	}
	
	/**
	 * Must instantiate the event-signals for this Facade.
	 */
	function setupEvents()		{ Assert.abstract(); }
	
	/**
	 * Must instantiate the Model for this Facade.
	 */
	function setupModel()		{ Assert.abstract(); }
	
	/**
	 * Must map the event handlers, and setup behaviours/commands for this (sub)system.
	 */
	function setupCommands()	{ Assert.abstract(); }
	
	/**
	 * Must instantiate the View for this (sub)system.
	 * - Flash:			Supply a reference to the base DisplayObject to the view.
	 * - Javascript:	Supply a reference to the base DOM-element to the view.
	 */
	function setupView()		{ Assert.abstract(); }
}