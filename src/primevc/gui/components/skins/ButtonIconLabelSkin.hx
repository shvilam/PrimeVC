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
package primevc.gui.components.skins;
 import primevc.gui.components.Button;
 import primevc.gui.components.Image;
 import primevc.gui.core.UITextField;
 import primevc.gui.core.Skin;
  using primevc.utils.BitUtil;



private typedef Flags = primevc.gui.core.UIElementFlags;


/**
 * ButtonSkin for a button with a label and a icon.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 19, 2011
 */
class ButtonIconLabelSkin extends Skin<Button>
{
	private var iconGraphic		: Image;
	private var labelField		: UITextField;
	
	
	override public function createChildren ()
	{
		var children	= owner.children;
		var layout		= owner.layoutContainer;
		
		//create children
		children.add( iconGraphic	= new Image(null, owner.icon) );
		children.add( labelField	= new UITextField( null, true, owner.data ) );
		
		layout.children.add( iconGraphic.layout );
		layout.children.add( labelField.layout );
		
		//change properties of new UIElements
		iconGraphic.maintainAspectRatio = false;
#if debug
		labelField.id.value		= owner.id.value + "TextField";
		iconGraphic.id.value	= owner.id.value + "Icon";
#end
#if flash9
		labelField.autoSize			= flash.text.TextFieldAutoSize.NONE;
		labelField.selectable		= false;
		labelField.mouseEnabled		= false;
		labelField.tabEnabled		= false;
		
		if (owner.textStyle != null)
			labelField.textStyle = owner.textStyle;
#end
	}
	
	
	override private function removeChildren ()
	{
		if (owner != null && !owner.isDisposed())
		{
			var children	= owner.children;
			var layout		= owner.layoutContainer;
			
			if (labelField != null) {
				layout.children.remove( labelField.layout );
				children.remove( labelField );
			}
			
			if (iconGraphic != null) {
				layout.children.remove( iconGraphic.layout );
				children.remove( iconGraphic );
			}
		}
		if (iconGraphic != null) {
			iconGraphic.dispose();
			iconGraphic = null;
		}
		
		if (labelField != null) {
			labelField.dispose();
			labelField	= null;
		}
	}
	
	
	override public function validate (changes:Int)
	{
		if (changes.has( Flags.ICON ))
			iconGraphic.data = owner.icon;
		
#if flash9
		if (changes.has( Flags.TEXTSTYLE ))
			labelField.textStyle = owner.textStyle;
#end
	}
}