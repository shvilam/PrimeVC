package primevc.js.display;

import js.Dom;
import js.Lib;
import primevc.js.events.TouchEvents;
import primevc.js.events.TouchSignal;

/**
 * @since	June 15, 2011
 * @author	Stanislav Sopov 
 */
class Link extends DOMElem
{	
	public var href				(default, setHref):String;
	public var action			(default, setAction):Void -> Void;
	public var touches			(default, null):TouchEvents;
	
	public function new()
	{
		super("a");
		
		touches = new TouchEvents(elem);
	}
	
	private function setAction(v:Void -> Void):Void -> Void
	{
		action = v;
		touches.end.bind(this, applyAction);
		return action;
	}
	
	private function setHref(v:String):String
	{
		href = v;
		elem.href = href;
		elem.target = "_blank";
		return href;
	}
	
	private function applyAction(e:TouchEvent)
	{
		action();
	}
	
	private function openUrl(e:TouchEvent)
	{
		//untyped console.log(href);
		//Lib.window.location.href = href;
	}
}