package primevc.js.display;
 import js.Dom;
 import js.Lib;
 import nl.onlinetouch.viewer.view.managers.Transform;
 import primevc.js.display.DisplayList;

/**
 * @since	April 22, 2011
 * @author	Stanislav Sopov 
 */
class DOMElem {
	public var children		(default, null):DisplayList;
	public var className	(default, setClassName):String;
	public var elem			(default, null):Dynamic;
	public var height		(default, setHeight):Int;
	public var id			(default, setId):String;
	public var matrix		(default, null):WebKitCSSMatrix;
	public var parent		:DOMElem;
	public var scale		(default, setScale):Float;
	public var style		(getStyle, null):Style;
	public var type			(default, null):String;
	public var visible		(default, setVisible):Bool;
	public var width		(default, setWidth):Int;
	public var x			(default, setX):Int;
	public var y			(default, setY):Int;
	
	public function new(type:String) {
		elem = Lib.document.createElement(type);
		
		children = new DisplayList(this);
		
		matrix = Transform.getMatrix(elem);
		
		(untyped this).x = 0;
		(untyped this).y = 0;
		(untyped this).scale = 1;
	}
	
	private function setWidth(v:Int):Int {
		if (width != v) {
			width = v;
			elem.style.width = v + "px";
		}
		return width;
	}
	
	private function setHeight(v:Int):Int {
		if (height != v) {
			height = v;
			elem.style.height = v + "px";
		}
		return height;
	}
	
	inline private function setX(v:Int):Int {
		if (x != v) {
			x = v;
			applyTransforms();
		}
		return x;
	}
	
	inline private function setY(v:Int):Int {
		if (y != v) {
			y = v;
			applyTransforms();
		}
		return y;
	}
	
	inline public function moveTo(x:Int, y:Int) {
		(untyped this).x = x;
		(untyped this).y = y;
		applyTransforms();
	}
	
	inline private function setScale(v:Float):Float {
		if (scale != v) {
			scale = v;
			applyTransforms();
		}
		return scale;
	}
	
	inline private function setId(v:String):String {
		id = v;
		elem.id = v;
		return id;
	}
	
	inline private function getStyle():Style {
		return elem.style;
	}
	
	inline private function setClassName(v:String):String {
		className = v;
		elem.className = v;
		return className;
	}
	
	inline private function setVisible(v:Bool):Bool {
		if (visible != v) {
			visible = v;
			elem.style.visibility = v ? "visible" : "hidden";
		}
		return visible;
	}
	
	inline private function applyTransforms() {
		//elem.style.webkitTransform = "translate3d(" + x + "px," + y + "px,0) scale3d(" + scale + "," + scale + ",1)";
		elem.style.webkitTransform = "translate(" + x + "px," + y + "px) scale(" + scale + ")";
	    /*
        var m = matrix;
		m.a = m.d = scale;
		m.e = x;
		m.f = y;
		elem.style.webkitTransform = m;
	    */
	}
}