package cases;
#if debug
 import flash.text.TextField;
 import flash.text.TextFormat;
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
 * @creation-date	Jul 13, 2010
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
		var app = new LayoutApp();
		children.add( app );
	}
}



/**
 * @creation-date	Jun 15, 2010
 * @author			Ruben Weijers
 */
class LayoutApp extends UIContainer <Dynamic>
{
	public function new ()
	{
		super("LayoutApp");
	}
	
	
	override private function createLayout ()
	{
		layout						= new LayoutContainer();
		layout.relative				= new RelativeLayout( 5, 5, 5 );
		layout.percentWidth			= 50;
		layout.padding				= new Box( 5 );
		layoutContainer.algorithm	= new RelativeAlgorithm();
	}
	
	
	override private function createBehaviours ()
	{
		behaviours.add( new ClippedLayoutBehaviour(this) );
	}
	
	
	override private function createChildren ()
	{
		var frame0							= new TileList( "frame0", true );
		frame0.layoutContainer.algorithm	= new VerticalFloatAlgorithm( Vertical.bottom );
		frame0.layout.percentHeight			= 100;
	//	frame0.layout.width					= 150;
		
		var frame1							= new TileList( "frame1", true );
		frame1.layoutContainer.algorithm	= new HorizontalFloatAlgorithm( Horizontal.left );
		frame1.layout.height				= 60;
		frame1.layout.relative				= new RelativeLayout( 5, 5, -100000, 5 );
		
		var frame2							= new TileList( "frame2", true, true, 150 );
		var frame2Alg						= new FixedTileAlgorithm();
		frame2Alg.maxTilesInDirection		= 16;
		frame2Alg.startDirection			= Direction.vertical;
	//	frame2Alg.horizontalDirection		= Horizontal.right;
	//	frame2Alg.verticalDirection			= Vertical.bottom;
		frame2.layoutContainer.algorithm	= frame2Alg;
		frame2.layout.relative				= new RelativeLayout( frame1.layout.bounds.bottom + 5, -100000, 5, 5 );
		frame2.layout.percentWidth			= 58;
		
		var frame3							= new TileList( "frame3", true );
		frame3.layoutContainer.algorithm	= new DynamicTileAlgorithm();
		frame3.layout.percentWidth			= 100;
		frame3.layout.percentHeight			= 40;
		
		var frame4							= new Frame("frame4");
		frame4.layout.percentWidth			= 50;
		frame4.layout.percentHeight			= 100;
		
		var frame5							= new Frame("frame5");
		frame5.layout.percentWidth			= LayoutFlags.FILL;
		frame5.layout.percentHeight			= 100;
		
		var frame6							= new Frame("frame6");
		frame6.layout.percentWidth			= LayoutFlags.FILL;
		frame6.layout.percentHeight			= 100;
		
		var frame7							= new Frame("frame7");
		frame7.layout.percentWidth			= 60;
		frame7.layout.percentHeight			= 5;
	//	frame7.layout.sizeConstraint	= new SizeConstraint(100, 400, 50, 200);
		
		var frame8							= new TileList( "frame8", true );
		frame8.layout.percentWidth			= 100;
		frame8.layout.percentHeight			= 40;
		frame8.layoutContainer.algorithm	= new DynamicLayoutAlgorithm(
			new HorizontalCircleAlgorithm( Horizontal.left ),
			new VerticalCircleAlgorithm( Vertical.top )
		);
		
		var box0				= new VirtualLayoutContainer();
		box0.algorithm			= new RelativeAlgorithm();
		box0.percentWidth		= LayoutFlags.FILL;
		box0.percentHeight		= 100;
		
		var box1				= new VirtualLayoutContainer();
		var box1Alg				= new VerticalFloatAlgorithm();
		box1Alg.direction		= Vertical.bottom;
		box1.relative			= new RelativeLayout( frame1.layout.bounds.bottom + 5 /*TOP*/, 5/*RIGHT*/, 5/*BOTTOM*/, -100000/*BOTTOM*/ );
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
		graphicData.value = new GraphicProperties (
			new RegularRectangle(),
			layout.bounds, 
			null, 
			cast new SolidBorder( new SolidFill(0x00), 1 )
		);
	}
}



class Button extends UIDataComponent < String >
{
#if (debug && flash9)
	public static var counter	: Int = 0;
	private var num				: Int;
	private var textField		: TextField;
#end
	private var color			: UInt;
	private var fill			: SolidFill;
	
	
	public function new (?id:String = "button")
	{
		color		= 0xaaaaaa;
#if debug
		num			= counter++;
		super(id + num);
#else
		super(id);
#end
	}
	
	
	private function highlight ()	{ fill.color = 0xaaaaaa; }
	private function normallity ()	{ fill.color = color; }
	
	
	override private function createBehaviours ()
	{
		highlight.on( userEvents.mouse.rollOver, this );
		normallity.on( userEvents.mouse.rollOut, this );
	}
	
	
	override private function createLayout ()
	{
		layout	= new LayoutClient(20, 20);
	}
	
	
	override private function createGraphics ()
	{	
		fill = new SolidFill( color );
		graphicData.value = new GraphicProperties( new RegularRectangle(), layout.bounds, fill );
	}
	
#if (debug && flash9)
	override private function createChildren ()
	{
		textField = new TextField();
		textField.text = ""+num;
		textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
		textField.setTextFormat( new TextFormat("Verdana", 15, 0x00 ) );
		textField.mouseEnabled = false;
		addChild( textField );
	}
#end
}

