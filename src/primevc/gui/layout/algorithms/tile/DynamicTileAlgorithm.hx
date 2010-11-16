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
 import primevc.core.collections.ChainedListCollection;
 import primevc.core.collections.ChainedList;
 import primevc.core.collections.ListChange;
 import primevc.core.collections.SimpleList;
 import primevc.core.geom.space.Direction;
 import primevc.core.geom.space.Horizontal;
 import primevc.core.geom.space.Vertical;
 import primevc.core.geom.Box;
 import primevc.core.geom.IRectangle;
 import primevc.core.validators.IntRangeValidator;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.algorithms.tile.TileContainer;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.layout.LayoutFlags;
 import primevc.utils.NumberMath;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
 

private typedef Flags = LayoutFlags;


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
	 * tileGroups is a TileContainer containing a reference to each TileContainer
	 * The tileGroups property is responsible for setting the correct x or y 
	 * position of each tilegroup.
	 * 
	 * tileGroups (TileContainer)
	 * 	-> children (ListCollection)
	 * 		-> tileGroup0 (TileContainer)
	 * 			-> children (ChainedList)
	 * 		-> tileGroup1 (TileContainer)
	 * 			-> children (ChainedList)
	 * 		-> etc.
	 */
	public var tileGroups (default, null)	: TileContainer; // < TileContainer < LayoutClient > >;
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
	
	private var childSizeValidator			: IntRangeValidator;
	private var childAlgorithm				: ILayoutAlgorithm;
	private var childPadding				: Box;
	
	
	private function createTileMap ()
	{
		Assert.that( group.is( LayoutContainer ), "group should be an LayoutContainer" );
		
		var group						= this.group.as(LayoutContainer);
		childSizeValidator				= new IntRangeValidator();
		tileCollection					= cast new ChainedListCollection < LayoutClient >();
		tileGroups						= new TileContainer();
		tileGroups.parent				= group;
		tileGroups.padding				= group.padding;
		tileGroups.width.validator		= group.width.validator;
		tileGroups.height.validator		= group.height.validator;
		
		var children = group.children;
		
		if (startDirection == Direction.horizontal)
		{
			tileGroups.algorithm	= verAlgorithm;
			childSizeValidator.max	= group.explicitWidth;
			if (group.padding != null)
				childPadding = new Box( 0, group.padding.left, 0, group.padding.right );
		}
		else
		{
			tileGroups.algorithm	= horAlgorithm;
			childSizeValidator.max	= group.explicitHeight;
			if (group.padding != null)
				childPadding = new Box( group.padding.top, 0, group.padding.bottom, 0 );
		}
		
		addTileContainer();
		for (child in children)
			if (child.includeInLayout)
				tileCollection.add(child);
	}
	
	
	private function addTileContainer (childList:ChainedList<LayoutClient> = null)
	{
		if (childList == null)
			childList = new ChainedList<LayoutClient>();
		
		var group					= this.group.as(LayoutContainer);
		var tileGroup				= new TileContainer( childList );
		tileGroup.algorithm			= childAlgorithm;
		tileGroup.padding			= childPadding;
		tileGroup.childWidth		= group.childWidth;
		tileGroup.childHeight		= group.childHeight;
		tileGroup.parent			= tileGroups;
#if debug
		tileGroup.name				= "row" + tileGroups.children.length;
#end
		if (startDirection == Direction.horizontal)
			tileGroup.width.validator = childSizeValidator;
		else
			tileGroup.height.validator = childSizeValidator;
		
		tileCollection.addList( childList );
		tileGroups.children.add( tileGroup );	
	}
	
	
	private inline function removeTileContainer (tileGroup:TileContainer)
	{
		tileCollection.removeList( cast tileGroup.children );
		tileGroups.children.remove( tileGroup );
		tileGroup.dispose();
	}
	
	
	private function updateMapsAfterChange (change:ListChange < LayoutClient > )
	{
		if (tileCollection == null)
			return;
		
		switch (change)
		{
			case added (client, newPos):
				if (!client.includeInLayout)
					return;
				
				tileCollection.add(client, newPos);
				
				
			case removed (client, oldPos):
				if (!client.includeInLayout)
					return;
				
				tileCollection.remove(client);
				
			
			case moved (client, newPos, oldPos):
				if (!client.includeInLayout)
					return;
				
				tileCollection.move(client, newPos, oldPos);
			
			default:
		}
	}
	
	
	
	
	//
	// LAYOUT METHODS
	//
	
	override public function isInvalid (changes:Int) : Bool
	{
		return super.isInvalid(changes) || changes.has( Flags.WIDTH_VALIDATOR | Flags.HEIGHT_VALIDATOR );
	}
	
	
	override public function prepareValidate () : Void
	{
		if (!validatePrepared)
		{
			var group = group.as(LayoutContainer);
		
			//create a new tile map if it removed
			if (tileCollection == null)
				createTileMap();
		
			if (group.children.length == 0)
				return;
		
			// APPLY CHANGES IN SIZE CONSTRAINT ALSO ON THE CHILDREN
			if (group.changes.has( Flags.WIDTH_VALIDATOR ))
				tileGroups.width.validator = group.width.validator;
			
			if (group.changes.has( Flags.HEIGHT_VALIDATOR ))
				tileGroups.height.validator = group.height.validator;
			
			//resize all columns / rows
			if (group.changes.has(Flags.EXPLICIT_HEIGHT | Flags.EXPLICIT_WIDTH))
				childSizeValidator.max = (startDirection == vertical) ? group.explicitHeight : group.explicitWidth;
		}
		super.prepareValidate();
	}
	
	
	private function validateGroups ()
	{
		//
		// Check if children are added, removed or moved in the list
		//
		var groupItr = tileGroups.iterator();
		//check each tileGroup for changes in the list or in the width of the children
		for (tileGroup in groupItr)
		{
			if (tileGroup.changes == 0)
				continue;
			
			var children:ChainedList<LayoutClient> = cast tileGroup.as(TileContainer).children;
			if (children.length == 0) {
			//	if (groupItr.hasNext())
				removeTileContainer( cast tileGroup );
				continue;
			}
			
			var hasNext = children.nextList != null;
			tileGroup.validate();
			
			if (!hasNext && children.nextList != null) {
				//A chained list is added by the previous validate method.
				//Create a tile group for the list.
				addTileContainer( children.nextList );
			}
		}
	}
	
	
	override public function validateHorizontal ()
	{
		if (startDirection != horizontal)
			return;
		
		validateGroups();
		tileGroups.validate();
		setGroupWidth( tileGroups.width.value );
	}
	
	
	override public function validateVertical ()
	{
		if (startDirection != vertical)
			return;
		
		validateGroups();
		tileGroups.validate();
		setGroupHeight( tileGroups.height.value );
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
		for (row in tileGroups)
			row.validated();
		
		tileGroups.validated();
		validatePrepared = false;
	}
	
	

	override public function getDepthForBounds (bounds:IRectangle)
	{
		var depth:Int	= 0;
		var rowNum		= tileGroups.algorithm.getDepthForBounds( bounds );
		
		if (rowNum == tileGroups.children.length)
		{
			depth = tileCollection.length;
		}
		else
		{
			if (rowNum > 0)
			{
				var i = 0;
				for (tileGroup in tileGroups.children)
				{
					if (i == rowNum)
						break;
					depth += tileGroup.as(TileContainer).children.length;
					i++;
				}
			}
			
			var row	 = tileGroups.children.getItemAt( rowNum ).as(TileContainer);
			row.algorithm.group = row;		//<-- important! will otherwise validate with wrong row
			depth	+= row.algorithm.getDepthForBounds( bounds );
		}
		return depth;
	}
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	override private function setStartDirection (v)
	{
		if (v != startDirection)
		{
			startDirection = v;
			if (startDirection == Direction.horizontal)
				childAlgorithm = new DynamicRowAlgorithm( horizontalDirection );
			else
				childAlgorithm = new DynamicColumnAlgorithm( verticalDirection );
			
			invalidate( true );
		}
		return v;
	}
	
	
	override private function setGroup (v)
	{
		if (group != v)
		{
			if (group != null) {
				Assert.that(v == null, "Group of DynamicTileAlgorithm cannot be changed.");
				if (tileGroups.padding == group.padding)
					tileGroups.padding = null;
				
				group.children.change.unbind(this);
			}
			
			v = super.setGroup(v);
			
			if (v != null)
				updateMapsAfterChange.on( group.children.change, this );
		}
		return v;
	}
	
	
	override private function setHorizontalDirection (v:Horizontal)
	{
		if (v != horizontalDirection) {
			super.setHorizontalDirection(v);
			if (childAlgorithm != null && childAlgorithm.is(DynamicRowAlgorithm))
				childAlgorithm.as(DynamicRowAlgorithm).direction = v;
		}
		return v;
	}
	
	
	override private function setVerticalDirection (v:Vertical)
	{
		if (v != verticalDirection) {
			super.setVerticalDirection(v);
			if (childAlgorithm != null && childAlgorithm.is(DynamicColumnAlgorithm))
				childAlgorithm.as(DynamicColumnAlgorithm).direction = v;
		}
		return v;
	}
	
	
