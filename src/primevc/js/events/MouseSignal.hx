package primevc.js.events;
 import primevc.core.geom.Point;
 import primevc.gui.events.KeyModState;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.events.UserEventTarget;
 import js.Dom;

/**
 * @author Stanislav Sopov
 * @author Ruben Weijers
 * @creation-date march 2, 2010
 */
class MouseSignal extends DOMSignal1<MouseState>
{
	var clickCount:Int;


	public function new (d:UserEventTarget, e:String, cc:Int)
	{
		super(d,e);
		this.clickCount = cc;
	}


	override private function dispatch(e:Event) 
	{
		var flags;
		
		/** scrollDelta				Button				clickCount			KeyModState
			FF (8-bit) -127-127		FF (8-bit) 0-255	F (4-bit) 0-15		F (4-bit)
		*/
		
		Assert.that(clickCount >=  0);
		Assert.that(clickCount <= 15);
		
	//	flags = e.delta << 16
		flags = 2 << 16			// FIXME: figure out how to use javascript mouse deltaX, deltaY, deltaZ
				| (clickCount & 0xF) << 4
				| (e.button > 0? 	0x0100 : 0)
				| (e.altKey?		KeyModState.ALT : 0)
				| (e.ctrlKey?		KeyModState.CMD | KeyModState.CTRL : 0)
				| (e.shiftKey?		KeyModState.SHIFT : 0);
		
		send(new MouseState(flags, e.target, new Point(e.clientX, e.clientY), new Point(e.screenX, e.screenY), (untyped e).relatedTarget));
	}
}
