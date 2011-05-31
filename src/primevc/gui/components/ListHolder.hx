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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.components;
 import primevc.core.collections.IReadOnlyList;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.traits.IValueObject;
 import primevc.core.Bindable;
 import primevc.gui.core.IUIElement;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.events.MouseEvents;
  using primevc.utils.Bind;


/**
 * ListHolder is a ListView component where the listview is wrapped inside of this 
 * component.
 * By extending list, or by setting a skin for list, the chrome around a 
 * listview can be used.
 * 
 * Class parameters:
 * 		DataType:		Type of the data property (could be a string for example)
 * 		ListDataType:	Type of list-data
 * 
 * @author Ruben Weijers
 * @creation-date Feb 12, 2011
 */
class ListHolder <DataType, ListDataType> extends UIDataContainer <DataType>, implements IListHolder<ListDataType>
{
	public var list		(default, default)		: ListView<ListDataType>;
	public var listData	(default, setListData)	: IReadOnlyList < ListDataType >;
	public var childClick (default, null)		: Signal1<MouseState>;
	
	/**
	 * Injectable method which will create the needed itemrenderer
	 * 
	 * @param	item:ListDataType
	 * @param	pos:Int
	 * @return 	IUIElement
	 */
	public var createItemRenderer				(default, setCreateItemRenderer) : ListDataType -> Int -> IUIElement;
	/**
	 * If the items in the list are selectable, this bindable holds the position
	 * of the currently selected index.
	 */
	public var selectedIndex					(default, null)	: Bindable<Int>;
	
	
	public function new (id:String, data:DataType = null, listData:IReadOnlyList<ListDataType> = null)
	{
		super(id, data);
		this.listData	= listData;
		selectedIndex	= new Bindable<Int>(-1);
	}
	
	
	override public function dispose ()
	{
		super.dispose();
		childClick.dispose();
		selectedIndex.dispose();
		
		childClick			= null;
		createItemRenderer	= null;
		selectedIndex		= null;
	}
	
	
	override private function createBehaviours ()
	{
		childClick = new Signal1<MouseState>();
	}
	
	
	override private function createChildren ()
	{
		super.createChildren();
		
		//check to see if list is not created yet by a skin
		if (list == null)
		{
			Assert.notNull(createItemRenderer);
			list = new ListView(id.value+"Content", listData);
			list.createItemRenderer = createItemRenderer;
			list.attachTo(this);
		}
		
		list.styleClasses.add("listContent");
		childClick.send.on( list.childClick, this );
	}
	
	
	override private function removeChildren ()
	{
		list.detach();
		list.dispose();
		list = null;
		super.removeChildren();
	}
	
	
	private inline function setListData (v)
	{
		if (listData != v) {
			listData = v;
			if (list != null)
				list.data = v;
		}
		return v;
	}
	
	
	private inline function setCreateItemRenderer (v)
	{
		if (v != createItemRenderer) {
			createItemRenderer = v;
			if (list != null)
				list.createItemRenderer = v;
		}
		return v;
	}
}