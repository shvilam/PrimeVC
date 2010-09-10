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
 import primevc.gui.traits.IScaleable;
 import primevc.types.Number;
  using primevc.utils.NumberUtil;


/**
 * Animation class for changing the scaleX and/or scaleY of the target.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class ScaleEffect extends Effect < IScaleable, ScaleEffect >
{
	/**
	 * Auto or explicit scaleX value to begin the effect with.
	 */
	private var _startX	: Float;
	/**
	 * Auto or explicit scaleY value to begin the effect with.
	 */
	private var _startY	: Float;
	
	/**
	 * Explicit scaleX value. By setting this value, the effect will ignore 
	 * the real target.scaleX value when the effect starts.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var startX	: Float;
	/**
	 * Explicit scaleY value. By setting this value, the effect will ignore 
	 * the real target.scaleY value when the effect starts.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var startY	: Float;
	
	/**
	 * End value of the scaleX property.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var endX		: Float;
	/**
	 * End value of the scaleY property.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var endY		: Float;
	
	
	public function new (target = null, duration:Int = 350, delay:Int = 0, easing:Easing = null, ?endX:Float, ?endY:Float)
	{
		super(target, duration, delay, easing);
		startX		= startY = Number.FLOAT_NOT_SET;
		this.endX	= (endX != null) ? endX : Number.FLOAT_NOT_SET;
		this.endY	= (endY != null) ? endY : Number.FLOAT_NOT_SET;
	}
	
	private inline function isXChanged () : Bool	{ return endX.isSet() && _startX != endX; }
	private inline function isYChanged () : Bool	{ return endY.isSet() && _startY != endY; }
	
	
	override public function clone ()
	{
		var n = new ScaleEffect( target, duration, duration, easing, endX, endY );
		n.startX	= startX;
		n.startY	= startY;
		return n;
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
	
	
	override private function initStartValues ()
	{
		if (startX.isSet())	_startX = startX;
		else				_startX = target.scaleX;
		if (startY.isSet())	_startY = startY;
		else				_startY = target.scaleY;
	}
	
	
	override private function tweenUpdater ( tweenPos:Float )
	{
#if flash9
		if (isXChanged())	target.scaleX = ( endX * tweenPos ) + ( _startX * (1 - tweenPos) );
		if (isYChanged())	target.scaleY = ( endY * tweenPos ) + ( _startY * (1 - tweenPos) );
#end
	}


	override private function calculateTweenStartPos () : Float
	{
#if flash9
		return if		(!isXChanged() && !isYChanged())	1;
		  else if (!isYChanged())							(target.scaleX - _startX) / (endX - _startX);
		  else if (!isXChanged())							(target.scaleY - _startY) / (endY - _startY);
		  else												Math.min(
					(target.scaleX - _startX) / (endX - _startX),
					(target.scaleY - _startY) / (endY - _startY)
				);
#else
		return 1;
#end
	}
}