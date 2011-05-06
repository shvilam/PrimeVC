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
 import primevc.core.dispatcher.Wire;
 import primevc.gui.behaviours.components.ButtonSelectedOpenPopup;
 import primevc.gui.behaviours.components.ListKeyNavigationBehaviour;
 import primevc.gui.behaviours.layout.FollowObjectBehaviour;
 import primevc.gui.components.DataButton;
 import primevc.gui.components.ListHolder;
 import primevc.gui.core.IUIDataElement;
 import primevc.gui.core.IUIElement;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.traits.ISelectable;
 import primevc.types.Asset;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;



/**
 * ComboBox component.
 * Will show a selectionlist when clicked on and display the current value
 * in the button.
 * 
 * This class is an abstract component. In order to use it, you can do 3 things:
 * 		- extend the class and override the createChildren method to create the 'list'.
 * 		- fill the 'list' method from outside before the combobox is added to the stage
 * 		- create a skin which will fill the 'list' property
 * 
 * Each combobox 'list' will get the styleclass 'comboList' and the id 
 * 	'this.id+"List"' to make the list stylable in css.
 * 
 * @author Ruben Weijers
 * @creation-date Feb 10, 2011
 */
class ComboBox <DataType> extends DataButton <DataType>
{
	/**
	 * The combobox popup.
	 * Don't forget to set this property
	 */
	public var list					(default, null)					: ListHolder<DataType, DataType>;
	public var listData				(default, setListData)			: IReadOnlyList<DataType>;
	
	/**
	 * Injectable method which will create the needed itemrenderer
	 * @param	item:ListDataType
	 * @param	pos:Int
	 * @return 	IUIElement
	 */
	public var createItemRenderer	(default, setCreateItemRenderer) : DataType -> Int -> IUIElement;
	
	private var selectListItemWire	: Wire<DataType->DataType->Void>;
	
