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
 import primevc.core.traits.QueueingInvalidatable;
  using primevc.utils.NumberMath;
  using primevc.utils.NumberUtil;


/**
 * Integer Rectangle implementation
 * 
 * @author Ruben Weijers
 * @creation-date Aug 03, 2010
 */
class IntRectangle extends QueueingInvalidatable, implements IRectangle
{
	public var centerX	(getCenterX, setCenterX)	: Float;
	public var centerY	(getCenterY, setCenterY)	: Float;
	
	public var left		(getLeft, setLeft)			: Int;
	public var right	(getRight, setRight)		: Int;
	public var top		(getTop, setTop)			: Int;
	public var bottom	(getBottom, setBottom)		: Int;
	
	public var width	(getWidth, setWidth)		: Int;
	public var height	(getHeight, setHeight)		: Int;
	
	
	public function new ( x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0 )
	{
		super();
		invalidatable = false;
		this.top	= x;
		this.left	= y;
		this.width	= width;
		this.height	= height;
		invalidatable = true;
	}
	
	
	public function clone () : IBox
	{
		return cast new IntRectangle( left, top, width, height );
	}
	
	
	public function toString ()
	{
		return "IntRect (x=" + left + ", y=" + top + ", width=" + width + ", height=" + height + ", r=" + right + ", b=" + bottom+" )";
	}
	
	
	public function resize (newWidth:Int, newHeight:Int) : Void
	{
		invalidatable = false;
		width	= newWidth;
		height	= newHeight;
		invalidatable = true;
	}
	
	
	public function move (newX:Int, newY:Int) : Void
	{
		invalidatable = false;
		top = newX;
		left = newY;
		invalidatable = true;
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setWidth (v:Int)
	{
		if (v != width) {
			Assert.that( v.isSet() );
			width	= v;
			right	= left + v;
			invalidate( RectangleFlags.WIDTH );
		}
		return v;
	}
	
	
	private inline function setHeight (v:Int)
	{
		if (v != height) {
			Assert.that( v.isSet() );
			height	= v;
			bottom	= top + v;
			invalidate( RectangleFlags.HEIGHT );
		}
		return v;
	}
	
	
	private inline function setTop (v:Int)
	{
		if (v != top) {
			Assert.that( v.isSet() );
			top		= v;
			bottom	= v + height;
			invalidate( RectangleFlags.TOP );
		}
		return v;
	}
	
	
	private function setBottom (v:Int)
	{
		if (v != bottom) {
			Assert.that( v.isSet() );
			bottom	= v;
			top		= v - height;
			invalidate( RectangleFlags.BOTTOM );
		}
		
		return v;
	}
	
	
	private inline function setLeft (v:Int)
	{
		if (v != left) {
			Assert.that( v.isSet() );
			left	= v;
			right	= v + width;
			invalidate( RectangleFlags.LEFT );
		}
		return v;
	}
	
	
	private function setRight (v:Int)
	{
		if (v != right) {
			Assert.that( v.isSet() );
			right	= v;
			left	= v - width;
			invalidate( RectangleFlags.RIGHT );
		}
		return v;
	}
	
	
	private inline function setCenterX (v:Float)
	{	
		Assert.that( v.isSet() );
		if (v.isSet())
			left = (v - (width * .5)).roundFloat();
		
		return centerX = v;
	}
	
	
	private inline function setCenterY (v:Float)
	{	
		Assert.that( v.isSet() );
		if (v.isSet())
			top = (v - (height * .5)).roundFloat();
		
		return centerY = v;
	}
	
	
	
	private inline function getLeft ()		{ return left; }
	private inline function getRight ()		{ return right; }
	private inline function getTop ()		{ return top; }
	private inline function getBottom ()	{ return bottom; }
	private inline function getWidth ()		{ return width; }
	private inline function getHeight ()	{ return height; }
	
	private inline function getCenterX ()	{ return left + (width * .5); }
	private inline function getCenterY ()	{ return top + (height * .5); }
	
	
	public function isEmpty ()
	{
		return width <= 0 || height <= 0;
	}
	
	
#if flash9
	public function toFloatRectangle () : Rectangle
	{
		return new Rectangle (0, 0, width, height);
	}
#end
}