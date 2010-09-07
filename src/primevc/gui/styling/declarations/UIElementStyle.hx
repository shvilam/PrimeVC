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
 import primevc.gui.styling.StyleFlags;
 import primevc.gui.core.ISkin;


/**
 * Class contains the style-data for a specifig UIElement
 * 
 * @author Ruben Weijers
 * @creation-date Aug 04, 2010
 */
class UIElementStyle extends StyleDeclarationBase < UIElementStyle >
{
	public var skin			(getSkin,		setSkin)		: ISkin;
	public var layout		(getLayout,		setLayout)		: LayoutStyleDeclarations;
	public var font			(getFont,		setFont)		: FontStyleDeclarations;
	public var graphics		(getGraphics,	setGraphics)	: GraphicStyleDeclarations;
	
	
	public function new (
		layout		: LayoutStyleDeclarations = null,
		font		: FontStyleDeclarations = null,
		graphics	: GraphicStyleDeclarations = null,
		skin		: ISkin = null
	)
	{
		super();
		this.layout		= layout;
		this.font		= font;
		this.graphics	= graphics;
		this.skin		= skin;
	}
	
	
	override public function dispose ()
	{
		if ((untyped this).layout != null)		layout.dispose();
		if ((untyped this).skin != null)		skin.dispose();
		if ((untyped this).font != null)		font.dispose();
		if ((untyped this).graphics != null)	graphics.dispose();
		
		layout		= null;
		graphics	= null;
		font		= null;
		skin		= null;
		
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


	private function getGraphics ()
	{
		if		(graphics != null)		return graphics;
		else if (extendedStyle != null)	return extendedStyle.graphics;
		else if (superStyle != null)	return superStyle.graphics;
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
	
	
	private inline function setGraphics (v)
	{
		if (v != graphics) {
			graphics = v;
			invalidate( StyleFlags.GRAPHICS );
		}
		return v;
	}


#if debug
	public function toString ()
	{
		var css = "";
		
		if (skin != null)		css += "\tskin: " + skin + ";\n";
		if (layout != null)		css += layout;
		if (font != null)		css += font;
		if (graphics != null)	css += graphics;
		
		return "{\n" + css + "\n}";
	}
#end
}