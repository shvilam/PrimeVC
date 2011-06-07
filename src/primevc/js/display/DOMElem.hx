package primevc.js.display;

import nl.onlinetouch.viewer.view.managers.js.WebkitTransform;
import nl.onlinetouch.viewer.view.managers.js.TransitionManager;
import primevc.js.display.DisplayList;

import js.Dom;
import js.Lib;

/**
 * @since	April 22, 2011
 * @author	Stanislav Sopov 
 */
 
class DOMElem
{
	public var type			(default, null):String;
	public var elem			(default, null):Dynamic;
	public var width		(default, setWidth):Int;
	public var height		(default, setHeight):Int;
	public var x			(default, setX):Float;
	public var y			(default, setY):Float;
	public var scale		(default, setScale):Float;
	public var id			(default, setId):String;
	public var style		(getStyle, null):Style;
	public var className	(default, setClassName):String;
	public var matrix		(default, null):WebKitCSSMatrix;
	public var children		(default, null):DisplayList;
	public var parent		:DOMElem;
	
	public function new(type:String)
	{
		elem = Lib.document.createElement(type);
		
		children = new DisplayList(this);
		
		matrix = WebkitTransform.getMatrix(this);
		
		(untyped this).x = 0;
		(untyped this).y = 0;
		(untyped this).scale = 1;
	}
	
	private function setWidth(v:Int):Int
	{
		width = v;
		elem.style.width = width + "px";
		return width;
	}
	
	private function setHeight(v:Int):Int
	{
		height = v;
		elem.style.height = height + "px";
		return height;
	}
	
	private function setX(v:Float):Float
	{
		x = v;
		WebkitTransform.translateX(this, x);
		return x;
	}
	
	private function setY(v:Float):Float
	{
		y = v;
		WebkitTransform.translateY(this, y);
		return y;
	}
	
	public function moveTo(x:Float, y:Float)
	{
		(untyped this).x = x;
		(untyped this).y = y;
		WebkitTransform.translate(this, x, y);
	}
	
	private function setScale(v:Float):Float
	{
		scale = v;
		//WebkitTransform.scale(this, scale);
		applyTransforms();
		return scale;
	}
	
	private function setId(v:String):String
	{
		id = v;
		elem.id = id;
		return id;
	}
	
	private function getStyle():Style
	{
		return elem.style;
	}
	
	private function setClassName(v:String):String
	{
		className = v;
		elem.className = className;
		return className;
	}
	
	private function applyTransforms()
	{
		elem.style.webkitTransform = "translate3d(" + x + "px," + y + "px, 0) scale(" + scale + ")";
	}
}