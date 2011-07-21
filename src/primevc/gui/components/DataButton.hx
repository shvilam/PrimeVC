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
 import primevc.core.dispatcher.Wire;
 import primevc.core.Bindable;
 import primevc.types.Asset;
  using primevc.utils.Bind;


/**
 * DataButton is a button that can be used as an ItemRenderer. Every time it's
 * vo property changes, it will try to update the data.value of the button by
 * calling the method "getLabelForVO".
 * 
 * If the 'vo' value is empty, it will set the "defaultValue" string as value
 * of 'data.value' and add the styleClass 'empty'.
 * 
 * @author Ruben Weijers
 * @creation-date Feb 11, 2011
 */
class DataButton <DataType> extends Button, implements IItemRenderer <DataType>
{
	// IItemRenderer Properties
	public var vo				(default, null)				: Bindable<DataType>;
	
	/**
	 * Method which should be set externally. The given method can return a
	 * correct string which should be displayed as label in the button
	 * (i.e. the selected value label).
	 */
	public var getLabelForVO								: DataType -> String;
	public var defaultLabel		(default, setDefaultLabel)	: String;
	
	private var updateLabelBinding							: Wire<Dynamic>;
	
	
	public function new (id:String = null, defaultLabel:String = null, icon:Asset = null, vo:DataType = null)
	{
		super(id, defaultLabel, icon);
		Assert.notNull(this.data);
		this.defaultLabel	= defaultLabel;
		this.vo				= new Bindable<DataType>(vo);
	}
	
	
	override public function dispose ()
	{
		if (updateLabelBinding != null) {
			updateLabelBinding.dispose();
			updateLabelBinding = null;
		}
		
		vo.dispose();
		vo = null;
		super.dispose();
	}
	
	
	override private function init ()
	{
		super.init();
		updateLabelBinding = updateLabel.on( vo.change, this );
		updateLabel(vo.value, vo.value);
	}
	
	
	public function updateLabel (newVal:DataType, oldVal:DataType)
	{
		if (oldVal == null)		styleClasses.remove("empty");
		if (newVal == null)		styleClasses.add("empty");
		
		//don't use data.value ==> if data is a RevertableBindable, updating the label won't cause any errors
		if (newVal != null)		data.set( getLabelForVO == null ? ""+newVal : getLabelForVO(newVal) );
		else					data.set( defaultLabel );
		
		data.change.send( data.value, null );
	}
	
	
	private function setDefaultLabel (v:String) : String
	{
		if (v != defaultLabel)
		{
			if (data.value == defaultLabel)
				data.value = v;
			
			defaultLabel = v;
		}
		return v;
	}
}