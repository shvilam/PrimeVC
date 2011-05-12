package primevc.js.display;

import js.Dom;
import js.Lib;

/**
 * @since	March 11, 2011
 * @author	Stanislav Sopov 
 */

class Image extends DOMElem
{
	
	public var src (default, setSrc):String;
	
	
	public function new()
	{
		super("img");
	}
	
	
	override private function setWidth(value:Float):Float
	{
		width = value;
		elem.width = Std.int(width);
		return width;
	}
	
	
	override private function setHeight(value:Float):Float
	{
		height = value;
		elem.height = Std.int(height);
		return height;
	}
	
	
	private function setSrc(value:String):String
	{
		src = value;
		elem.src = src;
		return src;
	}
}