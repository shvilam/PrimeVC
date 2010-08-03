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



/**
 * Integer Rectangle implementation
 * 
 * @author Ruben Weijers
 * @creation-date Aug 03, 2010
 */
class IntRectangle implements IRectangle 
{
	public var left		(getLeft, setLeft)		: Int;
	public var right	(getRight, setRight)	: Int;
	public var top		(getTop, setTop)		: Int;
	public var bottom	(getBottom, setBottom)	: Int;
	
	public var width	(getWidth, setWidth)	: Int;
	public var height	(getHeight, setHeight)	: Int;
	
	/*
	public function new ( top:Int = 0, right:Int = 0, bottom:Int = 0, left:Int = 0 )
	{
		this.top	= top;
		this.right	= right;
		this.bottom	= bottom;
		this.left	= left;
	}*/
	public function new ( x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0 )
	{
		this.top	= x;
		this.left	= y;
		this.width	= width;
		this.height	= height;
	}
	
	
	public function clone () : IBox {
		return cast new Rectangle( left, top, width, height );
	//	return new Rectangle( top, right, bottom, left );
	}
	
	
	public function toString ()
	{
		return "t: " + top + "; r: " + right + "; b: " + bottom + "; l: " + left + "; width: " + width + "; height: " + height;
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setWidth (v:Int) {
		width	= v;
		right	= left + v;
		return v;
	}
	
	
	private inline function setHeight (v:Int) {
		height	= v;
		bottom	= top + v;
		return v;
	}
	
	
	private inline function setTop (v:Int) {
		if (v != top) {
			top		= v;
			bottom	= v + height;
		}
		return v;
	}
	
	
	private function setBottom (v:Int) {
		if (v != bottom) {
			bottom	= v;
			top		= v - height;
		}
		
		return v;
	}
	
	
	private inline function setLeft (v:Int) {
		if (v != left) {
			left	= v;
			right	= v + width;
		}
		return v;
	}
	
	
	private function setRight (v:Int) {
		if (v != right) {
			right	= v;
			left	= v - width;
		}
		return v;
	}
	
	
	private inline function getLeft ()		{ return left; }
	private inline function getRight ()		{ return right; }
	private inline function getTop ()		{ return top; }
	private inline function getBottom ()	{ return bottom; }
	private inline function getWidth ()		{ return width; }
	private inline function getHeight ()	{ return height; }
}