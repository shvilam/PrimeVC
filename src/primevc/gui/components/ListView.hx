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
// import primevc.gui.behaviours.layout.AutoChangeLayoutChildlistBehaviour;
 import primevc.gui.components.IItemRenderer;
 import primevc.gui.core.IUIDataElement;
// import primevc.gui.core.UIContainer;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.states.ValidateStates;
 import primevc.gui.traits.IInteractive;
 import primevc.gui.traits.ISelectable;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
  using haxe.Timer;


//private typedef ItemRenderer <T:IValueObject>		= IUIDataElement < T >;
//private typedef ItemRendererType <T:IValueObject>	= Class < ItemRenderer < T > >;


/**
 * Class to visually represent data in a list.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 26, 2010
 */
class ListView < ListDataType > extends UIDataContainer < IReadOnlyList < ListDataType > >//, implements haxe.rtti.Generic //, implements IListView < ListDataType >
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
	
	/**
	 * Container in which the itemrenders will be placed.
	 * Don't add children here manually!
	 */
//	public var content			(default, null) : UIContainer;
	
	
	
	override private function createBehaviours ()
	{
	//	content			= new UIContainer(id+"Content");
		childClick		= new Signal1<MouseState>();
		childClick.disable();
		
		scheduleEnable		.on( displayEvents.addedToStage, this );
		disableChildClick	.on( displayEvents.removedFromStage, this );
	//	behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
	}
	
	
	var enableDelay : haxe.Timer;
	
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
	
	
	override public function dispose ()
	{
		super.dispose();
		removeEnableTimer();
		childClick.dispose();
		childClick = null;
	}
	
	
	override private function initData ()
	{
		var length = data.length;
		
		var layout = layoutContainer;
		if (layout.algorithm != null && isScrollable) {
			layout.setFixedChildLength( length );
			
			checkFirstItemRenderer	.on( layout.scrollPos.xProp.change, this );
			checkFirstItemRenderer	.on( layout.scrollPos.yProp.change, this );
			checkItemRenderers		.on( layout.changed, this );
			
			trace(this+"; "+layout.childHeight+" / "+layout.height);
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
		var renderer = getRendererFor( item );
		if (renderer != null)
			removeRenderer( renderer );		// removing the click-listener is not nescasary since the item-renderer is getting disposed
	}
	
	
	private inline function removeRenderer (renderer:IUIDataElement<ListDataType>)	{ renderer.dispose(); }
	
	
	
	public inline function getRendererFor ( item:ListDataType ) : IUIDataElement<ListDataType>
	{
		return getRendererAt( getPositionFor( item ) );
	}
	
	
	public inline function getRendererAt( pos:Int ) : IUIDataElement<ListDataType>
	{
		return pos > -1 ? cast children.getItemAt(pos).as(IUIDataElement) : null;
	}
	
	
	/**
	 * Method returns the position of the item-renderer with the given data-item
	 */
	public inline function getPositionFor (dataItem:ListDataType) : Int
	{
		var renderers = children;
		var pos = data.indexOf(dataItem);
		if (pos > -1)
			pos -= layoutContainer.fixedChildStart;
		
		return pos;
	}
	
	
	public inline function hasRendererFor (dataItem:ListDataType) : Bool
	{
	    var l     = layoutContainer;
	    var depth = data.indexOf(dataItem) - l.fixedChildStart;
	    return depth >= 0 && depth < l.children.length;
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
	
	
	private function checkFirstItemRenderer ()
	{
		var l = layoutContainer;
		var a = l.algorithm;
		updateVisibleItemRenderers( a.getDepthOfFirstVisibleChild(), l.children.length );
	}
	
	
	private inline function updateVisibleItemRenderers (startVisible:Int, maxVisible:Int)
	{
		var l = layoutContainer;
		var curStart = l.fixedChildStart;
		var curLen	 = l.children.length;
		
		trace(this+": "+startVisible+" / "+maxVisible+"; current: "+curStart+" / "+curLen);
		if ((startVisible + maxVisible) > data.length)
			startVisible = data.length - maxVisible;
		
		if (curStart != startVisible)
		{
			l.fixedChildStart = startVisible;
			var diff = (startVisible - curStart).abs().getSmallest(curLen);
			var max	 = curLen - 1;		// max items used in calculations (using 0 - (x - 1) instead of 1 - x)
			
			// move children
			if		(curStart < startVisible)	for (i in 0...diff)	reuseRenderer( 0, max, startVisible + i );
			else if (curStart > startVisible)	for (i in 0...diff)	reuseRenderer( max, 0, startVisible + diff - i - 1 );
		}
		
		if (curLen != maxVisible)
		{
			// add-remove children
			if		(curLen < maxVisible)		for (i in curLen...maxVisible)	addRenderer(    data.getItemAt( i + startVisible ), i );
			else if (curLen > maxVisible)		for (i in maxVisible...curLen)	removeRenderer( cast children.getItemAt(maxVisible) );
		}
	}
	
	
	private inline function reuseRenderer( from:Int, to:Int, newDataPos:Int )
	{
	//	trace("reuse renderer from "+from+" to "+to+" with data "+newDataPos);
		var d = data.getItemAt(newDataPos);
		var r = children.getItemAt(from).as(IUIDataElement);
		r.changeDepth( to );
		
		if (r.is(ISelectable))
		    r.as(ISelectable).deselect();
		
		if (r.is(IItemRenderer))	r.as(IItemRenderer).vo.value = cast d;
	 	else						r.data = cast d;
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	
	private function handleListChange ( change:ListChange<ListDataType> ) : Void
	{
		switch (change)
		{
			case added( item, newPos):			addRenderer( item, newPos );
			case removed (item, oldPos):		removeRendererFor( item, oldPos );
			case moved (item, newPos, oldPos):	moveRenderer( item, newPos, oldPos );
			default:
		}
	}
}