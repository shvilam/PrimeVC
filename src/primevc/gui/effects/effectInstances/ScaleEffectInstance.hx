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
 import primevc.gui.effects.ScaleEffect;
 import primevc.gui.traits.IScaleable;
 import primevc.types.Number;
  using primevc.utils.NumberUtil;



/**
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
class ScaleEffectInstance extends EffectInstance < IScaleable, ScaleEffect >
{
	/**
	 * ScaleX start value.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var startX	: Float;
	/**
	 * ScaleY start value.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var startY	: Float;
	
	/**
	 * End value of the scaleX property.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var endX	: Float;
	/**
	 * End value of the scaleY property.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var endY	: Float;
	
	
	public function new (target, effect)
	{
		super(target, effect);
		startX = startY = endX = endY = Number.FLOAT_NOT_SET;
	}
	
	
	override public function setValues ( v:EffectProperties ) 
	{
		switch (v) {
			case scale(fromSx, fromSy, toSx, toSy):
				startX	= fromSx;
				startY	= fromSy;
				endX	= toSx;
				endY	= toSy;
			default:
				return;
		}
	}
	
	
	private inline function isXChanged () : Bool	{ return endX.isSet() && startX != endX; }
	private inline function isYChanged () : Bool	{ return endY.isSet() && startY != endY; }
	
	
	override private function initStartValues ()
	{
		startX	= effect.startX.isSet() ? effect.startX : target.scaleX;
		startY	= effect.startY.isSet() ? effect.startY : target.scaleY;
		if (effect.endX.isSet())	endX = effect.endX;
		if (effect.endY.isSet())	endY = effect.endY;
	}
	
	
	override private function tweenUpdater ( tweenPos:Float )
	{
#if flash9
		if (isXChanged())	target.scaleX = ( endX * tweenPos ) + ( startX * (1 - tweenPos) );
		if (isYChanged())	target.scaleY = ( endY * tweenPos ) + ( startY * (1 - tweenPos) );
#end
	}


	override private function calculateTweenStartPos () : Float
	{
#if flash9
		return if (!isXChanged() && !isYChanged())	1;
		  else if (!isYChanged())					(target.scaleX - startX) / (endX - startX);
		  else if (!isXChanged())					(target.scaleY - startY) / (endY - startY);
		  else										Math.min(
					(target.scaleX - startX) / (endX - startX),
					(target.scaleY - startY) / (endY - startY)
				);
#else
		return 1;
#end
	}
}