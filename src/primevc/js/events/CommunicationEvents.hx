package primevc.js.events;

import primevc.core.events.CommunicationEvents;
import primevc.js.net.XMLHttpRequest;
import primevc.core.dispatcher.Signal0;
import js.Dom;

/**
 * @author	Danny Wilson
 * @since 	April 14, 2011
 */

class CommunicationEvents extends CommunicationSignals
{
	public function new (request:XMLHttpRequest)
	{
		started		= new Signal0();
		progress	= new ProgressSignal();
		init		= new Signal0();
		completed	= new Signal0();
		error		= new ErrorSignal();
	}
}