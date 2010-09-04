/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.layout.algorithms.tile;
 import primevc.core.collections.BalancingListCollection;
 import primevc.core.collections.BalancingList;
 import primevc.core.collections.ChainedListCollection;
 import primevc.core.collections.ChainedList;
 import primevc.core.collections.IList;
 import primevc.core.collections.IListCollection;
 import primevc.core.geom.space.Direction;
 import primevc.core.geom.IRectangle;
 import primevc.types.Number;
 import primevc.core.RangeIterator;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.ILayoutContainer;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.LayoutContainer;
 import primevc.utils.FastArray;
 import primevc.utils.IntMath;
  using primevc.utils.BitUtil;
  using primevc.utils.Bind;
  using primevc.utils.IntUtil;
  using primevc.utils.IntMath;
  using primevc.utils.TypeUtil;
 

/**
 * Algorithm to layout children as tiles in rows and columns.
 * 
 * @creation-date	Jun 25, 2010
 * @author			Ruben Weijers
 */
class FixedTileAlgorithm extends TileAlgorithmBase, implements ILayoutAlgorithm
{
	/**
	 * Maximum number of rows or columns that the layout can have. 
	 * When the start-direction is 'horizontal', the value will be used as 
	 * the max number of columns. The number of rows will vary on the number
	 * of items.
	 * 
	 * When the start-direction is 'vertical', the value will be used as the
	 * maxmimum number or rows. The number of columns will vary on the number
	 * of items.
	 * 
	 * @default		4
	 */
	public var maxTilesInDirection	(default, setMaxTilesInDirection)		: Int;
	
	
	
	/**
	 * The maximum width of each tile. Their orignal width will be ignored if
	 * the tile is bigger then this number (it won't get resized).
	 * 
	 * @default		Number.INT_NOT_SET
	 */
//	public var tileWidth			(default, setTileWidth)					: Int;
	/**
	 * The maximum height of each tile. Their orignal height will be ignored if
	 * the tile is heigher then this number (it won't get resized).
	 * 
	 * @default		Number.INT_NOT_SET
	 */
//	public var tileHeight			(default, setTileHeight)				: Int;
	
	
	
	
	/**
	 * Rows is a TileContainer containing a reference to each row (also TileContainer).
	 * The rows property is responsible for setting the correct y position of
	 * each row.
	 * 
	 * rows (TileContainer)
	 * 	-> children (ListCollection)
	 * 		-> row0 (TileContainer)
	 * 			-> children (ChainedList)
	 * 		-> row1 (TileContainer)
	 * 			-> children (ChainedList)
	 * 		-> etc.
	 */
	public var rows					(default, null)		: TileContainer < TileContainer < LayoutClient > >;
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
	private var horizontalMap		: IListCollection <LayoutClient, IList<LayoutClient>>;
	
	
	/**
	 * Columns is a TileContainer containing a reference to each column (also TileContainer).
	 * The columns property is responsible for setting the correct x position of
	 * each column.
	 * 
	 * columns (TileContainer)
	 * 	-> children (ListCollection)
	 * 		-> column0 (TileContainer)
	 * 			-> children (ChainedList)
	 * 		-> column1 (TileContainer)
	 * 			-> children (ChainedList)
	 * 		-> etc.
	 */
	public var columns				(default, null)		: TileContainer < TileContainer < LayoutClient > >;
	/**
	 * VerticalMap is a collection of the children properties of all columns. 
	 * Defining them in a ChainedListCollection makes it easy to let the 
	 * children flow easily from one column to another.
	 * 
	 * map (ChainedListCollection)
	 * 		-> lists
	 * 			-> column0.children
	 * 			-> column1.children
	 * 		-> items
	 * 			-> tile0
	 * 			-> tile3
	 * 			-> ...
	 */
	private var verticalMap			: IListCollection <LayoutClient, IList<LayoutClient>>;
	
	
	private var childHorAlgorithm	: HorizontalFloatAlgorithm;
	private var childVerAlgorithm	: VerticalFloatAlgorithm;
	
	
	public function new() 
	{
		super();
		maxTilesInDirection	= 4;
		childHorAlgorithm	= new HorizontalFloatAlgorithm( horizontalDirection );
		childVerAlgorithm	= new VerticalFloatAlgorithm( verticalDirection );
	}
	
	
	
