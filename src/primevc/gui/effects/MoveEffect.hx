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
package primevc.gui.effects;
 import primevc.gui.traits.IPositionable;
 import primevc.types.Number;
  using primevc.utils.NumberUtil;


/**
 * Animates an IPositionable object from start position to it's end position
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class MoveEffect extends Effect < IPositionable, MoveEffect >
{
	/**
	 * The startX that will be used during the calculations when the effect
	 * is playing.
	 * The value will be the 'startX' property when this is set and 
	 * otherwise the original x value of the target.
	 */
	private var _startX	: Float;
	/**
	 * The startY that will be used during the calculations when the effect
	 * is playing.
	 * The value will be the 'startY' property when this is set and 
	 * otherwise the original y value of the target.
	 */
	private var _startY	: Float;
	
	/**
	 * Explicit start x value. If this value is not set, the effect will 
	 * use the current x of the IPositionable.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var startX	: Float;
	/**
	 * Explicit start y value. If this value is not set, the effect will 
	 * use the current y of the IPositionable.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var startY	: Float;
	/**
	 * Explicit x value of the animation at the end.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var endX		: Float;
	/**
	 * Explicit y value of the animation at the end.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var endY		: Float;
	
	
	public function new (target = null, duration:Int = 350, delay:Int = 0, easing:Easing = null)
	{
		startX = startY = endX = endY = Number.FLOAT_NOT_SET;
		super(target, duration, delay, easing);
	}
	
	
	private inline function isXChanged () : Bool	{ return endX.isSet() && _startX != endX; }
	private inline function isYChanged () : Bool	{ return endY.isSet() && _startY != endY; }
	
	
	override public function clone ()
	{
		var n = new MoveEffect( target, duration, duration, easing );
		n.startX	= startX;
		n.startY	= startY;
		n.endX		= endX;
		n.endY		= endY;
		return n;
	}


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
		if (startX.isSet())	_startX = startX;
		else				_startX = target.x;
		if (startY.isSet())	_startY = startY;
		else				_startY = target.y;
	}
	

	override private function tweenUpdater ( tweenPos:Float )
	{
		if (isXChanged())	target.x = ( endX * tweenPos ) + ( _startX * (1 - tweenPos) );
		if (isYChanged())	target.y = ( endY * tweenPos ) + ( _startY * (1 - tweenPos) );
	}
	
	
	override private function calculateTweenStartPos () : Float
	{
		return if (!isXChanged() && !isYChanged())	1;
		  else if (!isYChanged())					(target.x - _startX) / (endX - _startX);
		  else if (!isXChanged())					(target.y - _startY) / (endY - _startY);
		  else										Math.min(
				(target.x - _startX) / (endX - _startX),
				(target.y - _startY) / (endY - _startY)
			);
	}
}