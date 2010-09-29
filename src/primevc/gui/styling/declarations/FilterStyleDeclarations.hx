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
 import primevc.gui.filters.BitmapFilter;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end



/**
 * Class holding all filter style properties.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 07, 2010
 */
class FilterStyleDeclarations extends StylePropertyGroup
{
	private var type		: FilterCollectionType;
	private var _shadow		: BitmapFilter;
	
	public var shadow	(getShadow, setShadow)	: BitmapFilter;
	
	
	
	public function new (newType:FilterCollectionType, shadow:BitmapFilter = null)
	{
		super();
		type	= newType;
		_shadow = shadow;
	}
	
	
	//
	// GETTERS
	//
	
	private inline function getExtendedBox () : FilterStyleDeclarations
	{
		var e = getExtended();
		var b:FilterStyleDeclarations = null;
		
		if (e != null)
			b = type == FilterCollectionType.box ? e.boxFilters : e.bgFilters;
		
		return b;
	}
	
	
	private inline function getSuperBox () : FilterStyleDeclarations
	{
		var s = getSuper();
		var b:FilterStyleDeclarations = null;
		
		if (s != null)
			b = type == FilterCollectionType.box ? s.boxFilters : s.bgFilters;
		
		return b;
	}
	
	
	private function getShadow ()
	{
		var v = _shadow;
		if (v == null && getExtended() != null)		v = getExtendedBox().shadow;
		if (v == null && getSuper() != null)		v = getSuperBox().shadow;
		return v;	
	}
	
	
	//
	// SETTERS
	//
	
	private function setShadow (v)
	{
		if (v != _shadow) {
			_shadow = v;
			invalidate( FilterFlags.SHADOW );
		}
		return v;
	}
	
	
	
#if (neko || debug)
	override public function toCSS (prefix:String = "")
	{
		var css = [];
		
		var propPrefix = (type == FilterCollectionType.box) ? "box-" : "background-";
		if (_shadow != null)	css.push( propPrefix + "shadow: " + _shadow );
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
	
	
	override public function isEmpty ()
	{
		return _shadow == null;
	}
#end


#if neko
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
		{
			code.construct( this, [ type, _shadow ] );
		}
	}
#end
}