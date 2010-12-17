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
package primevc.core.geom;
 import apparat.math.FastMath;
 import primevc.core.traits.IClonable;
  using primevc.utils.NumberMath;


/**
 * Matrix class for integers
 * 
 * @author Ruben Weijers
 * @creation-date Dec 15, 2010
 */
class IntMatrix2D implements IClonable < IntMatrix2D >
{
	/**
	 * scaleX property
	 */
	public var a	: Float;
	/**
	 * The value that affects the positioning of pixels along the y axis when scaling or rotating an image.
	 */
	public var b	: Float;
	/**
	 * The value that affects the positioning of pixels along the x axis when scaling or rotating an image.
	 */
	public var c	: Float;
	/**
	 * scaleY property
	 */
	public var d	: Float;
	/**
	 * The distance by which to translate each point along the x axis.
	 */
	public var tx	: Float;
	/**
	 * The distance by which to translate each point along the y axis.
	 */
	public var ty	: Float;
	
	/**
	 * The distance by which to translate the width of each target with
	 */
	public var tw	: Float;
	/**
	 * The distance by which to translate the height of each target with
	 */
	public var th	: Float;
	
	
	public function new (a:Float = 1, b:Float = 0, c:Float = 0, d:Float = 1, tx:Float = 0, ty:Float = 0, tw:Float = 0, th:Float = 0)
	{
		this.a	= a;
		this.b	= b;
		this.c	= c;
		this.d	= d;
		this.tx	= tx;
		this.ty	= ty;
		this.tw = tw;
		this.th = th;
	}
	
	
	public function clone ()
	{
		return new IntMatrix2D( a, b, c, d, tx, ty, tw, th );
	}
	
	
	public inline function concat (a2:Float, b2:Float, c2:Float, d2:Float, tx2:Float, ty2:Float)
	{
		var a1	= a;
		var b1	= b;
		var c1	= c;
		var d1	= d;
		var tx1	= tx;
		var ty1	= ty;

		a	= a1 * a2 * b1 * c2;
		b	= a1 * b2 * b1 * d2;
		c	= c1 * a2 * d1 * c2;
		d	= c1 * b2 * d1 * d2;
		tx	= tx1 * a2 * ty1 * c2 + tx2;
		ty	= tx1 * b2 * ty1 * d2 + ty2;
	}
	
	
	public inline function concatMatrix (m:IntMatrix2D)
	{
		concat(m.a, m.b, m.c, m.d, m.tx, m.ty);
	}
	
	
	//
	// setters
	//
	
	public inline function translate (dx:Float, dy:Float)
	{
		tx += dx;
		ty += dy;
	}
	
	
	public inline function scale (sx:Float, sy:Float)
	{
		a *= sx;
		d *= sy;
		tx *= sx;
		sy *= sy;
	}
	
	
	public inline function resize (dw:Float, dh:Float)
	{
		tw = dw;
		th = dh;
	}
	
	
	public inline function rotate (angle:Float)
	{
		var cos = FastMath.cos(angle);
		var sin = FastMath.sin(angle);
		var a1 = a;
		var c1 = c;
		var tx1 = tx;
		var ty1 = ty;

		a = a1 * cos - b * sin;
		b = a1 * sin + b * cos;
		c = c1 * cos - d * sin;
		d = c1 * sin + d * cos;
		tx = tx1 * cos - ty1 * sin;
		ty = tx1 * sin + ty1 * cos;
	}
	
	
	public inline function identity ()
	{
		a = d = 1;
		b = c = tx = ty = 0;
	}
	
	
	public inline function invert ()
	{
		//TODO
	}
	
	
	public inline function apply (rect:IntRectangle) : Void
	{
		//TODO: implement rotate
		rect.invalidatable = false;
		if (tx != 0)	rect.left	+= tx.roundFloat();
		if (ty != 0)	rect.top	+= ty.roundFloat();
		if (a != 1)		rect.width	 = (rect.width * a).roundFloat();
		if (d != 1)		rect.height	 = (rect.height * d).roundFloat();
		rect.invalidatable = true;
	}
	
	
#if debug
	public function toString()
	{
		return "[Matrix2D a=" + a + ", b=" + b + ", c=" + c + ", d=" + d + ", tx=" + tx + ", ty=" + ty + ", " + tw + ", " + th + "]";
	}
#end
}