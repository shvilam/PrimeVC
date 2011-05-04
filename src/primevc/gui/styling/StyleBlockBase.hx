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
package primevc.gui.styling;
 import primevc.core.traits.IInvalidatable;
 import primevc.core.traits.Invalidatable;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
#if (neko || debug)
 import primevc.utils.ID;
#end
  using primevc.utils.BitUtil;


/**
 * Base class for (sub-)style declarations
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class StyleBlockBase extends Invalidatable, implements IStyleBlock
{
#if (debug || neko)
	public var _oid					(default, null)		: Int;
#end
	
	/**
	 * Flag with properties that are set for this style-block.
	 */
	public var filledProperties		(default, null)		: Int;
	/**
	 * Combination of filledProperties and inheritedProperties
	 */
	public var allFilledProperties	(default, null)		: Int;
	/**
	 * Flag with the styleproperties that are inherited and not set in this
	 * style-block
	 */
	public var inheritedProperties	(default, null)		: Int;
	
	
	public function new ()
	{
		super();
#if (debug || neko)
		_oid = ID.getNext();
#end
		filledProperties	= 0;
		inheritedProperties	= 0;
		allFilledProperties	= 0;
	}
	
	
	override public function dispose ()
	{
#if (debug || neko)
		_oid				= -1;
#end
		filledProperties	= 0;
		inheritedProperties	= 0;
		allFilledProperties	= 0;
		super.dispose();
	}
	
	
	private function markProperty ( propFlag:Int, isSet:Bool ) : Void
	{
		if (isSet)	filledProperties = filledProperties.set( propFlag );
		else		filledProperties = filledProperties.unset( propFlag );
		
		//Now it's unknow if the property that is changed, is somewhere in
		//the list with super / extended styles, so the object must rebuild 
		//these flags.
		if (isSet)	allFilledProperties = allFilledProperties.set( propFlag );
		else		updateAllFilledPropertiesFlag();
		
	//	trace("markProperty "+readProperties(propFlag)+" = "+isSet);
		invalidate( propFlag );
	}
	
	
	public inline function has (propFlag:Int) : Bool		{ return allFilledProperties.has( propFlag ); }
	public inline function doesntHave (propFlag:Int) : Bool	{ return allFilledProperties.hasNone( propFlag ); }
	public inline function owns (propFlag:Int) : Bool		{ return filledProperties.has( propFlag ); }
	public function isEmpty () : Bool						{ return filledProperties == 0; }
	
	
	public function updateAllFilledPropertiesFlag () : Void									{ Assert.abstract(); }
	public function getPropertiesWithout (noExtendedStyle:Bool, noSuperStyle:Bool) : Int	{ Assert.abstract(); return 0; }
	
	
#if debug
	public function readProperties ( flags:Int = -1 )	: String	{ Assert.abstract(); return null; }
	public inline function readAll () : String						{ return readProperties( allFilledProperties ); }
#end
	
	
#if neko
	#if	debug
		public var cssName : String;
		public function toString ()						{ return cssName; }
	#else
		public function toString ()						{ return toCSS(); }
	#end
	
	public function toCSS (prefix:String = "") 		{ Assert.abstract(); return ""; }
	public function cleanUp ()						{ Assert.abstract(); }
	public function toCode (code:ICodeGenerator)	{ Assert.abstract(); }
#end
}