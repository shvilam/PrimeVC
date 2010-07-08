package primevc.gui.layout.algorithms.tile;
 import primevc.core.collections.ChainedListCollection;
 import primevc.core.collections.ChainedList;
 import primevc.core.collections.IList;
 import primevc.core.collections.IListCollection;
 import primevc.gui.layout.LayoutGroup;
 import primevc.gui.layout.algorithms.directions.Direction;
 import primevc.gui.layout.algorithms.tile.TileGroup;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.LayoutClient;
  using primevc.utils.Bind;
  using primevc.utils.IntUtil;
  using primevc.utils.TypeUtil;
 

/**
 * FixedTileAlgorithm will place a fixed number of tiles in one row or column.
 * DynamicTileAlgorithm will place as many tiles as possible in one row or 
 * column.
 * 
 * The amount of tiles in one row or column will be defined by the explicitWidth
 * and explicitHeight of the layoutgroup on which the algorithm is applied.
 * 
 * @creation-date	Jul 7, 2010
 * @author			Ruben Weijers
 */
class DynamicTileAlgorithm extends TileAlgorithmBase, implements ILayoutAlgorithm
{
	/**
	 * Rows is a TileGroup containing a reference to each row (also TileGroup).
	 * The rows property is responsible for setting the correct y position of
	 * each row.
	 * 
	 * rows (TileGroup)
	 * 	-> children (ListCollection)
	 * 		-> row0 (TileGroup)
	 * 			-> children (ChainedList)
	 * 		-> row1 (TileGroup)
	 * 			-> children (ChainedList)
	 * 		-> etc.
	 */
	public var rows					(default, null)		: TileGroup < TileGroup < LayoutClient > >;
	/**
	 * HorizontalMap is a collection of the children properties of all rows. 
	 * Defining them in a ChainedListCollection makes it easy to let the 
	 * children flow easily from one row to another.
	 * 
	 * map (ChainedListCollection)
	 * 		-> lists
	 * 			-> row0.children
	 * 			-> row1.children
	 * 		-> items
	 * 			-> tile0
	 * 			-> tile1
	 * 			-> ...
	 */
	private var tileCollection		: IListCollection < LayoutClient, IList<LayoutClient> > ;	
	
	
	public function new() 
	{
		super();
	}
	
	
	private function createTileMap ()
	{
		Assert.that( group.is( LayoutGroup ), "group should be an LayoutGroup" );
		
		tileCollection		= cast new ChainedListCollection <LayoutClient>();
		rows				= new TileGroup<TileGroup<LayoutClient>>();
		var group			= group.as(LayoutGroup);
		rows.padding		= group.padding;
		var children		= group.children;
		
		if (startDirection == Direction.horizontal)
		{
			rows.algorithm		= verAlgorithm;
			var maxWidth:Int	= group.explicitWidth;
			var rowWidth:Int	= 0;
			
			Assert.that( maxWidth.isSet(), "group should have an explicitWidth for the floating-tile-algorithm" );
			
			for (child in children)
			{
				//check if the child will still fit in this row
				if (rowWidth < child.bounds.width)
				{
					addRow( horAlgorithm );
					rowWidth = maxWidth;
				}
				
				//add child to row
				tileCollection.add(child);
				rowWidth -= child.bounds.width;
			}
		}
		else
		{
			rows.algorithm		= horAlgorithm;
			var maxHeight:Int	= group.explicitHeight;
			var rowHeight:Int	= 0;
			
			Assert.that( maxHeight.isSet(), "group should have an explicitHeight for the floating-tile-algorithm" );
			
			for (child in children)
			{
				//check if the child will still fit in this row
				if (rowHeight < child.bounds.height)
				{
					addRow( verAlgorithm );
					rowHeight = maxHeight;
				}
				
				//add child to row
				tileCollection.add(child);
				rowHeight -= child.bounds.height;
			}
		}
		
		trace(""+tileCollection);
	}
	
	
	private inline function addRow (childAlg:ILayoutAlgorithm)
	{
		var rowChildren	= new ChainedList<LayoutClient>();
		var row			= new TileGroup<LayoutClient>( rowChildren);
		row.algorithm	= childAlg;
		
		tileCollection.addList( rowChildren );
		rows.children.add( row );	
	}
	
	
	private function updateMapsAfterRemove (client, pos) : Void
	{
		if (tileCollection == null)
			return;
		
		tileCollection.remove(client);
	}
	
	
	private function updateMapsAfterAdd (client:LayoutClient, pos:Int) : Void
	{
		if (tileCollection == null)
			return;
		
		//reset boundary properties
		client.bounds.left	= 0;
		client.bounds.top	= 0;
		
	/*	if (tileCollection.length % maxTilesInDirection == 0) {
			if (startDirection == horizontal)		addRow(horAlgorithm);
			else									addRow(verAlgorithm);
			
		}*/
		
		tileCollection.add(client, pos);
	}
	
	
	private function updateMapsAfterMove (client, oldPos, newPos)
	{
		if (tileCollection == null)
			return;
		
		tileCollection.move(client, newPos, oldPos);
	}
	
	
	
	
	//
	// LAYOUT METHODS
	//
	
	
	override public function measure () : Void
	{
		if (group.children.length == 0)
			return;
		
		if (tileCollection == null)
			createTileMap();
		
		measureHorizontal();
		measureVertical();
	}
	
	
	override public function measureHorizontal ()
	{
		rows.measureHorizontal();
		setGroupWidth(rows.width);
	}
	
	
	override public function measureVertical ()
	{
		rows.measureVertical();
		setGroupHeight(rows.height);
	}
	
	
	override private function invalidate (shouldbeResetted:Bool = true) : Void
	{
		if (shouldbeResetted) {
			tileCollection = null;
			rows = null;
		}
		
		super.invalidate(shouldbeResetted);
	}
	
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	override private function setStartDirection (v)
	{
		if (v != startDirection) {
			startDirection = v;
			invalidate( true );
		}
		return v;
	}
	
	
	override private function setGroup (v)
	{
		if (group != v)
		{
			if (group != null) {
				if (rows.padding == group.padding)
					rows.padding = null;
				
				group.children.events.unbind(this);
			}
			
			v = super.setGroup(v);
			
			if (v != null) {
				updateMapsAfterAdd		.on( group.children.events.added, this );
				updateMapsAfterRemove	.on( group.children.events.removed, this );
				updateMapsAfterMove		.on( group.children.events.moved, this );
			}
		}
		return v;
	}
}