/*
class TileFadeMoveEffect extends SequenceEffect
{
	private var fadeIn		: FadeEffect;
	private var fadeOut		: FadeEffect;
	private var setAction	: SetAction;
	
	override public function init ()
	{
		add( fadeOut	= new FadeEffect(null, 200, 0, null, 1, 0) );
		add( setAction	= new SetAction() );
		add( fadeIn		= new FadeEffect(null, 200, 0, null, 0, 1) );
	}
	
	override public function setValues (v:EffectProperties)
	{
		setAction.setValues(v);
	}
}

class TileMoveScaleEffect extends ParallelEffect
{
	private var move		: MoveEffect;
	private var scaleCol	: SequenceEffect;
	private var scaleIn		: ScaleEffect;
	private var scaleOut	: ScaleEffect;
	
	
	override public function init ()
	{
		add( move				= new MoveEffect(null, 600) );
		add( scaleCol			= new SequenceEffect() );
		scaleCol.add( scaleIn	= new ScaleEffect(null, 300) );
		scaleCol.add( scaleOut	= new ScaleEffect(null, 300) );
		
		scaleIn.endX	= scaleIn.endY	= 2;
		scaleOut.endX	= scaleOut.endY	= 1;
	}
	
	override public function setValues (v:EffectProperties)
	{
		move.setValues(v);
	}
}



typedef Eff = feffects.easing.Elastic;


class TileRotateFadeScaleMoveEffect extends SequenceEffect
{
	private var move		: MoveEffect;
	private var rotate1		: RotateEffect;
	private var rotate2		: RotateEffect;
	private var fadeIn		: FadeEffect;
	private var fadeOut		: FadeEffect;
	private var scaleIn		: ScaleEffect;
	private var scaleOut	: ScaleEffect;
	private var prlIn		: ParallelEffect;
	private var prlOut		: ParallelEffect;
	
	override public function init ()
	{
		add( prlIn			= new ParallelEffect() );
		add( prlOut			= new ParallelEffect() );
		
		prlIn.add( fadeOut	= new FadeEffect(null, 150, 0, Eff.easeInOut, .7) );
		prlIn.add( move		= new MoveEffect(null, 800, 0, Eff.easeInOut) );
		prlIn.add( scaleIn	= new ScaleEffect(null, 800, 0, Eff.easeInOut, 2, 2) );
	//	prlIn.add( scaleIn	= new AnchorScaleEffect(null, 500, 0, null, Position.MiddleCenter, 2.5) );
		prlIn.add( rotate1	= new RotateEffect(null, 800, 0, Eff.easeInOut, 360 * Math.random()) );
		
		prlOut.add( fadeIn	= new FadeEffect(null, 500, 0, null, 1) );
		prlOut.add( scaleOut= new ScaleEffect(null, 500, 0, Eff.easeInOut, 1, 1) );
	//	prlOut.add( scaleOut= new AnchorScaleEffect(null, 500, 0, null, Position.MiddleCenter, 1) );
		prlOut.add( rotate2	= new RotateEffect(null, 500, 0, Eff.easeInOut, 0) );
	}
	
	override public function setValues (v:EffectProperties)
	{
		move.setValues(v);
	}
}
*/

class Tile extends Button, implements IDraggable
{	
	private var dynamicSize					: Bool;
	public var dragEvents (default, null)	: DragEvents;
	public var isDragging					: Bool;
	
	
	public function new (?dynamicSize = false)
	{
		this.dynamicSize = dynamicSize;
		super("tile");
		color		= Color.random();
		dragEvents	= new DragEvents();
		
		effects			= new UIElementEffects( this );
	//	effects.move	= new TileFadeMoveEffect();
		effects.move	= new MoveEffect(null, 400); //, 0, Eff.easeOut);
	//	effects.move	= new TileMoveScaleEffect();
	//	effects.move	= new TileRotateFadeScaleMoveEffect();
	}


