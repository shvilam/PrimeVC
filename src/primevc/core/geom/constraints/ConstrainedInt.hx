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
 

/**
 * Class to provide a int with dynamic rules wich can be applied on it when 
 * the value of the int is changed.
 * 
 * The constraints won't contain a value by themselves but their validate method
 * will be called when the value changes. The constraint can then apply it's
 * rules on the given value and change it if he likes that.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class ConstrainedInt extends ConstraintBase <Int>
{
	/**
	 * Value of the cosntrained float. When the value is changed, the new
	 * value will first be checked by the constraints if they are enabled.
	 */
	public var value (default, setValue)		: Int;
		private inline function setValue (v)	{ return value = applyConstraint(v); }
	
	
	public function new (v = 0)
	{
		super();
		value = v;
	}
	
	
	override public function dispose ()
	{
		super.dispose();
		value = 0;
	}
	
	
	public function validateValue ()
	{
		value = applyConstraint(value);
	}
}