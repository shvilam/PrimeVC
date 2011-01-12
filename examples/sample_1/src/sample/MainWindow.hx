package sample;

import primevc.gui.core.UIWindow;


/**
 * Initializes user interface elements and 
 * acts as a container for them.
 */
class MainWindow extends UIWindow
{	
    public var imageLoader:ImageLoader;
    public var loadButton:Button;


    // Add ui elements to the window.
    override private function createChildren ()
    {
        imageLoader = new ImageLoader();
        (untyped this).target.addChild(imageLoader);
        
        loadButton = new Button("Load image");
        (untyped this).target.addChild(loadButton);
        
        loadButton.x = (ImageLoader.IMG_SIZE - Button.BTN_WIDTH) / 2;
        loadButton.y = ImageLoader.IMG_SIZE + 10;
    }
}
