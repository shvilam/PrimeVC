package sample;

import primevc.mvc.MVCNotifier;
import primevc.mvc.IMVCCore;


/**
 * MainModel corresponds to the model of the MVC model. 
 * MainModel serves as a transitional hub for various 
 * data provided by proxies, thus allowing to separate data
 * logic from UI and to keep various data separate. 
 * It defines and groups together proxies, provides a main 
 * access point for them and handles data logic.
 */
class MainModel extends MVCNotifier, implements IMVCCore
{
	
    public var mainProxy (default, null):MainProxy;
    public function new ()		{ super(); }

    public function init (facade:MainFacade)
    {
        mainProxy = new MainProxy( facade.events );
    }
}