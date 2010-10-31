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
 import primevc.gui.core.UIDataComponent;
 import primevc.gui.core.UITextField;
 import primevc.gui.layout.AdvancedLayoutClient;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;



/**
 * Label Component
 * 
 * @author Ruben Weijers
 * @creation-date Oct 29, 2010
 */
class Label extends UIDataComponent < String >
{
	private var field	: UITextField;
	
	
	override private function createLayout ()
	{
		layout = new AdvancedLayoutClient();
	}
	
	
	override private function createChildren ()
	{
		field = new UITextField(id+"TextField");
#if flash9
		field.autoSize			= flash.text.TextFieldAutoSize.LEFT;
		field.selectable		= false;
		field.mouseWheelEnabled	= false;
#end
		field.layout.validateOnPropertyChange = true;
		
		updateSize.on( field.layout.events.sizeChanged, this );
		children.add( field );
	}
	
	
	override private function removeChildren ()
	{
		super.removeChildren();
		field.dispose();
		field = null;
	}
	
	
	override private function initData ()
	{
		dataChangeHandler.on( data.change, this );
		field.setText( value );
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function updateSize ()
	{
		var l = layout.as(AdvancedLayoutClient);
		trace("label.updateSize");
		l.measuredWidth		= field.layout.width;
		l.measuredHeight	= field.layout.height;
	}
	
	
	private function dataChangeHandler (newValue:String, oldValue:String)
	{
		field.setText( newValue );
	}
}