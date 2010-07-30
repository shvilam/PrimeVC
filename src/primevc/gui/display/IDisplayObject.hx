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
 import primevc.core.geom.Matrix2D;
 import primevc.core.geom.Point;
 import primevc.gui.display.Window;
 import primevc.gui.traits.IDisplayable;
 

/**
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
interface IDisplayObject implements IDisplayable
{
	/**
	 * Reference to the object in which this displayobject is placed. It 
	 * behaves like the 'parent' property in as3.
	 */
	var container		(default, setContainer)			: IDisplayContainer;

	/**
	 * Wrapper object for the stage.
	 */
	var window			(default, setWindow)			: Window;
	
	function isObjectOn (otherObj:IDisplayObject)	: Bool;
	
	
#if flash9
	var filters					: Array < Dynamic >;
	var name					: String;
	var scrollRect				: flash.geom.Rectangle;
	var transform				: flash.geom.Transform; //Matrix2D;
	
	function globalToLocal (point : Point) : Point;
	function localToGlobal (point : Point) : Point;
#else
	var transform	(default, null)						: Matrix2D;
#end
}