	/**
	 * Wire for listening to mouse-down events on the stage. Only enabled when
	 * the combobox is enabled.
	 */
	private var windowWire			: Wire<Dynamic>;
	private var indexChangeWire		: Wire<Dynamic>;
	
	
	public function new (id:String = null, defaultLabel:String = null, icon:Asset = null, selectedItem:DataType = null, listData:IReadOnlyList<DataType> = null)
	{
		(untyped this).listData = listData;
		super(id, defaultLabel, icon, selectedItem);
	}
	
	
	override private function createChildren ()
	{
		super.createChildren();
		
		if (list == null) {
			list = new ListHolder( id.value+"List", null, listData );
			list.styleClasses.add( "comboList" );
			list.behaviours.add( new FollowObjectBehaviour( list, this ) );
			list.behaviours.add( new ListKeyNavigationBehaviour( list ) );
			
			if (createItemRenderer == null)
				createItemRenderer = createDefaultItemRenderer;
			
			list.createItemRenderer	= createItemRenderer;
		}
		else if (list.createItemRenderer != null)
			createItemRenderer = list.createItemRenderer;
		
		indexChangeWire = updateSelectedItem.on( list.selectedIndex.change, this );
		
	//	Assert.notNull( listData );
		Assert.notNull( getLabelForVO );
	//	Assert.notNull( createItemRenderer );
		
		//leave the opening and closing of the list to the behaviouruserEvents.
		behaviours.add( new ButtonSelectedOpenPopup( this, list ) );
		toggleSelect	.on( userEvents.mouse.down, this );
		handleSelected	.on( selected.change, this );
		
		windowWire = checkToDeselect.on( window.userEvents.mouse.down, this );
		windowWire.disable();
		
		handleItemRendererClick.on( list.childClick, this );
		
		//listen to layout changes.. make sure the combobox is always at least the size of the combobox button
	//	updateListWidth	.on( layout.changed, this );
		
		//select the current value in the list when the list item-renderers are created
		selectCurrentValue	.on( list.state.change, this );
		
		//re-select item on vo change, but only when list is initialized (start disabled)
		selectListItemWire = handleVOChange.on( vo.change, this );
		selectListItemWire.disable();
	}
	
	
	override public function dispose ()
	{
		if (indexChangeWire != null) {
			indexChangeWire.dispose();
			indexChangeWire = null;
		}
		if (list != null) {
			list.dispose();
			list = null;
		}
		listData = null;
		super.dispose();
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private function setListData (v)
	{
		if (v != listData)
		{
			if (selectListItemWire != null) // FIXME: Unsure if needed
				selectListItemWire.disable();
			
			if (list != null)
				list.listData = cast v;
			
			listData	= v;
			vo.value	= null;
		}
		
		return v;
	}
	
	
	private inline function setCreateItemRenderer (v)
	{
		if (v != createItemRenderer)
		{
			createItemRenderer = v;
			if (list != null)
				list.createItemRenderer = v;
		}
		return v;
	}
	
	
	private function createDefaultItemRenderer (vo:DataType, pos:Int) : IUIElement
	{
		var b = new DataButton<DataType>();
		b.vo.value = vo;
		b.getLabelForVO = getLabelForVO;
		return cast b;
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	
	/**
	 * Method is called when an item-renderer in the list is clicked. The
	 * method will try to update the value of the combobox.
	 */
	private function handleItemRendererClick (mouseEvt:MouseState) : Void
	{
		if (mouseEvt.target != null)
		{
			if (mouseEvt.target.is( DataButton )) {
				var dataButton : DataButton<DataType> = cast mouseEvt.target;
				vo.value = dataButton.vo.value;
			}
			
			else if (mouseEvt.target.is( IUIDataElement )) {
				var dataElement : IUIDataElement<DataType> = cast mouseEvt.target;
				vo.value = dataElement.data;
			}
		}
	}
	
	
	/**
	 * Method will update the min-width of the list to the current-width of
	 * the button to make sure the list is always at least the same width as
	 * the button
	 */
/*	private function updateListWidth (changes:Int)
	{
		if (changes.has(LayoutFlags.WIDTH) && list.list != null)
		{
			var l = list.list.layout;
			trace("update list min-width to "+layout.innerBounds.width);
			if (l.widthValidator == null)
				l.widthValidator = new IntRangeValidator( layout.innerBounds.width );
			else
				l.widthValidator.min = layout.innerBounds.width;
		}
	}*/
	
	
	/**
	 * Method will try to select the item-renderer of the new value-object in
	 * the list
	 */
	private function handleVOChange (newVO:DataType, oldVO:DataType)
	{
	//	trace( oldVO + " => "+newVO+"; selected: "+isSelected());
		
#if debug
		if (newVO != null)
			Assert.that( listData.has(newVO) );
#end		
		
		Assert.notNull(list);
		Assert.notNull(list.list);
		if (oldVO != null)	deselectItem(oldVO);
		if (newVO != null)	selectItem(newVO);
		
		//close list
		if (isSelected())
			deselect();
	}
	
	
	private inline function deselectItem (vo:DataType)
	{
		//change selected itemrenderer in list
		var view = list.list;
		var r = view.getRendererFor( vo );
		if (r != null && r.is(ISelectable))
			r.as(ISelectable).deselect();
		
		indexChangeWire.disable();
		list.selectedIndex.value = -1;
		indexChangeWire.enable();
	}
	
	
	private inline function selectItem (vo:DataType)
	{
		//change selected itemrenderer in list
		var view = list.list;
		var i	= view.getPositionFor( vo );
		var r	= view.getRendererAt( i );
		
	//	trace(this+".select "+r);
		if (r != null && r.is(ISelectable))
			r.as(ISelectable).select();
		
		indexChangeWire.disable();
		list.selectedIndex.value = i;
		indexChangeWire.enable();
	}
	
	
	/**
	 * Eventhandler that is called when list.selectedIndex changes
	 */
	private function updateSelectedItem (newIndex:Int, oldIndex:Int) : Void
	{
		vo.value = listData.getItemAt( newIndex );
	}
	
	
	/**
	 * Method will select the current-value the first-time the list is opened
	 */
	private function selectCurrentValue ()
	{
		if (list.isInitialized())
		{
			Assert.notThat(selectListItemWire.isEnabled());
			
			if (vo.value != null)
				selectItem( vo.value );
			
			selectListItemWire.enable();
		//	updateListWidth( LayoutFlags.WIDTH );
		}
	}
	
	
	private function handleSelected (newVal:Bool, oldVal:Bool)
	{
		if (newVal)		windowWire.enable();
		else			windowWire.disable();
	}
	
	
	public function checkToDeselect (m:MouseState)
	{
		if (!m.related.is(IUIElement)) {
			deselect();
		}
		else
		{
			var target = m.related.as(IUIElement);
			if (target != this && target != list)
			{
				var displayTarget = target.container;
				while (displayTarget != null && displayTarget != displayTarget.window && displayTarget != list)
				 	displayTarget = displayTarget.container;
				
				if (displayTarget != list) // && !list.list.children.has(target))
					deselect();
			//	else: mouse event target is a descendant of list, do nothing
			}
		}
	}
}