package primevc.js.display;

import js.Dom;
import js.Lib;
import org.valueobjects.types.Color;
import primevc.js.events.MouseEvents;
import primevc.gui.events.MouseEvents;
using primevc.utils.Color;

/**
 * @since	June 15, 2011
 * @author	Stanislav Sopov 
 */
class Link extends DOMElem
{	
	public var action			(default, setAction):Void -> Void;
	public var href				(default, setHref):String;
	public var events			(default, null):MouseEvents;
	public var backgroundColor	(default, default):String;
	public var borderColor		(default, default):String;
	
	public function new()
	{
		super("a");
		
		events = new MouseEvents(elem);
	}
	
	private function setAction(v:Void -> Void):Void -> Void
	{
		action = v;
		events.click.bind(this, applyAction);
		return action;
	}
	
	private function setHref(v:String):String
	{
		href = v;
		elem.href = href;
		elem.target = "_blank";
		return href;
	}
	
	private function applyAction(state:MouseState)
	{
		action();
	}
}