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
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.gui.text.FontStyle;
 import primevc.gui.text.FontWeight;
 import primevc.gui.text.TextAlign;
 import primevc.gui.text.TextDecoration;
 import primevc.gui.text.TextTransform;
 import primevc.types.Number;
 import primevc.types.RGBA;
 import primevc.utils.NumberUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.Color;


/**
 * Class holding all style properties for fonts.
 * Font properties are also inheritable of the container object.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class FontStyleDeclarations extends StyleDeclarationBase < FontStyleDeclarations >
{
	public var size				(getSize,			setSize)			: Int;
	public var family			(getFamily,			setFamily)			: String;
	public var color			(getColor,			setColor)			: Null<RGBA>;
	public var weight			(getWeight,			setWeight)			: FontWeight;
	public var style			(getStyle,			setStyle)			: FontStyle;
	/**
	 * @default	0
	 */
	public var letterSpacing	(getLetterSpacing,	setLetterSpacing)	: Float;
	public var align			(getAlign,			setAlign)			: TextAlign;
	public var decoration		(getDecoration,		setDecoration)		: TextDecoration;
	public var indent			(getIndent,			setIndent)			: Float;
	public var transform		(getTransform,		setTransform)		: TextTransform;
	
	
	public function new (
		size:Int					= Number.INT_NOT_SET,
		family:String				= null,
		color:RGBA					= null,
		weight:FontWeight			= null,
		style:FontStyle				= null,
		letterSpacing:Float			= Number.INT_NOT_SET,
		align:TextAlign				= null,
		decoration:TextDecoration	= null,
		indent:Float				= Number.INT_NOT_SET,
		transform:TextTransform		= null
	)
	{
		super();
		this.size			= size;
		this.family			= family;
		this.color			= color;
		this.weight			= weight;
		this.style			= null;
		this.letterSpacing	= letterSpacing == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : letterSpacing;
		this.align			= align;
		this.decoration		= decoration;
		this.indent			= indent == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : indent;
		this.transform		= transform;
	}
	
	
	override public function dispose ()
	{
		family		= null;
		align		= null;
		weight		= null;
		style		= null;
		decoration	= null;
		transform	= null;
		super.dispose();
	}
	
	
	//
	// GETTERS
	//
	
	private function getSize ()
	{
		if		(size.isSet())				return size;
		else if (extendedStyle != null)		return extendedStyle.size;
		else if (nestingInherited != null)	return nestingInherited.size;
		else if (superStyle != null)		return superStyle.size;
		else								return Number.INT_NOT_SET;
	}
	
	
	private function getFamily ()
	{
		if		(family != null)			return family;
		else if (extendedStyle != null)		return extendedStyle.family;
		else if (nestingInherited != null)	return nestingInherited.family;
		else if (superStyle != null)		return superStyle.family;
		else								return null;
	}
	
	
	private function getColor ()
	{
		if		(color != null)				return color;
		else if (extendedStyle != null)		return extendedStyle.color;
		else if (nestingInherited != null)	return nestingInherited.color;
		else if (superStyle != null)		return superStyle.color;
		else								return null;
	}
	
	
	private function getAlign ()
	{
		if		(align != null)				return align;
		else if (extendedStyle != null)		return extendedStyle.align;
		else if (nestingInherited != null)	return nestingInherited.align;
		else if (superStyle != null)		return superStyle.align;
		else								return null;
	}
	
	
	private function getWeight ()
	{
		if		(weight != null)			return weight;
		else if (extendedStyle != null)		return extendedStyle.weight;
		else if (nestingInherited != null)	return nestingInherited.weight;
		else if (superStyle != null)		return superStyle.weight;
		else								return null;
	}
	
	
	private function getStyle ()
	{
		if		(style != null)				return style;
		else if (extendedStyle != null)		return extendedStyle.style;
		else if (nestingInherited != null)	return nestingInherited.style;
		else if (superStyle != null)		return superStyle.style;
		else								return null;
	}


	private function getLetterSpacing ()
	{
		if		(letterSpacing.isSet())		return letterSpacing;
		else if (extendedStyle != null)		return extendedStyle.letterSpacing;
		else if (nestingInherited != null)	return nestingInherited.letterSpacing;
		else if (superStyle != null)		return superStyle.letterSpacing;
		else								return Number.INT_NOT_SET;
	}
	
	
	private function getDecoration ()
	{
		if		(decoration != null)		return decoration;
		else if (extendedStyle != null)		return extendedStyle.decoration;
		else if (nestingInherited != null)	return nestingInherited.decoration;
		else if (superStyle != null)		return superStyle.decoration;
		else								return null;
	}
	
	
	private function getIndent ()
	{
		if		(indent.isSet())			return indent;
		else if (extendedStyle != null)		return extendedStyle.indent;
		else if (nestingInherited != null)	return nestingInherited.indent;
		else if (superStyle != null)		return superStyle.indent;
		else								return Number.INT_NOT_SET;
	}
	
	
	private function getTransform ()
	{
		if		(transform != null)			return transform;
		else if (extendedStyle != null)		return extendedStyle.transform;
		else if (nestingInherited != null)	return nestingInherited.transform;
		else if (superStyle != null)		return superStyle.transform;
		else								return null;
	}
	
	
	
	
	//
	// SETTERS
	//
	
	private inline function setSize (v)
	{
		if (v != size) {
			size = v;
			invalidate( FontFlags.SIZE );
		}
		return v;
	}
	
	
	private inline function setFamily (v)
	{
		if (v != family) {
			family = v;
			invalidate( FontFlags.FAMILY );
		}
		return v;
	}
	
	
	private inline function setColor (v:Null<RGBA>)
	{
		if (v != null)
			v = v.validate();
		
		if (v != color) {
			color = v;
			invalidate( FontFlags.COLOR );
		}
		return v;
	}
	
	
	private inline function setWeight (v)
	{
		if (v != weight) {
			weight = v;
			invalidate( FontFlags.WEIGHT );
		}
		return v;
	}
	
	
	private inline function setStyle (v)
	{
		if (v != style) {
			style = v;
			invalidate( FontFlags.STYLE );
		}
		return v;
	}
	
	
	private inline function setLetterSpacing (v)
	{
		if (v != letterSpacing) {
			letterSpacing = v;
			invalidate( FontFlags.LETTER_SPACING );
		}
		return v;
	}
	
	
	private inline function setAlign (v)
	{
		if (v != align) {
			align = v;
			invalidate( FontFlags.ALIGN );
		}
		return v;
	}
	
	
	private inline function setDecoration (v)
	{
		if (v != decoration) {
			decoration = v;
			invalidate( FontFlags.DECORATION );
		}
		return v;
	}
	
	
	private inline function setIndent (v)
	{
		if (v != indent) {
			indent = v;
			invalidate( FontFlags.INDENT );
		}
		return v;
	}
	
	
	private inline function setTransform (v)
	{
		if (v != transform) {
			transform = v;
			invalidate( FontFlags.TRANSFORM );
		}
		return v;
	}
	
	

#if debug
	public function toString ()
	{
		var css = [];
		
		if (size.isSet())			css.push("font-size: " 		+ size + "px");
		if (family != null)			css.push("font-family: "	+family);
		if (color != null)			css.push("color: "			+color.string());
		if (weight != null)			css.push("font-weight: "	+weight);
		if (style != null)			css.push("font-style: "		+style);
		if (letterSpacing != null)	css.push("letter-spacing: "	+letterSpacing);
		if (align != null)			css.push("text-align: "		+align);
		if (decoration != null)		css.push("text-decoration: "+decoration);
		if (indent.isSet())			css.push("text-indent: "	+indent);
		if (transform != null)		css.push("text-transform: "	+transform);
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
#end

#if neko
	override public function toCode (code:ICodeGenerator)
	{
		code.construct( this, [ size, family, color, weight, style, letterSpacing, align, decoration, indent, transform ] );
		super.toCode(code);
	}
#end
}