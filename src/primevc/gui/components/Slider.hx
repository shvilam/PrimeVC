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
 import primevc.core.geom.space.Direction;
 import primevc.core.Bindable;
 import primevc.gui.behaviours.components.DirectToolTipBehaviour;
 import primevc.gui.behaviours.UpdateMaskBehaviour;
 import primevc.gui.core.UIElementFlags;
 import primevc.gui.core.UIGraphic;
 import primevc.gui.display.VectorShape;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberMath;
  using Std;


/**
 * Slider component with a filling background to indicate which part of the
 * slider is slided.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 05, 2010
 */
class Slider extends SliderBase
{
	/**
	 * String displaying the value in %
	 */
	public var label	(default, null)		: Bindable<String>;
	
	
	public function new (id:String = null, value:Float = 0.0, minValue:Float = 0.0, maxValue:Float = 1.0, direction:Direction = null)
	{
		super(id, value, minValue, maxValue, direction);
		label = new Bindable<String>();
	}
	
	
	override private function init ()
	{
		super.init();
		behaviours.add( new UpdateMaskBehaviour( maskShape, this ) );
		dragBtn.behaviours.add( new DirectToolTipBehaviour( dragBtn, dragBtn.data ) );
	}
	
	
	override public function dispose ()
	{
		label.dispose();
		label = null;
		super.dispose();
	}
	
	
	
	//
	// CHILDREN
	//
	
	private var background			: UIGraphic;
	/**
	 * Shape that is used to fill the part of the slider that is slided
	 */
	private var maskedBackground	: UIGraphic;
	private var maskShape			: VectorShape;
	
	
	override private function createChildren ()
	{
		maskShape			= new VectorShape();
		background			= new UIGraphic();
		maskedBackground	= new UIGraphic();
		
		background.styleClasses.add("background");
		maskedBackground.styleClasses.add("maskedBackground");
		
#if debug
		background.id.value = id.value + "Background";
		maskedBackground.id.value = id.value + "MaskedBackground";
#end
		
		layoutContainer.children.add( background.layout );
		layoutContainer.children.add( maskedBackground.layout );
		children.add( background );
		children.add( maskedBackground );
		children.add( maskShape );

		maskedBackground.mask = maskShape;
		super.createChildren();
	}
	
	
	override private function updateChildren ()
	{
		if (direction == horizontal)	maskedBackground.layout.percentWidth = percentage;
		else							maskedBackground.layout.percentHeight = percentage;
		
		dragBtn.data.value = (data.value * 100).roundFloat() + "%";
		return super.updateChildren();
	}
	
	
	override private function setDirection (v)
	{
		if (direction != v)
		{
			if (direction != null)
				styleClasses.remove( direction.string()+"Slider" );
			
			super.setDirection(v);
			
			if (v != null)
				styleClasses.add( direction.string()+"Slider" );
		}
		return v;
	}
	
	
/*	override public function validate ()
	{
		var changes = this.changes;
		super.validate();
		
		if (changes.has(UIElementFlags.PERCENTAGE))
			label.value = percentage.roundFloat() + "%";
	}*/
}