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
 * @since	mar 22, 2010
 * @author	Ruben Weijers
 */
class Box implements IRectangle
{
	public var left		(getLeft, setLeft)		: Int;
	public var right	(getRight, setRight)	: Int;
	public var top		(getTop, setTop)		: Int;
	public var bottom	(getBottom, setBottom)	: Int;
	
	public function new ( top:Int = 0, right:Int = -100, bottom:Int = -100, left:Int = -100 )
	{
		this.top	= top;
		this.right	= (right == -100) ? this.top : right;
		this.bottom	= (bottom == -100) ? this.top : bottom;
		this.left	= (left == -100) ? this.right : left;
	}
	
	public function toString ()
	{
		return "t: " + top + "; r: " + right + "; b: " + bottom + "; l: " + left + ";";
	}
	
	private inline function getLeft ()		{ return left; }
	private inline function getRight ()		{ return right; }
	private inline function getTop ()		{ return top; }
	private inline function getBottom ()	{ return bottom; }
	private inline function setLeft (v)		{ return this.left = v; }
	private inline function setRight (v)	{ return this.right = v; }
	private inline function setTop (v)		{ return this.top = v; }
	private inline function setBottom (v)	{ return this.bottom = v; }
}