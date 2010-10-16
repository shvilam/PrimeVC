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
 import primevc.gui.filters.BitmapFilter;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
  using primevc.utils.BitUtil;


private typedef Flags = FilterFlags;


/**
 * Class holding all filter style properties.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 07, 2010
 */
class FilterStyleDeclarations extends StylePropertyGroup
{
	private var extendedStyle	: FilterStyleDeclarations;
	private var superStyle		: FilterStyleDeclarations;

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
		this.type			= newType;
		this.shadow 		= shadow;
		this.bevel			= bevel;
		this.blur			= blur;
		this.glow			= glow;
		this.gradientBevel	= gradientBevel;
		this.gradientGlow	= gradientGlow;
		
		validate();
	}
	
	
	override public function dispose ()
	{
		_shadow = _bevel = _blur = _glow = _gradientBevel = _gradientGlow = null;
		super.dispose();
	}
	
	
	override private function updateOwnerReferences (changedReference:UInt) : Void
	{
		if (changedReference.has( StyleFlags.EXTENDED_STYLE ))
		{
			if (extendedStyle != null)
				extendedStyle.listeners.remove( this );
			
			extendedStyle = null;
			if (owner != null && owner.extendedStyle != null)
			{
				extendedStyle = type == FilterCollectionType.box ? owner.extendedStyle.boxFilters : owner.extendedStyle.bgFilters;
				
				if (extendedStyle != null)
					extendedStyle.listeners.add( this );
			}
		}
		
		
		if (changedReference.has( StyleFlags.SUPER_STYLE ))
		{
			if (superStyle != null)
				superStyle.listeners.remove( this );
			
			superStyle = null;
			if (owner != null && owner.superStyle != null)
			{
				superStyle = type == FilterCollectionType.box ? owner.superStyle.boxFilters : owner.superStyle.bgFilters;
				
				if (superStyle != null)
					superStyle.listeners.add( this );
			}
		}
	}
	
	
	override private function updateAllFilledPropertiesFlag ()
	{
		super.updateAllFilledPropertiesFlag();
		
		if (allFilledProperties < Flags.ALL_PROPERTIES && extendedStyle != null)	allFilledProperties |= extendedStyle.allFilledProperties;
		if (allFilledProperties < Flags.ALL_PROPERTIES && superStyle != null)		allFilledProperties |= superStyle.allFilledProperties;
	}
	
	
	/**
	 * Method is called when a property in the super- or extended-style is 
	 * changed. If the property is not set in this style-object, it means that 
	 * the allFilledPropertiesFlag needs to be changed..
	 */
	override public function invalidateCall ( changeFromOther:UInt, sender:IInvalidatable ) : Void
	{
		Assert.that(sender != null);
		
		if (sender == owner)
			return super.invalidateCall( changeFromOther, sender );
		
		if (filledProperties.has( changeFromOther ))
			return;
		
		//The changed property is not in this style-object.
		//Check if the change should be broadcasted..
		var propIsInExtended	= extendedStyle != null	&& extendedStyle.allFilledProperties.has( changeFromOther );
		var propIsInSuper		= superStyle != null	&& superStyle	.allFilledProperties.has( changeFromOther );
		
		if (sender == extendedStyle)
		{
			if (propIsInExtended)	allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the super style and the extended-style doesn't have the property that is changed, broadcast the change as well
		else if (sender == superStyle && !propIsInExtended)
		{
			if (propIsInSuper)		allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		return;
	}
	
	
	
	//
	// GETTERS
	//
	
	
	private function getShadow ()
	{
		var v = _shadow;
		if (v == null && getExtended() != null)		v = extendedStyle.shadow;
		if (v == null && getSuper() != null)		v = superStyle.shadow;
		return v;
	}
	
	
	private function getBevel ()
	{
		var v = _bevel;
		if (v == null && getExtended() != null)		v = extendedStyle.bevel;
		if (v == null && getSuper() != null)		v = superStyle.bevel;
		return v;
	}
	
	
	private function getBlur ()
	{
		var v = _blur;
		if (v == null && getExtended() != null)		v = extendedStyle.blur;
		if (v == null && getSuper() != null)		v = superStyle.blur;
		return v;
	}
	
	
	private function getGlow ()
	{
		var v = _glow;
		if (v == null && getExtended() != null)		v = extendedStyle.glow;
		if (v == null && getSuper() != null)		v = superStyle.glow;
		return v;
	}
	
	
	private function getGradientBevel ()
	{
		var v = _gradientBevel;
		if (v == null && getExtended() != null)		v = extendedStyle.gradientBevel;
		if (v == null && getSuper() != null)		v = superStyle.gradientBevel;
		return v;
	}


	private function getGradientGlow ()
	{
		var v = _gradientGlow;
		if (v == null && getExtended() != null)		v = extendedStyle.gradientGlow;
		if (v == null && getSuper() != null)		v = superStyle.gradientGlow;
		return v;
	}
	
	
	
	
	//
	// SETTERS
	//
	
	
	private function setShadow (v)
	{
		if (v != _shadow) {
			_shadow = v;
			markProperty( Flags.SHADOW, v != null );
		}
		return v;
	}
	
	
	private function setBevel (v)
	{
		if (v != _bevel) {
			_bevel = v;
			markProperty( Flags.BEVEL, v != null );
		}
		return v;
	}
	
	
	private function setBlur (v)
	{
		if (v != _blur) {
			_blur = v;
			markProperty( Flags.BLUR, v != null );
		}
		return v;
	}
	
	
	private function setGlow (v)
	{
		if (v != _glow) {
			_glow = v;
			markProperty( Flags.GLOW, v != null );
		}
		return v;
	}
	
	
	private function setGradientBevel (v)
	{
		if (v != _gradientBevel) {
			_gradientBevel = v;
			markProperty( Flags.GRADIENT_BEVEL, v != null );
		}
		return v;
	}
	
	
	private function setGradientGlow (v)
	{
		if (v != _gradientGlow) {
			_gradientGlow = v;
			markProperty( Flags.GRADIENT_GLOW, v != null );
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

#if debug
	override public function readProperties (flags:Int = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;

		return Flags.readProperties(flags);
	}
#end
}