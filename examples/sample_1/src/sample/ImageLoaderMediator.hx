package sample;

import primevc.gui.events.MouseEvents;
import primevc.mvc.Mediator;
import primevc.core.dispatcher.Signal1;
using primevc.utils.Bind;
using primevc.utils.TypeUtil;

/**
 * Defines what ui events should be listened to
 * and what functions react to them.
 */
class ImageLoaderMediator extends Mediator <MainFacade, ImageLoader>
{	
    override public function startListening ()
    {
        if (isListening())
            return;
        // Bind a ui event to a function.
        f.events.loadImage.bind(this, gui.loadImage);
        super.startListening();
    }


    override public function stopListening ()
    {
        if (!isListening())
            return;
		
		super.stopListening();
        // Unbind action from a ui event.
        f.events.loadImage.unbind(this);
    }
}