package primevc.js.events;

import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since	April 6, 2011
 */

class LoadSignal extends DOMSignal0
{
	override private function dispatch(event:Event) 
	{
		send();
	}
}