package sample;

import primevc.mvc.MVCNotifier;
import primevc.mvc.core.MVCCore;


/**
 * Defines and groups together proxies,
 * provides access point for them and
 * handles data logic. 
 */
class MainModel extends MVCCore<MainFacade>, implements IModel
{
    public var mainProxy (default, null):MainProxy;
    public function new (facade:MainFacade)		{ super(facade); }

    public function init ()
    {
        mainProxy = new MainProxy( cast facade.events );
    }
}