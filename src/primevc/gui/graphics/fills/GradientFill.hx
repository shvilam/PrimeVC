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
 import primevc.core.geom.IRectangle;
 import primevc.core.geom.Matrix2D;
 import primevc.gui.graphics.GraphicElement;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.utils.FastArray;
  using primevc.utils.FastArray;
  using primevc.utils.RectangleUtil;
  using primevc.utils.Formulas;


enum GradientType {
	linear;
	radial;
}


enum SpreadMethod {
	normal;
	reflect;
	repeat;
}



/**
 * Gradient fill.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 30, 2010
 */
class GradientFill implements IFill 
{
	public var fills			(default, null)			: FastArray <GradientStop>;
	public var type				(default, setType)		: GradientType;
	public var spread			(default, setSpread		: SpreadMethod;
	public var focalPointRatio	(default, setFocalP)	: Float;
	
	/**
	 * gradient rotation in degrees
	 */
	public var rotation			(default, setRotation)	: Int;
	
	private var lastBounds		: IRectangle;
	private var lastMatrix		: Matrix2D;
	
	
	public function new (type:GradientType = lineair, spread:SpreadMethod = normal, focalPointRatio:Float = 0)
	{
		super();
		this.type				= type;
		this.spread				= spread;
		this.focalPointRatio	= focalPointRatio;
		fills					= FastArrayUtil.create();
	}
	
	
	override public function dispose ()
	{
		for (fill in fills)
			fill.dispose();
		
		fills		= null;
		lastBounds	= null;
		lastMatrix	= null;
		
		super.dispose();
	}
	
	
	
	//
	// SETTERS
	//
	
	private inline function setRotation ( v:Int )
	{
		if (v != rotation) {
			matrix		= null;
			rotation	= v;
			invalidate( GraphicFlags.FILL_CHANGED );
		}
		return v;
	}
	
	
	private inline function setType (v:GradientType)
	{
		if (v != type) {
			type = v;
			invalidate( GraphicFlags.FILL_CHANGED );
		}
		return v;
	}


	private inline function setSpread (v:SpreadMethod)
	{
		if (v != spread) {
			spread = v;
			invalidate( GraphicFlags.FILL_CHANGED );
		}
		return v;
	}


	private inline function setFocalP (v:Float)
	{
		if (v != focalPointRatio) {
			focalPointRatio = v;
			invalidate( GraphicFlags.FILL_CHANGED );
		}
		return v;
	}
	
	
	
	
	//
	// FILL METHODS
	//
	
	public inline function begin (target, ?bounds:IRectangle)
	{
		Assert.that( fills.length >= 2, "There should be at least be two fills in an gradient.");
			
#if flash9
		if (lastMatrix == null || bounds != lastBounds || !bounds.isEqualTo(lastBounds))
			lastMatrix = createMatrix();
		
		//TODO: MORE EFFICIENT TO CACHE THIS? MEMORY vs. SPEED
		var colors	= new Array();
		var alphas	= new Array();
		var ratios	= new Array();
		
		for (fill in fills) {
			colors.push( fill.color.rgb() );
			alphas.push( fill.color.alpha() );
			ratios.push( fill.position );
		}
		
		target.graphics.beginGradientFill( getFlashType(), colors, alphas, ratios, lastMatrix, getSpreadMethod(), "rgb",  );
#end
	}
	
	
	public inline function end (target)
	{
#if flash9
		target.graphics.endFill();
#end
	}
	
	
	public inline function createMatrix (bounds:IRectangle) : Matrix2D
	{
		var m = new Matrix2D();
		m.createGradientBox( bounds.width, bounds.height, rotation.degreesToRadians() );
		lastBounds = bounds.clone();
		return m;
	}
	
	
	public inline function getFlashType () {
		return type == lineair ? flash.display.GradientType.LINEAR : flash.display.GradientType.RADIAL;
	}
	
	public inline function getSpreadMethod () {
		return switch (spread) {
			case normal:	flash.display.SpreadMethod.PAD;
			case reflect:	flash.display.SpreadMethod.REFLECT;
			case repeat:	flash.display.SpreadMethod.REPEAT;
		}
	}
	
	
	
	//
	// LIST METHODS
	//
	
	public inline function add ( fill:GradientStop, depth:Int = -1 )
	{
		fills.insertAt( fill, depth );
		fill.parent = this;
		invalidate( GraphicFlags.FILL_CHANGED );
	}
	
	
	public inline function remove ( fill:GradientStop )
	{
		fills.remove(fill);
		fill.dispose();
		invalidate( GraphicFlags.FILL_CHANGED );
	}
}