package primevc.js.events;

import primevc.core.dispatcher.Signals;
import js.Dom;

/**
 * @since	march 8, 2011
 * @author	Stanislav Sopov
 */

class DisplayEvents extends Signals
{
	private var eventDispatcher:HtmlDom;
	
	// IMPORTANT
	// these events are mockups
	// Safari doesn't (yet) support mutation events
	// see below link for reference
	// http://www.w3.org/TR/DOM-Level-2-Events/events.html#Events-eventgroupings-mutationevents
	
	public var add		(default, null):DisplaySignal;
	public var remove	(default, null):DisplaySignal;
	
	
	public function new(eventDispatcher)
	{
		this.eventDispatcher = eventDispatcher;
		
		add		= new DisplaySignal(eventDispatcher, "add");
		remove	= new DisplaySignal(eventDispatcher, "remove");
	}
	
	override public function dispose ()
	{
		eventDispatcher = null;
		
		if ((untyped this).add != null)		add		.dispose();
		if ((untyped this).remove != null)	remove	.dispose();
		
		add =
		remove =
		null;
	}
}