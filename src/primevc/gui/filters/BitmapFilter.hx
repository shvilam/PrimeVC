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
package primevc.gui.filters;


typedef BitmapFilter = 
	#if		flash9	flash.filters.BitmapFilter;
	#elseif	flash8	flash.filters.BitmapFilter;
	#elseif	js		throw "error";
	#else			BitmapFilterImpl;
	

 import primevc.tools.generator.ICodeGenerator;
 import primevc.utils.ID;


/**
 * @author Ruben Weijers
 * @creation-date Sep 29, 2010
 */
class BitmapFilterImpl implements IBitmapFilter
{
#if (neko || debug)
	public var _oid			(default, null)	: Int;
#end
	
	public function new ()
	{
		_oid = ID.getNext();
	}
	
	
	public function toCSS (prefix:String = "") : String	{ Assert.abstract(); return ""; }
	public function toString ()							{ return toCSS(); }
	
	
#if (neko || debug)	
	public function cleanUp () : Void				{}
	public function toCode (code:ICodeGenerator)	{ Assert.abstract(); }
	public function isEmpty () : Bool				{ Assert.abstract(); return false; }
#end
}

#end