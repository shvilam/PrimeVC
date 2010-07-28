package cases;
#if debug
 import flash.text.TextField;
 import flash.text.TextFormat;
// import com.elad.optimize.memory.FrameStats;
#end
 import primevc.core.geom.constraints.SizeConstraint;
 import primevc.core.geom.Box;
 import primevc.core.geom.IntPoint;
 import primevc.core.geom.Point;
 import primevc.core.Application;
 import primevc.gui.behaviours.drag.DragDropBehaviour;
 import primevc.gui.behaviours.drag.DragMoveBehaviour;
 import primevc.gui.behaviours.drag.DropTargetBehaviour;
 import primevc.gui.behaviours.drag.ShowDragGapBehaviour;
 import primevc.gui.behaviours.drag.DragSource;
 import primevc.gui.behaviours.drag.IDropTarget;
 import primevc.gui.behaviours.drag.IDraggable;
 import primevc.gui.behaviours.layout.ClippedLayoutBehaviour;
 import primevc.gui.behaviours.layout.AutoChangeLayoutChildlistBehaviour;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.ISkin;
 import primevc.gui.core.Skin;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.events.DragEvents;
 import primevc.gui.events.DropTargetEvents;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.layout.algorithms.circle.HorizontalCircleAlgorithm;
 import primevc.gui.layout.algorithms.circle.VerticalCircleAlgorithm;
 import primevc.gui.layout.algorithms.directions.Direction;
 import primevc.gui.layout.algorithms.directions.Horizontal;
 import primevc.gui.layout.algorithms.directions.Vertical;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.relative.RelativeAlgorithm;
 import primevc.gui.layout.algorithms.tile.DynamicTileAlgorithm;
 import primevc.gui.layout.algorithms.tile.FixedTileAlgorithm;
 import primevc.gui.layout.algorithms.DynamicLayoutAlgorithm;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.RelativeLayout;
 import primevc.gui.layout.VirtualLayoutContainer;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;

/**
 * @creation-date	Jul 13, 2010
 * @author			Ruben Weijers
 */
class LayoutTest extends Application
{
	public static function main () { Application.startup( LayoutTest ); }
	
/*#if debug
	private var frameStats : FrameStats;
#end*/
	
	public function new (target)
	{
		super(target);
		var skin = new LayoutAppSkin();
		window.layout.children.add( skin.layout );
		window.children.add( skin );
/*#if debug
		frameStats = new FrameStats(skin);
		window.children.add( frameStats );
		moveFrameStats.on( window.layout.events.sizeChanged, this );
		moveFrameStats();
#end*/
	}
	
/*
#if debug
	private function moveFrameStats ()
	{
		frameStats.x = window.layout.width - FrameStats.WIDTH;
	}
#end*/
}



/**
 * @creation-date	Jun 15, 2010
 * @author			Ruben Weijers
 */
class LayoutAppSkin extends Skin < LayoutTest >
{
	public var layoutGroup (getLayoutGroup, null)	: LayoutContainer;
		private inline function getLayoutGroup ()	{ return layout.as( LayoutContainer ); }
	
	
	public function new ()
	{
		super();
#if debug
		id = "LayoutAppSkin";
#end
	}
	
