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
package primevc.gui.core;
 import primevc.core.collections.DataCursor;
 import primevc.core.collections.IList;
 import primevc.core.Bindable;
  using primevc.utils.TypeUtil;
 

/**
 * UIDataComponent is an UIComponent with a bindable data property of the given
 * type. The DataComponent will default create a bindable object of the 
 * requested type which can be used to update other values in the component.
 * 
 * It's possible to change or read the value of the bindable directly by calling
 *  v = component.value; and component.value = newValue;
 * 
 * @see				primevc.gui.core.UIComponent
 * @see				primevc.gui.core.IUIComponent
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class UIDataComponent <DataType> extends UIComponent, implements IUIDataComponent <DataType>
{
	public var data (default, setData)		: Bindable < DataType >;
	public var value (getValue, setValue)	: DataType;
	
	
	public function new (id:String = null, value:DataType = null)
	{
		super(id);
		if (data == null)
			data = new Bindable < DataType >(value);
	}
	
	
	override public function dispose ()
	{
		if (data != null) {
			data.dispose();
			data = null;
		}
		super.dispose();
	}
	
	
	//
	// METHODS
	//
	
	override private function init ()
	{
		super.init();
		initData();
	}
	
	
	private function initData ()	{ /*Assert.abstract();*/ }
	
	
	public function getDataCursor ()
	{
		var cursor = new DataCursor < DataType > ( value );
		if (container == null || !container.is(IUIDataComponent))
			return cursor;
		
		var parent = container.as(IUIDataComponent);
		if (!parent.value.is(IList))
			return cursor;
		
		cursor.list = cast parent.value.as( IList );
		return cursor;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setData (newData:Bindable < DataType >)
	{
		data = newData;
		if (state.current == state.initialized && data != null)
			initData();
		
		return data;
	}
	
	
	private inline function getValue () : DataType	{ return data.value; }
	private inline function setValue (v:DataType)	{ return data.value = v; }
}