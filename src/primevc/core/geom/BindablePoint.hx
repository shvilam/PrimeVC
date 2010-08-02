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


/**
 * Description
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class BindablePoint extends IntPoint, implements IDisposable
{
	public var xProp (default, null)	: Bindable < Int >;
	public var yProp (default, null)	: Bindable < Int >;
	
	
	public function new (x = 0, y = 0)
	{
		xProp = new Bindable<Int>(x);
		yProp = new Bindable<Int>(y);
		super(x, y);
	}
	
	
	public function dispose () {
		xProp.dispose();
		yProp.dispose();
		xProp = yProp = null;
	}
	
	
	override public function clone () : IntPoint {
		return new BindablePoint( x, y );
	}
	
	
	override private function getX ()	{ return xProp.value; }
	override private function setX (v)	{ return xProp.value = v; }
	override private function getY ()	{ return yProp.value; }
	override private function setY (v)	{ return yProp.value = v; }
}