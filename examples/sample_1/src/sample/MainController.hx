package sample;
 import primevc.mvc.MVCActor;
  using primevc.utils.Bind;

/**
 * Receives and dispatches global events.
 */
class MainController extends MVCActor<MainFacade>
{	
    public function new (facade:MainFacade)		{ super(facade); }
}