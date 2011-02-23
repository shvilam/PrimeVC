package sample;

import primevc.gui.events.MouseEvents;
import primevc.mvc.Mediator;
import primevc.core.dispatcher.Signal1;
using primevc.utils.Bind;
using primevc.utils.TypeUtil;

class ButtonMediator extends Mediator <MainEvents, MainModel, MainView, Button>
{	
    override public function startListening ()
    {
        if (isListening())
            return;

        viewComponent.addEventListener("click", clickHandler);
        super.startListening();
    }

    override public function stopListening ()
    {
        if (!isListening())
            return;
        
        viewComponent.removeEventListener("click", clickHandler);
        super.stopListening ();
    }

    private function clickHandler(e)
    {
        events.loadImage.send(model.mainProxy.vo.value);
    }
}