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
 import primevc.gui.effects.effectInstances.MoveEffectInstance;
 import primevc.gui.traits.IPositionable;
 import primevc.types.Number;


/**
 * Animates an IPositionable object from start position to it's end position
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class MoveEffect extends Effect < IPositionable, MoveEffect >
{
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
	
	
	public function new (duration:Int = 350, delay:Int = 0, easing:Easing = null, startX:Float = Number.INT_NOT_SET, startY:Float = Number.INT_NOT_SET, endX:Float = Number.INT_NOT_SET, endY:Float = Number.INT_NOT_SET)
	{
		super(duration, delay, easing);
		
		this.startX	= startX == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : startX;
		this.startY	= startY == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : startY;
		this.endX	= endX == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : endX;
		this.endY	= endY == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : endY;
	}
	
	
	override public function clone ()
	{
		return cast new MoveEffect( duration, duration, easing, startX, startY, endX, endY );
	}
	
	
	override public function createEffectInstance (target)
	{
		return cast new MoveEffectInstance(target, this);
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
}