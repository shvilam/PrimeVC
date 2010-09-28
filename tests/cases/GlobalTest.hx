package cases;
#if debug
 import flash.text.TextFormat;
 import primevc.gui.display.TextField;
// import com.elad.optimize.memory.FrameStats;
#end
 import primevc.core.geom.constraints.SizeConstraint;
 import primevc.core.geom.space.Direction;
 import primevc.core.geom.space.Horizontal;
 import primevc.core.geom.space.Position;
 import primevc.core.geom.space.Vertical;
 import primevc.core.geom.Box;
 import primevc.core.geom.IntPoint;
 import primevc.core.geom.IRectangle;
 import primevc.core.Application;
 import primevc.gui.behaviours.drag.DragDropBehaviour;
 import primevc.gui.behaviours.drag.DragMoveBehaviour;
 import primevc.gui.behaviours.drag.DropTargetBehaviour;
 import primevc.gui.behaviours.drag.ShowDragGapBehaviour;
 import primevc.gui.behaviours.drag.DragSource;
 import primevc.gui.behaviours.layout.ClippedLayoutBehaviour;
 import primevc.gui.behaviours.layout.AutoChangeLayoutChildlistBehaviour;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.behaviours.scroll.CornerScrollBehaviour;
 import primevc.gui.behaviours.scroll.MouseMoveScrollBehaviour;
 import primevc.gui.behaviours.scroll.DragScrollBehaviour;
 import primevc.gui.core.IUIComponent;
 import primevc.gui.core.IUIElement;
 import primevc.gui.core.UIContainer;
 import primevc.gui.core.UIDataComponent;
 import primevc.gui.core.UIGraphic;
 import primevc.gui.core.UITextField;
 import primevc.gui.core.UIWindow;
 import primevc.gui.effects.AnchorScaleEffect;
 import primevc.gui.effects.EffectProperties;
 import primevc.gui.effects.FadeEffect;
 import primevc.gui.effects.MoveEffect;
 import primevc.gui.effects.ParallelEffect;
 import primevc.gui.effects.ResizeEffect;
 import primevc.gui.effects.RotateEffect;
 import primevc.gui.effects.SetAction;
 import primevc.gui.effects.ScaleEffect;
 import primevc.gui.effects.SequenceEffect;
 import primevc.gui.effects.UIElementEffects;
 import primevc.gui.effects.WipeEffect;
 import primevc.gui.events.DragEvents;
 import primevc.gui.events.DropTargetEvents;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.graphics.borders.BitmapBorder;
 import primevc.gui.graphics.borders.GradientBorder;
 import primevc.gui.graphics.borders.SolidBorder;
 import primevc.gui.graphics.fills.BitmapFill;
 import primevc.gui.graphics.fills.ComposedFill;
 import primevc.gui.graphics.fills.SolidFill;
 import primevc.gui.graphics.shapes.Circle;
// import primevc.gui.graphics.shapes.ComposedShape;
 import primevc.gui.graphics.shapes.Ellipse;
 import primevc.gui.graphics.shapes.Line;
 import primevc.gui.graphics.shapes.Triangle;
 import primevc.gui.graphics.shapes.RegularRectangle;
 import primevc.gui.graphics.GraphicProperties;
 import primevc.gui.layout.algorithms.circle.HorizontalCircleAlgorithm;
 import primevc.gui.layout.algorithms.circle.VerticalCircleAlgorithm;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.tile.DynamicTileAlgorithm;
 import primevc.gui.layout.algorithms.tile.FixedTileAlgorithm;
 import primevc.gui.layout.algorithms.DynamicLayoutAlgorithm;
 import primevc.gui.layout.algorithms.RelativeAlgorithm;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutContainer;
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
	
	
	override private function createLayout ()
	{
		layout						= new LayoutContainer();
	//	layout.relative				= new RelativeLayout( 5, 5, 5 );
	//	layout.percentWidth			= 50;
	//	layout.padding				= new Box( 5 );
	//	layoutContainer.algorithm	= new RelativeAlgorithm();
	}
	
	
	override private function createBehaviours ()
	{
		behaviours.add( new ClippedLayoutBehaviour(this) );
	}
	
	
	override private function createChildren ()
	{
	//	trace("createChildren");
	//	var proxy = style.getLayout();
	//	trace("layout maxwidth "+proxy.maxWidth);
		var frame0							= new TileList( "frame0", true );
	//	frame0.layoutContainer.algorithm	= new VerticalFloatAlgorithm( Vertical.bottom );
	//	frame0.layout.percentHeight			= 100;
	//	frame0.layout.width					= 150;
		
		var frame1							= new TileList( "frame1", true );
	//	frame1.layoutContainer.algorithm	= new HorizontalFloatAlgorithm( Horizontal.left );
	//	frame1.layout.height				= 60;
	//	frame1.layout.relative				= new RelativeLayout( 5, 5, Number.INT_NOT_SET, 5 );
		
		var frame2							= new TileList( "frame2", true, true, 150 );
	//	var frame2Alg						= new FixedTileAlgorithm();
	//	frame2Alg.maxTilesInDirection		= 16;
	//	frame2Alg.startDirection			= Direction.vertical;
	//	frame2Alg.horizontalDirection		= Horizontal.right;
	//	frame2Alg.verticalDirection			= Vertical.bottom;
	//	frame2.layoutContainer.algorithm	= frame2Alg;
	//	frame2.layout.relative				= new RelativeLayout( frame1.layout.bounds.bottom + 5, Number.INT_NOT_SET, 5, 5 );
	//	frame2.layout.percentWidth			= 58;
		
		var frame3							= new TileList( "frame3", true );
	//	frame3.layoutContainer.algorithm	= new DynamicTileAlgorithm();
	//	frame3.layout.percentWidth			= 100;
	//	frame3.layout.percentHeight			= 40;
		
		var frame4							= new Frame("frame4");
	//	frame4.layout.percentWidth			= 50;
	//	frame4.layout.percentHeight			= 100;
		
		var frame5							= new Frame("frame5");
	//	frame5.layout.percentWidth			= LayoutFlags.FILL;
	//	frame5.layout.percentHeight			= 100;
		
		var frame6							= new Frame("frame6");
	//	frame6.layout.percentWidth			= LayoutFlags.FILL;
	//	frame6.layout.percentHeight			= 100;
		
		var frame7							= new Frame("frame7");
	//	frame7.layout.percentWidth			= 60;
	//	frame7.layout.percentHeight			= 5;
	//	frame7.layout.sizeConstraint	= new SizeConstraint(100, 400, 50, 200);
		
		var frame8							= new TileList( "frame8", true );
	//	frame8.layout.percentWidth			= 100;
	//	frame8.layout.percentHeight			= 40;
	/*	frame8.layoutContainer.algorithm	= new DynamicLayoutAlgorithm(
			new HorizontalCircleAlgorithm( Horizontal.left ),
			new VerticalCircleAlgorithm( Vertical.top )
		);*/
		
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
		
		layoutContainer.algorithm = new HorizontalFloatAlgorithm();
		
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
		
		children.add(frame0, 0);
		children.add(frame2, 1);
		children.add(frame1, 2);
		children.add(frame3, 3);
		children.add(frame4, 4);
		children.add(frame5, 5);
		children.add(frame6, 6);
		children.add(frame7, 7);
		children.add(frame8, 8);
	}
	
	
	override private function createGraphics ()
	{
	/*	graphicData.value = new GraphicProperties (
			new RegularRectangle(),
			layout.bounds//, 
		//	null, 
		//	cast new SolidBorder( new SolidFill(0x00), 1 )
		);*/
		
		graphicData.value.shape = new RegularRectangle();
		graphicData.value.layout = layout.bounds;
	}
}



