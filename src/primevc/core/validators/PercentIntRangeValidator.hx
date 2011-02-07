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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.core.validators;
 import primevc.types.Number;
  using primevc.utils.NumberMath;
  using primevc.utils.NumberUtil;


/**
 * PercentIntRangeValidator is a class which does the same as IntRangeValidator.
 * The class adds 2 properties to the validator, minPercent and maxPercent which
 * allow to define a min and max-value as a relative value to another object.
 * 
 * This is most handy in a layout with for example a min-width and a max-width
 * defined in percentages. The actual value of the IntRangeValidator will change
 * every time the parent of a layoutclient changes, but the percentage value
 * stays the same.
 * 
 * @author Ruben Weijers
 * @creation-date Jan 13, 2011
 */
class PercentIntRangeValidator extends IntRangeValidator
{
	public var percentMin (default, default) : Float;
	public var percentMax (default, default) : Float;
	
	
	public function new (percentMin:Float = Number.INT_NOT_SET, percentMax:Float = Number.INT_NOT_SET)
	{
		super();
		this.percentMin = percentMin == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentMin;
		this.percentMax = percentMax == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentMax;
	}
	
	
	public function calculateValues (targetValue:Int)
	{
		var min = percentMin.isSet() ? (percentMin * targetValue).roundFloat() : Number.INT_NOT_SET;
		var max = percentMax.isSet() ? (percentMax * targetValue).roundFloat() : Number.INT_NOT_SET;
		setValues( min, max );
	}
	
	
	
#if debug
	override public function toString ()
	{
		return "PercentIntRangeValidator ( " + percentMin + " = " + min + ", " + percentMax + " = " + max + " )";
	}
#end
}