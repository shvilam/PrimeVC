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
 import primevc.core.net.CommunicationType;
 import primevc.core.Bindable;

 import primevc.gui.components.Label;

 import primevc.gui.core.UIElementFlags;
 import primevc.gui.core.UIGraphic;

  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;


/**
 * Linear loader bar for the ProgressBar component with a label underneath the
 * progressbar
 * 
 * @author Ruben Weijers
 * @creation-date Apr 20, 2011
 */
class LinearProgressLabelSkin extends LinearProgressSkin
{
	private var label		: Bindable<String>;
	private var labelField	: Label;
	
	/**
	 * String to put before the label ('Laden' or 'Uploaden')
	 */
	private var labelPrefix	: String;
	
	
	override private function createBehaviours ()
	{
		label = new Bindable<String>();
		super.createBehaviours();
	}
	
	
	override private function removeBehaviours ()
	{
		label.dispose();
		label = null;
		
		super.removeBehaviours();
	}
	

	override public function createChildren ()
	{
		super.createChildren();
		labelField	= new Label(null, label);
		labelField.attachTo( owner );
	}


	override private function removeChildren ()
	{
		super.removeChildren();
		if (labelField != null)
		{
			labelField.dispose();
			labelField	= null;
		}
	}
	
	
	override public function validate (changes:Int)
	{
		if (changes.has( UIElementFlags.SOURCE ))
		{
			if (owner.source != null) {
				labelPrefix	= owner.source.type == CommunicationType.loading ? 'Laden: ' : 'Uploaden: ';
				update( owner.data.percentage, 0 );
			}
			else
			{
				labelPrefix = "";
				update( owner.data.percentage, 0 );
			}
		}
	}
	
	
	//
	// EVENTHANDLERS
	//
	
	override private function update (newVal:Float, oldVal:Float)
	{
		label.value = labelPrefix + (newVal * 100).roundFloat() + "%";
		super.update(newVal, oldVal);
	}
}