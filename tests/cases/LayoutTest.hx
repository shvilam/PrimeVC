package cases;
 import flash.text.TextField;
 import flash.text.TextFormat;
 import primevc.core.geom.constraints.SizeConstraint;
 import primevc.core.geom.Box;
 import primevc.core.geom.Point;
 import primevc.core.Application;
 import primevc.core.Number;
 import primevc.gui.behaviours.DragBehaviour;
 import primevc.gui.behaviours.layout.ClippedLayoutBehaviour;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.ISkin;
 import primevc.gui.core.Skin;
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
 import primevc.gui.layout.RelativeLayout;
 import primevc.gui.layout.VirtualLayoutContainer;
 import primevc.gui.states.LayoutStates;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;

/**
 * @creation-date	Jul 13, 2010
 * @author			Ruben Weijers
 */
class LayoutTest extends Application
{
	public static function main () { Application.startup( LayoutTest ); }
	
	public function new (target)
	{
		super(target);
		var skin = new LayoutAppSkin();
		trace("window: "+window);
		trace("children "+window.children);
		window.children.add( skin );
	}
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
		id = "ResizableBox";
#end
	//	render.on( layout.events.sizeChanged, this );
	}
	
	override private function createLayout ()
	{
		layout = new LayoutContainer();
		layout.width	= 800;
		layout.height	= 650;
		layout.padding	= new Box( 5 );
		layoutGroup.algorithm = new RelativeAlgorithm();
	}
	
	
	override private function createBehaviours ()
	{
		behaviours.add( new ClippedLayoutBehaviour(this) );
		behaviours.add( new ResizeFromCornerBehaviour(this) );
	}
	
	override private function createChildren ()
	{
		trace("create children");
		var frame1						= new TileList();
		var frame1Alg					= new FixedTileAlgorithm();
		frame1Alg.maxTilesInDirection	= 5;
		frame1Alg.startDirection		= Direction.vertical;
		frame1Alg.horizontalDirection	= Horizontal.right;
		frame1Alg.verticalDirection		= Vertical.bottom;
		frame1.layoutGroup.algorithm	= frame1Alg;
		frame1.layout.height			= 100;
		frame1.layout.relative			= new RelativeLayout( 5, 5, -100000, 5 );
		
		var frame2				= new TileList();
		var frame2Alg			= new DynamicLayoutAlgorithm(
			new HorizontalCircleAlgorithm( Horizontal.left ),
			new VerticalCircleAlgorithm( Vertical.top )
		);
		frame2.layout.relative			= new RelativeLayout( frame1.layout.bounds.bottom + 5, -100000, 5, 5 );
		frame2.layout.percentWidth		= 58;
		frame2.layoutGroup.algorithm	= frame2Alg;
		
		var frame3						= new TileList();
		var frame3Alg					= new DynamicTileAlgorithm();
		frame3.layoutGroup.algorithm	= frame3Alg;
		frame3.layout.percentWidth		= 100;
		frame3.layout.percentHeight		= 60;
		
		var frame4						= new Frame();
		frame4.layout.percentWidth		= 33;
		frame4.layout.percentHeight		= 100;
		
		var frame5						= new Frame();
		frame5.layout.percentWidth		= 33;
		frame5.layout.percentHeight		= 100;
		
		var frame6						= new Frame();
		frame6.layout.percentWidth		= 33;
		frame6.layout.percentHeight		= 100;
		
		var frame7						= new Frame();
		frame7.layout.percentWidth		= 60;
		frame7.layout.percentHeight		= 5;
		
		var frame8						= new Frame();
		frame8.layout.percentWidth		= 100;
		frame8.layout.percentHeight		= 20;
		
		
		var box1				= new VirtualLayoutContainer();
		var box1Alg				= new VerticalFloatAlgorithm();
		box1Alg.direction		= Vertical.bottom;
		box1.relative			= new RelativeLayout( frame1.layout.bounds.bottom + 5, 5, 5, -100000 );
		box1.percentWidth		= 40;
		box1.algorithm			= box1Alg;
		
		var box2				= new VirtualLayoutContainer();
		box2.algorithm			= new HorizontalFloatAlgorithm();
		box2.percentWidth		= 100;
		box2.percentHeight	 	= 15;
		
#if debug
		frame1.id = "frame1";
		frame2.id = "frame2";
		frame3.id = "frame3";
		frame4.id = "frame4";
		frame5.id = "frame5";
		frame6.id = "frame6";
		frame7.id = "frame7";
		frame8.id = "frame8";
		
		box1.name	= "VirtualMainBox";
		box2.name	= "VirtualSubBox";
#end
		
		layoutGroup.children.add( frame1.layout );
		layoutGroup.children.add( frame2.layout );
		layoutGroup.children.add( box1 );
		
		box1.children.add( frame3.layout );
		box1.children.add( box2 );
		box1.children.add( frame7.layout );
		box1.children.add( frame8.layout );
		
		box2.children.add( frame4.layout );
		box2.children.add( frame5.layout );
		box2.children.add( frame6.layout );
		
		children.add(frame2);
		children.add(frame1);
		children.add(frame3);
		children.add(frame4);
		children.add(frame5);
		children.add(frame6);
		children.add(frame7);
		children.add(frame8);
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




class TileList extends Frame
{
	private var fixedTiles		: FixedTileAlgorithm;
	private var dynamicTiles	: DynamicTileAlgorithm;
	
	public var layoutGroup (getLayoutGroup, null)	: LayoutContainer;
		private inline function getLayoutGroup ()	{ return layout.as( LayoutContainer ); }
	
	
	public function new ()
	{
		super();
#if debug
		id = "TilesOwner";
#end
	}
	
	override private function createBehaviours ()
	{
		behaviours.add( new ClippedLayoutBehaviour(this) );
		behaviours.add( cast new TileListBehaviour(this) );
	}
	
	
	override private function createLayout ()
	{
		layout = new LayoutContainer();
	//	layout.x = 50;
	//	layout.y = 10;
		layout.padding = new Box(30);
	//	layout.maintainAspectRatio = true;
	//	layout.sizeConstraint = new SizeConstraint(500, 800, 200, 800);
	//	layout.sizeConstraint = new SizeConstraint(300, Number.NOT_SET, 200, Number.NOT_SET);
		
		trace("createLayout of " + this);
	/*/
		layoutGroup.algorithm = new DynamicLayoutAlgorithm(
			new HorizontalFloatAlgorithm( Horizontal.center ),
			new VerticalFloatAlgorithm( Vertical.top )
		);
	//*/
	/*/	
		fixedTiles = new FixedTileAlgorithm();
		fixedTiles.maxTilesInDirection	= 3;
	//	fixedTiles.startDirection		= Direction.vertical;
		fixedTiles.horizontalDirection	= Horizontal.left;
		fixedTiles.verticalDirection	= Vertical.top;
		layoutGroup.algorithm = fixedTiles;
	//*/
	/*/
		dynamicTiles = new DynamicTileAlgorithm();
		dynamicTiles.startDirection			= Direction.vertical;
		dynamicTiles.horizontalDirection	= Horizontal.right;
		dynamicTiles.verticalDirection		= Vertical.bottom;
		layoutGroup.algorithm = dynamicTiles;
	/*/
	
	//*/
	//	layoutGroup.algorithm = new VerticalFloatAlgorithm( Vertical.center );
	//	layoutGroup.algorithm = new HorizontalFloatAlgorithm( Horizontal.center );
	/*/	
		layoutGroup.algorithm = new DynamicLayoutAlgorithm(
			new HorizontalCircleAlgorithm( Horizontal.left ),
			new VerticalCircleAlgorithm( Vertical.top )
		);
	//*/	
	//	layoutGroup.algorithm.childHeight		= 60;
	//	layoutGroup.algorithm.childWidth		= 60;
		
	//	layoutGroup.width	= 400;
	//	layoutGroup.height	= 400;
		
	//	render.on( layout.events.sizeChanged, this );
	}
	
	
/*	override public function render ()
	{
		var l = layout.bounds;
		var g = graphics;
		trace("render "+id+": "+l.width+", "+l.height);
		g.clear();
		g.beginFill( 0xaaaaaa );
		g.drawRect( 0, 0, l.width, l.height );
	//	g.beginFill( 0xaaaa00, .7 );
	//	g.drawEllipse( 0, 0, l.width, l.height );
		g.endFill();
		
		if (fixedTiles != null)
		{
			//draw rows
			var count:Int = 0;
			for (row in fixedTiles.rows) {
				var color	= count % 2 == 0 ? 0xeeeeee : 0xcccccc;
				l			= row.bounds;
				var w		= l.width == 0 ? fixedTiles.rows.bounds.width + 30 : l.width;
				var h		= l.height == 0 ? fixedTiles.rows.bounds.height + 30 : l.height;
				g.beginFill( color, 0.6 );
				g.drawRect( l.left, l.top, w, h );
				g.endFill();
				count++;
			}
			
			//draw columns
			count = 0;
			for (column in fixedTiles.columns) {
				var color	= count % 2 == 0 ? 0xddffff : 0xccdddd;
				l			= column.bounds;
				var w		= l.width == 0 ? fixedTiles.columns.bounds.width + 30 : l.width;
				var h		= l.height == 0 ? fixedTiles.columns.bounds.height + 30 : l.height;
				g.beginFill( color, .6 );
				g.drawRect( l.left, l.top, w, h );
				g.endFill();
				count++;
			}
		}
	}*/
}




class Tile extends Skin < Tile >
{
	public var textField	: TextField;
	private var color		: UInt;
	private var isHovered	: Bool;
	
	public function new ()
	{
		isHovered	= false;
		color		= Math.round( Math.random() * 0xffffff );
		super();
	//	render.on( layout.events.sizeChanged, this );
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
			g.beginFill( color, .7 );
			g.drawRect( 0, 0, l.width, l.height );
		}
		
		g.endFill();
	}
	
	private function highlight ()	{ isHovered = true; render(); }
	private function normallity ()	{ isHovered = false; render(); }
	
	
	override private function createBehaviours () {
	//	behaviours.add( cast new TileBehaviour( this ) );
		highlight.on( userEvents.mouse.rollOver, this );
		normallity.on( userEvents.mouse.rollOut, this );
	}
	
	
	override private function createLayout () {
		layout			= new LayoutClient();
		layout.width	= 20; //50 + Std.int(150 * Math.random());
		layout.height	= 20; //30 + Std.int(40 * Math.random());
	}
	
#if debug
	override private function createChildren () {
		textField = new TextField();
		textField.text = name;
		textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
		textField.setTextFormat( new TextFormat("Verdana", 15, 0x00 ) );
		textField.mouseEnabled = false;
		children.add( textField );
	}
#end
}




