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
 import primevc.core.collections.IReadOnlyList;
 import primevc.core.traits.IValueObject;
// import primevc.core.Bindable;
// import primevc.core.IBindable;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;
 

/**
 * UIDataComponent is an UIComponent with a bindable vo property of the given
 * type. The DataComponent will default create a bindable object of the 
 * requested type which can be used to update other values in the component.
 * 
 * It's possible to change or read the value of the bindable directly by calling
 *  v = component.data; and component.data = newValue;
 * 
 * @see				primevc.gui.core.UIComponent
 * @see				primevc.gui.core.IUIComponent
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class UIDataComponent <DataType> extends UIComponent, implements IUIDataElement <DataType>
{
//	public var vo (default, setVO)		: IBindable < DataType >;
//	public var data (getData, setData)	: DataType;
	public var data (default, setData)	: DataType;
	
	
	public function new (id:String = null, data:DataType = null)
	{
		super(id);
		if (data != null)
			this.data = data;
	}
	
	
	override public function dispose ()
	{
		if (data != null)
			data = null;
		
		super.dispose();
	}
	
	
	//
	// METHODS
	//
	
	override public function validate ()
	{
		if (changes.has( UIElementFlags.DATA ))
		{
			if (data != null)
				initData();
		}
		
		super.validate();
	}
	
	
	/**
	 * Method in which childcomponents can be bound to the data of the component.
	 * This method can be called on two moments:
	 * 		- component has created children and the data is already set
	 * 		- data is set and the component-state is already initialized
	 */
	private function initData () : Void		{}
	private function removeData () : Void	{}
	
	
	public function getDataCursor ()
	{
		var cursor = new DataCursor < DataType > ( data );
		
		var parent = null;
		if (container != null && container.is(IUIDataElement))
			parent = container.as(IUIDataElement);
		
		if (parent == null)
			return cursor;
		
		if (!parent.data.is(IReadOnlyList))
			return cursor;
		
		cursor.list = cast parent.data.as( IReadOnlyList );
		return cursor;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setData (v:DataType)
	{
		if (v != data)
		{
			if (data != null)// && window != null)
				removeData();
			
			data = v;
			invalidate( UIElementFlags.DATA );
		}
		
		return v;
	}


	public inline function unsetData ()
	{
		data = null;
	}
	
	
//	private inline function getData () : DataType	{ return vo.value; }
//	private inline function setData (v:DataType)	{ return vo.value = v; }
}