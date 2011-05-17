package primevc.js.display;

import primevc.js.events.DisplayEvents;
import primevc.js.events.DisplaySignal;
using primevc.utils.Bind;
import js.Dom;
import js.Lib;

/**
 * @since	March 11, 2011
 * @author	Stanislav Sopov 
 */
class Image extends DOMElem
{
	public var src 			(default, setSrc):String;
	public var events		(default, null):DisplayEvents;
	public var isDisplayed	(default, null):Bool;
	
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
		//if (isDisplayed) { elem.src = src; }
		elem.src = src;
		return src;
	}
	
	private function onInsertedIntoDoc(event:DisplayEvent)
	{
		isDisplayed= true;
		//if (src != null && elem.src == "") { elem.src = src; }
	}
	
	private function onRemovedFromDoc(event:DisplayEvent)
	{
		isDisplayed = false;
	}
}