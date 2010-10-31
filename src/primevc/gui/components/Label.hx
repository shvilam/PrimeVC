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
 import primevc.core.Bindable;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.core.UITextField;
  using primevc.utils.Bind;



/**
 * Label Component
 * 
 * @author Ruben Weijers
 * @creation-date Oct 29, 2010
 */
class Label extends UIDataContainer < String >
{
	private var labelField	: UITextField;
	
	
	public function new (id:String = null, data:Bindable<String> = null)
	{
		if (data != null)
			this.data = cast data;
		
		super(id);
	}
	
	
	override private function createChildren ()
	{
		labelField = new UITextField("labelField");
#if flash9
		labelField.autoSize				= flash.text.TextFieldAutoSize.LEFT;
		labelField.selectable			= false;
		labelField.mouseWheelEnabled	= false;
#end
		children.add( labelField );
		layoutContainer.children.add( labelField.layout );
	}
	
	
	override private function removeChildren ()
	{
		super.removeChildren();
		layoutContainer.children.remove( labelField.layout );
		labelField.dispose();
		labelField = null;
	}
	
	
	override private function initData ()
	{
		dataChangeHandler.on( data.change, this );
		labelField.setText( value );
	}
	
	
	private function dataChangeHandler (newValue:String, oldValue:String)
	{
		labelField.setText( newValue );
	}
}