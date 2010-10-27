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
 import primevc.core.collections.IList;
 import primevc.gui.behaviours.layout.AutoChangeLayoutChildlistBehaviour;
 import primevc.gui.core.IUIDataComponent;
 import primevc.gui.core.UIContainer;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


private typedef ItemRendererType <T> = Class < IUIDataComponent < T > >;


/**
 * Class to visually represent data in a list.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 26, 2010
 */
class ListView < ListDataType > extends UIContainer < IList < ListDataType > >, implements IListView < ListDataType >
{
	public var itemRenderer (default, null)	: ItemRendererType < ListDataType >;
	
	
	public function new (id:String = null, data:IList<ListDataType> = null, itemRenderer:ItemRendererType<ListDataType> = null)
	{
		super(id, data);
		this.itemRenderer = itemRenderer;
	}
	
	
	override private function createBehaviours ()
	{
		behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
	}
	
	
	override private function initData ()
	{
		Assert.that(window != null);
		
		//listen for data changes
		dataChangeHandler.on( data.change, this );
		dataChangeHandler( data.value, null );
	}
	
	
	//
	// DATA RENDERER METHODS
	//
	
	private function addItemRenderer( item:ListDataType, newPos:Int = -1 )
	{
		Assert.notNull( itemRenderer, "Item renderer cannot be null" );
		var inst = Type.createInstance( itemRenderer, [ null, item ] );
		children.add( inst );
	}
	
	
	private function removeItemRenderer( item:ListDataType, oldPos:Int = -1 )
	{
		var inst = getItemRendererFor( item );
		if (inst != null)
			children.remove( inst );
	}
	
	
	private function getItemRendererFor ( item:ListDataType )
	{
		for (child in children)
			if (child.is( ItemRendererType ) )
				return child;
		
		return null;		
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function dataChangeHandler (newVal:IList< ListDataType >, oldVal:IList< ListDataType > ) : Void
	{
		if (oldVal == newVal)
			return;
		
		if (oldVal != null)
		{
			for (item in oldVal)
				removeItemRenderer( item );
			
			oldVal.change.unbind(this);
		}
		
		if (newVal != null)
		{
			listChangeHandler.on( newVal.change, this );
			
			//add itemrenders for new list
			trace(this+".dataChangeHandler");
			for (item in newVal)
				addItemRenderer( item );
		}
	}
	
	
	
	private function listChangeHandler ( change:ListChanges < ListDataType > ) : Void
	{
		
	}
}