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
package primevc.gui.effects.effectInstances;
 import primevc.core.geom.Rectangle;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.effects.EffectProperties;
 import primevc.gui.effects.WipeEffect;
 import primevc.types.Number;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


/**
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
class WipeEffectInstance extends EffectInstance < IDisplayObject, WipeEffect >
{
	
	/**
	 * start x/y position that will be used during the effect. The startValue
	 * will be used when it's set, otherwise the effect will calculate the
	 * default start-value based on the direction of the wipe.
	 */
	private var startValue			: Float;
	
	/**
	 * final x/y position that will be used during the effect. The endValue
	 * will be used when it's set, otherwise the effect will calculate the
	 * default end-value based on the direction of the wipe.
	 */
	private var endValue			: Float;
	
	
	
	public function new (target, effect)
	{
		super(target, effect);
		startValue = endValue = Number.FLOAT_NOT_SET;
	}
	
	
	override public function setValues ( v:EffectProperties ) 
	{
		
	}
	
	
#if flash9
	override private function initStartValues ()
	{
		var t = target;
		if (t.scrollRect == null)
			t.scrollRect = new Rectangle( 0, 0, t.width, t.height );
		
		var rect	= t.scrollRect;
		startValue	= effect.startValue;
		endValue	= effect.endValue;
		
		if (endValue.notSet())
			endValue = 0;
		
		if (startValue.notSet() || startValue == effect.endValue)
			switch (effect.direction) {
				case TopToBottom:	rect.y = startValue =  rect.height;
				case BottomToTop:	rect.y = startValue = -rect.height;
				case LeftToRight:	rect.x = startValue =  rect.width;
				case RightToLeft:	rect.x = startValue = -rect.width;
			}
		else switch (effect.direction) {
				case TopToBottom, BottomToTop:	rect.y = startValue;
				case LeftToRight, RightToLeft:	rect.x = startValue;
			}
		
		t.scrollRect	= rect;
		t.visible		= true;
	}


	override private function tweenUpdater ( tweenPos:Float )
	{
		var rect			= target.scrollRect;
		var newVal:Float	= ( endValue * tweenPos ) + ( startValue * (1 - tweenPos) );
		
		switch (effect.direction) {
			case TopToBottom, BottomToTop:	rect.y = newVal;
			case LeftToRight, RightToLeft:	rect.x = newVal;
		}
		target.scrollRect = rect;
	}


	override private function calculateTweenStartPos () : Float
	{
		var curValue:Float = 0;
		switch (effect.direction) {
			case TopToBottom, BottomToTop:	curValue = target.scrollRect.y;
			case LeftToRight, RightToLeft:	curValue = target.scrollRect.x;
		}
		
		return (curValue - startValue) / (endValue - startValue);
	}
	
	
	override private function onTweenReady ( ?tweenPos:Float )
	{
		var rect = target.scrollRect;
		switch (effect.direction) {
			case TopToBottom:	if (rect.y >=  rect.height)	{ target.visible = false; rect.y = 0; }
			case BottomToTop:	if (rect.y <= -rect.height)	{ target.visible = false; rect.y = 0; }
			case LeftToRight:	if (rect.x >=  rect.width)	{ target.visible = false; rect.x = 0; }
			case RightToLeft:	if (rect.x <= -rect.width)	{ target.visible = false; rect.x = 0; }
		}
		
		target.scrollRect = rect;
		super.onTweenReady();
	}
#end
}