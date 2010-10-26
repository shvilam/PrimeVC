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
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.core.geom.space.Position;
 import primevc.core.geom.IntPoint;
 import primevc.gui.display.IDisplayObject;	
#if (flash8 || flash9 || js)
 import primevc.gui.effects.effectInstances.AnchorScaleEffectInstance;
#end
 import primevc.gui.states.EffectStates;
 import primevc.types.Number;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
  using primevc.utils.NumberUtil;


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
		zoomPosition	= position != null				? position				: Position.TopLeft;
		startValue		= startV == Number.INT_NOT_SET	? Number.FLOAT_NOT_SET	: startV;
		endValue		= endV == Number.INT_NOT_SET	? Number.FLOAT_NOT_SET	: endV;
	}
	
	
	override public function clone ()
	{
		return cast new AnchorScaleEffect(duration, delay, easing, zoomPosition, startValue, endValue);
	}
	
	
#if (flash8 || flash9 || js)
	override public function createEffectInstance (target)
	{
		return cast new AnchorScaleEffectInstance(target, this);
	}
#end
	
	
	override public function dispose ()
	{
		zoomPosition = null;
		super.dispose();
	}
	
	
	override public function setValues (v:EffectProperties) {}
	
	
#if (debug || neko)
	private function posToCSS () : String
	{
		return switch (zoomPosition) {
			case Position.BottomCenter:		"bottom-center";
			case Position.BottomLeft:		"bottom-left";
			case Position.BottomRight:		"bottom-right";
			case Position.MiddleLeft:		"middle-left";
			case Position.MiddleCenter:		"middle-center";
			case Position.MiddleRight:		"middle-right";
			case Position.TopLeft:			"top-left";
			case Position.TopCenter:		"top-center";
			case Position.TopRight:			"top-right";
			default:						null;
		}
	}
	
	
	override public function toCSS (prefix:String = "") : String
	{
		var props = [];
		
		if (duration.isSet())		props.push( duration + "ms" );
		if (delay.isSet())			props.push( delay + "ms" );
		if (easing != null)			props.push( easingToCSS() );
		if (zoomPosition != null)	props.push( posToCSS() );
		if (startValue.isSet())		props.push( (startValue * 100) + "%" );
		if (endValue.isSet())		props.push( (endValue * 100) + "%" );
		
		
		return "anchor-scale " + props.join(" ");
	}
#end

#if neko
	override public function toCode (code:ICodeGenerator) : Void
	{
		if (!isEmpty())
			code.construct( this, [ duration, delay, easingToCode(), zoomPosition, startValue, endValue ] );
	}
#end
}