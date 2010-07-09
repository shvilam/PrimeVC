package primevc.gui.layout.algorithms.tile;
 import primevc.core.collections.ChainedListCollection;
 import primevc.core.collections.ChainedList;
 import primevc.core.collections.SimpleList;
 import primevc.core.geom.constraints.SizeConstraint;
 import primevc.gui.layout.LayoutGroup;
 import primevc.gui.layout.algorithms.directions.Direction;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.tile.TileGroup;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutFlags;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
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
	 * tileGroups is a TileGroup containing a reference to each TileGroup
	 * The tileGroups property is responsible for setting the correct x or y 
	 * position of each tilegroup.
	 * 
	 * tileGroups (TileGroup)
	 * 	-> children (ListCollection)
	 * 		-> tileGroup0 (TileGroup)
	 * 			-> children (ChainedList)
	 * 		-> tileGroup1 (TileGroup)
	 * 			-> children (ChainedList)
	 * 		-> etc.
	 */
	public var tileGroups (default, null)	: TileGroup < TileGroup < LayoutClient > >;
	/**
	 * HorizontalMap is a collection of the children properties of all tileGroups. 
	 * Defining them in a ChainedListCollection makes it easy to let the 
	 * children flow easily from one row to another.
	 * 
	 * map (ChainedListCollection)
	 * 		-> lists
	 * 			-> tileGroup0.children
	 * 			-> tileGroup1.children
	 * 		-> items
	 * 			-> tile0
	 * 			-> tile1
	 * 			-> ...
	 */
	private var tileCollection				: ChainedListCollection < LayoutClient > ;
	
	private var childSizeConstraint			: SizeConstraint;
	private var childAlgorithm				: ILayoutAlgorithm;
	
	
	
	private function createTileMap ()
	{
		Assert.that( group.is( LayoutGroup ), "group should be an LayoutGroup" );
		
		childSizeConstraint = new SizeConstraint();
		
		tileCollection		= cast new ChainedListCollection <LayoutClient>();
		tileGroups			= new TileGroup<TileGroup<LayoutClient>>();
		tileGroups.padding	= group.padding;
		var children		= group.children;
		
		if (startDirection == Direction.horizontal)
			tileGroups.algorithm = verAlgorithm;
		else
			tileGroups.algorithm = horAlgorithm;
		
		addTileGroup();
		for (child in children)
			tileCollection.add(child);
		
		trace(""+tileCollection);
	}
	
	
	private inline function addTileGroup (childList:ChainedList<LayoutClient> = null)
	{
		trace("add new tileGroup");
		if (childList == null)
			childList = new ChainedList<LayoutClient>();
		
		var tileGroup				= new TileGroup<LayoutClient>( childList );
		var group					= group.as(LayoutGroup);
		tileGroup.algorithm			= childAlgorithm;
		tileGroup.sizeConstraint	= childSizeConstraint;
		
		if (startDirection == Direction.horizontal)
		{
			if		(group.explicitWidth.isSet())		tileGroup.width = group.explicitWidth;
			else if	(childSizeConstraint != null)		tileGroup.sizeConstraint = childSizeConstraint;
#if debug	else	throw "group should have an explicitWidth/maxWidth to use the dynamic-tile-algorithm"; #end
		}
		else
		{
			if		(group.explicitHeight.isSet())		tileGroup.height = group.explicitHeight;
			else if	(childSizeConstraint != null)		tileGroup.sizeConstraint = childSizeConstraint;
#if debug	else	throw "group should have an explicitHeight/maxHeight to use the dynamic-tile-algorithm";	#end	
		}
		
#if debug
		tileGroup.name = "row" + tileGroups.children.length;
#end	
		tileCollection.addList( childList );
		tileGroups.children.add( tileGroup );	
	}
	
	
	private inline function removeTileGroup (tileGroup:TileGroup<LayoutClient>)
	{
		trace("remove group "+tileGroup);
		tileCollection.removeList( cast tileGroup.children );
		tileGroups.children.remove( tileGroup );
		tileGroup.dispose();
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
	
	
	override public function isInvalid (changes:Int) : Bool {
		return super.isInvalid(changes) || changes.has( LayoutFlags.SIZE_CONSTRAINT_CHANGED );
	}
	
	
	override public function measure () : Void
	{
		if (group.children.length == 0)
			return;
		
		var group = group.as(LayoutGroup);
		
		//
		//create a new tile map if it removed
		//
		if (tileCollection == null)
			createTileMap();
		
		//
		// APPLY CHANGES IN SIZE CONSTRAINT ALSO ON THE CHILDREN
		//
		if (group.changes.has(LayoutFlags.SIZE_CONSTRAINT_CHANGED))
		{
			if (group.sizeConstraint == null) {
				childSizeConstraint.reset();
			} else {
				if (startDirection == horizontal) {
					childSizeConstraint.width.min = group.sizeConstraint.width.min;
					childSizeConstraint.width.max = group.sizeConstraint.width.max;
				} else {
					childSizeConstraint.height.min = group.sizeConstraint.height.min;
					childSizeConstraint.height.max = group.sizeConstraint.height.max;
				}
			}
		}
		
		//resize all rows
		else if (group.changes.has(LayoutFlags.WIDTH_CHANGED) && startDirection == horizontal && group.explicitWidth.isSet())
			for (tileGroup in tileGroups)
				tileGroup.width = group.explicitWidth;
		
		//resize all columns
		else if (group.changes.has(LayoutFlags.HEIGHT_CHANGED) && startDirection == vertical && group.explicitHeight.isSet())
			for (tileGroup in tileGroups)
				tileGroup.height = group.explicitHeight;
		
		//
		// Check if children are added, removed or moved in the list
		//
		if (group.changes.has(LayoutFlags.LIST_CHANGED))
		{
			var groupItr = tileGroups.iterator();
			
			//check each tileGroup for changes in the list or in the width of the children
			for (tileGroup in groupItr)
			{
				var children:ChainedList<LayoutClient> = cast tileGroup.children;
				
				if (children.length == 0) {
				//	if (groupItr.hasNext())
					removeTileGroup( tileGroup );
					continue;
				}
				
				var hasNext = children.nextList != null;
				tileGroup.measure();
				
				if (!hasNext && children.nextList != null) {
					//A chained list is added by the previous measure method.
					//Create a tile group for the list.
					addTileGroup( children.nextList );
				}
			}
			
			trace(""+tileCollection);
		}
		
		if (startDirection == horizontal)
			measureVertical();
		else
			measureHorizontal();
	}
	
	
	override public function measureHorizontal ()
	{
		tileGroups.measureHorizontal();
		setGroupWidth(tileGroups.width);
	}
	
	
	override public function measureVertical ()
	{
		tileGroups.measureVertical();
		setGroupHeight(tileGroups.height);
	}
	
	
	override private function invalidate (shouldbeResetted:Bool = true) : Void
	{
		if (shouldbeResetted) {
			tileCollection = null;
			tileGroups = null;
		}
		
		super.invalidate(shouldbeResetted);
	}
	
	
	override public function apply ()
	{
		tileGroups.validate();
	//	verAlgorithm.apply();
		
		for (row in tileGroups)
			row.validate();
	}
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	override private function setStartDirection (v)
	{
		if (v != startDirection) {
			startDirection = v;
			if (startDirection == Direction.horizontal)
				childAlgorithm = new DynamicRowAlgorithm();
			else
				childAlgorithm = new DynamicColumnAlgorithm();
			invalidate( true );
		}
		return v;
	}
	
	
	override private function setGroup (v)
	{
		if (group != v)
		{
			if (group != null) {
				if (tileGroups.padding == group.padding)
					tileGroups.padding = null;
				
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



/**
 * Layout-algorithm which is only used for rows. It measures them and if there
 */
private class DynamicRowAlgorithm extends HorizontalFloatAlgorithm
{
	override public function measureHorizontal ()
	{
		var children:ChainedList<LayoutClient> = cast group.children;
		
		if ( group.changes.has(LayoutFlags.LIST_CHANGED) || group.changes.has(LayoutFlags.CHILDREN_INVALIDATED) )
		{
			trace("checking group "+group+ "for changes.");
			var groupSize		= group.width;
			var fullChildNum	= -1;			//counter to count all the children that didn't fit in the group
			
			//TileGroups children are changed.
			//Check the group to see if the width is bigger then the maxWidth
			for (child in children)
			{
				//check if the child will still fit in this row
				if (fullChildNum >= 0 || groupSize < child.bounds.width) {
					trace("group "+group + " is full. "+child+" won't fit in here ("+groupSize+" vs "+child.bounds.width+")");
					
					//move child to the next list
					fullChildNum++;
					children.moveItemToNextList( child, fullChildNum );
				}
				else
				{
					//add child to row
					groupSize -= child.bounds.width;
				}
			}
		}
	}
}



private class DynamicColumnAlgorithm extends VerticalFloatAlgorithm
{
	override public function measureVertical ()
	{
		var children:ChainedList<LayoutClient> = cast group.children;
		
		if ( group.changes.has(LayoutFlags.LIST_CHANGED) || group.changes.has(LayoutFlags.CHILDREN_INVALIDATED) )
		{
			trace("checking group "+group+ "for changes.");
			var groupSize		= group.height;
			var fullChildNum	= -1;				//counter to count all the children that didn't fit in the group
			
			//TileGroups children are changed.
			//Check the group to see if the width is bigger then the maxWidth
			for (child in children)
			{
				//check if the child will still fit in this row
				if (fullChildNum >= 0 || groupSize < child.bounds.width) {
					trace("group "+group + " is full. "+child+" won't fit in here ("+groupSize+" vs "+child.bounds.width+")");
					
					//move child to the next list
					fullChildNum++;
					children.moveItemToNextList( child, fullChildNum );
				}
				else
				{
					//add child to row
					groupSize -= child.bounds.width;
				}
			}
		}
	}
}