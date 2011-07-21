package sample;


import primevc.core.dispatcher.Signal1;
import primevc.core.dispatcher.Signals;

/**
 * Defines and groups together application events
 * and provides an access point for them.
 */
class MainEvents extends MVCEvents
{
    public var loadImage:Signal1 < String >;

    public function new ()
    {
        super();
        
        loadImage = new Signal1();
    }
}