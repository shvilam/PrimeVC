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
 import primevc.core.IDisposable;
 import primevc.gui.core.IUIElement;
  using primevc.utils.NumberUtil;
  using Std;


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
		if (target.effects == null || target.effects.show == null)
			target.visible = true;
		else
			target.effects.playShow();
	}
	
	
	public static inline function doHide (target:IUIElement)
	{
		if (target.effects == null || target.effects.hide == null)
			target.visible = false;
		else
			target.effects.playHide();
	}
	
	
	public static inline function doMove (target:IUIElement, newX:Float, newY:Float)
	{
		if (newX.isSet())	target.layout.x = newX.int();
		if (newY.isSet())	target.layout.y = newY.int();
	}
	
	
	public static inline function doRotate (target:IUIElement, v:Float)
	{
		if (target.effects == null || target.effects.rotate == null)
			target.rotation = v;
		else
			target.effects.playRotate(v);
	}
	
	
	public static inline function doResize (target:IUIElement, newW:Float, newH:Float)
	{
		if (newW.isSet())	target.layout.width		= newW.int();
		if (newH.isSet())	target.layout.height	= newH.int();
	}
	
	
	public static inline function doScale (target:IUIElement, newScaleX:Float, newScaleY:Float)
	{
		if (target.effects == null || target.effects.scale == null) {
			target.scaleX = newScaleX;
			target.scaleY = newScaleY;
		} else {
			target.effects.playScale(newScaleX, newScaleY);
		}
	}
}