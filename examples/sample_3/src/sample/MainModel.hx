package sample;

import primevc.mvc.core.IModel;
import primevc.mvc.core.MVCCore;


/**
 * MainModel corresponds to the model of the MVC model. 
 * MainModel serves as a transitional hub for various 
 * data provided by proxies, thus allowing to separate data
 * logic from UI and to keep various data separate. 
 * It defines and groups together proxies, provides a main 
 * access point for them and handles data logic.
 */
class MainModel extends MVCCore<MainFacade>, implements IModel
{
    public function new (facade:MainFacade)		{ super(facade); }

    public function init ()
    {
        // Instantiate Proxies here
    }
}