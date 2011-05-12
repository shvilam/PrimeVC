package primevc.js.display;

import nl.onlinetouch.viewer.view.managers.js.WebkitTransform;
import primevc.js.display.DisplayList;

import js.Dom;
import js.Lib;

/**
 * @since	April 22, 2011
 * @author	Stanislav Sopov 
 */
 
class DOMElem
{
	public var type		(default, null):String;
	public var elem		(default, null):Dynamic;
	public var width	(default, setWidth):Float;
	public var height	(default, setHeight):Float;
	public var x		(default, setX):Float;
	public var y		(default, setY):Float;
	public var scale	(default, setScale):Float;
	public var id		(default, setId):String;
	public var style	(getStyle, null):Style;
	public var className(default, setClassName):String;
	public var matrix	(default, null):WebKitCSSMatrix;
	public var children	(default, null):DisplayList;
	public var parent	:Dynamic;
	
	public function new(type:String)
	{
		elem = Lib.document.createElement(type);
		
		children = new DisplayList(this);
		
		matrix = WebkitTransform.getMatrix(elem);
		
		(untyped this).x = 0;
		(untyped this).y = 0;
		(untyped this).scale = 1;
	}
	
	
	private function setWidth(value:Float):Float
	{
		width = value;
		elem.style.width = width + "px";
		return width;
	}
	
	
	private function setHeight(value:Float):Float
	{
		height = value;
		elem.style.height = height + "px";
		return height;
	}
	
	
	private function setX(value:Float):Float
	{
		x = value;
		//WebkitTransform.translate(this, x, y);
		elem.style.left = x + "px";
		return x;
	}
	
	
	private function setY(value:Float):Float
	{
		y = value;
		//WebkitTransform.translate(this, x, y);
		elem.style.top = y + "px";
		return y;
	}
	
	
	public function moveTo(x:Float, y:Float)
	{
		(untyped this).x = x;
		(untyped this).y = y;
		WebkitTransform.translate(this, x, y);
	}
	
	
	private function setScale(value:Float):Float
	{
		scale = value;
		WebkitTransform.scale(this, scale);
		return scale;
	}
	
	
	private function setId(value:String):String
	{
		id = value;
		elem.id = id;
		return id;
	}
	
	
	private function getStyle():Style
	{
		return elem.style;
	}
	
	
	private function setClassName(value:String):String
	{
		className = value;
		elem.className = className;
		return className;
	}
}