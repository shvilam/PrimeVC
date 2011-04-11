package primevc.js.events;

import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since	April 6, 2011
 */

class ErrorSignal extends DOMSignal1<String>
{
	override private function dispatch(event:Event) 
	{
		send("error");
	}
}

class ErrorEvent extends DOMEvent
{
	public var filename (default, null):String; 
	public var lineno	(default, null):Int; 
	public var message	(default, null):String; 
	
	public function new (event:Event)
	{
		super(event);
		
		untyped
		{
			filename	= event.filename;
			lineno		= event.lineno;
			message		= event.message;
		}
	}
}