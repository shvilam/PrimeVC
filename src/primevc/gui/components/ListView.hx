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
package primevc.gui.components;
 import primevc.core.collections.IReadOnlyList;
 import primevc.core.collections.ListChange;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.traits.IValueObject;
 import primevc.core.geom.IRectangle;
 import primevc.gui.components.IItemRenderer;
 import primevc.gui.core.IUIDataElement;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.states.ValidateStates;
 import primevc.gui.traits.IInteractive;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
  using haxe.Timer;


/**
 * Class to visually represent data in a list.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 26, 2010
 */
class ListView<ListDataType> extends UIDataContainer < IReadOnlyList < ListDataType > >//, implements haxe.rtti.Generic //, implements IListView < ListDataType >
{
	/**
	 * Signal which will dispatch mouse-clicks of interactive item-rendered 
	 * children.
	 */
	public var childClick (default, null)	: Signal1<MouseState>;
	
	/**
	 * Injectable method which will create the needed itemrenderer
	 * @param	item:ListDataType
	 * @param	pos:Int
	 * @return 	IUIDataElement
	 */
	public var createItemRenderer			: ListDataType -> Int -> IUIDataElement<ListDataType>;
	
	
	
	override private function createBehaviours ()
	{
		childClick		= new Signal1<MouseState>();
		childClick.disable();
		
		scheduleEnable		.on( displayEvents.addedToStage, this );
		disableChildClick	.on( displayEvents.removedFromStage, this );
	}
	
	
	override public function dispose ()
	{
		childClick.dispose();
		childClick = null;
		
		removeEnableTimer();
		displayEvents.addedToStage.unbind(this);
		displayEvents.removedFromStage.unbind(this);
		
		super.dispose();
	}
	
	
	private var enableDelay : haxe.Timer;
	
	private function scheduleEnable()
	{
		enableDelay = childClick.enable.delay(200);
	}
	
	
	private function disableChildClick()
	{
		removeEnableTimer();
		childClick.disable();
	}
	
	
	private inline function removeEnableTimer ()
	{
		if (enableDelay != null) {
			enableDelay.stop();
			enableDelay = null;
		}
	}
	
	
	override private function initData ()
	{
		var length = data.length;
		
		var layout = layoutContainer;
		if (layout.algorithm != null && isScrollable) {
			layout.setFixedChildLength( length );
			
			layout.invisibleBefore = layout.invisibleAfter = 1;

			invalidateScrollPos	.on( layout.scrollPos.xProp.change, this );
			invalidateScrollPos	.on( layout.scrollPos.yProp.change, this );
			checkItemRenderers	.on( layout.changed, this );
			
			length = layout.algorithm.getMaxVisibleChildren();
		}

		//add itemrenders for new list
		for (i in 0...length)
			addRenderer( data.getItemAt(i), i );
		
		handleListChange.on( data.change, this );
	}
	
	
	override private function removeData ()
	{
		children.disposeAll();
		data.change.unbind(this);
	}
	
	
	
	//
	// DATA RENDERER METHODS
	//
	
	
	private inline function addRenderer( item:ListDataType, newPos:Int = -1 )
	{
		if (newPos == -1)
			newPos = data.indexOf( item );
		
		Assert.notNull( createItemRenderer );
		var child = createItemRenderer( item, newPos ).attachTo(this, newPos);
		
		if (child.is(IInteractive)) // && child.as(IInteractive).mouseEnabled)
			childClick.send.on( child.as(IInteractive).userEvents.mouse.click, this );
	}
	
	
	private inline function removeRendererFor( item:ListDataType, oldPos:Int = -1 )
	{
		var renderer:IDisplayObject = null;
		var depth = indexToDepth(oldPos);
		if (depth > -1)
		{
			renderer = children.getItemAt(depth);
		}
		else
		{
		//	var renderer = getRendererFor( item );
			// can't use getRendererFor here since the data-item is most likely already moved from the
			// data array. Instead all children will be checked if they have the same data as given.
			for (i in 0...children.length)
				if (getRendererData(cast children.getItemAt(i)) == item) {
					renderer = children.getItemAt(i);
					break;
				}
		}

		if (renderer != null)
			renderer.dispose();		// removing the click-listener is not nescasary since the item-renderer is getting disposed
	}
	
	
	private inline function removeRenderer (renderer:IUIDataElement<ListDataType>)
	{
	    renderer.dispose();
	}
	
	
	private inline function moveRenderer ( item:ListDataType, newPos:Int, oldPos:Int )
	{
		var renderer = getRendererFor( item );
		if (renderer != null) {
			layoutContainer.children.move( renderer.layout, newPos, oldPos );
			children.move( renderer, newPos, oldPos );
		}
#if debug
		else
			trace("no itemrenderer found to move for vo-item "+item+"; move: "+oldPos+" => "+newPos);
#end
	}
	
	
	private inline function reuseRenderer( from:Int, to:Int, newDataPos:Int )
	{
		var d = data.getItemAt(newDataPos);
		var r = children.getItemAt(from).as(IUIDataElement);
		setRendererData(cast r, cast d);
		r.changeDepth( to );
	}
	
	
	private inline function setRendererData (r:IUIDataElement<ListDataType>, v:ListDataType)
	{
	    if (r.is(IItemRenderer))	r.as(IItemRenderer).vo.value = cast v;
	 	else						r.data = cast v;
	}
	
	
	private inline function getRendererData (r:IUIDataElement<ListDataType>) : ListDataType
	{
	    return r.is(IItemRenderer) ? cast r.as(IItemRenderer).vo.value : cast r.data;
	}
	
	
	
	
	
