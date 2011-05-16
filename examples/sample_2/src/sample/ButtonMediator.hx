package sample;

import primevc.gui.events.MouseEvents;
import primevc.mvc.actors.Mediator;
import primevc.core.dispatcher.Signal1;
import primevc.gui.components.Button;
using primevc.utils.Bind;
using primevc.utils.TypeUtil;


/**
 * ButtonMediator corresponds to a mediator in the MVC model.
 * A mediator separates event handling for a specific UI element
 * from the element itself. It defines what Button events should 
 * be listened to and what functions react to them. 
 */
class ButtonMediator extends Mediator <MainFacade, Button>
{	
    override public function startListening ()
    {
        if (isListening())
            return;
		
        clickHandler.on(gui.userEvents.mouse.click, this);
        super.startListening();
    }

    override public function stopListening ()
    {
        if (!isListening())
            return;
        
        gui.userEvents.unbind(this);
        super.stopListening ();
    }
	
    private function clickHandler(e)
    {
        f.events.loadImage.send(f.model.mainProxy.vo.value);
    }
}