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
 import primevc.core.validators.IntRangeValidator;
 import primevc.core.Bindable;
 import primevc.gui.behaviours.components.ComboBoxBehaviour;
 import primevc.gui.components.DataButton;
 import primevc.gui.components.ListView;
 import primevc.gui.core.IUIDataElement;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.traits.ISelectable;
 import primevc.types.Bitmap;
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
	public var list			: ListView<DataType>;
	public var listData		(default, setListData)		: IReadOnlyList<DataType>;
	
	/**
	 * Method which should be set externally. The given method can return a
	 * correct string which should be displayed as label in the combobox 
	 * (i.e. the selected value label).
	 */
	public var getLabelForValue							: DataType -> String;
	public var defaultLabel	(default, setDefaultLabel)	: String;
	
	private var listBehaviour	: ComboBoxBehaviour;
	
	
	public function new (id:String = null, defaultLabel:String = null, icon:Bitmap = null, selectedItem:DataType = null, listData:IReadOnlyList<DataType> = null)
	{
		super(id, null, icon, selectedItem);
		this.defaultLabel	= defaultLabel;
		this.listData		= listData;
	}
	
	
	override private function createChildren ()
	{
		super.createChildren();
		
		Assert.notNull( list );
		Assert.notNull( listData );
		Assert.notNull( getLabelForValue );
		
		list.styleClasses.add( "comboList" );
		list.data = listData;
		
		//leave the opening and closing of the list to the behaviouruserEvents.
		behaviours.add( listBehaviour = new ComboBoxBehaviour( this, list, userEvents.mouse.down, userEvents.mouse.down ) );
		handleItemRendererClick.on( list.childClick, this );
		
		//listen to layout changes.. make sure the combox is always at least the size of the combobox button
		updateListWidth.on( layout.changed, this );
	}
	
	
	override public function dispose ()
	{
		if (list != null) {
			list.dispose();
			list = null;
		}
		listData			= null;
		getLabelForValue	= null;
		super.dispose();
	}
	
	
	
	//
	// GETTERS / SETTERS / EVENTHANDLERS
	//
	
	override private function setVO (v:DataType) : DataType
	{
		if ( v != vo)
		{
			trace( vo + " => "+v+"; selected: "+isSelected());
			if (isSelected())
			{
				if (vo != null)
				{
					//change selected itemrenderer in list
					var r = list.getItemRendererFor( vo );
					trace(this+".deselect "+r);
					if (r.is(ISelectable))
						r.as(ISelectable).deselect();
				}
				
				vo = v;
				updateLabel();
				
				if (v != null)
				{
					//change selected itemrenderer in list
					var r = list.getItemRendererFor( vo );
					trace(this+".select "+r);
					if (r.is(ISelectable))
						r.as(ISelectable).select();
				}
			}
			else
			{
				vo = v;
				updateLabel();
			}
		}
		return v;
	}
	
	
	private inline function setListData (v)
	{
		if (v != listData)
		{
			if (list != null)
				list.data = v;
			
			listData = v;
		}
		
		return v;
	}
	
	
	private inline function setDefaultLabel (v:String)
	{
		if (v != defaultLabel)
		{
			defaultLabel = v;
			if (vo == null)
				updateLabel();
		}
		return v;
	}
	
	
	
	/**
	 * Method will show the correct label for the current 'vo'. If the vo is 
	 * null, it will display the "defaultLabel" and add the styleClass "empty"
	 */
	private function updateLabel ()
	{
		if (vo == null)		data.value = defaultLabel;
		else				data.value = getLabelForValue( vo );
	}
	
	
	/**
	 * Method is called when an item-renderer in the list is clicked. The
	 * method will try to update the value of the combobox.
	 */
	private function handleItemRendererClick (mouseEvt:MouseState) : Void
	{
		if (mouseEvt.target != null)
		{
			if (mouseEvt.target.is( DataButton )) {
				vo = cast mouseEvt.target.as( DataButton ).vo;
				listBehaviour.closeList();
			}
			
			else if (mouseEvt.target.is( IUIDataElement )) {
				vo = cast mouseEvt.target.as( IUIDataElement ).data;
				listBehaviour.closeList();
			}
		}
	}
	
	
	private function updateListWidth (changes:Int)
	{
		if (changes.has(LayoutFlags.WIDTH)) {
			var l = list.layout;
			trace("update list min-width to "+layout.innerBounds.width);
			if (l.widthValidator == null)
				l.widthValidator = new IntRangeValidator( layout.innerBounds.width );
			else
				l.widthValidator.min = layout.innerBounds.width;
		}
	}
}