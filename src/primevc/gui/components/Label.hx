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
 import primevc.gui.graphics.fills.SolidFill;
 import primevc.gui.graphics.shapes.RegularRectangle;
 import primevc.gui.layout.AdvancedLayoutClient;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * Label is a UIComponent which will display a textfield with the given text.
 * 
 * Options of the Label component
 * 		- truncate text when the width or height reach a certain value
 * 		- skinnable
 * 		- graphics drawable
 * 		- in flash10 full implementation of the text-layout framework
 * 		- autogrowing if height or width aren't defined and the text value 
 * 			changes.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 02, 2010
 */
class Label extends UIDataComponent < String >
{
	private var field	: UITextField;
	
	
	public function new (id:String = null, ?value:String)
	{
		super(id, value);
	}
	
	
	override private function initData ()
	{
		field.setText.on( data.change, this );
		field.setText( value );
	}
	
	
	override private function createChildren ()
	{
		field = new UITextField("labelField");
#if flash9
		field.autoSize = flash.text.TextFieldAutoSize.LEFT;
#end
		field.layout.validateOnPropertyChange = true;
		
		updateSize.on( field.layout.events.sizeChanged, this );
		children.add( field );
	}
	
	
	override private function createLayout ()
	{
		layout = new AdvancedLayoutClient();
	}
	
	
	override private function createGraphics ()
	{
		graphicData.value = new RegularRectangle(
			layout.bounds,
			new SolidFill( 0xffaaaaaa )
		);
	}
	
	
	//
	// EVENTHANDLERS
	//
	
	private function updateSize ()
	{
		trace(this+".updateSize "+field.layout.width+", "+field.layout.height);
		var l = layout.as(AdvancedLayoutClient);
		l.measuredWidth		= field.layout.width;
		l.measuredHeight	= field.layout.height;
	}
}