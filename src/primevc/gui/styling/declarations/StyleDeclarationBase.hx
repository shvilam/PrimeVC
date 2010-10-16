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
package primevc.gui.styling.declarations;
 import primevc.core.traits.IInvalidatable;
 import primevc.core.traits.Validatable;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
#if (neko || debug)
 import primevc.utils.StringUtil;
#end
  using primevc.utils.BitUtil;


/**
 * Base class for (sub-)style declarations
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class StyleDeclarationBase extends Validatable, implements IStyleDeclaration
{
#if (debug || neko)
	public var uuid					(default, null)		: String;
#end
	public var filledProperties		(default, null)		: UInt;
	public var allFilledProperties	(default, null)		: UInt;
	
	
	public function new ()
	{
		super();
#if (debug || neko)
		uuid				= StringUtil.createUUID();
#end
		filledProperties	= 0;
		allFilledProperties	= 0;
	}
	
	
	override public function dispose ()
	{
#if (debug || neko)
		uuid				= null;
#end
		filledProperties	= 0;
		allFilledProperties	= 0;
		super.dispose();
	}
	
	
	private function markProperty ( propFlag:UInt, isSet:Bool ) : Void
	{
		if (isSet)	filledProperties = filledProperties.set( propFlag );
		else		filledProperties = filledProperties.unset( propFlag );
		
		//Now it's unknow if the property that is changed, is somewhere in
		//the list with super / extended styles, so the object must rebuild 
		//these flags.
		updateAllFilledPropertiesFlag();
		
		invalidate( propFlag );
	}
	
	
	private function updateAllFilledPropertiesFlag () : Void
	{
		allFilledProperties = filledProperties;
	}
	
	
#if debug
	public function readProperties ( flags:UInt = -1 )	: String	{ Assert.abstract(); return null; }
	public function readChanges ( flags:UInt = -1 )		: String
	{
		if (flags == -1)
			flags = changes;
		return readProperties( flags );
	}
#end
	
	
#if (debug || neko)
	public function toString ()						{ return toCSS(); }
	public function isEmpty ()						{ Assert.abstract(); return false; }
	public function toCSS (prefix:String = "") 		{ Assert.abstract(); return ""; }
#end
	
#if neko
	public function toCode (code:ICodeGenerator)	{ Assert.abstract(); }
#end
}