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
 import primevc.core.geom.space.Position;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.effects.effectInstances.AnchorScaleEffectInstance;
 import primevc.gui.states.EffectStates;
 import primevc.types.Number;


/**
 * Effect that will scale and move the target around the specified anchor-point.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class AnchorScaleEffect extends Effect < IDisplayObject, AnchorScaleEffect >
{
	/**
	 * Explicit ScaleX and ScaleY start-value
	 */
	public var startValue			: Float;
	/**
	 * ScaleX and ScaleY end-value
	 */
	public var endValue				: Float;

	/**
	 * Defines the position of the anchor point.
	 * Default is TopLeftCorner
	 */
	public var zoomPosition			: Position;
	
	
	public function new (duration:Int = 350, delay:Int = 0, easing:Easing = null, position:Position = null, startV:Float = Number.INT_NOT_SET, endV:Float = Number.INT_NOT_SET)
	{
		super(duration, delay, easing);
		zoomPosition	= position != null				? position				: TopLeft;
		startValue		= startV == Number.INT_NOT_SET	? Number.FLOAT_NOT_SET	: startV;
		endValue		= endV == Number.INT_NOT_SET	? Number.FLOAT_NOT_SET	: endV;
	}
	
	
	override public function clone ()
	{
		return cast new AnchorScaleEffect(duration, delay, easing, zoomPosition, startValue, endValue);
	}
	
	
	override public function createEffectInstance (target)
	{
		return cast new AnchorScaleEffectInstance(target, this);
	}
	
	
	override public function dispose ()
	{
		zoomPosition	= null;
		super.dispose();
	}
	
	
	override public function setValues (v:EffectProperties) {}
}