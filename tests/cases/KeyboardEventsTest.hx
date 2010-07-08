package cases;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.events.KeyLocation;
 import primevc.avm2.events.KeyboardEvents;

/**
 * 
 * @author Danny Wilson
 * @creation-date jun 15, 2010
 */
class KeyboardEventsTest
{
	public static function main ()
	{
		var test = {keyCode: 1023, charCode:16383, altKey:true, ctrlKey:true, shiftKey:true, target:null, keyLocation: flash.ui.KeyLocation.LEFT};
		
		testState(test);
		test.keyCode = 2;
		testState(test);
		test.charCode = 5;
		test.altKey = false;
		testState(test);
		test.ctrlKey = false;
		testState(test);
		test.shiftKey = false;
		testState(test);
		test.keyLocation = flash.ui.KeyLocation.RIGHT;
		testState(test);
		
		#if debug
			trace("done!");
		#else
			trace("Compile with -debug to check assertions...");
		#end
	}
	
	static function testState(test)
	{
		var m = primevc.avm2.events.KeyboardSignal.stateFromFlashEvent(test);
		
		Assert.that(test.altKey  == m.altKey(),			 "alt: "+m.altKey() +" - "+ StringTools.hex(m.flags));
		Assert.that(test.ctrlKey == m.ctrlKey(),		 "ctrl: "+m.ctrlKey() +" - "+ StringTools.hex(m.flags));
		Assert.that(test.ctrlKey == m.cmdKey(),			 "cmd: "+m.cmdKey() +" - "+ StringTools.hex(m.flags));
		Assert.that(test.shiftKey == m.shiftKey(),		 "shift: "+m.shiftKey() +" - "+ StringTools.hex(m.flags));
		
		Assert.that(test.keyCode == m.keyCode(),		 "keyCode: "+m.keyCode() +" - "+ StringTools.hex(m.flags));
		Assert.that(test.charCode == m.charCode(),		 "charCode: "+m.charCode() +" - "+ StringTools.hex(m.flags));
	}
}