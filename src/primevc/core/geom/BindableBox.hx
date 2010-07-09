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
 import primevc.core.IDisposable;
 import primevc.core.Number;


/**
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class BindableBox implements IDisposable
{
	public var left		: Bindable <Int>;
	public var right	: Bindable <Int>;
	public var top		: Bindable <Int>;
	public var bottom	: Bindable <Int>;
//	public var centerX	: Bindable <Int>;
//	public var centerY	: Bindable <Int>;
	
	
	public function new (top = Number.INT_MIN, right = Number.INT_MAX, bottom = Number.INT_MAX, left = Number.INT_MIN) 
	{
		Assert.that(top <= bottom);
		Assert.that(left <= right);
		
		this.left		= new Bindable<Int>( left );
		this.right		= new Bindable<Int>( right );
		this.top		= new Bindable<Int>( top );
		this.bottom		= new Bindable<Int>( bottom );
	//	this.centerX	= new Bindable<Int>( (right - left) * .5 );
	//	this.centerY	= new Bindable<Int>( (bottom - top) * .5 );
	}
	
	
	public function dispose ()
	{
		left.dispose();
		right.dispose();
		top.dispose();
		bottom.dispose();
	//	centerX.dispose();
	//	centerY.dispose();
		
		left = right = top = bottom = null;
	//	centerX = centerY = null;
	}
}