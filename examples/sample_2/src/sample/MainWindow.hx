package sample;

import primevc.gui.core.UIWindow;
import primevc.gui.components.Button;
import primevc.gui.components.Image;


/**
 * Initializes user interface elements and 
 * acts as a container for them.
 */
class MainWindow extends UIWindow
{	
    //public var imageLoader:ImageLoader;
    //public var loadButton:Button;
    public var button:Button;
    public var image:Image;

    // Add ui elements to the window.
    override private function createChildren ()
    {
        image = new Image("mainImage");
        children.add(image);
        
        //imageLoader = new ImageLoader();
        //(untyped this).target.addChild(imageLoader);
        
        button = new Button("loadButton", "Load image");
        children.add(button);
        
        //loadButton = new Button("Load image");
        //(untyped this).target.addChild(loadButton);
        
        //loadButton.x = (ImageLoader.IMG_SIZE - Button.BTN_WIDTH) / 2;
        //loadButton.y = ImageLoader.IMG_SIZE + 10;
        
        
    }
}
