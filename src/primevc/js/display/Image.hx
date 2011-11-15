package primevc.js.display;

 import js.Dom;
 import primevc.core.dispatcher.Signal1;
 import primevc.js.events.DisplayEvents;
 import primevc.js.events.DisplaySignal;
  using primevc.utils.Bind;

/**
 * @since	March 11, 2011
 * @author	Stanislav Sopov 
 */
class Image extends DOMElem {
    
	public var src 				(default, setSrc):String;
	public var events			(default, null):DisplayEvents;
	public var isDisplayed		(default, null):Bool;
	public var loaded			(default, null):Signal1<Image>;
	override public var width	(default, setWidth):Int;
	override public var height	(default, setHeight):Int;
	
	public function new() {
		super("img");
		
		initEvents();
	}
	
	private function initEvents() {
		events = new DisplayEvents(elem);
		
		events.insertedIntoDoc.bind(this, onInsertedIntoDoc);
		events.removedFromDoc.bind(this, onRemovedFromDoc);
		
		loaded = new Signal1();
		untyped elem.addEventListener("load", onLoad, false);
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
	
	private function setSrc(v:String):String {
		if (src != v) {
			src = v;
			if (isDisplayed) { 
                load(); 
            }
		}
		return src;
	}
	
	private function onInsertedIntoDoc(event:DisplayEvent) {
		isDisplayed = true;
		load();
	}
	
	private function onRemovedFromDoc(event:DisplayEvent) {
		isDisplayed = false;
		elem.src = "";
	}
	
	private function onLoad(event:Event) {
		loaded.send(this);
	}
	
	inline public function load() {
		if (src != null && elem.src != src) { 
            elem.src = src;
        }
	}
}