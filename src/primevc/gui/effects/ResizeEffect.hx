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
 import primevc.gui.traits.ISizeable;
 import primevc.types.Number;
  using primevc.utils.NumberUtil;


/**
 * Animate effect for resizing the width and/or height of the given target.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class ResizeEffect extends Effect < ISizeable, ResizeEffect >
{
	/**
	 * The start width that will be used during the calculations when the effect
	 * is playing.
	 * The value will be the 'startW' property when this is set and 
	 * otherwise the original width value of the target.
	 */
	private var _startW	: Float;
	/**
	 * The start height that will be used during the calculations when the effect
	 * is playing.
	 * The value will be the 'startH' property when this is set and 
	 * otherwise the original height value of the target.
	 */
	private var _startH	: Float;
	
	/**
	 * Explicit start width value. If this value is not set, the effect will 
	 * use the current width of the ISizeable.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var startW	: Float;
	/**
	 * Explicit start height value. If this value is not set, the effect will 
	 * use the current height of the ISizeable.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var startH	: Float;
	/**
	 * Explicit width value of the animation at the end.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var endW		: Float;
	/**
	 * Explicit height value of the animation at the end.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var endH		: Float;
	
	
	private inline function isWChanged () : Bool	{ return endW.isSet() && startW != endW; }
	private inline function isHChanged () : Bool	{ return endH.isSet() && startH != endH; }
	
	
	override public function clone ()
	{
		var n = new ResizeEffect( target, duration, duration, easing );
		n.endW = endW;
		n.endH = endH;
		return n;
	}


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
		if (startW.isSet())	_startW = startW;
		else				_startW = target.width;
		if (startH.isSet())	_startH = startH;
		else				_startH = target.height;
	}
	

	override private function tweenUpdater ( tweenPos:Float )
	{
		if (isWChanged())	target.width	= ( endW * tweenPos ) + ( _startW * (1 - tweenPos) );
		if (isHChanged())	target.height	= ( endH * tweenPos ) + ( _startH * (1 - tweenPos) );
	}
	
	
	override private function calculateTweenStartPos () : Float
	{
		return if (!isWChanged() && !isHChanged())	1;
		  else if (!isHChanged())					(target.width  - _startW) / (endW - _startW);
		  else if (!isWChanged())					(target.height - _startH) / (endH - _startH);
		  else										Math.min(
				(target.width  - _startW) / (endW - _startW),
				(target.height - _startH) / (endH - _startH)
			);
	}
	
	
	override private function setTarget ( v )
	{
		startW = startH = endW = endH = Number.FLOAT_NOT_SET;
		return super.setTarget( v );
	}
}