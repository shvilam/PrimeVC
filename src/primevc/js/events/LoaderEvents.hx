package primevc.js.events;

import primevc.core.events.CommunicationEvents;
import primevc.js.net.URLLoader;
import primevc.core.events.LoaderEvents;
import primevc.core.dispatcher.Signal0;
import primevc.core.dispatcher.Signal1;
import primevc.js.net.XMLHttpRequest;
import js.Dom;
import js.Lib;

/**
 * JS implementation of loader-events.
 * 
 * @author	Stanislav Sopov
 * @since	April 5, 2011
 */

// TODO: Make events extend DOMSignal 
 
class LoaderEvents extends LoaderSignals
{
	public function new (request:XMLHttpRequest)
	{
		unloaded	= new Signal0();
		load		= new CommunicationEvents(request);
		httpStatus	= new Signal1<Int>();
	}
}