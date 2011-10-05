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
 import primevc.core.geom.Rectangle;
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
	
	public function isObjectOn			(otherObj:IDisplayObject)					: Bool;
#if !neko
	public function getDisplayCursor	()											: DisplayDataCursor;
	
	/**
	 * Method will attach this IDisplayObject to the given Sprite.
	 * @return own-instance
	 */
	public function attachDisplayTo		(target:IDisplayContainer, pos:Int = -1)	: IDisplayObject;
	
	/**
	 * Method will detach this IDisplayObject from it's parent sprite.
	 * @return own-instance
	 */
	public function detachDisplay		()											: IDisplayObject;
	
	public function changeDisplayDepth	(newDepth:Int)								: IDisplayObject;
#end
	
#if flash9
	public var alpha				: Float;
	public var visible				: Bool;
	
	public var mouseX				(default, never)		: Float;
	public var mouseY				(default, never)		: Float;
	
	public var filters				: Array < Dynamic >;
	public var name					: String;
	public var scrollRect			: flash.geom.Rectangle;
	public var parent 				(default, null) 		: flash.display.DisplayObjectContainer;
	
	public function globalToLocal 	(point : Point) 					: Point;
	public function localToGlobal 	(point : Point) 					: Point;
	public function getBounds 	  	(other:DisplayObject)				: Rectangle;
#else
	public var parent 				: IDisplayContainer;
	public var visible				(getVisibility, setVisibility)		: Bool;
	public var alpha				(getAlpha,		setAlpha)			: Float;
	public function getBounds 		(other:IDisplayObject)				: Rectangle;
#end
}