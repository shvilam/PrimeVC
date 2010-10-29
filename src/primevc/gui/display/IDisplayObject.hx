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
 import primevc.core.geom.Point;
 import primevc.gui.traits.IDisplayable;
 import primevc.gui.traits.IPositionable;
 import primevc.gui.traits.IScaleable;
 import primevc.gui.traits.ISizeable;


/**
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
interface IDisplayObject 
				implements IDisplayable
			,	implements IPositionable
			,	implements IScaleable
			,	implements ISizeable
#if flash9  ,	implements flash.display.IBitmapDrawable #end
{
	
	function isObjectOn (otherObj:IDisplayObject)	: Bool;
	function getDisplayCursor ()					: DisplayDataCursor;
	
#if flash9
	var alpha					: Float;
	var visible					: Bool;
	
	var filters					: Array < Dynamic >;
	var name					: String;
	var scrollRect				: flash.geom.Rectangle;
	var transform				: flash.geom.Transform; //Matrix2D;
	
	function globalToLocal (point : Point) : Point;
	function localToGlobal (point : Point) : Point;
#else
	var visible		(getVisibility, setVisibility)		: Bool;
	var alpha		(getAlpha,		setAlpha)			: Float;
	var transform	(default, null)						: primevc.core.geom.Matrix2D;
#end
}