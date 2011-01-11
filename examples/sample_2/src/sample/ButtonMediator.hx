package sample;

import primevc.gui.events.MouseEvents;
import primevc.mvc.Mediator;
import primevc.core.dispatcher.Signal1;
import primevc.gui.components.Button;
using primevc.utils.Bind;
using primevc.utils.TypeUtil;

class ButtonMediator extends Mediator <MainEvents, MainModel, MainView, Button>
{	
    override public function startListening ()
    {
        if (isListening())
            return;

        //addEventListener("click", clickHandler);
        clickHandler.on(viewComponent.userEvents.mouse.click, this);
        super.startListening();
    }

    override public function stopListening ()
    {
        if (!isListening())
            return;
        
        //viewComponent.removeEventListener("click", clickHandler);
        viewComponent.userEvents.unbind(this);
        super.stopListening ();
    }
	
    private function clickHandler(e)
    {
        events.loadImage.send(model.mainProxy.vo.value);
    }
}