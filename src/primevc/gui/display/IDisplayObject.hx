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
package primevc.gui.display;
 import primevc.core.IDisposable;
 import primevc.core.geom.Matrix2D;
 import primevc.core.geom.Point;
 import primevc.gui.events.DisplayEvents;
 

/**
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
interface IDisplayObject implements IDisposable
{
	var displayEvents	(default, null)			: DisplayEvents;
	var window			(default, setWindow)	: Window;
	var displayList		(default, default)		: DisplayList;
	
#if flash9
	var filters					: Array < Dynamic >;
	var name					: String;
//	var parent(default,null)	: flash.display.DisplayObjectContainer;
//	var stage (default,null)	: flash.display.Stage;
	var scrollRect				: flash.geom.Rectangle;
	var transform				: flash.geom.Transform; //Matrix2D;
	
	var alpha					: Float;
	var visible					: Bool;
	
	var height					: Float;
	var width					: Float;
	var x						: Float;
	var y						: Float;
	var rotation				: Float;
	
	var scaleX					: Float;
	var scaleY					: Float;
	
	var mouseX (default,null)	: Float;
	var mouseY (default, null)	: Float;
	
	function globalToLocal (point : Point) : Point;
	function localToGlobal (point : Point) : Point;
	
	#if flash10
	var rotationX				: Float;
	var rotationY				: Float;
	var rotationZ				: Float;
	var scaleZ					: Float;
	var z						: Float;
	#end
	
#else
//	var parent		(default, null)						: ISprite;
	var visible		(getVisibility, setVisibility)		: Bool;
	var transform	(default, null)						: Matrix2D;
	
	var alpha		(getAlpha,		setAlpha)			: Float;
	var x			(getX,			setX)				: Float;
	var y			(getY,			setY)				: Float;
	var width		(getWidth,		setWidth)			: Float;
	var height		(getHeight,		setHeight)			: Float;
#end
}