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
package primevc.gui.graphics.fills;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.core.geom.IRectangle;
 import primevc.core.geom.Matrix2D;
 import primevc.gui.graphics.GraphicElement;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.gui.traits.IDrawable;
 import primevc.types.Bitmap;
  using primevc.utils.Bind;


/**
 * Bitmap fill
 * 
 * @author Ruben Weijers
 * @creation-date Jul 30, 2010
 */
class BitmapFill extends GraphicElement, implements IFill 
{
	public var bitmap		(default, setBitmap)	: Bitmap;
	public var matrix		(default, setMatrix)	: Matrix2D;
	public var smooth		(default, setSmooth)	: Bool;
	public var repeat		(default, setRepeat)	: Bool;
	public var isFinished	(default, null)			: Bool;
	
	
	public function new (bitmap:Bitmap, matrix:Matrix2D = null, repeat:Bool = true, smooth:Bool = false)
	{
		super();
		this.bitmap = bitmap;
		this.matrix	= matrix; //matrix == null ? new Matrix2D() : matrix;
		this.repeat = repeat;
		this.smooth	= smooth;
		isFinished	= false;
	}
	
	
	override public function dispose ()
	{
		if (bitmap != null) {
			bitmap.dispose();
		//	untyped bitmap = null;
		}
		if (matrix != null)
			untyped matrix = null;
		
		super.dispose();
	}
	
	
	
	//
	// GETTERS / SETTERES
	//
	
	private inline function setBitmap (v:Bitmap)
	{
		if (v != bitmap) {
			if (bitmap != null)
				bitmap.state.change.unbind(this);
			
			bitmap = v;
			
			if (bitmap != null) {
				if (bitmap.state.is(BitmapStates.ready))
					invalidate( GraphicFlags.FILL );
				
				handleBitmapStateChange.on( bitmap.state.change, this );
			}
		}
		return v;
	}


	private inline function setMatrix (v:Matrix2D)
	{
		if (v != matrix) {
			matrix = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}


	private inline function setSmooth (v:Bool)
	{
		if (v != smooth) {
			smooth = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}


	private inline function setRepeat (v:Bool)
	{
		if (v != repeat) {
			repeat = v;
			invalidate( GraphicFlags.FILL );
		}
		return v;
	}
	
	
	//
	// EVENT HANDLERS
	//
	
	private inline function handleBitmapStateChange (newState:BitmapStates, oldState:BitmapStates)
	{
		switch (newState) {
			case BitmapStates.ready:	invalidate( GraphicFlags.FILL );
			case BitmapStates.empty:	invalidate( GraphicFlags.FILL );
		}
	}
	
	
	
	//
	// IFILL METHODS
	//
	
	public inline function begin (target:IDrawable, ?bounds:IRectangle)
	{	
		isFinished = true;
		if (bitmap == null)
			return;
		
		if (bitmap.state.is(BitmapStates.ready))
		{
#if flash9
			var m:Matrix2D = null;
			if (repeat == false) {
				m = new Matrix2D();
				matrix.scale( bounds.width / bitmap.data.width, bounds.height / bitmap.data.height );
			}
			target.graphics.beginBitmapFill( bitmap.data, m, repeat, smooth );
#end
		}
		else if (bitmap.state.is(BitmapStates.loadable))
			bitmap.load();
	}
	
	
	public inline function end (target:IDrawable)
	{	
		isFinished = false;
		if (bitmap != null && bitmap.state.is(BitmapStates.ready))
		{
#if flash9
			target.graphics.endFill();
#end
		}
	}
	
	
#if (debug || neko)
	override public function toString ()
	{
		return "BitmapFill( " + bitmap + ", " + smooth + ", " + repeat + " )";
	}
	
	
	override public function toCSS (prefix:String = "")
	{
		return bitmap.toString + " " + repeat;
	}
#end
#if neko
	override public function toCode (code:ICodeGenerator)
	{
		code.construct( this, [ bitmap, matrix, repeat, smooth ] );
	}
#end
}