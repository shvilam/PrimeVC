package primevc.js.display;
 import js.Dom;
 import js.Lib;
 import nl.onlinetouch.viewer.events.BookletEvents;
 import nl.onlinetouch.vo.publication.ISpreadVO;
 
/**
 * @since	June 15, 2011
 * @author	Stanislav Sopov 
 */
class Link extends DOMElem
{	
    public var bookletEvents    (default, null):BookletEvents;
	public var href				(default, setHref):String;
    public var spread           (default, setSpread):ISpreadVO;
    
	public function new() {
		super("a");
        bookletEvents = new BookletEvents();
	}
	
	private function setSpread(v:ISpreadVO):ISpreadVO {
		spread = v; 
        untyped elem.addEventListener("click", gotoSpread, false);
		return v;
	}
	
	private function setHref(v:String):String {
		href = v;
		elem.href = href;
		elem.target = "_blank";
		return v;
	}
	
	private function gotoSpread(e:Event) {
		bookletEvents.gotoSpread.send(spread.num);    
	}
}