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
 import primevc.gui.core.UITextField;
 import primevc.gui.core.Skin;
 import primevc.gui.events.UserEventTarget;
  using primevc.utils.BitUtil;



private typedef Flags = primevc.gui.core.UIElementFlags;



/**
 * Skin for a button with only a label.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 19, 2011
 */
class ButtonLabelSkin extends Skin<Button>
{
	private var labelField : UITextField;


	override public function createChildren ()
	{
		labelField = new UITextField( null, true, owner.data );
		
#if debug
		labelField.id.value		= owner.id.value + "TextField";
#end
#if flash9
		labelField.autoSize			= flash.text.TextFieldAutoSize.NONE;
		labelField.selectable		= false;
		labelField.mouseEnabled		= false;
		labelField.tabEnabled		= false;
		labelField.respondToFocusOf( owner );

		if (owner.textStyle != null)
			labelField.textStyle = owner.textStyle;
#end
		owner.attach( labelField );
	}


	override private function removeChildren ()
	{
		if (labelField != null)
		{
			labelField.detach();
			labelField.dispose();
			labelField = null;
		}
	}

	
#if flash9
	override public function validate (changes:Int)
	{
		if (changes.has( Flags.TEXTSTYLE ))
			labelField.textStyle = owner.textStyle;
	}
	
	
	override public function isFocusOwner (target:UserEventTarget)
	{
		return labelField.isFocusOwner(target);
	}
#end
}