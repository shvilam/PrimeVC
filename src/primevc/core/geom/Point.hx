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

/**
 * @creation-date	Jun 11, 2010
 * @author			Ruben Weijers
 */
#if flash9
	typedef Point = flash.geom.Point;
#else


class Point
{
	
	public var x (getX, setX)	: Float;
	public var y (getY, setY)	: Float;
	
	
	public function new(x:Float = 0, y:Float = 0)
	{
		this.x = x;
		this.y = y;
	}
	
	
	public function clone () {
		return new Point( x, y );
	}
	
	
	private function getX()		{ return x; }
	private function setX(v)	{ return x = v; }
	private function getY()		{ return y; }
	private function setY(v)	{ return y = v; }
	
	
	public inline function subtract (v:Point) {
		return new Point(
			x - v.x,
			y - v.y
		);
	}
	
	
	public inline function add (v:Point) {
		return new Point(
			x + v.x,
			y + v.y
		);
	}
	
	
	public inline function isEqualTo (v:Point) : Bool {
		return x == v.x && y == v.y;
	}
	
	
	public inline function setTo (v:Point) : Void {
		x = v.x;
		y = v.y;
	}
	
	
	#if debug
	public inline function toString () {
		return "Point( "+x+", "+y+" )";
	}
	#end
}

#end