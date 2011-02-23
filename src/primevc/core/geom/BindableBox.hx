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
 import primevc.core.Bindable;
 import primevc.core.traits.IDisposable;
 import primevc.types.Number;


/**
 * A Box is an object with for coordinates which won't respond to each other
 * changes.
 * 
 * This is for example usefull to define the maximum or minimum values of a
 * ContrainedRect or to define the relative properties of a LayoutClient.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class BindableBox implements IBox, implements IDisposable
{
	public var top			(getTop, setTop)		: Int;
	public var bottom		(getBottom, setBottom)	: Int;
	public var left			(getLeft, setLeft)		: Int;
	public var right		(getRight, setRight)	: Int;
	
	public var leftProp		(default, null)			: Bindable <Int>;
	public var rightProp	(default, null)			: Bindable <Int>;
	public var topProp		(default, null)			: Bindable <Int>;
	public var bottomProp	(default, null)			: Bindable <Int>;
	
	
	public function new (top = Number.INT_MIN, right = Number.INT_MAX, bottom = Number.INT_MAX, left = Number.INT_MIN) 
	{
		Assert.that(top <= bottom);
		Assert.that(left <= right);
		
		leftProp	= new Bindable<Int>( left );
		rightProp	= new Bindable<Int>( right );
		topProp		= new Bindable<Int>( top );
		bottomProp	= new Bindable<Int>( bottom );
	}
	
	
	public function dispose ()
	{
		leftProp.dispose();
		rightProp.dispose();
		topProp.dispose();
		bottomProp.dispose();
		
		leftProp = rightProp = topProp = bottomProp = null;
	}
	
	
	public function clone () : IBox
	{
		return new BindableBox( top, right, bottom, left );
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getLeft ()		{ return leftProp.value; }
	private inline function getRight ()		{ return rightProp.value; }
	private inline function getTop ()		{ return topProp.value; }
	private inline function getBottom ()	{ return bottomProp.value; }
	
	private function setLeft (v:Int)		{ return leftProp.value = v; }
	private function setRight (v:Int)		{ return rightProp.value = v; }
	private function setTop (v:Int)			{ return topProp.value = v; }
	private function setBottom (v:Int)		{ return bottomProp.value = v; }
	

#if debug
	public function toString () {
		return "left " + left + "; right: " + right + "; top: " + top + "; bottom: " + bottom ;
	}
#end
}