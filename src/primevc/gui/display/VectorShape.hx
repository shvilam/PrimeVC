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
 

typedef VectorShape = 
	#if		flash9	primevc.avm2.display.VectorShape;
	#elseif	flash8	primevc.avm1.display.VectorShape;
	//#elseif	js		primevc.js  .display.VectorShape;
	#else			VectorShapeImpl



 import primevc.core.geom.Matrix2D;
 import primevc.gui.events.DisplayEvents;


/**
 * Default mock implementation for Shape
 * 
 * @creation-date	Jun 14, 2010
 * @author			Ruben Weijers
 */
class VectorShapeImpl implements IDisplayObject
{
//	public var displayList		(default, default)				: DisplayList;
	public var displayEvents	(default, null)					: DisplayEvents;
	public var container		(default, setContainer)			: IDisplayContainer;
	public var window			(default, setWindow)			: Window;
	
	public var transform		(default,null)					: Matrix2D;
	public var maxWidth			(getMaxWidth,never)				: Float;
	public var visible			(getVisibility, setVisibility)	: Bool;
	
	public var alpha			(default, setAlpha)				: Float;
	public var x				(default, default)				: Float;
	public var y				(default, default)				: Float;
	public var width			(default, default)				: Float;
	public var height			(default, default)				: Float;
	
	private inline function setAlpha(a:Float)		{ return alpha = a; }
	
	
	public function new() {
		events = new DisplayEvents( this );
	}
	
	public function render () {}
	
	private inline function getVisibility()			{ return _visible; }
	private inline function setVisibility(v:Bool)	{ return _visible = v; }
	
	public function resizeScrollRect (newWidth:Float, newHeight:Float) {}
	public function moveScrollRect (?newX:Float = 0, ?newY:Float = 0) {}
	
	
	public function dispose() : Void
	{
		displayEvents.dispose();
		displayEvents	= null;
		displayList		= null;
		window			= null;
	}
	
	
#if !neko
	public function getDisplayCursor () : DisplayDataCursor
	{
		return new DisplayDataCursor(this);
	}
#end
	
	
	private var _visible:Bool;
	private inline function getMaxWidth() { return 1024; }
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setContainer (v) {
		container	= v;
		window		= container.window;
		return v;
	}
	
	private inline function setWindow (v) {
		return window = v;
	}
}

#end