class Button extends UIDataComponent < String >
{
#if (debug && flash9)
	public static var counter	: Int = 0;
	private var num				: Int;
	private var textField		: TextField;
#end
//	private var color			: UInt;
//	private var fill			: SolidFill;
	
	
	public function new (?id:String = "button")
	{
//		color		= 0xaaaaaa;
#if debug
		num			= counter++;
		super(id + num);
#else
		super(id);
#end
	}
	
	
//	private function highlight ()	{ fill.color = 0xaaaaaa; }
//	private function normallity ()	{ fill.color = color; }
	
	
	override private function createBehaviours ()
	{
	//	highlight.on( userEvents.mouse.rollOver, this );
	//	normallity.on( userEvents.mouse.rollOut, this );
	}
	
	
	override private function createLayout ()
	{
		layout	= new LayoutClient();
	}
	
	
	override private function createGraphics ()
	{	
	//	fill = new SolidFill( color );
/*		graphicData.value = new GraphicProperties( new RegularRectangle(), layout.bounds ); //, fill );*/
		graphicData.value.shape = new RegularRectangle();
		graphicData.value.layout = layout.bounds;
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
	//	color		= Color.random();
		dragEvents	= new DragEvents();
		
		effects			= new UIElementEffects( this );
	//	effects.move	= new TileFadeMoveEffect();
		effects.move	= new MoveEffect(null, 400); //, 0, Eff.easeOut);
	//	effects.move	= new TileMoveScaleEffect();
	//	effects.move	= new TileRotateFadeScaleMoveEffect();
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
//	private var color 		: UInt;
//	private var fill		: SolidFill;


	override private function createLayout ()
	{
		layout = new LayoutContainer();
	}


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


	override private function createGraphics ()
	{
	//	color	= Color.random();
	//	fill	= new SolidFill(0xFFFFFFFF);
	//	graphicData.value = new GraphicProperties( new RegularRectangle(), layout.bounds ); //, fill, cast new SolidBorder( new SolidFill(color), 3, true ) );
		graphicData.value.shape = new RegularRectangle();
		graphicData.value.layout = layout.bounds;
	}
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
		
		dragEvents	= new DropTargetEvents();
		super(id, id);
	}

	override private function createBehaviours ()
	{
		behaviours.add( new ClippedLayoutBehaviour(this) );
		behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
		behaviours.add( new DropTargetBehaviour(this) );
		behaviours.add( new ShowDragGapBehaviour(this) );
	//	behaviours.add( new MouseMoveScrollBehaviour(this) );
	//	behaviours.add( new CornerScrollBehaviour(this) );
		behaviours.add( new DragScrollBehaviour(this) );
	//	dragOverHandler.on( dragEvents.over, this );
	//	dragOutHandler.on( dragEvents.out, this );
		addTile.on( userEvents.mouse.doubleClick, this );
	}
	
	
	override private function createChildren ()
	{
		super.createChildren();
		for ( i in 0...tilesToCreate )
			addTile();
	}


	override private function createLayout ()
	{
		super.createLayout();

/*		if (!dynamicSizes) {
			layoutContainer.childWidth	= 20;
			layoutContainer.childHeight	= 20;
		}*/
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
	
//	private function dragOverHandler ()	{ fill.color = color.setAlpha(.3.uint()); }
//	private function dragOutHandler ()	{ fill.color = 0xffffffff; }
}