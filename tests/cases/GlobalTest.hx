package cases;
#if debug
 import flash.text.TextFormat;
 import primevc.gui.display.TextField;
// import com.elad.optimize.memory.FrameStats;
#end
 import primevc.core.geom.space.Vertical;
 import primevc.core.geom.IRectangle;
 import primevc.core.Application;
 import primevc.gui.behaviours.drag.DragDropBehaviour;
 import primevc.gui.behaviours.drag.DragMoveBehaviour;
 import primevc.gui.behaviours.drag.DropTargetBehaviour;
 import primevc.gui.behaviours.drag.ShowDragGapBehaviour;
 import primevc.gui.behaviours.drag.DragSource;
 import primevc.gui.behaviours.layout.AutoChangeLayoutChildlistBehaviour;
 import primevc.gui.core.UIContainer;
 import primevc.gui.core.UIDataComponent;
// import primevc.gui.core.UIGraphic;
// import primevc.gui.core.UITextField;
 import primevc.gui.core.UIWindow;
 import primevc.gui.events.DragEvents;
 import primevc.gui.events.DropTargetEvents;
// import primevc.gui.events.MouseEvents;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.tile.DynamicTileAlgorithm;
 import primevc.gui.layout.algorithms.tile.FixedTileAlgorithm;
 import primevc.gui.layout.algorithms.RelativeAlgorithm;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.RelativeLayout;
 import primevc.gui.layout.VirtualLayoutContainer;
 import primevc.gui.traits.IDropTarget;
 import primevc.gui.traits.IDraggable;
 import primevc.types.Number;
 import primevc.utils.Color;
  using primevc.utils.Bind;
  using primevc.utils.Color;
  using primevc.utils.TypeUtil;
  using Type;

/**
 * @creation-date	Sep 16, 2010
 * @author			Ruben Weijers
 */
class GlobalTest
{
	public static function main () { Application.startup( GlobalTestWindow ); }
}

class GlobalTestWindow extends UIWindow
{
	override private function createChildren ()
	{
		var app = new GlobalApp();
		children.add( app );
	}
}



/**
 * @creation-date	Jun 15, 2010
 * @author			Ruben Weijers
 */
class GlobalApp extends UIContainer <Dynamic>
{
	public function new ()
	{
		super("GlobalApp");
	}
	
	
	override private function createBehaviours ()
	{
		changeTileColor.on( userEvents.mouse.click, this );
	}
	
	
	override private function createChildren ()
	{
		var frame0				= new TileList( "frame0", true );
		var frame1				= new TileList( "frame1", true );
		var frame2				= new TileList( "frame2", true, true, 150 );
		var frame3				= new TileList( "frame3", true );
		var frame4				= new Frame("frame4");
		var frame5				= new Frame("frame5");
		var frame6				= new Frame("frame6");
		var frame7				= new Frame("frame7");
		var frame8				= new TileList( "frame8", true );
		
		var box0				= new VirtualLayoutContainer();
		box0.algorithm			= new RelativeAlgorithm();
		box0.percentWidth		= LayoutFlags.FILL;
		box0.percentHeight		= 100;
		
		var box1				= new VirtualLayoutContainer();
		var box1Alg				= new VerticalFloatAlgorithm();
		box1Alg.direction		= Vertical.bottom;
		box1.relative			= new RelativeLayout( 90, 5, 5, Number.INT_NOT_SET );
		box1.percentWidth		= 40;
		box1.algorithm			= box1Alg;
		
		var box2				= new VirtualLayoutContainer();
		box2.algorithm			= new HorizontalFloatAlgorithm();
		box2.percentWidth		= 100;
		box2.percentHeight	 	= 15;

#if debug
		box0.name	= "box0";
		box1.name	= "box1";
		box2.name	= "box2";
#end
		
		layoutContainer.children.add( frame0.layout );
		layoutContainer.children.add( box0 );
		
		box0.children.add( frame1.layout );
		box0.children.add( frame2.layout );
		box0.children.add( box1 );
		
		box1.children.add( frame3.layout );
		box1.children.add( box2 );
		box1.children.add( frame7.layout );
		box1.children.add( frame8.layout );
		
		box2.children.add( frame4.layout );
		box2.children.add( frame5.layout );
		box2.children.add( frame6.layout );
		
		children.add(frame0);
		children.add(frame2);
		children.add(frame1);
		children.add(frame3);
		children.add(frame4);
		children.add(frame5);
		children.add(frame6);
		children.add(frame7);
		children.add(frame8);
	}
	
	
	private function changeTileColor ()
	{
		var tileStyle	= window.as(UIWindow).style.idStyle.children.elementSelectors.get( Tile.getClassName() );
		var newColor	= Color.random();
		tileStyle.background.as( primevc.gui.graphics.fills.SolidFill ).color = newColor;
		trace("changeTileColor to "+newColor.string());
		
		var btnStyle	= window.as(UIWindow).style.idStyle.children.elementSelectors.get( Button.getClassName() );
		btnStyle.visible= !btnStyle.visible;
	}
}



