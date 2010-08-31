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
 import primevc.core.geom.space.MoveDirection;
 import primevc.core.geom.Rectangle;
 import primevc.gui.display.IDisplayObject;
 import primevc.types.Number;
  using primevc.utils.FloatUtil;
  using primevc.utils.TypeUtil;


/**
 * A wipe effect animates the wiping of a target's scrollrect. If the target 
 * doesn't have a scrollrect, one will be created.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class WipeEffect extends Effect < IDisplayObject, WipeEffect >
{
	/**
	 * Move direction of the wipe effect.
	 * @default		MoveDirection.LeftToRight
	 */
	public var direction			: MoveDirection;
	public var startValue			: Float;
	public var endValue				: Float;
	
	
	public function new (target, duration:Int = 350, delay:Int = 0, easing:Easing = null, direction:MoveDirection = null)
	{
		super(target, duration, delay, easing);
		this.direction	= direction == null ? LeftToRight : direction;
		startValue		= Number.FLOAT_NOT_SET;
		endValue		= Number.FLOAT_NOT_SET;
	}
	
	
	override public function clone ()
	{
		return new WipeEffect( target, duration, delay, easing, direction );
	}


#if flash9
	override public function play ( ?withEffect:Bool = true, ?directly:Bool = false ) : Void
	{
	//	hideFilters();
		var t = target;
		if (t.scrollRect == null)
			t.scrollRect = new Rectangle( 0, 0, t.width, t.height );

		if (endValue.notSet())
			endValue = 0;

		if (startValue.notSet() || startValue == endValue) {
			startValue = switch (direction) {
				case TopToBottom:	 t.scrollRect.height;
				case BottomToTop:	-t.scrollRect.height;
				case LeftToRight:	 t.scrollRect.width;
				case RightToLeft:	-t.scrollRect.width;
			}
		}

		super.play( withEffect, directly );
	}


	override private function tweenUpdater ( tweenPos:Float )
	{
		var rect			= target.scrollRect;
		var newVal:Float	= ( endValue * tweenPos ) + ( startValue * (1 - tweenPos) );

		switch (direction) {
			case TopToBottom, BottomToTop:	rect.y = newVal;
			case LeftToRight, RightToLeft:	rect.x = newVal;
		}

		target.scrollRect = rect;
	}


	override private function calculateTweenStartPos () : Float
	{
		var curValue:Float = switch (direction) {
			case TopToBottom, BottomToTop:	target.scrollRect.y;
			case LeftToRight, RightToLeft:	target.scrollRect.x;
		}

		return (curValue - startValue) / (endValue - startValue);
	}	
#end
}