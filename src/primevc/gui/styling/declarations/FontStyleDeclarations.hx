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
	private var _size			: Int;
	private var _family			: String;
	private var _color			: Null < RGBA >;
	private var _weight			: FontWeight;
	private var _style			: FontStyle;
	private var _letterSpacing	: Float;
	private var _align			: TextAlign;
	private var _decoration		: TextDecoration;
	private var _indent			: Float;
	private var _transform		: TextTransform;
	private var _textWrap		: Null < Bool >;
	private var _columnCount	: Int;
	private var _columnGap		: Int;
	private var _columnWidth	: Int;
	
	
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
	
	public var textWrap			(getTextWrap,		setTextWrap)		: Null < Bool >;
	public var columnCount		(getColumnCount,	setColumnCount)		: Int;
	public var columnGap		(getColumnGap,		setColumnGap)		: Int;
	public var columnWidth		(getColumnWidth,	setColumnWidth)		: Int;
	
	
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
		transform:TextTransform		= null,
		textWrap:Null < Bool >		= null,
		columnCount:Int				= Number.INT_NOT_SET,
		columnGap:Int				= Number.INT_NOT_SET,
		columnWidth:Int				= Number.INT_NOT_SET
	)
	{
		super();
		_size			= size;
		_family			= family;
		_color			= color;
		_weight			= weight;
		_style			= null;
		_letterSpacing	= letterSpacing == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : letterSpacing;
		_align			= align;
		_decoration		= decoration;
		_indent			= indent == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : indent;
		_transform		= transform;
		_textWrap		= textWrap;
		_columnCount	= columnCount;
		_columnGap		= columnGap;
		_columnWidth	= columnWidth;
	}
	
	
	override public function dispose ()
	{
		_family		= null;
		_align		= null;
		_weight		= null;
		_style		= null;
		_decoration	= null;
		_transform	= null;
		_textWrap	= null;
		super.dispose();
	}
	
	
	
	
	//
	// GETTERS
	//
	
	
	private function getSize ()
	{
		var v = _size;
		if (v.notSet() && getExtended() != null)	v = getExtended().font.size;
		if (v.notSet() && getNesting() != null)		v = getNesting().font.size;
		if (v.notSet() && getSuper() != null)		v = getSuper().font.size;
		if (v.notSet() && getParent() != null)		v = getParent().font.size;
		
		return v;
	}
	
	
	private function getFamily ()
	{
		var v = _family;
		if (v == null && getExtended() != null)		v = getExtended().font.family;
		if (v == null && getNesting() != null)		v = getNesting().font.family;
		if (v == null && getSuper() != null)		v = getSuper().font.family;
		if (v == null && getParent() != null)		v = getParent().font.family;

		return v;
	}
	
	
	private function getColor ()
	{
		var v = _color;
		if (v == null && getExtended() != null)		v = getExtended().font.color;
		if (v == null && getNesting() != null)		v = getNesting().font.color;
		if (v == null && getSuper() != null)		v = getSuper().font.color;
		if (v == null && getParent() != null)		v = getParent().font.color;

		return v;
	}
	
	
	private function getAlign ()
	{
		var v = _align;
		if (v == null && getExtended() != null)		v = getExtended().font.align;
		if (v == null && getNesting() != null)		v = getNesting().font.align;
		if (v == null && getSuper() != null)		v = getSuper().font.align;
		if (v == null && getParent() != null)		v = getParent().font.align;

		return v;
	}
	
	
	private function getWeight ()
	{
		var v = _weight;
		if (v == null && getExtended() != null)		v = getExtended().font.weight;
		if (v == null && getNesting() != null)		v = getNesting().font.weight;
		if (v == null && getSuper() != null)		v = getSuper().font.weight;
		if (v == null && getParent() != null)		v = getParent().font.weight;

		return v;
	}
	
	
	private function getStyle ()
	{
		var v = _style;
		if (v == null && getExtended() != null)		v = getExtended().font.style;
		if (v == null && getNesting() != null)		v = getNesting().font.style;
		if (v == null && getSuper() != null)		v = getSuper().font.style;
		if (v == null && getParent() != null)		v = getParent().font.style;

		return v;
	}

	
	private function getLetterSpacing ()
	{
		var v = _letterSpacing;
		if (v.notSet() && getExtended() != null)	v = getExtended().font.letterSpacing;
		if (v.notSet() && getNesting() != null)		v = getNesting().font.letterSpacing;
		if (v.notSet() && getSuper() != null)		v = getSuper().font.letterSpacing;
		if (v.notSet() && getParent() != null)		v = getParent().font.letterSpacing;

		return v;
	}
	
	
	private function getDecoration ()
	{
		var v = _decoration;
		if (v == null && getExtended() != null)		v = getExtended().font.decoration;
		if (v == null && getNesting() != null)		v = getNesting().font.decoration;
		if (v == null && getSuper() != null)		v = getSuper().font.decoration;
		if (v == null && getParent() != null)		v = getParent().font.decoration;

		return v;
	}
	
	
	private function getIndent ()
	{
		var v = _indent;
		if (v.notSet() && getExtended() != null)	v = getExtended().font.indent;
		if (v.notSet() && getNesting() != null)		v = getNesting().font.indent;
		if (v.notSet() && getSuper() != null)		v = getSuper().font.indent;
		if (v.notSet() && getParent() != null)		v = getParent().font.indent;

		return v;
	}
	
	
	private function getTransform ()
	{
		var v = _transform;
		if (v == null && getExtended() != null)		v = getExtended().font.transform;
		if (v == null && getNesting() != null)		v = getNesting().font.transform;
		if (v == null && getSuper() != null)		v = getSuper().font.transform;
		if (v == null && getParent() != null)		v = getParent().font.transform;

		return v;
	}
	
	
	private function getTextWrap ()
	{
		var v = _textWrap;
		if (v == null && getExtended() != null)		v = getExtended().font.textWrap;
		if (v == null && getNesting() != null)		v = getNesting().font.textWrap;
		if (v == null && getSuper() != null)		v = getSuper().font.textWrap;
		if (v == null && getParent() != null)		v = getParent().font.textWrap;

		return v;
	}
	
	
	private function getColumnCount ()
	{
		var v = _columnCount;
		if (v.notSet() && getExtended() != null)	v = getExtended().font.columnCount;
		if (v.notSet() && getNesting() != null)		v = getNesting().font.columnCount;
		if (v.notSet() && getSuper() != null)		v = getSuper().font.columnCount;
		if (v.notSet() && getParent() != null)		v = getParent().font.columnCount;

		return v;
	}
	
	
	private function getColumnGap ()
	{
		var v = _columnGap;
		if (v.notSet() && getExtended() != null)	v = getExtended().font.columnGap;
		if (v.notSet() && getNesting() != null)		v = getNesting().font.columnGap;
		if (v.notSet() && getSuper() != null)		v = getSuper().font.columnGap;
		if (v.notSet() && getParent() != null)		v = getParent().font.columnGap;

		return v;
	}
	
	
	private function getColumnWidth ()
	{
		var v = _columnWidth;
		if (v.notSet() && getExtended() != null)	v = getExtended().font.columnWidth;
		if (v.notSet() && getNesting() != null)		v = getNesting().font.columnWidth;
		if (v.notSet() && getSuper() != null)		v = getSuper().font.columnWidth;
		if (v.notSet() && getParent() != null)		v = getParent().font.columnWidth;

		return v;
	}
	
	
	
	
	//
	// SETTERS
	//
	
	private function setSize (v)
	{
		if (v != _size) {
			_size = v;
			invalidate( FontFlags.SIZE );
		}
		return v;
	}
	
	
	private function setFamily (v)
	{
		if (v != _family) {
			_family = v;
			invalidate( FontFlags.FAMILY );
		}
		return v;
	}
	
	
	private function setColor (v:Null<RGBA>)
	{
		if (v != null)
			v = v.validate();
		
		if (v != _color) {
			_color = v;
			invalidate( FontFlags.COLOR );
		}
		return v;
	}
	
	
	private function setWeight (v)
	{
		if (v != _weight) {
			_weight = v;
			invalidate( FontFlags.WEIGHT );
		}
		return v;
	}
	
	
	private function setStyle (v)
	{
		if (v != _style) {
			_style = v;
			invalidate( FontFlags.STYLE );
		}
		return v;
	}
	
	
	private function setLetterSpacing (v)
	{
		if (v != _letterSpacing) {
			_letterSpacing = v;
			invalidate( FontFlags.LETTER_SPACING );
		}
		return v;
	}
	
	
	private function setAlign (v)
	{
		if (v != _align) {
			_align = v;
			invalidate( FontFlags.ALIGN );
		}
		return v;
	}
	
	
	private function setDecoration (v)
	{
		if (v != _decoration) {
			_decoration = v;
			invalidate( FontFlags.DECORATION );
		}
		return v;
	}
	
	
	private function setIndent (v)
	{
		if (v != _indent) {
			_indent = v;
			invalidate( FontFlags.INDENT );
		}
		return v;
	}
	
	
	private function setTransform (v)
	{
		if (v != _transform) {
			_transform = v;
			invalidate( FontFlags.TRANSFORM );
		}
		return v;
	}
	
	
	private function setTextWrap (v)
	{
		if (v != _textWrap) {
			_textWrap = v;
			invalidate( FontFlags.TEXTWRAP );
		}
		return v;
	}
	
	
	private function setColumnCount (v)
	{
		if (v != _columnCount) {
			_columnCount = v;
			invalidate( FontFlags.COLUMN_COUNT );
		}
		return v;
	}
	
	
	private function setColumnGap (v)
	{
		if (v != _columnGap) {
			_columnGap = v;
			invalidate( FontFlags.COLUMN_GAP );
		}
		return v;
	}
	
	
	private function setColumnWidth (v)
	{
		if (v != _columnWidth) {
			_columnWidth = v;
			invalidate( FontFlags.COLUMN_WIDTH );
		}
		return v;
	}
	
	
	

