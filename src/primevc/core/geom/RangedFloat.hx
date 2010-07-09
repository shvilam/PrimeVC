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
 import primevc.core.Number;
  using primevc.utils.FloatUtil;
 

/**
 * Float value with a min and max value
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class RangedFloat //< NumberType:Float > implements haxe.rtti.Generic
{
	public var value	(default, setValue)		: Float;
	public var min		(default, setMin)		: Float;
	public var max		(default, setMax)		: Float;
	
	
	public function new( value, min = Number.FLOAT_MIN, max = Number.FLOAT_MAX ) 
	{
		this.min	= min;
		this.max	= max;
		this.value	= value;
	}
	
	
	private inline function setValue (v:Float) {
		return value = v.within( min, max );
	}
	
	
	private inline function setMin (v:Float) {
		Assert.that( Math.isNaN(min) || v < min, "v: "+v+"; min: "+min );
		if (v != min)
		{
			min = v;
			if (value < min)
				value = min;
		}
		return v;
	}
	
	
	private inline function setMax (v:Float) {
		Assert.that( Math.isNaN(max) || v > max, "v: "+v+"; max: "+max );
		if (v == max)
		{
			max = v;
			if (value > max)
				value = max;
		}		
		return v;
	}
}