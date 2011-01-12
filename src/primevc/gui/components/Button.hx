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
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.styling.IIconOwner;
 import primevc.gui.text.TextFormat;
 import primevc.gui.traits.ITextStylable;
 import primevc.types.Bitmap;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;


private typedef DataType = Bindable<String>;


/**
 * Button component
 * 
 * @author Ruben Weijers
 * @creation-date Oct 29, 2010
 */
class Button extends UIDataContainer <DataType>, implements IIconOwner, implements ITextStylable
{
	public static inline var ICON : Int = 16384;
	
	public var icon			(default, setIcon)		: Bitmap;
	public var labelField	(default, null)			: UITextField;
	public var iconGraphic	(default, null)			: Image;
	
#if flash9
	public var textStyle	(default, setTextStyle)	: TextFormat;
	public var wordWrap		: Bool;
#end
	
	
	public function new (id:String = null, value:String = null, icon:Bitmap = null)
	{
		super(id, new DataType(value));
		this.icon = icon;
	}
	
	
	override private function createChildren ()
	{
		labelField = new UITextField( null, true, data);
#if debug
		labelField.id.value = id.value + "TextField";
#end
#if flash9
		labelField.autoSize			= flash.text.TextFieldAutoSize.NONE;
		labelField.selectable		= false;
		labelField.mouseEnabled		= false;
		labelField.tabEnabled		= false;
#end
		if (textStyle != null)
			labelField.textStyle	= textStyle;
		
	//	if (data == null)
	//		data = labelField.data;
		
		addOrRemoveLabel();
	}
	
	
	private function addOrRemoveLabel ()
	{
		if (data.value == null && labelField.container != null)
		{
			layoutContainer.children.remove( labelField.layout );
			children.remove( labelField );
		}
		
		else if (data.value != null && labelField.container == null)
		{
			layoutContainer.children.add( labelField.layout, children.length );
			children.add( labelField, children.length );
		}
	}
	
	
	override private function removeChildren ()
	{
		super.removeChildren();
		layoutContainer.children.remove( labelField.layout );
		labelField.dispose();
		labelField	= null;
		icon		= null;
	}
	
	
	override private function initData ()
	{
		addOrRemoveLabel.on( data.change, this );
		labelField.data = data;
	}
	
	
	override private function removeData ()
	{
		labelField.data = null;
		data.change.unbind(this);
	}
	
	
	override public function validate ()
	{
		if (changes.has( ICON ))
		{
			if (iconGraphic != null)
			{
				children.remove(iconGraphic);
				layoutContainer.children.remove( iconGraphic.layout );
				iconGraphic.dispose();
				iconGraphic = null;
			}
			
			if (icon != null)
			{
				Assert.null( iconGraphic );
				iconGraphic = new Image( null, icon );
				iconGraphic.maintainAspectRatio = false;
#if debug		iconGraphic.id.value = id.value + "Icon";	#end
				layoutContainer.children.add( iconGraphic.layout, 0 );
				children.add( iconGraphic, 0 );
			}
		}
		
		super.validate();
	}
	
	
	private inline function setIcon (v)
	{
		if (icon != v)
		{
			icon = v;
			invalidate( ICON );
		}
		return v;
	}
	
	
#if flash9
	private inline function setTextStyle (v:TextFormat)
	{
		if (labelField != null)
			labelField.textStyle = v;
		
		return textStyle = v;
	}
#end
}