#if (debug || neko)
	override public function toCSS (prefix:String = "")
	{
		var css = [];
		
		if (_size.isSet())				css.push("font-size: " 		+ _size + "px");
		if (_family != null)			css.push("font-family: "	+ _family);
		if (_color != null)				css.push("color: "			+ _color.string());
		if (_weight != null)			css.push("font-weight: "	+ _weight);
		if (_style != null)				css.push("font-style: "		+ _style);
		if (_letterSpacing.isSet())		css.push("letter-spacing: "	+ _letterSpacing);
		if (_align != null)				css.push("text-align: "		+ _align);
		if (_decoration != null)		css.push("text-decoration: "+ _decoration);
		if (_indent.isSet())			css.push("text-indent: "	+ _indent);
		if (_transform != null)			css.push("text-transform: "	+ _transform);
		if (_textWrap != null)			css.push("text-wrap: "		+ _textWrap);
		if (_columnCount.isSet())		css.push("column-count: "	+ _columnCount);
		if (_columnGap.isSet())			css.push("column-gap: "		+ _columnGap);
		if (_columnWidth.isSet())		css.push("column-width: "	+ _columnWidth);
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
	
	
	override public function isEmpty () : Bool
	{
		return	_size.notSet() &&
				_family == null &&
				_color == null &&
				_weight == null &&
				_style == null &&
				_letterSpacing.notSet() &&
				_align == null &&
				_decoration == null &&
				_indent.notSet() &&
				_transform == null &&
				_textWrap == null &&
				_columnCount.notSet() &&
				_columnGap.notSet() &&
				_columnWidth.notSet();
	}
#end

#if neko
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ _size, _family, _color, _weight, _style, _letterSpacing, _align, _decoration, _indent, _transform, _textWrap, _columnCount, _columnGap, _columnWidth ] );
	}
#end
}