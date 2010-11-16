package primevc.mvc;


/**
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
class Command <EventsTypedef, ModelTypedef> extends Listener <EventsTypedef, ModelTypedef>, implements ICommand 
{
	public function execute () : Void;
}