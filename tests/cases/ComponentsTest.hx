package cases;
 import primevc.core.geom.Box;
 import primevc.core.Application;
 import primevc.gui.behaviours.layout.AutoChangeLayoutChildlistBehaviour;
 import primevc.gui.behaviours.layout.ClippedLayoutBehaviour;
 import primevc.gui.components.Label;
 import primevc.gui.core.UIContainer;
 import primevc.gui.core.UIWindow;
 import primevc.gui.layout.algorithms.RelativeAlgorithm;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.layout.RelativeLayout;
  using primevc.utils.Bind;


/**
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class ComponentsTest extends UIWindow
{
	public static function main () { Application.startup( ComponentsTest ); }
	
	override private function createChildren ()
	{
		var app = new ComponentsApp();
		children.add( app );
	}
}


/**
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class ComponentsApp extends UIContainer <Dynamic>
{
	private var label	: Label;
	
	
	public function new ()
	{
		super("ComponentsApp");
	}
	
	
	override private function createLayout ()
	{
		layout						= new LayoutContainer();
		layout.relative				= new RelativeLayout( 5, 5, 5, 5 );
		layout.padding				= new Box( 5 );
		layoutContainer.algorithm	= new RelativeAlgorithm();
	}
	
	
	override private function createBehaviours ()
	{	
		behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
		behaviours.add( new ClippedLayoutBehaviour(this) );
		
		changeLabel.on( userEvents.mouse.down, this );
	}
	
	
	override private function createChildren ()
	{
		//create label
		label	= new Label("testLabel", "Test tekst");
		var rel	= new RelativeLayout();
		rel.hCenter	= 0;
		label.layout.relative = rel;
		children.add(label);
	}
	
	private function changeLabel ()
	{
		label.value += " test";
	}
}