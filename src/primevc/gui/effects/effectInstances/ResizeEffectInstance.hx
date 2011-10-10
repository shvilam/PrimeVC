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
 import primevc.gui.effects.EffectProperties;
 import primevc.gui.effects.ResizeEffect;
 import primevc.gui.traits.ISizeable;
 import primevc.types.Number;
  using primevc.utils.NumberUtil;
  using Std;


/**
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
class ResizeEffectInstance extends EffectInstance < ISizeable, ResizeEffect >
{
	/**
	 * Start width value.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var startW	: Float;
	/**
	 * Start height value.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var startH	: Float;
	/**
	 * Width value of the animation at the end.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var endW	: Float;
	/**
	 * Height value of the animation at the end.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var endH	: Float;
	
	
	
	public function new (target, effect)
	{
		super(target, effect);
		startW = startH = endW = endH = Number.FLOAT_NOT_SET;
	}
	
	
	private inline function isWChanged () : Bool	{ return endW.isSet() && startW != endW; }
	private inline function isHChanged () : Bool	{ return endH.isSet() && startH != endH; }
	

	override public function setValues ( v:EffectProperties ) 
	{
		switch (v) {
			case size(fromW, fromH, toW, toH):
				startW	= fromW;
				startH	= fromH;
				endW	= toW;
				endH	= toH;
			default:
				return;
		}
	}
	
	
	
	override private function initStartValues ()
	{
		var e = effect, t = target;
		if (e.startW.isSet())	startW = e.startW.int();
		else					startW = t.width;
		if (e.startH.isSet())	startH = e.startH.int();
		else					startH = t.height;
		
		t.rect.width	= startW.int();
		t.rect.height	= startH.int();
	//	t.visible		= true;		no visible property in IDisplayable
	}
	

	override private function tweenUpdater ( tweenPos:Float )
	{
	//	Assert.notNull(target.rect+"; "+tweenPos+"; target "+target+"; "+startW+" -> "+endW+"; "+startH+" -> "+endH);
		if (isWChanged())	target.rect.width	= (( endW * tweenPos ) + ( startW * (1 - tweenPos) )).roundFloat();
		if (isHChanged())	target.rect.height	= (( endH * tweenPos ) + ( startH * (1 - tweenPos) )).roundFloat();
	}
	
	
	override private function calculateTweenStartPos () : Float
	{
		return if (!isWChanged() && !isHChanged())	1;
		  else if (!isHChanged())					(target.rect.width  - startW) / (endW - startW);
		  else if (!isWChanged())					(target.rect.height - startH) / (endH - startH);
		  else										Math.min(
				(target.rect.width  - startW) / (endW - startW),
				(target.rect.height - startH) / (endH - startH)
			);
	}
}