class Button extends UIDataComponent < String >
{
	public static var counter	: Int = 0;
	private var num				: Int;
	
#if (debug && flash9)
	private var textField		: TextField;
#end
	
	public function new (?id:String = "button")
	{
		num = counter++;
		super(id + num);
	}
	
	
#if (debug && flash9)
	override private function createChildren ()
	{
		textField = new TextField();
		textField.text = ""+num;
		textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
		textField.setTextFormat( new TextFormat("Verdana", 15, 0x00 ) );
		textField.mouseEnabled = false;
		children.add( textField );
	}
#end
}



class Tile extends Button, implements IDraggable
{	
	private var dynamicSize					: Bool;
	public var dragEvents (default, null)	: DragEvents;
	public var isDragging					: Bool;
	
	
	public function new (?dynamicSize = false)
	{
		this.dynamicSize = dynamicSize;
		super();
		dragEvents	= new DragEvents();
	}


	override private function createGraphics ()
	{	
		super.createGraphics();
		if (dynamicSize) {
			layout.width += Std.int(layout.width * Math.random());
			layout.height += Std.int(layout.height * Math.random());
		}
	}
	
	
	override private function createBehaviours ()
	{
		super.createBehaviours();
		behaviours.add( new DragDropBehaviour(this) );
	}
}




class DragButton extends Button, implements IDraggable
{
	public var dragEvents (default, null)	: DragEvents;
	public var isDragging					: Bool;
	
	
	public function new ()
	{
		super();
		dragEvents = new DragEvents();
	}
	
	
	override private function createBehaviours ()
	{
		super.createBehaviours();
		behaviours.add( new DragMoveBehaviour(this) );
	}
}



class Frame extends UIContainer < String >
{
#if debug
	public var textField	: TextField;
#end


#if (debug && flash9)
	override private function createChildren () {
		textField = new TextField();
		textField.text = id.value;
		textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
		textField.setTextFormat( new TextFormat("Verdana", 15, 0x00 ) );
		textField.mouseEnabled = false;
		addChild( textField );
	}
#end
}


class TileList extends Frame, implements IDropTarget
{
	public var dragEvents				: DropTargetEvents;
	public var allowDropFromOtherLists	: Bool;
	public var tilesToCreate			: Int;
	
	private var fixedTiles		: FixedTileAlgorithm;
	private var dynamicTiles	: DynamicTileAlgorithm;
	public var dynamicSizes		: Bool;


	public function new (id:String = null, dynamicSizes = false, allowDropFromOtherLists = true, tilesToCreate:Int = 50)
	{	
		this.tilesToCreate				= tilesToCreate;
		this.dynamicSizes				= dynamicSizes;
		this.allowDropFromOtherLists	= allowDropFromOtherLists;
		doubleClickEnabled				= true;
		cacheAsBitmap = true;
		
		dragEvents	= new DropTargetEvents();
		super(id, id);
	}

	override private function createBehaviours ()
	{
		behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
		behaviours.add( new DropTargetBehaviour(this) );
		behaviours.add( new ShowDragGapBehaviour(this) );
		addTile.on( userEvents.mouse.doubleClick, this );
	}
	
	
	override private function createChildren ()
	{
		super.createChildren();
		for ( i in 0...tilesToCreate )
			addTile();
	}
	

	private function addTile ()
	{
		var num		= numChildren;
		var child	= new Tile(dynamicSizes);
		children.add( child );
	}


	//
	// IDROPTARGET IMPLEMENTATION
	//

	public inline function isDropAllowed (draggedItem:DragSource) : Bool {
		return (draggedItem.target.is(Tile) && (allowDropFromOtherLists || this == draggedItem.origContainer));
	}
	public inline function getDepthForBounds (bounds:IRectangle) : Int {
		return layoutContainer.algorithm.getDepthForBounds(bounds);
	}
}