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
	public var isAddedToStage	(default, null):Bool;
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
		
		//events.nodeInsertedIntoDoc.bind(this, onInsertedIntoDoc);
		//events.nodeRemovedFromDoc.bind(this, onRemovedFromDoc);
		
		loaded = new Signal1();
		untyped elem.addEventListener("load", onLoad, false);
	}
	
	override private function setWidth(v:Int):Int
	{
		if (width != v)
		{
			width = v;
			elem.width = v;
		}
		return width;
	}
	
	override private function setHeight(v:Int):Int
	{
		if (height != v)
		{
			height = v;
			elem.height = v;
		}
		return height;
	}
	
	private function setSrc(v:String):String
	{
		if (src != v)
		{
			src = v;
			if (isAddedToStage) { load(); }
		}
		return src;
	}
	
	inline private function onInsertedIntoDoc(event:DisplayEvent)
	{
		isAddedToStage = true;
		load();
	}
	
	inline private function onRemovedFromDoc(event:DisplayEvent)
	{
		isAddedToStage = false;
	}
	
	private function onLoad(event:Event)
	{
		loaded.send(this);
	}
	
	inline public function load()
	{
		if (src != null && elem.src != src) { elem.src = src; }
	}
}