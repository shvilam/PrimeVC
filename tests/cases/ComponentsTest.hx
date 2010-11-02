package cases;
 import primevc.core.Application;
 import primevc.gui.components.ApplicationView;
 import primevc.gui.components.Button;
 import primevc.gui.components.Label;
 import primevc.gui.components.Image;
 import primevc.gui.components.InputField;
 import primevc.gui.core.UIWindow;
 import primevc.types.Bitmap;
  using primevc.utils.Bind;


/**
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class ComponentsTest extends UIWindow
{
	public static function main ()					{ Application.startup( ComponentsTest ); }
	override private function createChildren ()		{ children.add( new ComponentsApp( "componentsApp" ) ); }
	override private function createBehaviours ()	{ haxe.Log.clear.on( mouse.events.doubleClick, this ); }
}


/**
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class ComponentsApp extends ApplicationView
{
	private var label	: Label;
	private var input	: InputField;
	private var button	: Button;
	private var image	: Image;
	
	
	override private function createChildren ()
	{
		children.add( label		= new Label("testLabel") );
		children.add( button	= new Button("testButton", "add some text", Bitmap.fromString("/Users/ruben/Desktop/naamloze map/Arrow-Right.png")) );
		children.add( image		= new Image("testImage", Bitmap.fromString("/Users/ruben/Pictures/0227pod11.jpg")) );
		children.add( input		= new InputField("testInput", "welcome welcome welcome welcome welcome welcome welcome") );
		
		label.data.pair( input.data );
		changeLabel.on( button.userEvents.mouse.down, this );
	}
	
	
	private function changeLabel ()
	{
		label.value += " test";
	}
}