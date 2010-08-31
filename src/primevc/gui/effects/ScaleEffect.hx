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
  using primevc.utils.FloatUtil;


/**
 * Animation class for changing the scaleX and/or scaleY of the target.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class ScaleEffect extends Effect < IScaleable, ScaleEffect >
{
	public var startX	: Float;
	public var startY	: Float;
	public var endX		: Float;
	public var endY		: Float;
	
	
	override public function clone ()
	{
		var n = new ScaleEffect( target, duration, duration, easing );
		n.endX = endX;
		n.endY = endY;
		return n;
	}

	override private function tweenUpdater ( tweenPos:Float )
	{
#if flash9
		if (endX.isSet())	target.scaleX = ( endX * tweenPos ) + ( startX * (1 - tweenPos) );
		if (endY.isSet())	target.scaleY = ( endY * tweenPos ) + ( startY * (1 - tweenPos) );
#end
	}


	override private function calculateTweenStartPos () : Float
	{
#if flash9
		if		(endX.notSet() && endY.notSet())	return 1;
		else if (endY.notSet())						return (target.scaleX - startX) / (endX - startX);
		else if (endX.notSet())						return (target.scaleY - startY) / (endY - startY);
		else										return Math.min(
			(target.scaleX - startX) / (endX - startX),
			(target.scaleY - startY) / (endY - startY)
		);
#else
		return 1;
#end
	}


#if flash9
	override private function setTarget ( v )
	{
		if (v == null)
		{
			startX = startY = endX = endY = Number.FLOAT_NOT_SET;
		}
		else if (v != target)
		{
			startX	= target.scaleX;
			startY	= target.scaleY;
			endX	= Number.FLOAT_NOT_SET;
			endY	= Number.FLOAT_NOT_SET;
		}
		return super.setTarget( v );
	}
#end
}