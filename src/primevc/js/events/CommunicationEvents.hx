package primevc.js.events;

import primevc.core.events.CommunicationEvents;
import primevc.js.net.XMLHttpRequest;
import primevc.core.dispatcher.Signal0;
import js.Dom;
import js.Lib;

private typedef ErrorSignal		= primevc.js.events.ErrorSignal; // override import
private typedef ProgressSignal	= primevc.js.events.ProgressSignal;	// override import

/**
 * @author	Stanislav Sopov
 * @since 	April 5, 2011
 */

class CommunicationEvents extends CommunicationSignals
{
	public function new (request:XMLHttpRequest)
	{
		started		= new LoadSignal(request, "loadstart");
		progress	= new ProgressSignal(request, "progress");
		init		= new LoadSignal(request, "loadstart");
		completed	= new Signal0();
		error		= new ErrorSignal(request, "error");
	}
}