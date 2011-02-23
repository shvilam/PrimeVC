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
class ImageLoaderMediator extends Mediator <MainEvents, MainModel, MainView, ImageLoader>
{	
    override public function startListening ()
    {
        if (isListening())
            return;
        // Bind a ui event to a function.
        events.loadImage.bind(this, viewComponent.loadImage);
        super.startListening();
    }


    override public function stopListening ()
    {
        if (!isListening())
            return;
        // Unbind action from a ui event.
        events.loadImage.unbind(this);
        super.stopListening ();
    }
}