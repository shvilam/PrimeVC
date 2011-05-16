package sample;

import primevc.gui.events.MouseEvents;
import primevc.mvc.actors.Mediator;
import primevc.core.dispatcher.Signal1;
using primevc.utils.Bind;
using primevc.utils.TypeUtil;

class ButtonMediator extends Mediator <MainFacade, Button>
{	
    override public function startListening ()
    {
        if (isListening())
            return;

        gui.addEventListener("click", clickHandler);
        super.startListening();
    }

    override public function stopListening ()
    {
        if (!isListening())
            return;
        
        gui.removeEventListener("click", clickHandler);
        super.stopListening ();
    }

    private function clickHandler(e)
    {
        f.events.loadImage.send(f.model.mainProxy.vo.value);
    }
}