	override private function createLayout ()
	{	
		super.createLayout();
		if (dynamicSize) {
			layout.width += Std.int(30 * Math.random());
			layout.height += Std.int(30 * Math.random());
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



/*
class DragThumb extends UIComponent
{ 
	public var direction	: Direction;
	
	
	public function new (direction:Direction)
	{
		this.direction = direction;
		super();
	}
	
	
	override private function createLayout ()
	{
		layout = new LayoutClient();
		if (direction == Direction.horizontal)
			layout.relative = new RelativeLayout( 2, -100000, 2 );
		else
			layout.relative = new RelativeLayout( -100000, 2, -100000, 2 );
	}
	
	
	override public function render ()
	{
		var g = graphics;
		var l = layout.bounds;
		g.beginFill( 0x00aadd );
		g.drawRoundRect( l.left, l.top, l.width, l.height, 5 );
		g.endFill();
	}
}



class DragTrack extends UIComponent
{
	override private function createLayout ()
	{
		layout = new LayoutClient();
		layout.relative = new RelativeLayout( 3, 3, 3, 3 );
	}
}



class ScrollBar extends UIComponent
{
	private var dragThumb	: DragThumb;
	private var track		: DragTrack;
	public var direction	: Direction;
	
	
	public function new (direction:Direction)
	{
		this.direction = direction;
		super();
	}
	
	
	override private function createLayout ()
	{
		layout = new LayoutContainer();
		
		var size:Int = 50;
		if (direction == Direction.horizontal) {
	//		layout.relative = new RelativeLayout( target.layout.height )
		}
	}
	
	
	override private function createChildren ()
	{
		track		= new DragTrack();
		dragThumb	= new DragThumb( direction );
		
		dragThumb.behaviours.add( new DragMoveBehaviour(dragThumb, track.layout.bounds) );
		
		layoutGroup.children.add( track.layout );
		layoutGroup.children.add( dragThumb.layout );
		
		children.add( track );
		children.add( dragThumb );
	}
}
*/



class Frame extends UIContainer < String >
{
#if debug
	public var textField	: TextField;
#end
	private var color 		: UInt;
	private var fill		: SolidFill;


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
		color	= Color.random();
		fill	= new SolidFill(0xFFFFFFFF);
		graphicData.value = new GraphicProperties( new RegularRectangle(), layout.bounds, fill, cast new SolidBorder( new SolidFill(color), 3, true ) );
	}
}

/*

class UIList <ListType:IList, RenderType:IUIElement> extends UIContainer < ListType >
{ 
	
}
*/

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
		super(id);
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
		dragOverHandler.on( dragEvents.over, this );
		dragOutHandler.on( dragEvents.out, this );
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
		layout.padding = new Box(10);

		if (!dynamicSizes) {
			layoutContainer.childWidth	= 20;
			layoutContainer.childHeight	= 20;
		}
	}
	
	/*
	override public function render () {
		super.render();
		
		if (draggedOver) {
			var l = layout;
			var g = graphics;
			g.beginFill(color, .3);
			g.drawRect( 
				l.padding.left, 
				l.padding.top,
				l.width, // - l.padding.left - l.padding.right, 
				l.height //- l.padding.top - l.padding.bottom
			);
			
			g.endFill();
			
		}
	}
	*/

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
	
	private function dragOverHandler ()	{ fill.color = color.setAlpha(.3.uint()); }
	private function dragOutHandler ()	{ fill.color = 0xffffffff; }
}




/*
class ResizeFromCornerBehaviour extends BehaviourBase <ISkin>
{
	private var dragBtn			: DragButton;
	private var startSize		: IntPoint;
	private var lastMousePos	: Point;
	
	
	override private function init () {
		var l		= new RelativeLayout();
		l.bottom	= 3;
		l.right		= 3;
		
		dragBtn = new DragButton();
		dragBtn.layout.includeInLayout = false;
		dragBtn.layout.relative = l;
		
		startResize.on( dragBtn.dragEvents.start, this );
		target.children.add(dragBtn);
		target.layout.as(LayoutContainer).children.add( dragBtn.layout );
	}
	
	
	override private function reset ()
	{
		dragBtn.dragEvents.start.unbind(this);
		dragBtn.dragEvents.complete.unbind(this);
		dragBtn.dragEvents.exit.unbind(this);
		dragBtn.window.mouse.events.move.unbind(this);
		
		dragBtn.dispose();
		dragBtn			= null;
		startSize		= null;
		lastMousePos	= null;
	}
	
	
	private function startResize ()
	{
		lastMousePos = new Point( target.window.mouse.x, target.window.mouse.y );
		
		dragBtn.dragEvents.start.unbind(this);
		stopResize	.on( dragBtn.dragEvents.complete, this );
		cancelResize.on( dragBtn.dragEvents.exit, this );
		doResize	.on( dragBtn.window.mouse.events.move, this );
	}
	
	
	private function stopResize ()
	{
		lastMousePos = null;
		dragBtn.dragEvents.complete.unbind(this);
		dragBtn.dragEvents.exit.unbind(this);
		dragBtn.window.mouse.events.move.unbind(this);
		startResize.on( dragBtn.dragEvents.start, this );
	}
	
	
	private function cancelResize ()
	{
		lastMousePos			= null;
		target.layout.width		= startSize.x;
		target.layout.height	= startSize.y;
		
		dragBtn.dragEvents.complete.unbind(this);
		dragBtn.dragEvents.exit.unbind(this);
		dragBtn.window.mouse.events.move.unbind(this);
		startResize.on( dragBtn.dragEvents.start, this );
	}
	
	
	private function doResize (mouseState:MouseState)
	{
		var delta = mouseState.stage.subtract( lastMousePos );
		target.layout.width += Std.int( delta.x );
		target.layout.height += Std.int( delta.y );
		lastMousePos = mouseState.stage;
	}
}*/