package primevc.js.display;

 import js.Dom;

/**
 * @since	November 14, 2011
 * @author	Stanislav Sopov 
 */
class Video extends DOMElem
{	
	override public var height	(default, setHeight):Int;
	override public var width	(default, setWidth):Int;
	public var src		        (default, setSrc):String;
	
	public function new() {
		super("video");
        
        elem.controls = "controls";
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
			src = v;
		}
		return src;
	}
    
	public function load() {
		if (src != null && elem.src != src) { 
            elem.src = src;
        }
	}
    
    public function unload() {
        elem.pause();
        elem.src = "";
    }
}