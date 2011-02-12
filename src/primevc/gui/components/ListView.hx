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
 import primevc.gui.core.IUIElement;
// import primevc.gui.core.UIContainer;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.traits.IInteractive;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


//private typedef ItemRenderer <T:IValueObject>		= IUIDataElement < T >;
//private typedef ItemRendererType <T:IValueObject>	= Class < ItemRenderer < T > >;


/**
 * Class to visually represent data in a list.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 26, 2010
 */
class ListView < ListDataType > extends UIDataContainer < IReadOnlyList < ListDataType > >, implements IListView < ListDataType >
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
	 * @return 	IUIElement
	 */
	public var createItemRenderer			: ListDataType -> Int -> IUIElement;
	
	/**
	 * Container in which the itemrenders will be placed.
	 * Don't add children here manually!
	 */
//	public var content			(default, null) : UIContainer;
	
	
	
	override private function createBehaviours ()
	{
	//	content		= new UIContainer(id+"Content");
		childClick	= new Signal1<MouseState>();
	//	behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
	}
	
	
	/*override private function createChildren ()
	{
		content.styleClasses.add( "listContent" );
		layoutContainer.children.add( content.layout );
		children.add( content );
	}
	
	
	override private function removeChildren ()
	{
		layoutContainer.children.remove( content.layout );
		children.remove( content );
		content.dispose();
		content = null;
		super.removeChildren();
	}*/
	
	
	override public function dispose ()
	{
		childClick.dispose();
		childClick = null;
		super.dispose();
	}
	
	
	override private function initData ()
	{
		//add itemrenders for new list
		for (i in 0...data.length)
			addItemRenderer( data.getItemAt(i), i );
		
		handleListChange.on( data.change, this );
	}
	
	
	override private function removeData ()
	{
		for (i in 0...data.length)
			removeItemRenderer( data.getItemAt(i) );
				
		data.change.unbind(this);
	}
	
	
	
	//
	// DATA RENDERER METHODS
	//
	
/*	private function createItemRenderer ( item:ListDataType, pos:Int ) : IUIElement
	{
		Assert.abstract();
		return null;
	}*/
	
	
	private function addItemRenderer( item:ListDataType, newPos:Int = -1 )
	{
		if (newPos == -1)
			newPos = data.indexOf( item );
		
		Assert.notNull( createItemRenderer );
		var child = createItemRenderer( item, newPos );
		
		layoutContainer.children.add( child.layout, newPos );
		children.add( child, newPos );
		
		if (child.is(IInteractive) && child.as(IInteractive).mouseEnabled)
			childClick.send.on( child.as(IInteractive).userEvents.mouse.click, this );
	}
	
	
	private function removeItemRenderer( item:ListDataType, oldPos:Int = -1 )
	{
		var renderer = getItemRendererFor( item );
		if (renderer != null)
		{
			//removing the click-listener is not nescasary since the item-renderer is getting disposed
			layoutContainer.children.remove( renderer.layout );
			children.remove( renderer );
			renderer.dispose();
		}
	}
	
	
	public function getItemRendererFor ( dataItem:ListDataType ) : IUIElement
	{
		var renderers = children;
		for (i in 0...renderers.length)
		{
			var child = renderers.getItemAt( i );
			
			if (child.is( IItemRenderer )) {
				if (child.as(IItemRenderer).vo.value == cast dataItem)
					return cast child.as(IItemRenderer);
			}
			
			else if (child.is( IUIDataElement )) {
				if (child.as(IUIDataElement).data == cast dataItem)
					return cast child.as(IUIDataElement);
			}
		}
		
		return null;
	}
	
	
	private function moveItemRenderer ( item:ListDataType, newPos:Int, oldPos:Int )
	{
		var renderer = getItemRendererFor( item );
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
	// EVENT HANDLERS
	//
	
	
	private function handleListChange ( change:ListChange<ListDataType> ) : Void
	{
		switch (change)
		{
			case added( item, newPos):			addItemRenderer( item, newPos );
			case removed (item, oldPos):		removeItemRenderer( item, oldPos );
			case moved (item, newPos, oldPos):	moveItemRenderer( item, newPos, oldPos );
			default:
		}
	}
}