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
package primevc.core.math;
 import primevc.core.dispatcher.Wire;
 import primevc.core.traits.IDisposable;
 import primevc.core.Bindable;
 import primevc.core.validators.FloatRangeValidator;
  using primevc.utils.Bind;
  using primevc.utils.NumberUtil;


/**
 * Helper class to set a min, max and a value and to update the percentage
 * of that value automaticly.
 * 
 * @author Ruben Weijers
 * @creation-date Mar 24, 2011
 */
class PercentageHelper extends Bindable<Float>, implements IDisposable
{
	//
	// PUBLIC VARS
	//
	
//	public var data			(default, null)					: Bindable<Float>;
	/**
	 * Percentage indicating the value on a scale of 0 - 1
	 */
	public var perc			(default, null)					: Bindable<Float>;
	
	/**
	 * getter / setter to quickly access the value of data
	 */
//	public var value		(getValue, setValue)			: Float;
	/**
	 * getter / setter to quickly access the value of perc
	 */
	public var percentage	(getPercentage, setPercentage)	: Float;
	
	
	/**
	 * Constraint defining the minimal and maximum value
	 * @default		0 - 1
	 */
	public var validator	(default, null)					: FloatRangeValidator;
	
	
	/**
	 * If true, the value of the slider will be inverted.
	 * For example:
	 * 		- slider between 4 and 8:
	 * 			normal value:	4 | 5 | 6 | 7 | 8
	 * 			inverted value:	8 | 7 | 6 | 5 | 4
	 * 
	 * @default false
	 */
	public var inverted		(default, setInverted)			: Bool;
	
	
	//
	// PRIVATE VARS
	//
	
	/**
	 * reference to the wire that is responsible for updating the percentage
	 * when the value changes
	 */
	private var updatePercBinding		: Wire < Dynamic >;
	private var updateValueBinding		: Wire < Dynamic >;
	
	
	
	public function new (value:Float = 0.0, minValue:Float = 0.0, maxValue:Float = 1.0)
	{
		super(value);
	//	this.data	= new Bindable<Float>(value);
		this.perc	= new Bindable<Float>(0);
		validator	= new FloatRangeValidator( minValue, maxValue );
		
		validateData.on( validator.change, this );
		updatePercBinding	= calculatePercentage	.on( change, this );
		updateValueBinding	= calculateValue		.on( perc.change, this );
		
		calculatePercentage();
	}
	
	
	override public function dispose ()
	{
		if (updatePercBinding != null) {
			updatePercBinding.dispose();
			updatePercBinding = null;
		}
		
		if (updateValueBinding != null) {
			updateValueBinding.dispose();
			updateValueBinding = null;
		}
		
	/*	if (value != null) {
			value.dispose();
			value = null;
		}*/
		
		if (perc != null) {
			perc.dispose();
			perc = null;
		}
		
		if (validator != null) {
			validator.dispose();
			validator = null;
		}
		super.dispose();
	}
	
	
	private inline function calculatePercentage () : Void
	{
		updateValueBinding.disable();
		var diff	= validator.getDiff();
		percentage	= diff == 0 ? 0 : (( value - validator.min ) / diff).within(0, 1);
		updateValueBinding.enable();
	}
	
	
	/**
	 * Method will set the given value as percentage and calculate the correct
	 * value for it.
	 */
	private function calculateValue () : Void
	{
		updatePercBinding.disable();
		value = validator.min + (percentage * (validator.max - validator.min));
		updatePercBinding.enable();
	}
	
	
	public function invert () : Void
	{
		updatePercBinding.disable();
		updateValueBinding.disable();
		
		value		= validator.max - value + validator.min;
		percentage	= 1 - percentage;
		
		updatePercBinding.enable();
		updateValueBinding.enable();
	}
	
	
	
	
	//
	// EVENTHANDLERS
	//
	
	
	/**
	 * Method is called when a property of the constraint changes. This method
	 * will make sure the current value of the slider is within the boundaries
	 * of the constraint.
	 */
	private inline function validateData ()
	{
		Assert.that( validator.min.isSet() );
		Assert.that( validator.max.isSet() );
		value = validator.validate( value );
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
//	private inline function getValue ()				{ return data.value; }
//	private inline function setValue (v:Float)		{ return data.value = v; }
	private inline function getPercentage ()		{ return perc.value; }
	private inline function setPercentage (v:Float)	{ Assert.that( v <= 1, v + " > 1" ); Assert.that( v >= 0, v + " < 0" ); return perc.value = v; }
	
	
	private inline function setInverted (v:Bool)
	{
		if (v != inverted)
		{
			inverted = v;
			invert();
		}
		
		return v;
	}
}