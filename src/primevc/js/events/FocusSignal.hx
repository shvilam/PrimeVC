package primevc.js.events;

import js.Dom;

/**
 * @author	Stanislav Sopov
 * @since	March 2, 2011
 */

class FocusSignal extends DOMSignal1<FocusEvent>
{
	override private function dispatch(event:Event) 
	{
		send(event);
	}
}