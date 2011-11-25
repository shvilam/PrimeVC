package primevc.js.display;
 import js.Dom;
 import js.Lib;

/**
 * @author 	Stanislav Sopov
 * @since 	March 22, 2011	
 */
class DisplayList {
	public var target(default, null):DOMElem;
	
	public function new (object:DOMElem) {
		target = object;
	}
	
	public inline function add(object:DOMElem) {
		if (object.elem.parentNode != target.elem) {
			target.elem.appendChild(object.elem);
			object.parent = target;
		}
	}
	
	public inline function remove(object:DOMElem) {
		if (object.elem.parentNode == target.elem) {
			target.elem.removeChild(object.elem);
			object.parent = null;
		}
	}
}