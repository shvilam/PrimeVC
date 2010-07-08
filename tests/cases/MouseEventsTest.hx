package cases;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.events.MouseButton;
 import primevc.avm2.events.MouseEvents;
 import Benchmark;

/**
 * 
 * @author Danny Wilson
 * @creation-date jun 14, 2010
 */
class MouseEventsTest
{
	public static function main ()
	{
		var test = {delta: -123, buttonDown:true, altKey:true, ctrlKey:true, shiftKey:true, localX:1, localY:2, stageX:3, stageY:4, target:null};
		
		testState(test, 2);
		test.delta = 0;
		testState(test, 1);
		test.altKey = false;
		testState(test, 0);
		test.ctrlKey = false;
		testState(test, 1);
		test.shiftKey = false;
		testState(test, 2);
		test.delta = 3;
		testState(test, 0);
		
		#if debug
			trace("done!");
		#else
			trace("Compile with -debug to check assertions...");
		#end
		
		var b = new Benchmark();
		
		b.add(new Test(testSwitch_int,		"Switch int speed test",		100000));
		b.add(new Test(testSwitch_shift,	"Switch shift speed test",  	100000));
		b.add(new Test(testSwitch_shift_2,	"Switch shift_2 speed test",	100000));
		b.start();
	}
	
	static function testState(test, clickCount)
	{
		var m = primevc.avm2.events.MouseSignal.stateFromFlashEvent(test, clickCount);
		
		Assert.that(test.altKey  == m.altKey(),			 "alt: "+m.altKey() +" - "+ StringTools.hex(m.flags));
		Assert.that(test.ctrlKey == m.ctrlKey(),		 "ctrl: "+m.ctrlKey() +" - "+ StringTools.hex(m.flags));
		Assert.that(test.ctrlKey == m.cmdKey(),			 "cmd: "+m.cmdKey() +" - "+ StringTools.hex(m.flags));
		Assert.that(test.shiftKey == m.shiftKey(),		 "shift: "+m.shiftKey() +" - "+ StringTools.hex(m.flags));
		
		Assert.that(clickCount == m.clickCount(),		 "clickCount: "+m.clickCount() +" - "+ StringTools.hex(m.flags));
		Assert.that(test.delta == m.scrollDelta(),		 "scrollDelta: "+m.scrollDelta() +" - "+ StringTools.hex(m.flags));
		
		Assert.that(test.buttonDown == m.leftButton(),	 "leftButton: "+m.leftButton() +" - "+ StringTools.hex(m.flags));
		Assert.that(m.rightButton() == false,			 "rightButton: "+m.rightButton() +" - "+ StringTools.hex(m.flags));
		Assert.that(m.middleButton() == false,			 "middleButton: "+m.middleButton() +" - "+ StringTools.hex(m.flags));
		
		var ass = switch (m.mouseButton()) {
			case None:		test.buttonDown == true;
			case Left:		test.buttonDown == true;
			case Middle:	false;
			case Right:		false;
			case Other(_):	false;
		};
		Assert.that(ass, "mouseButton: "+m.mouseButton());
	}
	
	static function testSwitch_int()
	{
		var flags = 0xFEFEFE;
		switch (flags & 0xFF00) {
			case 0x0000: MouseButton.None;
			case 0x0100: MouseButton.Left;
			case 0x0200: MouseButton.Right;
			case 0x0300: MouseButton.Middle;
			default:	 MouseButton.Other((flags >> 8) & 0xFF);
		}
	}
	
	static function testSwitch_shift()
	{
		var flags = 0xFEFEFE;
		switch ((flags & 0xFF00) >> 8) {
			case 0: MouseButton.None;
			case 1: MouseButton.Left;
			case 2: MouseButton.Right;
			case 3: MouseButton.Middle;
			default:	 MouseButton.Other((flags >> 8) & 0xFF);
		}
	}
	
	static function testSwitch_shift_2()
	{
		var flags = 0xFEFEFE;
		
		var num;
		// TODO: Bench if 0xFF00 >> 8  is faster then case 0x0100
		switch (num = (flags >> 8) & 0xFF) {
			case 0:		MouseButton.None;
			case 1:		MouseButton.Left;
			case 2:		MouseButton.Right;
			case 3:		MouseButton.Middle;
			default:	MouseButton.Other(num);
		}
	}
}