class Button extends Tile
{
	public function new ()
	{
		super();
		color = 0x00;
#if debug
		id = "button";
#end
	}
}





class Frame extends Skin < Box >
{	
	public var textField	: TextField;
	private var color 		: UInt;
	
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
		layout = new LayoutClient();
	}

	
#if debug
	override private function createChildren () {
		textField = new TextField();
		textField.text = name;
		textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
		textField.setTextFormat( new TextFormat("Verdana", 15, 0x00 ) );
		textField.mouseEnabled = false;
		children.add( textField );
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





class TileListBehaviour extends BehaviourBase <TileList>
{
	override private function init () 
	{
		addTile.on( target.userEvents.mouse.click, this );
		createBeginTiles.onceOn( target.skinState.initialized.entering, this );
	}
	
	private function createBeginTiles () {
		for ( i in 0...150 )
			addTile();
	}


	private function addTile (?event:MouseState)
	{
		if (event != null && event.target != target)
			return;
		
		var num = target.numChildren;
		var child = new Tile();
#if debug
		child.id = "Tile" + num;
#end
		child.doubleClickEnabled = true;
		target.layoutGroup.children.add( child.layout );
	//	child.behaviours.add( new TileBehaviour( child ) );
		removeTile.onceOn( child.userEvents.mouse.doubleClick, this );
		target.children.add( child );
	}
	
	
	private function removeTile (event:MouseState)
	{
		var tile:Tile = event.target.as(Tile);
		trace("removeTile "+tile);
		target.layoutGroup.children.remove( tile.layout );
	//	target.removeChild( tile );
		tile.dispose();
	}
}




class TileBehaviour extends BehaviourBase <Tile>
{
	override private function init () {
	//	resize.on( target.userEvents.mouse.rollOver, this );
	//	remove.on( target.userEvents.mouse.doubleClick, this );
	}
	
	
	override private function reset () {
		target.userEvents.mouse.unbind( this );
	}
	
	
	private function resize () {
		trace("resize");
		target.layout.width += 5;
	}
}



class ResizeFromCornerBehaviour extends BehaviourBase <ISkin>
{
	private var startLocation	: Point;
	private var dragBtn			: Button;
	
	
	override private function init () {
		createBtn.onceOn( target.skinState.initialized.entering, this );
	}
	
	
	override private function reset () {
	}
	
	
	private function createBtn () {
		trace("create button!");
		var l		= new RelativeLayout();
		l.bottom	= 3;
		l.right		= 3;
		
		dragBtn		= new Button();
		dragBtn.layout.relative = l;
		
		startResize.on( dragBtn.userEvents.mouse.down, this );
		
		target.children.add(dragBtn);
		target.layout.as(LayoutContainer).children.add( dragBtn.layout );
	}
	
	
	private function startResize (mouse:MouseState)
	{
		if (startLocation != null)
			return;
		haxe.Log.clear();
		trace("startResize ");
		
		dragBtn.layout.includeInLayout = false;
		dragBtn.startDrag();
		dragBtn.userEvents.mouse.down.unbind( this );
		stopResize	.on( dragBtn.displayList.window.userEvents.mouse.up, this );
		doResize	.on( dragBtn.displayList.window.userEvents.mouse.move, this );
		
		startLocation = mouse.stage;
	}
	
	
	private function stopResize (mouse:MouseState)
	{
		trace("stopResize");
		dragBtn.stopDrag();
		dragBtn.layout.includeInLayout = true;
	//	doResize( mouse );
		dragBtn.displayList.window.userEvents.mouse.up	.unbind(this);
		dragBtn.displayList.window.userEvents.mouse.move.unbind(this);
		
		startResize.on( dragBtn.userEvents.mouse.down, this );
		startLocation = null;
	}
	
	
	private function doResize (mouse:MouseState)
	{
		var delta = mouse.stage.subtract( startLocation );
		
		target.layout.width += Std.int( delta.x );
		target.layout.height += Std.int( delta.y );
		
		startLocation = mouse.stage;
	}
}


