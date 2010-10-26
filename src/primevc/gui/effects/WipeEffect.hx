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
 import primevc.gui.display.IDisplayObject;	
#if (flash8 || flash9 || js)
 import primevc.gui.effects.effectInstances.WipeEffectInstance;
#end
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.types.Number;
  using primevc.utils.NumberUtil;


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
	
	/**
	 * Explicit startValue of the object
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var startValue			: Float;
	/**
	 * Explicit endValue of the object
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var endValue				: Float;
	
	
	public function new (duration:Int = 350, delay:Int = 0, easing:Easing = null, direction:MoveDirection = null, startValue:Float = Number.INT_NOT_SET, endValue:Float = Number.INT_NOT_SET)
	{
		super(duration, delay, easing);
		this.direction	= direction == null					? LeftToRight			: direction;
		this.startValue	= startValue == Number.INT_NOT_SET	? Number.FLOAT_NOT_SET	: startValue;
		this.endValue	= endValue == Number.INT_NOT_SET	? Number.FLOAT_NOT_SET	: endValue;
	}
	
	
	override public function setValues (v:EffectProperties) {}
	override public function clone ()						{ return cast new WipeEffect( duration, delay, easing, direction, startValue, endValue ); }
#if (flash8 || flash9 || js)
	override public function createEffectInstance (target)	{ return cast new WipeEffectInstance(target, this); }
#end
	
	
#if (debug || neko)
	override public function toCSS (prefix:String = "") : String
	{
		var props = [];
		
		if (duration.isSet())		props.push( duration + "ms" );
		if (delay.isSet())			props.push( delay + "ms" );
		if (easing != null)			props.push( easingToCSS() );
		if (direction != null)		props.push( directionToCSS() );
		if (startValue.isSet())		props.push( startValue + "px" );
		if (endValue.isSet())		props.push( endValue + "px" );
		
		return "wipe " + props.join(" ");
	}
	
	
	private function directionToCSS () : String 
	{
		return switch (direction) {
			case MoveDirection.LeftToRight:		"left-to-right";
			case MoveDirection.RightToLeft:		"right-to-left";
			case MoveDirection.TopToBottom:		"top-to-bottom";
			case MoveDirection.BottomToTop:		"bottom-to-top";
			default:							null;
		}
	}
#end

#if neko
	override public function toCode (code:ICodeGenerator) : Void
	{
		if (!isEmpty())
			code.construct( this, [ duration, delay, easingToCode(), direction, startValue, endValue ] );
	}
#end
}