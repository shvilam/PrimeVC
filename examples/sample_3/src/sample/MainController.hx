package sample;

import primevc.mvc.core.IController;
import primevc.mvc.core.MVCCore;
using primevc.utils.Bind;

/**
 * Receives and dispatches global events.
 */
class MainController extends MVCCore<MainFacade>, implements IController
{	
    public function new (facade:MainFacade)		{ super(facade); }

    public function init ()
    {
        
    }	
}