package primevc.js.display;

import primevc.js.events.DisplayEvents;
import primevc.js.events.DisplaySignal;
import primevc.core.dispatcher.Signal1;
using primevc.utils.Bind;
import js.Dom;

/**
 * @since	March 11, 2011
 * @author	Stanislav Sopov 
 */
class Image extends DOMElem
{
	public var src 				(default, setSrc):String;
	public var events			(default, null):DisplayEvents;
	public var isDisplayed		(default, null):Bool;
	public var loaded			(default, null):Signal1<Image>;
	override public var width	(default, setWidth):Int;
	override public var height	(default, setHeight):Int;
	
	public function new()
	{
		super("img");
		
		initEvents();
	}
	
	private function initEvents()
	{
		events = new DisplayEvents(elem);
		
		events.nodeInsertedIntoDoc.bind(this, onInsertedIntoDoc);
		events.nodeRemovedFromDoc.bind(this, onRemovedFromDoc);
		
		loaded = new Signal1();
		untyped elem.addEventListener("load", onLoad, false);
	}
	
	override private function setWidth(v:Int):Int
	{
		width = v;
		elem.width = width;
		return width;
	}
	
	override private function setHeight(v:Int):Int
	{
		height = v;
		elem.height = height;
		return height;
	}
	
	private function setSrc(v:String):String
	{
		src = v;
		if (isDisplayed) { elem.src = src; }
		return src;
	}
	
	private function onInsertedIntoDoc(event:DisplayEvent)
	{
		isDisplayed = true;
		load();
	}
	
	private function onRemovedFromDoc(event:DisplayEvent)
	{
		isDisplayed = false;
	}
	
	private function onLoad(event:Event)
	{
		loaded.send(this);
	}
	
	public function load()
	{
		if (src != null && elem.src == "") { elem.src = src; }
	}
}