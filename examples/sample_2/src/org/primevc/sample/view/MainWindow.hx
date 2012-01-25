package org.primevc.sample.view;

import primevc.gui.core.UIWindow;
import primevc.gui.components.Button;
import primevc.gui.components.Image;


/**
 * Initializes user interface elements and 
 * acts as a container for them.
 */
class MainWindow extends UIWindow
{	
    public var button:Button;
    public var image:Image;
	
    // Add ui elements to the window.
    override private function createChildren ()
    {
        image = new Image("mainImage");
        children.add(image);
     
        button = new Button("loadButton", "Load image");
        children.add(button);
    }
}
