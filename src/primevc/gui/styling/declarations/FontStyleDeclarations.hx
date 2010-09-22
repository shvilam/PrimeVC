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
class FontStyleDeclarations extends StylePropertyGroup
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
		color:Null<RGBA>			= null,
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
		var v = size;
		if (v.notSet() && getExtended() != null)	v = getExtended().font.size;
		if (v.notSet() && getNesting() != null)		v = getNesting().font.size;
		if (v.notSet() && getSuper() != null)		v = getSuper().font.size;
		if (v.notSet() && getParent() != null)		v = getParent().font.size;
		
		return v;
	}
	
	
	private function getFamily ()
	{
		var v = family;
		if (v == null && getExtended() != null)		v = getExtended().font.family;
		if (v == null && getNesting() != null)		v = getNesting().font.family;
		if (v == null && getSuper() != null)		v = getSuper().font.family;
		if (v == null && getParent() != null)		v = getParent().font.family;

		return v;
	}
	
	
	private function getColor ()
	{
		var v = color;
		if (v == null && getExtended() != null)		v = getExtended().font.color;
		if (v == null && getNesting() != null)		v = getNesting().font.color;
		if (v == null && getSuper() != null)		v = getSuper().font.color;
		if (v == null && getParent() != null)		v = getParent().font.color;

		return v;
	}
	
	
	private function getAlign ()
	{
		var v = align;
		if (v == null && getExtended() != null)		v = getExtended().font.align;
		if (v == null && getNesting() != null)		v = getNesting().font.align;
		if (v == null && getSuper() != null)		v = getSuper().font.align;
		if (v == null && getParent() != null)		v = getParent().font.align;

		return v;
	}
	
	
	private function getWeight ()
	{
		var v = weight;
		if (v == null && getExtended() != null)		v = getExtended().font.weight;
		if (v == null && getNesting() != null)		v = getNesting().font.weight;
		if (v == null && getSuper() != null)		v = getSuper().font.weight;
		if (v == null && getParent() != null)		v = getParent().font.weight;

		return v;
	}
	
	
	private function getStyle ()
	{
		var v = style;
		if (v == null && getExtended() != null)		v = getExtended().font.style;
		if (v == null && getNesting() != null)		v = getNesting().font.style;
		if (v == null && getSuper() != null)		v = getSuper().font.style;
		if (v == null && getParent() != null)		v = getParent().font.style;

		return v;
	}


	private function getLetterSpacing ()
	{
		var v = letterSpacing;
		if (v.notSet() && getExtended() != null)	v = getExtended().font.letterSpacing;
		if (v.notSet() && getNesting() != null)		v = getNesting().font.letterSpacing;
		if (v.notSet() && getSuper() != null)		v = getSuper().font.letterSpacing;
		if (v.notSet() && getParent() != null)		v = getParent().font.letterSpacing;

		return v;
	}
	
	
	private function getDecoration ()
	{
		var v = decoration;
		if (v == null && getExtended() != null)		v = getExtended().font.decoration;
		if (v == null && getNesting() != null)		v = getNesting().font.decoration;
		if (v == null && getSuper() != null)		v = getSuper().font.decoration;
		if (v == null && getParent() != null)		v = getParent().font.decoration;

		return v;
	}
	
	
	private function getIndent ()
	{
		var v = indent;
		if (v.notSet() && getExtended() != null)	v = getExtended().font.indent;
		if (v.notSet() && getNesting() != null)		v = getNesting().font.indent;
		if (v.notSet() && getSuper() != null)		v = getSuper().font.indent;
		if (v.notSet() && getParent() != null)		v = getParent().font.indent;

		return v;
	}
	
	
	private function getTransform ()
	{
		var v = transform;
		if (v == null && getExtended() != null)		v = getExtended().font.transform;
		if (v == null && getNesting() != null)		v = getNesting().font.transform;
		if (v == null && getSuper() != null)		v = getSuper().font.transform;
		if (v == null && getParent() != null)		v = getParent().font.transform;

		return v;
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
	
	

#if (debug || neko)
	override public function toCSS (prefix:String = "")
	{
		var css = [];
		
		if (IntUtil.isSet(untyped size))			css.push("font-size: " 		+ size + "px");
		if ((untyped family) != null)				css.push("font-family: "	+family);
		if ((untyped color) != null)				css.push("color: "			+color.string());
		if ((untyped weight) != null)				css.push("font-weight: "	+weight);
		if ((untyped style) != null)				css.push("font-style: "		+style);
		if (FloatUtil.isSet(untyped letterSpacing))	css.push("letter-spacing: "	+letterSpacing);
		if ((untyped align) != null)				css.push("text-align: "		+align);
		if ((untyped decoration) != null)			css.push("text-decoration: "+decoration);
		if (FloatUtil.isSet(untyped indent))		css.push("text-indent: "	+indent);
		if ((untyped transform) != null)			css.push("text-transform: "	+transform);
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
	
	
	override public function isEmpty () : Bool
	{
		return	IntUtil.notSet(untyped size) &&
				(untyped family) == null &&
				(untyped color) == null &&
				(untyped weight) == null &&
				(untyped style) == null &&
				(untyped letterSpacing) == null &&
				(untyped align) == null &&
				(untyped decoration) == null &&
				(untyped indent) == null &&
				(untyped transform) == null;
	}
#end

#if neko
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ untyped size, untyped family, untyped color, untyped weight, untyped style, untyped letterSpacing, untyped align, untyped decoration, untyped indent, untyped transform ] );
	}
#end
}