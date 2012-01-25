package org.primevc.sample.controller;
 import primevc.mvc.MVCActor;
 import primevc.mvc.IMVCCoreActor;
  using primevc.utils.Bind;

/**
 * Receives and dispatches global events.
 */
class MainController extends MVCActor<MainFacade>, implements IMVCCoreActor
{	
    public function new (facade:MainFacade)		{ super(facade); }
}