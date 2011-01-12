package sample;

import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;


/**
 * Loads, scales and shows and image. 
 */
class ImageLoader extends Sprite 
{
	
    public static inline var IMG_SIZE:Float = 200;

    private var loader:Loader;


    public function new() 
    {
        super();
        
        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, scale);
        addChild(loader);
    }


    public function loadImage(imgUrlIn:String) 
    {	
        var request:URLRequest = new URLRequest(imgUrlIn);
        loader.load(request);
    }


    public function unloadImage() 
    {
        loader.unload();
    }


    public function scale(evt:Event) 
    {
        var scale:Float;
        var width:Float = loader.width;
        var height:Float = loader.height;
        var horizontal:Bool = width >= height;
		
        if (horizontal) 
        {
            scale = IMG_SIZE / width;
        } 
        else 
        {
            scale = IMG_SIZE / height;
        }
            
        loader.scaleX = scale;
        loader.scaleY = scale;
    }
	
}