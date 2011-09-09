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
package primevc.gui.utils;
 import primevc.core.traits.IDisposable;
 import primevc.gui.core.IUIElement;
 import primevc.types.Number;
  using primevc.utils.IfUtil;
  using primevc.utils.NumberUtil;


private typedef Flags = primevc.gui.effects.EffectFlags;


/**
 * Utility to remove redundant code from IUIElements. The methods below will
 * perform the requested actions and will play an effect on the IUIelement if
 * one is defined.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 01, 2010
 */
class UIElementActions
{
	//
	// ACTION METHODS
	//
	
	public static inline function doShow (target:IUIElement)
	{
		// Check if the show-effect is defined and should be played.
		//
		// Don't check for target.window.. if the container is added to the stage later and
		// a hide-effect has hidden the target, making it visible isn't enough, also the result 
		// of the hide-effect should be reversed (alpha = 0, scrollrect position negative etc.).
		trace(target+"; playEff? "+(target.container == null || target.effects == null || target.effects.show == null)+"; visible? "+target.visible+"; alpha? "+target.alpha);
		if (shouldPlay(Flags.SHOW, target)) 	target.effects.playShow();
		else									target.visible = true;
	}
	
	
	public static inline function doHide (target:IUIElement)
	{
		if (shouldPlay(Flags.HIDE, target))		target.effects.playHide();
		else 									target.visible = false;
	}
	
	
	public static inline function doMove (target:IUIElement, newX:Float = Number.INT_NOT_SET, newY:Float = Number.INT_NOT_SET) 	// using Number.FLOAT_NOT_SET is not allowed since Float.NaN is not a constant value
	{
		if (newX.isSet() && newX != Number.INT_NOT_SET)		target.layout.x = newX.roundFloat();
		if (newY.isSet() && newY != Number.INT_NOT_SET)		target.layout.y = newY.roundFloat();
	}
	
	
	public static inline function doRotate (target:IUIElement, v:Float)
	{
		if (shouldPlay(Flags.ROTATE, target)) 	target.effects.playRotate(v);
		else 									target.rotation = v;
			
	}
	
	
	public static inline function doResize (target:IUIElement, newW:Float = Number.INT_NOT_SET, newH:Float = Number.INT_NOT_SET)
	{
		if (newW.isSet() && newW != Number.INT_NOT_SET)		target.layout.width		= newW.roundFloat();
		if (newH.isSet() && newH != Number.INT_NOT_SET)		target.layout.height	= newH.roundFloat();
	}
	
	
	public static inline function doScale (target:IUIElement, newScaleX:Float, newScaleY:Float)
	{
		if (shouldPlay(Flags.SCALE, target)) {
			target.effects.playScale(newScaleX, newScaleY);
		} else {
			target.scaleX = newScaleX;
			target.scaleY = newScaleY;
		}
	}


	public static inline function shouldPlay(effect:Int, target:IUIElement) : Bool
	{
		var e = target.effects;
		return target.container.notNull() && e.notNull() && e.has(effect);
	}
}