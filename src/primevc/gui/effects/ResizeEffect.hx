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
#if (flash8 || flash9 || js)
 import primevc.gui.effects.effectInstances.ResizeEffectInstance;
#end
 import primevc.gui.traits.ISizeable;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
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
	
	
	public function new (duration:Int = 350, delay:Int = 0, easing:Easing = null, startW:Float = Number.INT_NOT_SET, startH:Float = Number.INT_NOT_SET, endW:Float = Number.INT_NOT_SET, endH:Float = Number.INT_NOT_SET)
	{
		super(duration, delay, easing);
		
		this.startW	= startW == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : startW;
		this.startH	= startH == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : startH;
		this.endW	= endW == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : endW;
		this.endH	= endH == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : endH;
	}
	
	
	override public function clone ()
	{
		return cast new ResizeEffect( duration, duration, easing, startW, startH, endW, endH );
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
	
	
#if (flash8 || flash9 || js)
	override public function createEffectInstance (target)
	{
		return cast new ResizeEffectInstance(target, this);
	}
#end
	
	
#if (debug || neko)
	override public function toCSS (prefix:String = "") : String
	{
		var props = [];
		
		if (duration.isSet())		props.push( duration + "ms" );
		if (delay.isSet())			props.push( delay + "ms" );
		if (easing != null)			props.push( easingToCSS() );
		if (startW.isSet())			props.push( startW + "px, " + startH + "px" );
		if (endW.isSet())			props.push( endW + "px, " + endH + "px" );
		
		return "resize " + props.join(" ");
	}
#end

#if neko
	override public function toCode (code:ICodeGenerator) : Void
	{
		if (!isEmpty())
			code.construct( this, [ duration, delay, easingToCode(), startW, startH, endW, endH ] );
	}
#end
}