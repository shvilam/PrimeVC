package cases;
#if debug
 import flash.text.TextFormat;
 import primevc.gui.display.TextField;
#end
 import primevc.core.collections.ArrayList;
 import primevc.core.collections.DataCursor;
 import primevc.core.geom.space.Vertical;
 import primevc.core.geom.IRectangle;
 import primevc.core.Application;
 import primevc.gui.behaviours.drag.DragDropBehaviour;
 import primevc.gui.behaviours.drag.ApplyDropBehaviour;
 import primevc.gui.behaviours.drag.ShowDragGapBehaviour;
 import primevc.gui.behaviours.drag.DragInfo;
 import primevc.gui.components.ApplicationView;
 import primevc.gui.components.ListView;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.core.UIDataComponent;
 import primevc.gui.core.UIWindow;
 import primevc.gui.display.DisplayDataCursor;
 import primevc.gui.events.DragEvents;
 import primevc.gui.events.DropTargetEvents;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.RelativeAlgorithm;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.RelativeLayout;
 import primevc.gui.layout.VirtualLayoutContainer;
 import primevc.gui.traits.IDataDropTarget;
 import primevc.gui.traits.IDropTarget;
 import primevc.gui.traits.IDraggable;
 import primevc.types.Number;
 import primevc.utils.Color;
  using primevc.utils.Bind;
  using primevc.utils.Color;
  using primevc.utils.TypeUtil;
  using Type;



typedef DataVOType = String;

/**
 * @creation-date	Sep 16, 2010
 * @author			Ruben Weijers
 */
class GlobalTest extends UIWindow
{
	public static function main () { Application.startup( GlobalTest ); }
	
	override private function createChildren ()
	{
		children.add( new GlobalApp() );
	}
}


/**
 * @creation-date	Jun 15, 2010
 * @author			Ruben Weijers
 */
class GlobalApp extends ApplicationView
{
	private var testList1 : ArrayList < String >;
	
	
	public function new ()
	{
		super("GlobalApp");
		
		testList1 = new ArrayList<DataVOType>();
		for (i in 0...60)
			testList1.add(i+"");
	}
	
	
	override private function createBehaviours () {}
	
	
	override private function createChildren ()
	{
		var frame0				= new TileList( "frame0", testList1 );
		var frame1				= new TileList( "frame1", testList1 );
		var frame2				= new TileList( "frame2", testList1 );
		var frame3				= new TileList( "frame3", testList1 );
		var frame4				= new TileList( "frame4");
		var frame5				= new TileList( "frame5");
		var frame6				= new TileList( "frame6");
		var frame7				= new TileList( "frame7");
		var frame8				= new TileList( "frame8", testList1 );
		
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
}


class Tile extends UIDataComponent < DataVOType >, implements IDraggable
{
	public static var counter				: Int = 0;
	public var dragEvents (default, null)	: DragEvents;
	public var isDragging					: Bool;
	private var num							: Int;

#if (debug && flash9)
	private var textField					: TextField;
#end
	
	
	public function new (value:DataVOType = null)
	{
		num = counter++;
		super("Tile" + num, value);
		dragEvents	= new DragEvents();
	}
	
	
	override private function createBehaviours ()
	{
		super.createBehaviours();
		behaviours.add( new DragDropBehaviour(this) );
		changeStyleClass.on( userEvents.mouse.click, this );
	}
	
	
#if (debug && flash9)
	override private function createChildren ()
	{
		textField = new TextField();
		textField.text = value;
		textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
		textField.setTextFormat( new TextFormat("Verdana", 15, 0x00 ) );
		textField.mouseEnabled = false;
		children.add( textField );
	}
#end
	
	
	public function createDragInfo () : DragInfo
	{
		return new DragInfo( this, getDataCursor() );//, t ); //getDisplayCursor()/*, new Tile(value), null*/ );
	}
	
	
	private function changeStyleClass ()
	{
		if (styleClasses.length == 1)
			styleClasses.remove("odd");
		else
			styleClasses.add("odd");
	}
}


class TileList extends ListView < DataVOType >, implements IDataDropTarget < DataVOType >
{
	public var dragEvents	(default, null) : DropTargetEvents;
	
	
	public function new (id:String = null, list:ArrayList<DataVOType> = null)
	{
		doubleClickEnabled	= true;
		dragEvents			= new DropTargetEvents();
		super(id, list);
	}
	
	
	override private function createBehaviours ()
	{
		super.createBehaviours();
		behaviours.add( new ApplyDropBehaviour (this) );
		behaviours.add( new ShowDragGapBehaviour(this) );
	}
	
	
	override private function createItemRenderer (dataItem:DataVOType, pos:Int)
	{
		return cast new Tile(dataItem);
	}
	
	
	public function isDisplayDropAllowed (displayCursor:DisplayDataCursor ) : Bool
	{
		var allowed = false;
		if (displayCursor.target.is(Tile))
		{
			var tile = displayCursor.target.as(Tile);
			if ( value != null && !value.has( tile.value ) )
				allowed = true;
		}
		return allowed;
	}
	
	
	public function isDataDropAllowed (dataCursor:DataCursor < DataVOType > ) : Bool
	{
		return dataCursor.list == value;
	}
	
	
	public inline function getDepthForBounds (bounds:IRectangle) : Int
	{
		return layoutContainer.algorithm.getDepthForBounds(bounds);
	}
}