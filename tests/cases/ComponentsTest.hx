package cases;
 import primevc.core.Application;
 import primevc.core.geom.space.Direction;
 import primevc.gui.components.ApplicationView;
 import primevc.gui.components.Button;
 import primevc.gui.components.Label;
 import primevc.gui.components.Image;
 import primevc.gui.components.InputField;
 import primevc.gui.components.Slider;
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
	private var input	: Label;
	private var button	: Button;
	private var image	: Image;
	private var slider	: Slider;
	private var slider2	: Slider;
	
	
	override private function init ()
	{
		styleClasses.add("test");
		super.init();
	}
	
	override private function createChildren ()
	{
		children.add( button	= new Button("testButton", "add some text", Bitmap.fromString("/Users/ruben/Desktop/naamloze map/Arrow-Right.png")) );
		children.add( image		= new Image("testImage", Bitmap.fromString("/Users/ruben/Pictures/0227pod11.jpg")) );
		children.add( slider	= new Slider("testSlider", 5, 4, 6) );
		children.add( slider2	= new Slider("sliderCopy", 5, 4, 6, Direction.vertical) );
		children.add( input		= new InputField("testInput", "welcome welcome welcome") );
		children.add( label		= new Label("testLabel") );
		
		label.data.pair( input.data );
		slider2.data.pair( slider.data );
		changeLabel.on( button.userEvents.mouse.down, this );
	}
	
	
	private function changeLabel ()
	{
		button.value += " test";
		input.value += " test";
	}
}