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
 import primevc.gui.core.Skin;
  using primevc.utils.BitUtil;



private typedef Flags = primevc.gui.core.UIElementFlags;



/**
 * Skin for a button with only an icon.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 19, 2011
 */
class ButtonIconSkin extends Skin<Button>
{
	private var iconGraphic : Image;


	override public function createChildren ()
	{
		owner					.children.add(	iconGraphic = new Image() );
		owner.layoutContainer	.children.add(	iconGraphic.layout );
		
		iconGraphic.maintainAspectRatio = false;
#if debug
		iconGraphic.id.value	= owner.id.value + "Icon";
#end
	}


	override private function removeChildren ()
	{
		if (iconGraphic != null)
		{
			if (owner != null) {
				owner.layoutContainer	.children.remove( iconGraphic.layout );
				owner					.children.remove( iconGraphic );
			}
			iconGraphic.dispose();
			iconGraphic = null;
		}
	}


	override public function validate (changes:Int)
	{
		if (changes.has( Flags.ICON ))
			iconGraphic.data = owner.icon;
	}
}