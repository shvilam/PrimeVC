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
package primevc.gui.traits;
 import primevc.core.IDisposable;
#if (flash8 || flash9 || js)
 import primevc.core.geom.IntRectangle;
 import primevc.gui.display.IDisplayContainer;
 import primevc.gui.display.Window;
 import primevc.gui.events.DisplayEvents;
#end


/**
 * @author Ruben Weijers
 * @creation-date Jul 30, 2010
 */
interface IDisplayable implements IDisposable	
{
#if (flash8 || flash9 || js)
	var displayEvents	(default, null)					: DisplayEvents;
	
	/**
	 * Reference to the object in which this displayobject is placed. It 
	 * behaves like the 'parent' property in as3.
	 */
	public var container		(default, setContainer)		: IDisplayContainer;
	/**
	 * Wrapper object for the stage.
	 */
	public var window			(default, setWindow)		: Window;
	
	
	/**
	 * Rectangle which contains the current width and height of the object 
	 * (without any strokes on shapes), or the wanted width of the object.
	 * 
	 * For example, the resize effect will change the width in the "rect" 
	 * property to make sure the background shape will redraw itself.
	 * 
	 * For the moment, the size and position is only correct when it's set
	 * manually or by an effect. This due the lack of support for AS3 setters.
	 */
	public var rect				(default, null)				: IntRectangle;
#end
}