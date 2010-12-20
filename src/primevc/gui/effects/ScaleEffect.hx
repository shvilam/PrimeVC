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
 import primevc.gui.effects.effectInstances.ScaleEffectInstance;
#end
 import primevc.gui.traits.IScaleable;
#if neko
 import primevc.tools.generator.ICodeGenerator;
  using primevc.types.Reference;
#end
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
	 * Explicit end value of the scaleX property.
	 * @default		Number.FLOAT_NOT_SET
	 */
	public var endX		: Float;
	/**
	 * Explicit end value of the scaleY property.
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
		return cast new ScaleEffect( duration, duration, easing, startX, startY, endX, endY );
	}
	
	
#if (flash8 || flash9 || js)
	override public function createEffectInstance (target)
	{
		return cast new ScaleEffectInstance( target, this );
	}
#end


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
	
	
#if neko
	override public function toCSS (prefix:String = "") : String
	{
		var props = [];
		
		if (duration.isSet())		props.push( duration + "ms" );
		if (delay.isSet())			props.push( delay + "ms" );
		if (easing != null)			props.push( easing.toCSS() );
		if (startX.isSet())			props.push( (startX * 100) + "%" );
		if (startY.isSet())			props.push( (startY * 100) + "%" );
		if (endX.isSet())			props.push( (endX * 100) + "px" );
		if (endY.isSet())			props.push( (endY * 100) + "px" );
		
		
		return "scale " + props.join(" ");
	}
	
	
	override public function toCode (code:ICodeGenerator) : Void
	{
		if (!isEmpty())
			code.construct( this, [ duration, delay, easing, startX, startY, endX, endY ] );
	}
#end
}