package cases;
 import primevc.core.geom.space.Direction;
 import primevc.gui.components.ApplicationView;
 import primevc.gui.components.Button;
 import primevc.gui.components.Label;
 import primevc.gui.components.Image;
 import primevc.gui.components.InputField;
 import primevc.gui.components.Slider;
 import primevc.gui.core.UIWindow;
 import primevc.gui.display.Window;
 import primevc.types.Asset;
  using primevc.utils.Bind;


/**
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class ComponentsTest extends UIWindow
{
	public static function main () {
		Window.startup( ComponentsTest );
	}
	
	
	private var label	: Label;
	private var input	: Label;
	private var button	: Button;
	private var image	: Image;
	private var slider	: Slider;
	private var slider2	: Slider;
	
	
	override private function createChildren ()
	{
		children.add( button	= new Button("testButton", "add some text" ) ); //, Asset.fromString("/Users/ruben/Desktop/naamloze map/Arrow-Right.png")) );
	//	children.add( image		= new Image("testImage", Asset.fromString("http://www.google.com/images/logos/ps_logo.png")) );
		children.add( slider	= new Slider("testSlider", 5, 4, 6) );
		children.add( slider2	= new Slider("sliderCopy", 5, 4, 6, Direction.vertical) );
		children.add( input		= new InputField("testInput") );
		children.add( label		= new Label("testLabel") );
		
		label.data.pair( input.data );
		slider2.data.pair( slider.data );
		changeLabel.on( button.userEvents.mouse.down, this );
	}
	
	
	private function changeLabel ()
	{
		button.data.value += " test";
		input.data.value += " test";
	}
	
	
	override private function createBehaviours ()
	{
		haxe.Log.clear.on( mouse.events.doubleClick, this );
		super.createBehaviours();
	}
}