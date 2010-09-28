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
 import primevc.core.dispatcher.Signal0;
 import primevc.core.Bindable;
 import primevc.types.Number;
 import primevc.utils.IntMath;
  using primevc.utils.NumberUtil;


/**
 * This class can constraint the value of an int to the given min and max value.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class IntConstraint implements IConstraint<Int>
{
	public var change (default, null)	: Signal0;
	
	public var min	(default, setMin)	: Int;
	public var max	(default, setMax)	: Int;
	
	
	public function new( min = Number.INT_NOT_SET, max = Number.INT_NOT_SET )
	{
		change = new Signal0();
		this.min = min;
		this.max = max;
	}
	
	
	public inline function dispose ()
	{
		change.dispose();
	}
	
	
	private inline function setMin (v)
	{
		if (v != min) {
			min = v;
			change.send();
		}
		return v;
	}
	
	private inline function setMax (v)
	{
		if (v != max) {
			max = v;
			change.send();
		}
		return v;
	}
	
	public inline function validate (v:Int) : Int
	{
		if (v.notSet())
			return v;
		
		if (min.isSet() && max.isSet())		v = v.within( min, max );
		else if (min.isSet())				v = IntMath.max( v, min );
		else								v = IntMath.min( v, max );
		
		return v;
	}
}