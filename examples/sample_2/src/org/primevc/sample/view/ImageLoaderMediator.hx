package org.primevc.sample.view;

import primevc.gui.events.MouseEvents;
import primevc.mvc.Mediator;
import primevc.core.dispatcher.Signal1;
import primevc.types.Asset;
import primevc.gui.components.Image;
using primevc.utils.Bind;
using primevc.utils.TypeUtil;


/**
 * ImageLoaderMediator corresponds to a mediator in the MVC model.
 * A mediator separates event handling for a specific UI element
 * from the element itself. It defines what ImageLoader events 
 * should be listened to and what functions react to them. 
 */
class ImageLoaderMediator extends Mediator <MainFacade, Image>
{	
    override public function startListening ()
    {
        if (isListening())
            return;
        // Bind a ui event to a function.
        //events.loadImage.bind(this, gui.loadImage);
		loadImage.on(f.events.loadImage, this);
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
	
	
	private function loadImage(url:String) 
	{
		//gui.layout.maintainAspectRatio = false;
		gui.data = Asset.fromString(url);
	}
}
