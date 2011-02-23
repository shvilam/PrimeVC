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
package primevc.core.validators;
 import primevc.core.dispatcher.Signal0;
 import primevc.types.Number;
 import primevc.utils.NumberMath;
  using primevc.utils.NumberUtil;


/**
 * This class can constraint the value of an float to the given min and max value.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 06, 2010
 */
class FloatRangeValidator implements IValueValidator <Float>
{
	public var change (default, null)	: Signal0;

	public var min	(default, setMin)	: Float;
	public var max	(default, setMax)	: Float;


	public function new( min:Float = Number.INT_NOT_SET, max:Float = Number.INT_NOT_SET )
	{
		this.min = min == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : min;
		this.max = max == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : max;
		change = new Signal0();
	}
	
	
	public inline function dispose ()
	{
		change.dispose();
		change = null;
	}
	
	
	public inline function getDiff ()
	{
		return min.isSet() && max.isSet() ? max - min : 0;
	}
	
	
	private inline function setMin (v)
	{
		if (v != min) {
			min = v;
			broadcastChange();
		}
		return v;
	}
	
	
	private inline function setMax (v)
	{
		if (v != max) {
			max = v;
			broadcastChange();
		}
		return v;
	}
	
	
	private inline function broadcastChange ()
	{
		if (change != null && (min == min || max == max)) //FIXME: haxe compiler bug, when inlining NumberUtil.isSet()
			change.send();
	}
	
	
	public function validate (v:Float) : Float
	{
	//	if (v.notSet())
	//		return v;
		if (min.isSet() && max.isSet())		v = v.within( min, max );
		else if (min.isSet())				v = v.getBiggest( min );
		else if (max.isSet())				v = v.getSmallest( max );
		return v;
	}
	
	
	public function setValues (min:Float, max:Float) : Void
	{
		var changed = min != this.min || max != this.max;
		(untyped this).min = min;
		(untyped this).max = max;
		
		if (changed)
			broadcastChange();
	}


#if debug
	public function toString ()
	{
		return "FloatValidator ( " + min + ", " + max + " )";
	}
#end
}