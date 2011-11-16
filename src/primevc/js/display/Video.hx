package primevc.js.display;

import js.Dom;
import js.Lib;

/**
 * @since	November 14, 2011
 * @author	Stanislav Sopov 
 */
class Video extends DOMElem
{	
    /**
     * Load the entire video when the page loads.
     */
    public static inline var PRELOAD_AUTO = "auto";
    
	/**
	 * Load only metadata when the page loads.
	 */
    public static inline var PRELOAD_METADATA = "metadata"; 	
    
    /**
     * Do not load the video when the page loads.
     */
    public static inline var PRELOAD_NONE = "none"; 
    
	public var src		        (default, setSrc):String;
    public var preload          (default, setPreload):String;
	override public var width	(default, setWidth):Int;
	override public var height	(default, setHeight):Int;
	
	public function new() {
		super("video");
        elem.controls = "controls";
        //elem.poster = "black_screen.gif";
        
        //untyped {
        //    elem.addEventListener("emptied", function(e) { console.log("video emptied"); });
        //}
	}
    
    override private function setWidth(v:Int):Int {
		if (width != v) {
			width = v;
			elem.width = v;
		}
		return width;
	}
	
	override private function setHeight(v:Int):Int {
		if (height != v) {
			height = v;
			elem.height = v;
		}
		return height;
	}
    
	private function setSrc(v:String):String
	{
		if (src != v) {
			elem.src = v;
		}
		return src;
	}
    
    private function setPreload(v:String):String
	{
		if (preload != v) {
			elem.preload = v;
		}
		return preload;
	}
    
    public function reload() {
        //elem.src = src;
        //elem.controls = "controls";
        //elem.load();
        //elem.play();
    }
}