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
 import primevc.gui.effects.MoveEffect;
 import primevc.gui.traits.IPositionable;
 import primevc.types.Number;
 import primevc.utils.NumberUtil;
  using primevc.utils.NumberUtil;



/**
 * @author Ruben Weijers
 * @creation-date Oct 04, 2010
 */
class MoveEffectInstance extends EffectInstance < IPositionable, MoveEffect >
{
	/**
	 * Start x value.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var startX	: Float;
	/**
	 * Start y value.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var startY	: Float;
	/**
	 * x value of the animation at the end.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var endX	: Float;
	/**
	 * y value of the animation at the end.
	 * @default		Number.FLOAT_NOT_SET
	 */
	private var endY	: Float;
	
	
	
	public function new (target:IPositionable, effect:MoveEffect)
	{
		super(target, effect);
		startX = startY = endX = endY = Number.FLOAT_NOT_SET;
	}
	
	
	private inline function isXChanged () : Bool	{ return endX.isSet() && startX != endX; }
	private inline function isYChanged () : Bool	{ return endY.isSet() && startY != endY; }
	
	
	override public function setValues ( v:EffectProperties ) 
	{
		switch (v) {
			case position(fromX, fromY, toX, toY):
				startX	= fromX;
				startY	= fromY;
				endX	= toX;
				endY	= toY;
			default:
				return;
		}
	}
	
	
	override private function initStartValues ()
	{
		if (effect.startX.isSet())	startX	= effect.startX;
		else						startX	= target.x;
		if (effect.startY.isSet())	startY	= effect.startY;
		else						startY	= target.y;
		
		if (endX.notSet())			endX	= effect.endX;
		if (endY.notSet())			endY	= effect.endY;
	}
	

	override private function tweenUpdater ( tweenPos:Float )
	{
		if (isXChanged())	target.x = target.rect.left	= (( endX * tweenPos ) + ( startX * (1 - tweenPos) )).roundFloat();
		if (isYChanged())	target.y = target.rect.top	= (( endY * tweenPos ) + ( startY * (1 - tweenPos) )).roundFloat();
	}
	
	
	override private function calculateTweenStartPos () : Float
	{
		return if (!isXChanged() && !isYChanged())	1;
		  else if (!isYChanged())					(target.x - startX) / (endX - startX);
		  else if (!isXChanged())					(target.y - startY) / (endY - startY);
		  else										FloatMath.min(
				(target.x - startX) / (endX - startX),
				(target.y - startY) / (endY - startY)
			);
	}
}