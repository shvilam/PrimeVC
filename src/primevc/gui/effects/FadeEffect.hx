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
 import primevc.gui.display.IDisplayObject;


/**
 * Effect to fade a DisplayObject from one alpha value to another.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class FadeEffect extends Effect < IDisplayObject, FadeEffect >
{
	private var startValue	: Float;
	private var endValue	: Float;
	
	
	public function new( target, duration:Int = 350, delay:Int = 0, easing:Easing = null, startValue:Float = 0, endValue:Float = 1 )
	{
		super( target, duration, delay, easing );
		hideFiltersDuringEffect	= false;
		this.startValue			= startValue;
		this.endValue			= endValue;
	}
	
	
	override public function clone ()
	{
		return new FadeEffect( target, duration, duration, easing, startValue, endValue );
	}
	
	
	/**
	 * Method which will perform the transformation from visible to hidden.
	 * Needs to be overwritten by SubClasses
	 */
	override private function tweenUpdater ( tweenPos:Float )
	{
		target.alpha = ( endValue * tweenPos ) + ( startValue * ( 1 - tweenPos ) );
	}
	
	
	override private function calculateTweenStartPos () : Float
	{
		return (target.alpha - startValue) / (endValue - startValue);
	}
}