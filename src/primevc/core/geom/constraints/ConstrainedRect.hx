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
 import primevc.core.geom.IBox;
 import primevc.core.geom.IRectangle;
  using primevc.utils.Bind;
  using primevc.utils.NumberUtil;
  using Std;


/**
 * A ConstrainedRect is a rectrangle (not a box) which can have constraints
 * on it's coordinate-properties. This way the rectange will never be bigger
 * than the constrained-size.
 * 
 * The difference between a Rectangle and a Box is that the coordinates in a
 * box don't have any relation to each other where they do in a rectangle.
 * When the top is changed, this will also change the bottom property (since
 * the height of the rectangle is changed) etc.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class ConstrainedRect extends BindableBox, implements IRectangle
{
	public var constraint		(default, setConstraint)		: BindableBox;
	
	public var centerX			(getCenterX, setCenterX)		: Float;
	public var centerY			(getCenterY, setCenterY)		: Float;
	
	public var size				(default, null)					: BindablePoint;
	public var width			(getWidth, setWidth)			: Int;
	public var height			(getHeight, setHeight)			: Int;
	
	
	public function new (top = 0, right = 0, bottom = 0, left = 0) 
	{
		size = new BindablePoint(right - left, bottom - top);
		super( top, right, bottom, left);
	}
	
	
	override public function dispose ()
	{
		super.dispose();
		size.dispose();
		size		= null;
		constraint	= null;
	}


	override public function clone () : IBox
	{
		return new ConstrainedRect( top, right, bottom, left );
	}
	
	
	private inline function getCenterX ()	{ return left + (width * .5); }
	private inline function getCenterY ()	{ return top + (height * .5); }
	private inline function getWidth ()		{ return size.x; }
	private inline function getHeight ()	{ return size.y; }
	
	
	private inline function setWidth (v:Int)
	{
		if (size.x != v)
		{
			Assert.that( v >= 0, "setWidth "+size.x+" => "+v );
			size.x = v;
			rightProp.value	= v.isSet() ? left + size.x : left;
		}
		return v;
	}
	
	
	private inline function setHeight (v:Int)
	{
		if (size.y != v)
		{
			Assert.that( v >= 0, "setHeight "+size.y+" => "+v );
			size.y = v;
			bottomProp.value = v.isSet() ? top + v : top;
		}
		return v;
	}
	
	
	override private function setTop (v:Int)
	{
		if (constraint != null && v < constraint.top)
			v = constraint.top;
		
		if (v != top) {
			topProp.value		= v;
			bottomProp.value	= (v.isSet() && height.isSet()) ? v + height : v;
		}
		return v;
	}
	
	
	override private function setBottom (v:Int)
	{
		if (constraint != null && v > constraint.bottom)
			v = constraint.bottom;
		
		if (v != bottom) {
			bottomProp.value = v;
			topProp.value = (v.isSet() && height.isSet()) ? v - height : v;
		}
		
		return v;
	}
	
	
	override private function setLeft (v:Int)
	{
		if (constraint != null && v < constraint.left)
			v = constraint.left;
		
		if (v != left) {
			leftProp.value	= v;
			rightProp.value	= (v.isSet() && width.isSet()) ? v + width : v;
		}
		return v;
	}
	
	
	override private function setRight (v:Int)
	{
		if (constraint != null && v > constraint.right)
			v = constraint.right;
		
		if (v != right) {
			rightProp.value	= v;
			leftProp.value	= (v.isSet() && width.isSet()) ? v - width : v;
		}
		return v;
	}
	
	
	private inline function setCenterX (v:Float)
	{
		if (v.isSet())
			left = width.isSet() ? (v - (width * .5)).int() : v.int();
		
		return centerX = v;
	}
	
	
	private inline function setCenterY (v:Float)
	{
		if (v.isSet())
			top = width.isSet() ? (v - (height * .5)).int() : v.int();
		
		return centerY = v;
	}
	
	
	
	public inline function setConstraint (v)
	{
		if (constraint != null) {
			constraint.leftProp		.change.unbind( this );
			constraint.rightProp	.change.unbind( this );
			constraint.topProp		.change.unbind( this );
			constraint.bottomProp	.change.unbind( this );
		}
		
		constraint = v;
		
		if (constraint != null) {
			validateConstraints.on( constraint.leftProp		.change, this );
			validateConstraints.on( constraint.rightProp	.change, this );
			validateConstraints.on( constraint.topProp		.change, this );
			validateConstraints.on( constraint.bottomProp	.change, this );
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


#if debug
	override public function toString () {
		return super.toString() + "; width: " + width + "; height: " + height;
	}
#end
}