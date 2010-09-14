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
package primevc.neko.geom;
 import primevc.utils.StringUtil;
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;


/**
 * Neko implementation for primevc.core.geom.Matrix2D
 * 
 * @author Ruben Weijers
 * @creation-date Sep 14, 2010
 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/geom/Matrix.html
 */
class Matrix implements ICodeFormattable
{
	public var a	: Float;
	public var b	: Float;
	public var c	: Float;
	public var d 	: Float;
	public var tx	: Float;
	public var ty	: Float;
	
	public var uuid	(default, null) : String;
	
	
	public function new (a, b, c, d, tx, ty)
	{
		uuid = StringUtil.createUUID();
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.tx = tx;
		this.ty = ty;
	}
	
	
#if neko
	public function toCode (code:ICodeGenerator)
	{
		code.construct( this, [ a, b, c, d, tx, ty ] );
	}
#end
}