	override private function createLayout ()
	{
		layout = new LayoutContainer();
		layout.relative			= new RelativeLayout( 5, 5, 5 );
		layout.percentWidth		= 70;
		layout.padding	= new Box( 5 );
		layoutGroup.algorithm = new RelativeAlgorithm();
	}
	
	
	override private function createBehaviours ()
	{
		behaviours.add( new ClippedLayoutBehaviour(this) );
	}
	
	
	override private function createChildren ()
	{
		var frame0						= new TileList( true );
		frame0.layoutGroup.algorithm	= new VerticalFloatAlgorithm( Vertical.bottom );
		frame0.layout.percentHeight		= 100;
	//	frame0.layout.width				= 150;
		
		var frame1						= new TileList( true );
		frame1.layoutGroup.algorithm	= new HorizontalFloatAlgorithm( Horizontal.right );
		frame1.layout.height			= 60;
		frame1.layout.relative			= new RelativeLayout( 5, 5, -100000, 5 );
		
		var frame2						= new TileList( true, true, 150 );
		var frame2Alg					= new FixedTileAlgorithm();
		frame2Alg.maxTilesInDirection	= 15;
		frame2Alg.startDirection		= Direction.vertical;
	//	frame2Alg.horizontalDirection	= Horizontal.right;
	//	frame2Alg.verticalDirection		= Vertical.bottom;
		frame2.layoutGroup.algorithm	= frame2Alg;
		frame2.layout.relative			= new RelativeLayout( frame1.layout.bounds.bottom + 5, -100000, 5, 5 );
		frame2.layout.percentWidth		= 58;
		
		var frame3						= new TileList( true );
		frame3.layoutGroup.algorithm	= new DynamicTileAlgorithm();
		frame3.layout.percentWidth		= 100;
		frame3.layout.percentHeight		= 40;
		
		var frame4						= new Frame();
		frame4.layout.percentWidth		= 50;
		frame4.layout.percentHeight		= 100;
		
		var frame5						= new Frame();
		frame5.layout.percentWidth		= LayoutFlags.FILL;
		frame5.layout.percentHeight		= 100;
		
		var frame6						= new Frame();
		frame6.layout.percentWidth		= LayoutFlags.FILL;
		frame6.layout.percentHeight		= 100;
		
		var frame7						= new Frame();
		frame7.layout.percentWidth		= 60;
		frame7.layout.percentHeight		= 5;
	//	frame7.layout.sizeConstraint	= new SizeConstraint(100, 400, 50, 200);
		
		var frame8						= new TileList( true );
		frame8.layout.percentWidth		= 100;
		frame8.layout.percentHeight		= 40;
		frame8.layoutGroup.algorithm	= new DynamicLayoutAlgorithm(
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
		frame0.id = "frame0";
		frame1.id = "frame1";
		frame2.id = "frame2";
		frame3.id = "frame3";
		frame4.id = "frame4";
		frame5.id = "frame5";
		frame6.id = "frame6";
		frame7.id = "frame7";
		frame8.id = "frame8";
		
		box0.name	= "box0";
		box1.name	= "box1";
		box2.name	= "box2";
#end
		
		layoutGroup.algorithm = new HorizontalFloatAlgorithm();
		
		layoutGroup.children.add( frame0.layout );
		layoutGroup.children.add( box0 );
		
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
	
	
	override public function render ()
	{
		var l = layout.bounds;
		var g = graphics;
		g.clear();
		g.lineStyle(3, 0x00, 1);
		g.drawRect( 3, 3, l.width - 6, l.height - 6 );
	}
}



class Button extends Skin < Tile >
{
#if (debug && flash9)
	public static var counter	: Int = 0;
	private var num				: Int;
	private var textField		: TextField;
#end
	private var color			: UInt;
	private var isHovered		: Bool;
	
	
	public function new ()
	{
		isHovered	= false;
		super();
#if debug
		num			= counter++;
		if (id == null)
			id = "button";
#end
	}
	
	
	override public function render ()
	{
		var l		 = layout.bounds;
		var g		 = graphics;
		
		g.clear();
		
		if (isHovered) {
			g.lineStyle( 2, color );
			g.beginFill( 0xffffff, 0 );
			g.drawRect( 2, 2, l.width - 4, l.height - 4 );
		} else {
			g.beginFill( color );
			g.drawRect( 0, 0, l.width, l.height );
		}
		
		g.endFill();
	}
	
	
	private function highlight ()	{ isHovered = true; render(); }
	private function normallity ()	{ isHovered = false; render(); }
	
	
	override private function createBehaviours ()
	{
		highlight.on( userEvents.mouse.rollOver, this );
		normallity.on( userEvents.mouse.rollOut, this );
	}
	
	
	override private function createLayout ()
	{
		layout = new LayoutClient(20, 20);
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




class Tile extends Button, implements IDraggable
{	
	private var dynamicSize					: Bool;
	public var dragEvents (default, null)	: DragEvents;
	
	
	public function new (?dynamicSize = false)
	{		
		color = Math.round( Math.random() * 0xffffff );
		this.dynamicSize = dynamicSize;
		super();
#if debug
		id = "tile" + num;
#end
		dragEvents = new DragEvents();
	}


	override private function createLayout ()
	{
		if (dynamicSize)
			layout = new LayoutClient(20 + Std.int(30 * Math.random()), Std.int(20 + 30 * Math.random()));
		else
			super.createLayout();
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




class Frame extends Skin < Box >
{
#if debug
	public var textField	: TextField;
#end
	private var color 		: UInt;

	public var layoutGroup (getLayoutGroup, null)	: LayoutContainer;
		private inline function getLayoutGroup ()	{ return layout.as( LayoutContainer ); }
	

	public function new ()
	{
		super();
#if debug
		id = "frame";
#end
		color = Math.round( Math.random() * 0xffffff );
	}


	override private function createLayout ()
	{
		layout = new LayoutContainer();
	}


#if (debug && flash9)
	override private function createChildren () {
		textField = new TextField();
		textField.text = name;
		textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
		textField.setTextFormat( new TextFormat("Verdana", 15, 0x00 ) );
		textField.mouseEnabled = false;
		addChild( textField );
	}
#end


	override public function render ()
	{
		var l = layout.bounds;
		var g = graphics;
		g.clear();
		g.beginFill(0xffffff, 0);
		g.lineStyle(3, color, 1);
		g.drawRect( 3, 3, l.width - 6, l.height - 6 );
		g.endFill();
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
	public var draggedOver		: Bool;


	public function new (dynamicSizes = false, allowDropFromOtherLists = true, tilesToCreate:Int = 25)
	{	
		this.tilesToCreate				= tilesToCreate;
		this.dynamicSizes				= dynamicSizes;
		this.allowDropFromOtherLists	= allowDropFromOtherLists;
		doubleClickEnabled				= true;
		
		dragEvents	= new DropTargetEvents();
		draggedOver	= false;
		super();
#if debug
		id = "TilesOwner";
#end
	}

	override private function createBehaviours ()
	{
		behaviours.add( new ClippedLayoutBehaviour(this) );
		behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
		behaviours.add( new DropTargetBehaviour(this) );
		behaviours.add( new ShowDragGapBehaviour(this) );
		dragOverHandler.on( dragEvents.over, this );
		dragOutHandler.on( dragEvents.out, this );
		addTile.on( userEvents.mouse.doubleClick, this );
	}
	
	
	override private function createChildren ()
	{
		for ( i in 0...tilesToCreate )
			addTile();
	}


	override private function createLayout ()
	{
		super.createLayout();
		layout.padding = new Box(10);

		if (!dynamicSizes) {
			layoutGroup.childWidth	= 20;
			layoutGroup.childHeight	= 20;
		}
	}
	
	
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
	public inline function getDepthForPosition (pos:Point) : Int {
		return layoutGroup.algorithm.getDepthForPosition(pos);
	}
	
	private function dragOverHandler () {
		draggedOver = true;
		render();
	}
	
	private function dragOutHandler () {
		draggedOver = false;
		render();
	}
}





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
}