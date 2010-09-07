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
 import primevc.core.traits.Invalidatable;
 import primevc.gui.styling.StyleFlags;


/**
 * Base class for style declarations
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class StyleDeclarationBase <DeclarationType> extends Invalidatable
					,	implements IStyleDeclaration <DeclarationType>
#if (flash9 || cpp)	,	implements haxe.rtti.Generic #end
{
	public var nestingInherited		(default, setNestingInherited)	: DeclarationType;
	public var superStyle			(default, setSuperStyle)		: DeclarationType;
	public var extendedStyle		(default, setExtendedStyle)		: DeclarationType;
	
	
	override public function dispose ()
	{
		nestingInherited	= null;
		superStyle			= null;
		extendedStyle		= null;
		super.dispose();
	}
	
	
	private inline function setNestingInherited (v)
	{
		if (v != nestingInherited) {
			nestingInherited = v;
			invalidate( StyleFlags.NESTING_STYLE );
		}
		return v;
	}
	
	
	private inline function setSuperStyle (v)
	{
		if (v != superStyle) {
			superStyle = v;
			invalidate( StyleFlags.SUPER_STYLE );
		}
		return v;
	}


	private inline function setExtendedStyle (v)
	{
		if (v != extendedStyle) {
			extendedStyle = v;
			invalidate( StyleFlags.EXTENDED_STYLE );
		}
		return v;
	}
}