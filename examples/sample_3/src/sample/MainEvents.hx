package sample;


import primevc.core.dispatcher.Signal1;
import primevc.mvc.events.MVCEvents;

/**
 * MainEvents defines and groups together the events used 
 * in the application and provides a main access point for them. 
 */
class MainEvents extends MVCEvents
{
    public var addImage:Signal1 < primevc.types.URI >;

    public function new ()
    {
        super();
        addImage = new Signal1();
    }
}