	//
	// TILEMAP METHODS
	//
	
	/**
	 * Method will create a new index of all the children of the group. It will
	 * calculate the rows and columns on which each child will be.
	 * 
	 * For creating the tilemap it doesn't matter if it's horizontal or vertical.
	 * The variable names below just describe the horizontal direction.. 
	 * At the end of this method the properties will be switched when it turns 
	 * out to be a vertical list.
	 */
	public function createTileMap () : Void
	{
		var children		= group.children;
		var childLen:Int	= children.length;
		var childNum:Int	= 0;
		
		horizontalMap		= cast new ChainedListCollection <LayoutClient>(maxTilesInDirection);
		verticalMap			= cast new BalancingListCollection <LayoutClient>(maxTilesInDirection);
		
		rows				= new TileContainer<TileContainer<LayoutClient>>();
		rows.algorithm		= verAlgorithm;
		rows.padding		= group.padding;
		
		columns				= new TileContainer<TileContainer<LayoutClient>>();
		columns.algorithm	= horAlgorithm;
		columns.padding		= group.padding;
#if debug
		rows.name			= "RowsContainer";
		columns.name		= "ColumnsContainer";
		horizontalMap.name	= "RowsList";
		verticalMap.name	= "ColumnsList";
#end
		
		if (childLen != 0)
		{
			var curRows	= childLen < maxTilesInDirection ? 1 : childLen.divCeil( maxTilesInDirection );
			
			//1. create a TileContainer for each row
			for (i in 0...curRows)
				addRow(childHorAlgorithm);
			
			//2. create a TileContainer for each column
			for ( i in 0...maxTilesInDirection )
			{
				var columnChildren	= new BalancingList<LayoutClient>();
				var column			= new TileContainer<LayoutClient>( columnChildren );
				column.childWidth	= group.childWidth;
				column.childHeight	= group.childHeight;
				column.algorithm	= childVerAlgorithm;
#if debug		column.name			= "column"+columns.children.length;			#end				
#if debug		columnChildren.name	= "columnList"+columns.children.length;		#end
				verticalMap.addList( columnChildren );
				columns.children.add( column );
			}
			
			//3. add all the children to the rows and columns
			for (child in children) {
				if (!child.includeInLayout)
					continue;
				
				horizontalMap.add(child);
				verticalMap.add(child);
			}
		}
		
		if (startDirection == Direction.vertical)
			swapHorizontalAndVertical();
	}
	
	
	private inline function addRow (childAlg:ILayoutAlgorithm)
	{
		var rowChildren	= new ChainedList<LayoutClient>( maxTilesInDirection );
		var row			= new TileContainer<LayoutClient>( rowChildren);
		row.childWidth	= group.childWidth;
		row.childHeight	= group.childHeight;
#if debug
		row.name		= "row"+rows.children.length;
#end
		row.algorithm	= childAlg;
		horizontalMap.addList( rowChildren );
		rows.children.add( row );	
	}
	
	
	private inline function swapHorizontalAndVertical ()
	{
		if (horizontalMap != null && verticalMap != null)
		{
			//switch algorithms of columns and rows around
			var columnsAlg		= columns.algorithm;
			columns.algorithm	= rows.algorithm;
			rows.algorithm		= columnsAlg;
			
			var columnAlg		= columns.children.getItemAt(0).algorithm;
			var rowAlg			= rows.children.getItemAt(0).algorithm;
			
			for (group in columns)
				group.algorithm = rowAlg;
			
			for (group in rows)
				group.algorithm = columnAlg;
		}
	}
	
	
	private function updateMapsAfterRemove (client:LayoutClient, pos:Int) : Void
	{
		if (horizontalMap == null || verticalMap == null || !client.includeInLayout)
			return;
		
		horizontalMap.remove(client);
		verticalMap.remove(client);
	//	validateMaps();
	}
	
	
	private function updateMapsAfterAdd (client:LayoutClient, pos:Int) : Void
	{
		if (horizontalMap == null || verticalMap == null || !client.includeInLayout)
			return;
		
		//reset boundary properties
	//	client.bounds.left	= 0;
	//	client.bounds.top	= 0;
		
		if (horizontalMap.length % maxTilesInDirection == 0) {
			if (startDirection == horizontal)		addRow(childHorAlgorithm);
			else									addRow(childVerAlgorithm);
			
		}
		
		horizontalMap.add(client, pos);
		verticalMap.add(client, pos);
	//	validateMaps();
	}
	
	
	private function updateMapsAfterMove (client:LayoutClient, oldPos:Int, newPos:Int)
	{
		if (horizontalMap == null || verticalMap == null || !client.includeInLayout)
			return;
		
		horizontalMap.move(client, newPos, oldPos);
		verticalMap.move(client, newPos, oldPos);
	//	validateMaps();
	}
	
	
	private inline function validateMaps ()
	{
#if (debug && debugLayout)
		var len = horizontalMap.length;
		
		for (i in 0...len)
		{
			var hChild = horizontalMap.getItemAt(i);
			var vChild = verticalMap.getItemAt(i);
			if (hChild != vChild) {
				trace(horizontalMap);
				trace(verticalMap);
				Assert.equal(hChild, vChild, "children at "+i+" should be equal");
			}
		}
#end
	}
	
	
	
