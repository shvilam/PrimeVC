package sample;

import primevc.gui.events.MouseEvents;
import primevc.mvc.Mediator;
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
        
		super.stopListening();
        gui.removeEventListener("click", clickHandler);
    }

    private function clickHandler(e)
    {
        f.events.loadImage.send(f.model.mainProxy.vo.value);
    }
}