package primevc.js.events;

import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since	April 7, 2011	
 */

class ProgressSignal_ extends DOMSignal1<ProgressEvent>
{
	override private function dispatch(event:Event) 
	{
		var progressEvent = new ProgressEvent(event);
		
		send(progressEvent);
	}
}

class ProgressEvent extends DOMEvent
{	
	public var lengthComputable	(default, null):Bool; // Returns true if the maximum known flag is set and false otherwise.
	public var loaded			(default, null):Int; // Returns bytes loaded.
	public var total			(default, null):Int; // Returns bytes total.
	
	public function new (event:Event)
	{
		super(event);
		
		untyped 
		{
			lengthComputable 	= event.lengthComputable;
			loaded 				= event.loaded;
			total 				= event.total;
		}
	}
}