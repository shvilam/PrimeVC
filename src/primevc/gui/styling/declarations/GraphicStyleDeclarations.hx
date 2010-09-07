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
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;


/**
 * Class holding all style properties for the graphics.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class GraphicStyleDeclarations extends StyleDeclarationBase < GraphicStyleDeclarations >
{
	public var background			(getBackground, setBackground)	: IFill;
	public var border				(getBorder,		setBorder)		: IBorder<IFill>;
	
	
	public function new (background:IFill = null, border:IBorder<IFill> = null)
	{
		super();
		this.background	= background;
		this.border		= border;
	}
	
	
	override public function dispose ()
	{
		if ((untyped this).background != null)	background.dispose();
		if ((untyped this).border != null)		border.dispose();
		
		background	= null;
		border		= null;
		super.dispose();
	}
	
	
	
	//
	// GETTERS
	//
	
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
	
	
	//
	// SETTERS
	//
	
	private inline function setBackground (v)
	{
		if (v != background) {
			background = v;
			invalidate( StyleFlags.GRAPHICS_BG );
		}
		return v;
	}
	
	
	private inline function setBorder (v)
	{
		if (v != border) {
			border = v;
			invalidate( StyleFlags.GRAPHICS_BORDER );
		}
		return v;
	}


#if debug
	public function toString ()
	{
		var css = [];

		if (background != null)	css.push("background: " + background);
		if (border != null)		css.push("border: "+border);

		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
#end
}