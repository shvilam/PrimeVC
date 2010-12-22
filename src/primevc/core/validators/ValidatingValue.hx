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
 import primevc.core.traits.Invalidatable;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using Std;
 

/**
 * @creation-date	Jun 20, 2010
 * @author			Ruben Weijers
 */
class ValidatingValue < DataType > extends Invalidatable
#if flash	,	implements haxe.rtti.Generic	#end
{
	public var validator			(default, setValidator)	: IValueValidator < DataType >;
	public var value				(default, setValue)		: DataType;
	
	
	public function new (newValue:DataType)
	{
		super();
		value = newValue;
	}
	
	
	override public function dispose ()
	{
		if (validator != null)
			validator = null;
		
		super.dispose();
	}
	
	
	private inline function applyValidator (v:DataType)
	{
		return (validator != null) ? validator.validate(v) : v;
	}
	
	
	public inline function validateValue ()
	{
		value = applyValidator(value);
	}
	
	
	private function validatorChangeHandler ()
	{
		invalidate( ValueFlags.VALIDATOR );
		validateValue();
	}
	
	
	private inline function setValidator (v)
	{
		if (v != validator)
		{
			if (validator != null)
				validator.change.unbind(this);
			
			validator = v;
			invalidate( ValueFlags.VALIDATOR );
			
			if (v != null) {
				validatorChangeHandler.on( validator.change, this );
			//	validateValue();
			}
		}
		return v;
	}
	
	
	private inline function setValue (v:DataType)
	{
		var oldV = value;
		if (v != value)
		{
			value = applyValidator(v);
			if (value != oldV)
				invalidate( ValueFlags.VALUE );
		}
		return value;
	}
	
	
#if debug
	public function toString ()
	{
		return "Value( "+value.string() + ") - validator: "+validator;
	}
#end
}


class ValueFlags
{
	public static inline var VALUE		= 1;
	public static inline var VALIDATOR	= 2;
	
#if debug
	public static function readProperties (flags:Int) : String
	{
		var output	= [];
		
		if (flags.has( VALUE ))			output.push("value");
		if (flags.has( VALIDATOR ))		output.push("validator");
		
		return "properties: " + output.join(", ")+" ("+flags+")";
	}
#end
}