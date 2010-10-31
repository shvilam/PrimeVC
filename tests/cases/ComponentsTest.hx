package cases;
 import primevc.core.Application;
 import primevc.gui.components.ApplicationView;
// import primevc.gui.components.Button;
 import primevc.gui.components.Label;
// import primevc.gui.components.Image;
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
	public static function main ()				{ Application.startup( ComponentsTest ); }
	override private function createChildren ()	{ children.add( new ComponentsApp( "componentsApp" ) ); }
}


/**
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class ComponentsApp extends ApplicationView
{
	private var label	: Label;
	private var input	: InputField;
//	private var button	: Button;
//	private var image	: Image;
	
	
	override private function createChildren ()
	{
		//create label
		children.add( label		= new Label("testLabel") );
		children.add( input		= new InputField("testInput", "welcome") );
//		children.add( button	= new Button("testButton", "add some text") );
//		children.add( image		= new Image("testImage" ) ); //, Bitmap.fromString("/Users/ruben/Pictures/0227pod11.jpg")) );
		
		label.data.pair( input.data );
//		changeLabel.on( button.userEvents.mouse.down, this );
	}
	
	
	private function changeLabel ()
	{
		label.value += " test";
	}
}