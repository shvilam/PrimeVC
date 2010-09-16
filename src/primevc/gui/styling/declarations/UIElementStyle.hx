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
 import primevc.gui.core.ISkin;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.shapes.IGraphicShape;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end


/**
 * Class contains the style-data for a specifig UIElement
 * 
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
class UIElementStyle extends StyleDeclarationBase < UIElementStyle >
{
	public var skin			(getSkin,		setSkin)		: Class < ISkin >;
	public var background	(getBackground, setBackground)	: IFill;
	public var border		(getBorder,		setBorder)		: IBorder<IFill>;
	public var shape		(getShape,		setShape)		: IGraphicShape;
	
	public var layout		(getLayout,		setLayout)		: LayoutStyleDeclarations;
	public var font			(getFont,		setFont)		: FontStyleDeclarations;
	
	public var effects		(getEffects,	setEffects)		: EffectStyleDeclarations;
	public var filters		(getFilters,	setFilters)		: FilterStyleDeclarations;
	
	
	public function new (
		layout		: LayoutStyleDeclarations = null,
		font		: FontStyleDeclarations = null,
		shape		: IGraphicShape = null,
		background	: IFill = null,
		border		: IBorder < IFill > = null,
		skin		: Class< ISkin > = null,
		effects		: EffectStyleDeclarations = null,
		filters		: FilterStyleDeclarations = null
	)
	{
		super();
		init();
		this.layout		= layout;
		this.font		= font;
		this.shape		= shape;
		this.background	= background;
		this.border		= border;
		this.skin		= skin;
		this.effects	= effects;
		this.filters	= filters;
	}
	
	
	private function init () : Void;
	
	
	override public function dispose ()
	{
	//	if ((untyped this).skin != null)		skin.dispose();
		if ((untyped this).shape != null)		shape.dispose();
		if ((untyped this).background != null)	background.dispose();
		if ((untyped this).border != null)		border.dispose();
		if ((untyped this).layout != null)		layout.dispose();
		if ((untyped this).font != null)		font.dispose();
		if ((untyped this).effects != null)		effects.dispose();
		if ((untyped this).filters != null)		filters.dispose();
		
		skin		= null;
		shape		= null;
		background	= null;
		border		= null;
		layout		= null;
		font		= null;
		effects		= null;
		filters		= null;
		
		super.dispose();
	}
	
	
	
	//
	// GETTERS
	//
	
	private function getSkin ()
	{
		if		(skin != null)			return skin;
		else if (extendedStyle != null)	return extendedStyle.skin;
		else if (superStyle != null)	return superStyle.skin;
		else							return null;
	}
	
	
	private function getShape ()
	{
		if		(shape != null)			return shape;
		else if (extendedStyle != null)	return extendedStyle.shape;
		else if (superStyle != null)	return superStyle.shape;
		else							return null;
	}
	
	
	private function getLayout ()
	{
		if		(layout != null)		return layout;
		else if (extendedStyle != null)	return extendedStyle.layout;
		else if (superStyle != null)	return superStyle.layout;
		else							return null;
	}
	
	
	private function getFont ()
	{
		if		(font != null)				return font;
		else if (extendedStyle != null)		return extendedStyle.font;
		else if (nestingInherited != null)	return nestingInherited.font;
		else if (superStyle != null)		return superStyle.font;
		else								return null;
	}


	private function getBackground ()
	{
		if		(background != null)	return background;
		else if (extendedStyle != null)	return extendedStyle.background;
		else if (superStyle != null)	return superStyle.background;
		else							return null;
	}


	private function getBorder ()
	{
		if		(border != null)		return border;
		else if (extendedStyle != null)	return extendedStyle.border;
		else if (superStyle != null)	return superStyle.border;
		else							return null;
	}
	
	
	private function getEffects ()
	{
		if		(effects != null)		return effects;
		else if (extendedStyle != null)	return extendedStyle.effects;
		else if (superStyle != null)	return superStyle.effects;
		else							return null;
	}


	private function getFilters ()
	{
		if		(filters != null)		return filters;
		else if (extendedStyle != null)	return extendedStyle.filters;
		else if (superStyle != null)	return superStyle.filters;
		else							return null;
	}
	
	
	
	//
	// SETTERS
	//
	
	private inline function setSkin (v)
	{
		if (v != skin) {
			skin = v;
			invalidate( StyleFlags.SKIN );
		}
		return v;
	}


	private inline function setShape (v)
	{
		if (v != shape) {
			shape = v;
			invalidate( StyleFlags.SHAPE );
		}
		return v;
	}
	
	
	private inline function setLayout (v)
	{
		if (v != layout) {
			layout = v;
			invalidate( StyleFlags.LAYOUT );
		}
		return v;
	}
	
	
	private inline function setFont (v)
	{
		if (v != font) {
			font = v;
			invalidate( StyleFlags.FONT );
		}
		return v;
	}
	
	
	private inline function setBackground (v)
	{
		if (v != background) {
			background = v;
			invalidate( StyleFlags.BACKGROUND );
		}
		return v;
	}


	private inline function setBorder (v)
	{
		if (v != border) {
			border = v;
			invalidate( StyleFlags.BORDER );
		}
		return v;
	}


	private inline function setEffects (v)
	{
		if (v != effects) {
			effects = v;
			invalidate( StyleFlags.EFFECTS );
		}
		return v;
	}


	private inline function setFilters (v)
	{
		if (v != filters) {
			filters = v;
			invalidate( StyleFlags.FILTERS );
		}
		return v;
	}


#if debug
	public function toString ()
	{
		var css = "";
		
		if (skin != null)		css += "\tskin: " + skin + ";";
		if (shape != null)		css += "\n\tshape: " + shape + ";";
		if (background != null)	css += "\n\tbackground: " + background + ";";
		if (border != null)		css += "\n\tborder: "+ border + ";";
		if (layout != null)		css += layout;
		if (font != null)		css += font;
		if (effects != null)	css += effects;
		if (filters != null)	css += filters;
		
		return "{\n" + css + "\n}";
	}
#end

#if neko
	override public function toCode (code:ICodeGenerator)
	{
		code.construct(this, [ layout, font, shape, background, border, skin, effects, filters ]);
		super.toCode(code);
	}
#end
}