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
 import primevc.core.geom.Point;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.states.EffectStates;
 import primevc.types.Number;
  using primevc.utils.FloatUtil;
  using Std;


/**
 * Effect that will scale and move the target around the specified anchor-point.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 31, 2010
 */
class AnchorScaleEffect extends Effect < IDisplayObject, AnchorScaleEffect >
{
	/**
	 * Position from which the window will scale. Point is relative to current
	 * position, so 0, 0 will be on the current x&y of the object.
	 * 
	 * It's not possible to set this property directly. To set a custom 
	 * anchorPoint, use Position.custom( point ).
	 */
	private var anchorPoint			: Point;

	/**
	 * Variable to keep track of the starting scale size
	 */
	private var posBeforeTween		: Point;
	
	/**
	 * Defines the position of the anchor point.
	 * Default is TopLeftCorner
	 */
	public var zoomPosition			: Position;
	
	
	/**
	 * Auto or explicit scale value to begin the effect with.
	 */
	private var _startValue			: Float;
	/**
	 * Explicit ScaleX and ScaleY start-value
	 */
	public var startValue			: Float;
	/**
	 * ScaleX and ScaleY end-value
	 */
	public var endValue				: Float;
	
	
	public function new (target = null, duration:Int = 350, delay:Int = 0, easing:Easing = null, position:Position = null, ?endV:Float, ?startV:Float)
	{
		super(target, duration, delay, easing);
		anchorPoint		= new Point();
		zoomPosition	= position != null	? position				: TopLeft;
		startValue		= startV == null	? Number.FLOAT_NOT_SET	: startV;
		endValue		= endV == null		? Number.FLOAT_NOT_SET	: endV;
	}
	
	
	override public function clone ()
	{
		return new AnchorScaleEffect(target, duration, delay, easing, zoomPosition, endValue, startValue);
	}
	
	
	override public function dispose ()
	{
		anchorPoint		= null;
		zoomPosition	= null;
		super.dispose();
	}
	
	
	override public function setValues (v:EffectProperties) {}
	
	
#if flash9
	override public function play ( ?withEffect:Bool = true, ?directly:Bool = false ) : Void
	{
		var p = anchorPoint;
		var t = target;
		
		var curScale = target.scaleX;
		t.scaleX = t.scaleY = 1;
		
		switch (zoomPosition)
		{
			case TopLeft:		p.x = 0;				p.y = 0;
			case TopRight:		p.x = t.width;			p.y = 0;
			case TopCenter:		p.x = t.width * .5;		p.y = 0;
			
			case MiddleLeft:	p.x = 0;				p.y = t.height * .5;
			case MiddleCenter:	p.x = t.width * .5;		p.y = t.height * .5;
			case MiddleRight:	p.x = t.width;			p.y = t.height * .5;
			
			case BottomLeft:	p.x = 0;				p.y = t.height;
			case BottomRight:	p.x = t.width;			p.y = t.height;
			case BottomCenter:	p.x = t.width * .5;		p.y = t.height;
			
			case Custom( cp ):	p.x = cp.x;				p.y = cp.y;
			default:			p.x = 0;				p.y = 0;
		}
		trace("startValue: "+ startValue +", anchorPoint " + p.x + ", " + p.y+"; scale "+curScale);
		t.scaleX = t.scaleY = curScale;
		super.play( withEffect, directly );
	}
#end
	
	
	override private function initStartValues ()
	{
		if (state == EffectStates.initialized)
			posBeforeTween = new Point( target.x, target.y );
		
		if (startValue.isSet())	_startValue = startValue;
		else					_startValue = target.scaleX;
	}
	
	
	override private function tweenUpdater ( tweenPos:Float )
	{
#if flash9
		//change scale percentage
		var curScale	= (endValue * tweenPos ) + ( startValue * (1 - tweenPos));
		target.scaleX	= target.scaleY = curScale;
		
		//base scale on anchorPoint
		target.x	= posBeforeTween.x + anchorPoint.x - (curScale * anchorPoint.x);
		target.y	= posBeforeTween.y + anchorPoint.y - (curScale * anchorPoint.y);
#end
	}
	
	
	override private function calculateTweenStartPos () : Float
	{
#if flash9
		return (target.scaleX - startValue) / (endValue - startValue);
#else
		return 1;
#end
	}
	
/*	
	override private function setTarget (newTarget)
	{
		if (target == newTarget)
			return newTarget;
		
		if		(newTarget == null)		posBeforeTween = null;
		else if	(target != newTarget)	posBeforeTween = new Point( newTarget.x, newTarget.y );
		
		return super.setTarget(newTarget);
	}*/
}