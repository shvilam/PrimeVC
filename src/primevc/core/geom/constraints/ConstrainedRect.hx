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
package primevc.core.geom.constraints;
 import primevc.core.geom.BindableBox;
 import primevc.core.geom.BindablePoint;
 import primevc.core.IDisposable;
  using primevc.utils.Bind;


/**
 * Description
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class ConstrainedRect implements IDisposable
{
	public var constraint		(default, setConstraint)		: BindableBox;
	public var props			(default, null)					: BindableBox;
	
	public var top				(getTop, setTop)				: Int;
	public var bottom			(getBottom, setBottom)			: Int;
	public var left				(getLeft, setLeft)				: Int;
	public var right			(getRight, setRight)			: Int;
	public var centerX			(getCenterX, setCenterX)		: Int;
	public var centerY			(getCenterY, setCenterY)		: Int;
	
	public var size				(default, null)					: BindablePoint;
	public var width			(getWidth, setWidth)			: Int;
	public var height			(getHeight, setHeight)			: Int;
	
	
	public function new (top = 0, right = 0, bottom = 0, left = 0) 
	{
		props		= new BindableBox();
		size		= new BindablePoint(right - left, bottom - top);
		this.top	= top;
		this.right	= right;
		this.bottom	= bottom;
		this.left	= left;
	}
	
	
	public function dispose ()
	{
		props.dispose();
		size.dispose();
		props		= null;
		size		= null;
		constraint	= null;
	}
	
	
	public function toString () {
		return "left " + left + "; right: " + right + "; top: " + top + "; bottom: " + bottom + "; width: " + width + "; height: " + height;
	}
	
	
	private inline function getLeft ()		{ return props.left.value; }
	private inline function getRight ()		{ return props.right.value; }
	private inline function getTop ()		{ return props.top.value; }
	private inline function getBottom ()	{ return props.bottom.value; }
	private inline function getCenterX ()	{ return left + Std.int(width * .5); }
	private inline function getCenterY ()	{ return top + Std.int(height * .5); }
	private inline function getWidth ()		{ return size.x; }
	private inline function getHeight ()	{ return size.y; }
	
	
	public inline function setWidth (v:Int) {
		size.x				= v;
		props.right.value	= left + size.x;
		return v;
	}
	
	
	public inline function setHeight (v:Int) {
		size.y				= v;
		props.bottom.value	= top + size.y;
		return v;
	}
	
	
	private inline function setTop (v:Int) {
		if (constraint != null && v < constraint.top.value)
			v = constraint.top.value;
		
		if (v != top) {
			props.top.value		= v;
			props.bottom.value	= v + height;
		}
		return v;
	}
	
	
	private inline function setBottom (v:Int) {
		if (constraint != null && v > constraint.bottom.value)
			v = constraint.bottom.value;
		
		if (v != bottom) {
			props.bottom.value	= v;
			props.top.value		= v - height;
		}
		
		return v;
	}
	
	
	private inline function setLeft (v:Int) {
		if (constraint != null && v < constraint.left.value)
			v = constraint.left.value;
		
		if (v != left) {
			props.left.value	= v;
			props.right.value	= v + width;
		}
		return v;
	}
	
	
	private inline function setRight (v:Int) {
		if (constraint != null && v > constraint.right.value)
			v = constraint.right.value;
		
		if (v != right) {
			props.right.value	= v;
			props.left.value	= v - width;
		}
		return v;
	}
	
	
	private inline function setCenterX (v:Int) {
		left = v - Std.int(width * .5);
		return centerX;
	}
	
	
	private inline function setCenterY (v:Int) {
		top = v - Std.int(height * .5);
		return centerY;
	}
	
	
	
	public inline function setConstraint (v) {
		if (constraint != null) {
			constraint.left		.change.unbind( this );
			constraint.right	.change.unbind( this );
			constraint.top		.change.unbind( this );
			constraint.bottom	.change.unbind( this );
		}
		
		constraint = v;
		
		if (constraint != null) {
			validateConstraints.on( constraint.left		.change, this );
			validateConstraints.on( constraint.right	.change, this );
			validateConstraints.on( constraint.top		.change, this );
			validateConstraints.on( constraint.bottom	.change, this );
			validateConstraints();
		}
		return v;
	}
	
	
	public inline function validateConstraints ()
	{
		setLeft(left);
		setRight(right);
		setTop(top);
		setBottom(bottom);
	}
}