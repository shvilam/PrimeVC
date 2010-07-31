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
 import primevc.core.traits.IClonable;
 import primevc.types.Number;
  using primevc.utils.FloatUtil;


/**
 * Object describing the corners of a rectangle
 * 
 * @author Ruben Weijers
 * @creation-date Aug 01, 2010
 */
class Corners implements IClonable
{
	public var topLeft		: Float;
	public var topRight		: Float;
	public var bottomLeft	: Float;
	public var bottomRight	: Float;
	
	
	public function new ( ?topLeft:Float = 0, ?topRight:Float = Number.FLOAT_NOT_SET, ?bottomLeft:Float = Number.FLOAT_NOT_SET, ?bottomRight:Float = Number.FLOAT_NOT_SET )
	{
		this.topLeft		= topLeft;
		this.topRight		= topRight.isSet()		? this.topLeft : topRight;
		this.bottomLeft		= bottomLeft.isSet()	? this.topLeft : bottomLeft;
		this.bottomRight	= bottomRight.isSet()	? this.topRight : bottomRight;
	}
	
	
	public function clone () : IClonable { return new Corners( topLeft, topRight, bottomLeft, bottomRight ); }
}