	/**
	 * Method returns the item-renderer for the given data item
	 */
	public inline function getRendererFor ( dataItem:ListDataType ) : IUIDataElement<ListDataType>
	{
		return getRendererAt(getDepthFor(dataItem));
	}
	
	
	/**
	 * Method returns the item-renderer at the given depth. If the depth is -1,
	 * the method will return null.
	 */
	public inline function getRendererAt(depth:Int) : IUIDataElement<ListDataType>
	{
		return depth > -1 ? cast children.getItemAt(depth).as(IUIDataElement) : null;
	}
	
	
	/**
	 * Method returns the position of the item-renderer with the given data-item
	 */
	public inline function getDepthFor (dataItem:ListDataType) : Int
	{
		return indexToDepth(data.indexOf(dataItem));
	}
	
	
	/**
	 * Method converts the given data-index to the depth of the item-renderer
	 * If there's no item-renderer for the given index, the method will return
	 * -1.
	 */
	public inline function indexToDepth (index:Int) : Int
	{
	    var depth = index;
	    if (depth > -1)                   depth -= layoutContainer.fixedChildStart;
		if (depth >= children.length)     depth  = -1;
		return depth;
	}
	
	
	/**
	 * Method will return the index of the data-item at the given renderer-depth.
	 * If the index is -1, the method will return -1.
	 */
	public inline function depthToIndex (depth:Int) : Int
	{
	    return depth > -1 ? depth + layoutContainer.fixedChildStart : -1;
	}
	
	
	/**
	 * returns true if there's an item-renderer for the given data-item.
	 */
	public inline function hasRendererFor (dataItem:ListDataType) : Bool
	{
	    return getDepthFor(dataItem) > -1;
	}
	
	
	/**
	 * returns true if there's an item-renderer for the given data-item.
	 */
	public inline function hasRendererAtDepth (depth:Int) : Bool
	{
	    return depthToIndex(depth) > -1;
	}
	
	
	public function getDepthForBounds (bounds:IRectangle) : Int
	{
		return layoutContainer.algorithm.getDepthForBounds(bounds);
	}
	
	
	
	
	
	//
	// ITEM-RENDERER CACHING
	//
	
	
	private function checkItemRenderers (changes:Int)
	{
		if (changes.has( LayoutFlags.CHILD_SIZE | LayoutFlags.SIZE ))
		{
			var a = layoutContainer.algorithm;
			updateVisibleItemRenderers( a.getDepthOfFirstVisibleChild(), a.getMaxVisibleChildren() );
		}
	}
	
	
	private function invalidateScrollPos ()
	{
		var l = layoutContainer;
		updateVisibleItemRenderers( l.algorithm.getDepthOfFirstVisibleChild(), l.children.length );
	}
	
	
	private inline function updateVisibleItemRenderers (startVisible:Int, maxVisible:Int)
	{
		var l = layoutContainer;
		var curStart = l.fixedChildStart;
		var curLen	 = l.children.length;
		
		if ((startVisible + maxVisible) > data.length)
			startVisible = data.length - maxVisible;
		
		
		if (curStart != startVisible)
		{
			l.fixedChildStart = startVisible;
			var diff    = (startVisible - curStart).abs().getSmallest(curLen);
			var max     = curLen - 1;		// max items used in calculations (using 0 - (x - 1) instead of 1 - x)
			
			// move children
			if		(curStart < startVisible)	{ var start = startVisible + curLen - diff;     for (i in 0...diff)	reuseRenderer( 0, max, start + i ); }
			else if (curStart > startVisible)	{ var start = startVisible + diff - 1;          for (i in 0...diff)	reuseRenderer( max, 0, start - i ); }
		}
		
		
		if (curLen != maxVisible)
		{
			// add or remove children
			if		(curLen < maxVisible)		for (i in curLen...maxVisible)	addRenderer(    data.getItemAt( i + startVisible ), i );
			else if (curLen > maxVisible)		for (i in maxVisible...curLen)	removeRenderer( cast children.getItemAt(maxVisible) );
		}
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function handleListChange ( change:ListChange<ListDataType> ) : Void
	{
		var l = children.length;
		switch (change)
		{
			case added( item, newPos):			addRenderer( item, newPos );
			case removed (item, oldPos):		removeRendererFor( item, oldPos );
			case moved (item, newPos, oldPos):	moveRenderer( item, newPos, oldPos );
			default:
		}
	}
}