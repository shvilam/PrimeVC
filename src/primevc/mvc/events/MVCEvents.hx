package primevc.mvc.events;
 import primevc.core.dispatcher.Signals;
 import primevc.core.dispatcher.Signal0;


/**
 * Basic events for an mvc-application
 * 
 * @author Ruben Weijers
 * @creation-date Nov 17, 2010
 */
class MVCEvents extends Signals
{
	public var started (default, null)	: Signal0;
	
	
	public function new ()
	{
		started = new Signal0();
	}
}