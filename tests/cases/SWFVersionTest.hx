package cases;
 import flash.display.SWFVersion;
 import flash.display.Loader;
 import flash.events.Event;
 import flash.net.URLRequest;


class SWFVersionTest
{
	public static function main ()
	{
		new SWFVersionTest();
	}
	
	
	private var loader : Loader;
	
	public function new ()
	{
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleLoadedSwf );
		loader.load( new URLRequest( "/Users/ruben/Documents/Projecten/Freelance/OnlineTouch/viewer/bin-debug/otv.swf" ) );
	}
	
	
	private function handleLoadedSwf (event:Event)
	{
		if (loader.contentLoaderInfo.swfVersion >= SWFVersion.FLASH9)
			flash.Lib.current.stage.addChild( loader );
	}
}