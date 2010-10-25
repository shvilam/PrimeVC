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
 import primevc.tools.generator.ICSSFormattable;
#if neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.utils.StringUtil;
#end
  using primevc.utils.NumberUtil;
  using Std;
 

/**
 * Simple point class
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class IntPoint	implements IClonable <IntPoint>	
			,	implements ICSSFormattable
#if neko	,	implements ICodeFormattable		#end
{
	public static inline function fromFloat (x:Float, y:Float)	: IntPoint	{ return new IntPoint( x.int(), y.int() ); }
	public static inline function fromPoint (p:Point)			: IntPoint	{ return new IntPoint( p.x.int(), p.y.int() ); }
	
	public var x		(getX, setX)	: Int;
	public var y		(getY, setY)	: Int;
	
#if neko
	public var uuid		(default, null) : String;
#end
	
	
	
	
	public function new(x = 0, y = 0)
	{
#if neko
		this.uuid	= StringUtil.createUUID();
#end
		this.x		= x;
		this.y		= y;
	}
	
	
	public function clone () {
		return new IntPoint( x, y );
	}
	
	
	private function getX()		{ return x; }
	private function setX(v)	{ return x = v; }
	private function getY()		{ return y; }
	private function setY(v)	{ return y = v; }
	
	
	public inline function subtract (v:IntPoint) {
		return new IntPoint(
			x - v.x,
			y - v.y
		);
	}
	
	
	public inline function add (v:IntPoint) {
		return new IntPoint(
			x + v.x,
			y + v.y
		);
	}
	
	
	public inline function isEqualTo (v:IntPoint) : Bool {
		return x == v.x && y == v.y;
	}
	
	
	public inline function setTo (v:IntPoint) : Void {
		x = v.x;
		y = v.y;
	}
	
	
#if (debug || neko)
	public inline function toString ()
	{
		return "IntPoint( "+x+", "+y+" )";
	}
	
	
	public function toCSS (prefix:String = "")
	{
		return x + "px, " + y + "px";
	}
#end
	
	
#if neko
	public function cleanUp () : Void				{}
	public function toCode (code:ICodeGenerator)	{ code.construct( this, [ x, y ] ); }
	public function isEmpty ()						{ return x.notSet() && y.notSet(); }
#end
}