#if debug
	override public function toString ()
	{
		return "DynamicTileAlgorithm";
	}


	override public function toCSS (prefix:String = "") : String
	{
		return "dynamic-tile ( "+startDirection+", "+horizontalDirection+", "+verticalDirection+" )";
	}
#end
}



/**
 * Layout-algorithm which is only used for rows. It measures them and if there
 */
private class DynamicRowAlgorithm extends HorizontalFloatAlgorithm
{
	override public function validateHorizontal ()
	{
		var children:ChainedList<LayoutClient> = cast group.children;
	//	if (children.length < 2)
	//		return;
		
		if ( group.changes.hasNone(Flags.LIST | Flags.CHILDREN_INVALIDATED | Flags.WIDTH | Flags.WIDTH_VALIDATOR ) )
			return;
		
		var maxWidth		= group.width.validator.as(IntRangeValidator).max;
		var availableSpace	= maxWidth;
		var fullChildNum	= -1;			//counter to count all the children that didn't fit in the group
		
		//TileContainers children are changed.
		//Check the group to see if the width is bigger then the maxWidth
		for (child in children)
		{
			//check if the child will still fit in this row
			if (fullChildNum >= 0 || availableSpace < child.outerBounds.width)
			{
				//move child to the next list
				if (children.length > 1) {
					fullChildNum++;
					children.moveItemToNextList( child, fullChildNum );
				}
			}
			else
			{
				//keep child in row
				availableSpace -= child.outerBounds.width;
			}
		}
		
		//try to add children from the next list to this lsit
		if (availableSpace > 0 && fullChildNum == -1 && children.nextList != null && children.nextList.length > 0)
		{
			for (child in children.nextList)
			{
				if (availableSpace < child.outerBounds.width)
					break;
				
				children.nextList.remove(child);
				children.add( child );
				availableSpace -= child.outerBounds.width;
			}
		}
		
		setGroupWidth( maxWidth - availableSpace );
	}
	
	
#if debug
	override public function toString ()
	{
		var start	= direction == Horizontal.left ? "left" : "right";
		var end		= direction == Horizontal.left ? "right" : "left";
		return "floatRow " + start + " -> " + end;
	}
#end
}