	//
	// LAYOUT METHODS
	//
	
	
	override public function prepareValidate ()
	{
		if (group.children.length > 0 && !validatePrepared && (horizontalMap == null || verticalMap == null))
			createTileMap();
		
		super.prepareValidate();
	}
	
	
	override public function validate () : Void
	{
		Assert.that( maxTilesInDirection.isSet(), "maxTilesInDirection should have been set" );
		
		if (group.children.length == 0)
			return;
		
		validateHorizontal();
		validateVertical();
	}
	
	
	override public function validateHorizontal ()
	{
		var w:Int = 0;
		
		if (group.children.length > 0) {
			if (startDirection == Direction.horizontal) {
				columns.validateHorizontal();
				w = rows.width = columns.width;
			} else {
				rows.validateHorizontal();
				w = columns.width = rows.width;
			}
		}
		
		setGroupWidth(w);
	}
	
	
	override public function validateVertical ()
	{
		var h:Int = 0;
		if (group.children.length > 0) {
			if (startDirection == Direction.horizontal) {
				rows.validateVertical();
				h = columns.height = rows.height;
			} else {
				columns.validateVertical();
				h = rows.height = columns.height;
			}	
		}
		
		setGroupHeight(h);
	}
	
	
	override private function invalidate (shouldbeResetted:Bool = true) : Void
	{
		if (shouldbeResetted) {
			horizontalMap = verticalMap = null;
			rows = columns = null;
		}
		
		super.invalidate(shouldbeResetted);
	}



	override public function getDepthForBounds (bounds:IRectangle)
	{
		var depth:Int = 0;
		var rowNum = rows.algorithm.getDepthForBounds( bounds );
		if (rowNum < rows.children.length)
		{
			depth  = maxTilesInDirection * rowNum;
			depth += columns.algorithm.getDepthForBounds( bounds );
		}
		else
			 depth = horizontalMap.length;
		return depth;
	}
	
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	private inline function setMaxTilesInDirection (v)
	{
		if (v != maxTilesInDirection) {
			maxTilesInDirection = v;
			invalidate( true );
		}
		return v;
	}
	
	
	override private function setStartDirection (v)
	{
		if (v != startDirection) {
			swapHorizontalAndVertical();
			super.setStartDirection(v);
		}
		return v;
	}
	
	
	override private function setGroup (v)
	{
		if (group != v)
		{
			if (group != null) {
				if (rows.padding == group.padding)		rows.padding = null;
				if (columns.padding == group.padding)	columns.padding = null;
				
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