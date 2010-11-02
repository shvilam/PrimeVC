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
#if neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.utils.StringUtil;
#end
 import primevc.tools.generator.ICSSFormattable;
 import primevc.types.Number;
  using primevc.utils.NumberUtil;


/**
 * @since	mar 22, 2010
 * @author	Ruben Weijers
 */
class Box
				implements IBox
			,	implements ICSSFormattable
#if neko	,	implements ICodeFormattable		#end
{
	public var left		(getLeft, setLeft)		: Int;
	public var right	(getRight, setRight)	: Int;
	public var top		(getTop, setTop)		: Int;
	public var bottom	(getBottom, setBottom)	: Int;
	
#if neko
	public var uuid		(default, null)			: String;
#end
	
	
	public function new ( top:Int = 0, right:Int = Number.INT_NOT_SET, bottom:Int = Number.INT_NOT_SET, left:Int = Number.INT_NOT_SET )
	{
#if neko
		this.uuid	= StringUtil.createUUID();
#end
		this.top	= top;
		this.right	= (right.notSet()) ? this.top : right;
		this.bottom	= (bottom.notSet()) ? this.top : bottom;
		this.left	= (left.notSet()) ? this.right : left;
	}
	
	
	public function clone () : IBox			{ return new Box( top, right, bottom, left ); }
	
	private inline function getLeft ()		{ return left; }
	private inline function getRight ()		{ return right; }
	private inline function getTop ()		{ return top; }
	private inline function getBottom ()	{ return bottom; }
	private inline function setLeft (v)		{ return this.left = v; }
	private inline function setRight (v)	{ return this.right = v; }
	private inline function setTop (v)		{ return this.top = v; }
	private inline function setBottom (v)	{ return this.bottom = v; }
	
	
#if (debug || neko)
	public function toString () { return toCSS(); }


	public function isEmpty () : Bool
	{
		return top.notSet()
			&& left.notSet()
			&& bottom.notSet()
			&& right.notSet();
	}
	
	
	public function toCSS (prefix:String = "") : String
	{
		return getCSSValue(top) + " " + getCSSValue(right) + " " + getCSSValue(bottom) + " " + getCSSValue(left);
	}
	
	
	private inline function getCSSValue (v:Int) { return v == 0 ? "0" : v + "px"; }
#end

#if neko
	public function cleanUp () : Void {}
	public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ top, right, bottom, left ] );
	}
#end
}