private class DynamicColumnAlgorithm extends VerticalFloatAlgorithm
{
	override public function validateVertical ()
	{
		var children:ChainedList<LayoutClient> = cast group.children;
		
	//	if (children.length < 2)
	//		return;
		
		if ( !group.changes.has(Flags.LIST) && !group.changes.has(Flags.CHILDREN_INVALIDATED) && !group.changes.has(Flags.HEIGHT) )
			return;
		
		var maxHeight		= group.height.validator.as(IntRangeValidator).max;
		var availableSpace	= maxHeight;
		var fullChildNum	= -1;				//counter to count all the children that didn't fit in the group
		
		//TileContainers children are changed.
		//Check the group to see if the width is bigger then the maxWidth
		for (child in children)
		{
			//check if the child will still fit in this row
			if (fullChildNum >= 0 || availableSpace < child.outerBounds.height)
			{
				//move child to the next list
				fullChildNum++;
				
				if (children.length > 1)
					children.moveItemToNextList( child, fullChildNum );
			}
			else
			{
				//add child to row
				availableSpace -= child.outerBounds.height;
			}
		}

		//try to add children from the next list to this lsit
		if (availableSpace > 0 && fullChildNum == -1 && children.nextList != null && children.nextList.length > 0)
		{
			for (child in children.nextList)
			{
				if (availableSpace < child.outerBounds.height)
					break;

				children.nextList.remove(child);
				children.add( child );
				availableSpace -= child.outerBounds.height;
			}
		}
		setGroupHeight( maxHeight - availableSpace );
	}
	
	
#if debug
	override public function toString ()
	{
		var start	= direction == Vertical.top ? "top" : "bottom";
		var end		= direction == Vertical.top ? "bottom" : "top";
		return "floatColumn " + start + " -> " + end;
	}
#end
}