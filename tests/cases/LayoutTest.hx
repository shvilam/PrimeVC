package cases;
 import flash.text.TextField;
 import flash.text.TextFormat;
 import primevc.core.geom.Box;
 import primevc.core.geom.constraints.SizeConstraint;
 import primevc.core.Number;
 import primevc.gui.behaviours.DragBehaviour;
 import primevc.gui.behaviours.layout.ClippedLayoutBehaviour;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.Skin;
 import primevc.gui.layout.algorithms.circle.HorizontalCircleAlgorithm;
 import primevc.gui.layout.algorithms.circle.VerticalCircleAlgorithm;
 import primevc.gui.layout.algorithms.directions.Direction;
 import primevc.gui.layout.algorithms.DynamicLayoutAlgorithm;
 import primevc.gui.layout.algorithms.directions.Horizontal;
 import primevc.gui.layout.algorithms.directions.Vertical;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.tile.DynamicTileAlgorithm;
 import primevc.gui.layout.algorithms.tile.FixedTileAlgorithm;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutGroup;
 import primevc.gui.states.LayoutStates;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;

/**
 * Description
 * 
 * @creation-date	Jun 15, 2010
 * @author			Ruben Weijers
 */
class LayoutTest extends Skin < LayoutTest >
{
#if MonsterTrace
	static var monster = new nl.demonsters.debugger.MonsterDebugger(flash.Lib.current);
	
	static function doTrace (v : Dynamic, ?infos : haxe.PosInfos) {
		var length	= infos.fileName.length - 3; // remove .hx
		var color	= infos.fileName.charCodeAt(0) * infos.fileName.charCodeAt( length >> 1 ) * infos.fileName.charCodeAt( length - 1 );
		nl.demonsters.debugger.MonsterDebugger.trace(infos.fileName +':' + infos.lineNumber +'\t -> ' + infos.methodName, v, color);
	}
#end

	public static function main ()
	{
#if ( MonsterTrace )
		haxe.Log.trace = doTrace;
#end
		trace("started!");
		var stage		= flash.Lib.current.stage;
		stage.scaleMode	= flash.display.StageScaleMode.NO_SCALE;
		
	//	haxe.Log.trace	= doTrace;
		
		var inst = new LayoutTest("Parent");
		stage.addChild( inst );		//will trigger the createLayout method
	}
	
	
	private var fixedTiles		: FixedTileAlgorithm;
	private var dynamicTiles	: DynamicTileAlgorithm;
	
	public function new (name) {
		this.name = name;
		super();
	}
	
	private var layoutGroup (getLayoutGroup, null)	: LayoutGroup;
		private inline function getLayoutGroup ()	{ return layout.as( LayoutGroup ); }
	
	
	override private function createChildren ()
	{
		trace("createChildren of " + name);
		for ( i in 0...10 )
			addTile();
	}
	
	
	override private function createBehaviours ()
	{
	//	behaviours.add( new ClippedLayoutBehaviour(this) );
		addTile.on( userEvents.mouse.click, this );
	}
	
	
	override private function createLayout ()
	{
		layout = new LayoutGroup();
		layout.x = 50;
		layout.y = 10;
		layout.padding = new Box(10);
	//	layout.maintainAspectRatio = true;
	//	layout.sizeConstraint = new SizeConstraint(300, 400, 200, 800);
	//	layout.sizeConstraint = new SizeConstraint(300, Number.NOT_SET, 200, Number.NOT_SET);
	
		trace("createLayout of " + name);
	/*/
		layoutGroup.algorithm = new DynamicLayoutAlgorithm(
			new HorizontalFloatAlgorithm( Horizontal.center ),
			new VerticalFloatAlgorithm( Vertical.top )
		);
	//*/
	//*/	
		fixedTiles = new FixedTileAlgorithm();
		fixedTiles.maxTilesInDirection	= 3;
	//	fixedTiles.startDirection		= Direction.vertical;
		fixedTiles.horizontalDirection	= Horizontal.left;
		fixedTiles.verticalDirection	= Vertical.top;
		layoutGroup.algorithm = fixedTiles;
	//*/
	/*/	
		dynamicTiles = new DynamicTileAlgorithm();
	//	dynamicTiles.startDirection			= Direction.vertical;
	//	dynamicTiles.horizontalDirection	= Horizontal.left;
	//	dynamicTiles.verticalDirection		= Vertical.top;
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
		layoutGroup.width	= 400;
		layoutGroup.height	= 400;
		
		redraw.on( layout.events.sizeChanged, this );
	}
	
	
	public function redraw ()
	{
		var l = layout.bounds;
		var g = graphics;
		trace("redraw "+name+": "+l.width+", "+l.height);
		g.clear();
	//	g.beginFill( 0xaaaaaa );
	//	g.drawRect( 0, 0, l.width, l.height );
		g.beginFill( 0xaaaa00, .7 );
		g.drawEllipse( 0, 0, l.width, l.height );
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
	}
	
	
	public function addTile ()
	{
		var num = numChildren;
		var child = new Tile("Tile" + num);
		layoutGroup.children.add( child.layout );
	//	child.behaviours.add( new DragBehaviour( child ) );
		addChild( child );
	}
	
	
	/*private function updateSecondChild ()
	{
		var child = getChildAt( 1 ).as( Tile );
		child.layout.width += 3;
		layout.validate();
	}*/
}


class Tile extends Skin < Tile >
{
	public var textField : TextField;
	private var color	: UInt;
	
	public function new (name)
	{
		this.name = name;
		super();
		color	= Math.round( Math.random() * 0xffffff );
		redraw.on( layout.events.sizeChanged, this );
	}
	
	
	public function redraw ()
	{
		var l = layout.bounds;
		var g = graphics;
		trace("redraw " + name + ": " + l.width + ", " + l.height);
		g.clear();
		g.beginFill( color, .4 );
		g.drawRect( 0, 0, l.width, l.height );
		g.endFill();
	}
	
	
	override private function createBehaviours () {
	//	behaviours.add( cast new TileBehaviour( this ) );
	}
	
	
	override private function createLayout () {
		layout			= new LayoutClient();
		layout.width	= 60 + Std.int(80 * Math.random());
		layout.height	= 60 + Std.int(40 * Math.random());
	}
	
	
	override private function createChildren () {
		textField = new TextField();
		textField.text = name;
		textField.setTextFormat( new TextFormat("Verdana", 15, 0x00 ) );
		textField.mouseEnabled = false;
		addChild( textField );
	}
}


class TileBehaviour extends BehaviourBase <Tile>
{
	override private function init () {
		resize.on( target.userEvents.mouse.rollOver, this );
	}
	
	
	override private function reset () {
		target.userEvents.mouse.rollOver.unbind( this );
	}
	
	
	private function resize (e) {
		trace("resize");
		target.layout.width += 5;
	}
}