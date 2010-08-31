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
  using primevc.utils.FloatUtil;


/**
 * Animate effect for resizing the width and/or height of the given target.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class ResizeEffect extends Effect < ISizeable, ResizeEffect >
{
	public var startW	: Float;
	public var startH	: Float;
	public var endW		: Float;
	public var endH		: Float;
	
	
	override public function clone ()
	{
		var n = new ResizeEffect( target, duration, duration, easing );
		n.endW = endW;
		n.endH = endH;
		return n;
	}
	

	override private function tweenUpdater ( tweenPos:Float )
	{
		if (endW.isSet())	target.width	= ( endW * tweenPos ) + ( startW * (1 - tweenPos) );
		if (endH.isSet())	target.height	= ( endH * tweenPos ) + ( startH * (1 - tweenPos) );
	}
	
	
	override private function calculateTweenStartPos () : Float
	{
		if		(endW.notSet() && endH.notSet())	return 1;
		else if (endH.notSet())						return (target.width  - startW) / (endW - startW);
		else if (endW.notSet())						return (target.height - startH) / (endH - startH);
		else										return Math.min(
			(target.width  - startW) / (endW - startW),
			(target.height - startH) / (endH - startH)
		);
	}
	
	
	override private function setTarget ( v )
	{
		if (v == null)
		{
			startW = startH = endW = endH = Number.FLOAT_NOT_SET;
		}
		else if (v != target)
		{
			startW	= target.width;
			startH	= target.height;
			endW	= Number.FLOAT_NOT_SET;
			endH	= Number.FLOAT_NOT_SET;
		}
		return super.setTarget( v );
	}
}