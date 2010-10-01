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
	private var type			: FilterCollectionType;
	private var _shadow			: BitmapFilter;
	private var _bevel			: BitmapFilter;
	private var _blur			: BitmapFilter;
	private var _glow			: BitmapFilter;
	private var _gradientBevel	: BitmapFilter;
	private var _gradientGlow	: BitmapFilter;
	
	
	public var shadow			(getShadow,			setShadow)			: BitmapFilter;
	public var bevel			(getBevel,			setBevel)			: BitmapFilter;
	public var blur				(getBlur,			setBlur)			: BitmapFilter;
	public var glow				(getGlow,			setGlow)			: BitmapFilter;
	public var gradientBevel	(getGradientBevel,	setGradientBevel)	: BitmapFilter;
	public var gradientGlow		(getGradientGlow,	setGradientGlow)	: BitmapFilter;
	
	
	
	public function new (newType:FilterCollectionType, shadow:BitmapFilter = null, bevel:BitmapFilter = null, blur:BitmapFilter = null, glow:BitmapFilter = null, gradientBevel:BitmapFilter = null, gradientGlow:BitmapFilter = null)
	{
		super();
		type			= newType;
		_shadow 		= shadow;
		_bevel			= bevel;
		_blur			= blur;
		_glow			= glow;
		_gradientBevel	= gradientBevel;
		_gradientGlow	= gradientGlow;
	}
	
	
	override public function dispose ()
	{
		_shadow = _bevel = _blur = _glow = _gradientBevel = _gradientGlow = null;
		super.dispose();
	}
	
	
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
	
	
	
	
	//
	// GETTERS
	//
	
	
	private function getShadow ()
	{
		var v = _shadow;
		if (v == null && getExtended() != null)		v = getExtendedBox().shadow;
		if (v == null && getSuper() != null)		v = getSuperBox().shadow;
		return v;
	}
	
	
	private function getBevel ()
	{
		var v = _bevel;
		if (v == null && getExtended() != null)		v = getExtendedBox().bevel;
		if (v == null && getSuper() != null)		v = getSuperBox().bevel;
		return v;
	}
	
	
	private function getBlur ()
	{
		var v = _blur;
		if (v == null && getExtended() != null)		v = getExtendedBox().blur;
		if (v == null && getSuper() != null)		v = getSuperBox().blur;
		return v;
	}
	
	
	private function getGlow ()
	{
		var v = _glow;
		if (v == null && getExtended() != null)		v = getExtendedBox().glow;
		if (v == null && getSuper() != null)		v = getSuperBox().glow;
		return v;
	}
	
	
	private function getGradientBevel ()
	{
		var v = _gradientBevel;
		if (v == null && getExtended() != null)		v = getExtendedBox().gradientBevel;
		if (v == null && getSuper() != null)		v = getSuperBox().gradientBevel;
		return v;
	}


	private function getGradientGlow ()
	{
		var v = _gradientGlow;
		if (v == null && getExtended() != null)		v = getExtendedBox().gradientGlow;
		if (v == null && getSuper() != null)		v = getSuperBox().gradientGlow;
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
	
	
	private function setBevel (v)
	{
		if (v != _bevel) {
			_bevel = v;
			invalidate( FilterFlags.BEVEL );
		}
		return v;
	}
	
	
	private function setBlur (v)
	{
		if (v != _blur) {
			_blur = v;
			invalidate( FilterFlags.BLUR );
		}
		return v;
	}
	
	
	private function setGlow (v)
	{
		if (v != _glow) {
			_glow = v;
			invalidate( FilterFlags.GLOW );
		}
		return v;
	}
	
	
	private function setGradientBevel (v)
	{
		if (v != _gradientBevel) {
			_gradientBevel = v;
			invalidate( FilterFlags.GRADIENT_BEVEL );
		}
		return v;
	}
	
	
	private function setGradientGlow (v)
	{
		if (v != _gradientGlow) {
			_gradientGlow = v;
			invalidate( FilterFlags.GRADIENT_GLOW );
		}
		return v;
	}
	
	
	
	//
	// CODE / CSS METHODS
	//
	
	
#if (neko || debug)
	override public function toCSS (prefix:String = "")
	{
		var css = [];
		
		var propPrefix = (type == FilterCollectionType.box) ? "box-" : "background-";
		
		if (_shadow != null)		css.push( propPrefix + "shadow: " + _shadow );
		if (_bevel != null)			css.push( propPrefix + "bevel: " + _bevel );
		if (_blur != null)			css.push( propPrefix + "blur: " + _blur );
		if (_glow != null)			css.push( propPrefix + "glow: " + _glow );
		if (_gradientBevel != null)	css.push( propPrefix + "gradient-bevel: " + _gradientBevel );
		if (_gradientGlow != null)	css.push( propPrefix + "gradient-glow: " + _gradientGlow );
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
	
	
	override public function isEmpty ()
	{
		return _shadow == null && _glow == null && _bevel == null && _blur == null && _gradientBevel == null && _gradientGlow == null;
	}
#end


#if neko
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ type, _shadow, _bevel, _blur, _glow, _gradientBevel, _gradientGlow ] );
	}
#end
}