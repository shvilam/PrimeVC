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
package primevc.gui.styling;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.core.traits.IInvalidatable;
 import primevc.gui.text.FontStyle;
 import primevc.gui.text.FontWeight;
 import primevc.gui.text.TextAlign;
 import primevc.gui.text.TextDecoration;
 import primevc.gui.text.TextTransform;
 import primevc.types.Number;
 import primevc.types.RGBA;
 import primevc.utils.NumberUtil;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.Color;


private typedef Flags = TextStyleFlags;


/**
 * Class holding all style properties for fonts.
 * Font properties are also inheritable of the container object.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class TextStyle extends StyleSubBlock
{
	private var extendedStyle	: TextStyle;
	private var nestingStyle	: TextStyle;
	private var superStyle		: TextStyle;
	private var parentStyle		: TextStyle;
	
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
		this.textWrap		= textWrap;
		this.columnCount	= columnCount;
		this.columnGap		= columnGap;
		this.columnWidth	= columnWidth;
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
	
	
	override private function updateOwnerReferences (changedReference:Int) : Void
	{
		if (changedReference.has( StyleFlags.EXTENDED_STYLE ))
		{
			if (extendedStyle != null)
				extendedStyle.listeners.remove( this );
			
			extendedStyle = null;
			if (owner != null && owner.extendedStyle != null)
			{
				extendedStyle = owner.extendedStyle.font;
				
				if (extendedStyle != null)
					extendedStyle.listeners.add( this );
			}
		}
		
		
		
		if (changedReference.has( StyleFlags.NESTING_STYLE ))
		{
			if (nestingStyle != null)
				nestingStyle.listeners.remove( this );
			
			nestingStyle = null;
			if (owner != null && owner.nestingInherited != null)
			{
				nestingStyle = owner.nestingInherited.font;
				
				if (nestingStyle != null)
					nestingStyle.listeners.add( this );
			}
		}
		
		
		
		if (changedReference.has( StyleFlags.SUPER_STYLE ))
		{
			if (superStyle != null)
				superStyle.listeners.remove( this );
			
			superStyle = null;
			if (owner != null && owner.superStyle != null)
			{
				superStyle = owner.superStyle.font;
				
				if (superStyle != null)
					superStyle.listeners.add( this );
			}
		}
		
		
		
		if (changedReference.has( StyleFlags.PARENT_STYLE ))
		{
			if (parentStyle != null)
				parentStyle.listeners.remove( this );
			
			parentStyle = null;
			if (owner != null && owner.parentStyle != null)
			{
				parentStyle = owner.parentStyle.font;
				
				if (parentStyle != null)
					parentStyle.listeners.add( this );
			}
		}
	}
	
	
	override public function updateAllFilledPropertiesFlag ()
	{
		super.updateAllFilledPropertiesFlag();
		
		if (allFilledProperties < Flags.ALL_PROPERTIES && extendedStyle != null)	allFilledProperties |= extendedStyle.allFilledProperties;
		if (allFilledProperties < Flags.ALL_PROPERTIES && nestingStyle != null)		allFilledProperties |= nestingStyle.allFilledProperties;
		if (allFilledProperties < Flags.ALL_PROPERTIES && superStyle != null)		allFilledProperties |= superStyle.allFilledProperties;
		if (allFilledProperties < Flags.ALL_PROPERTIES && parentStyle != null)		allFilledProperties |= parentStyle.allFilledProperties;
	}
	
	
	override private function isPropAnStyleReference ( property)
	{
		return super.isPropAnStyleReference(property) || property == StyleFlags.NESTING_STYLE || property == StyleFlags.PARENT_STYLE;
	}
	
	
	/**
	 * Method is called when a property in the parent-, super-, extended- or 
	 * nested-style is changed. If the property is not set in this style-object,
	 * it means that the allFilledPropertiesFlag needs to be changed..
	 */
	override public function invalidateCall ( changeFromOther:Int, sender:IInvalidatable ) : Void
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
		var propIsInNesting		= nestingStyle != null	&& nestingStyle	.allFilledProperties.has( changeFromOther );
		var propIsInParent		= parentStyle != null	&& parentStyle	.allFilledProperties.has( changeFromOther );
		
		if (sender == extendedStyle)
		{
			if (propIsInExtended)	allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the nesting style and the extendedStyle doesn't have the property that is changed, broadcast the change as well
		else if (sender == nestingStyle && !propIsInExtended)
		{
			if (propIsInNesting)	allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the super style and the nesting- and extendedStyle doesn't have the property that is changed, broadcast the change as well
		else if (sender == superStyle && !propIsInExtended && !propIsInNesting)
		{
			if (propIsInSuper)		allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the parent style and the other styles doesn't have the property that is changed, broadcast the change as well
		else if (sender == parentStyle && !propIsInExtended && !propIsInNesting && !propIsInSuper)
		{
			if (propIsInParent)		allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		return;
	}
	
	
	
	//
	// GETTERS
	//
	
	private function getSize ()
	{
		var v = _size;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.size;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.size;
		if (v.notSet() && superStyle != null)		v = superStyle.size;
		if (v.notSet() && parentStyle != null)		v = parentStyle.size;
		
		return v;
	}
	
	
	private function getFamily ()
	{
		var v = _family;
		if (v == null && extendedStyle != null)		v = extendedStyle.family;
		if (v == null && nestingStyle != null)		v = nestingStyle.family;
		if (v == null && superStyle != null)		v = superStyle.family;
		if (v == null && parentStyle != null)		v = parentStyle.family;

		return v;
	}
	
	
	private function getColor ()
	{
		var v = _color;
		if (v == null && extendedStyle != null)		v = extendedStyle.color;
		if (v == null && nestingStyle != null)		v = nestingStyle.color;
		if (v == null && superStyle != null)		v = superStyle.color;
		if (v == null && parentStyle != null)		v = parentStyle.color;

		return v;
	}
	
	
	private function getAlign ()
	{
		var v = _align;
		if (v == null && extendedStyle != null)		v = extendedStyle.align;
		if (v == null && nestingStyle != null)		v = nestingStyle.align;
		if (v == null && superStyle != null)		v = superStyle.align;
		if (v == null && parentStyle != null)		v = parentStyle.align;

		return v;
	}
	
	
	private function getWeight ()
	{
		var v = _weight;
		if (v == null && extendedStyle != null)		v = extendedStyle.weight;
		if (v == null && nestingStyle != null)		v = nestingStyle.weight;
		if (v == null && superStyle != null)		v = superStyle.weight;
		if (v == null && parentStyle != null)		v = parentStyle.weight;

		return v;
	}
	
	
	private function getStyle ()
	{
		var v = _style;
		if (v == null && extendedStyle != null)		v = extendedStyle.style;
		if (v == null && nestingStyle != null)		v = nestingStyle.style;
		if (v == null && superStyle != null)		v = superStyle.style;
		if (v == null && parentStyle != null)		v = parentStyle.style;

		return v;
	}

	
	private function getLetterSpacing ()
	{
		var v = _letterSpacing;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.letterSpacing;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.letterSpacing;
		if (v.notSet() && superStyle != null)		v = superStyle.letterSpacing;
		if (v.notSet() && parentStyle != null)		v = parentStyle.letterSpacing;

		return v;
	}
	
	
	private function getDecoration ()
	{
		var v = _decoration;
		if (v == null && extendedStyle != null)		v = extendedStyle.decoration;
		if (v == null && nestingStyle != null)		v = nestingStyle.decoration;
		if (v == null && superStyle != null)		v = superStyle.decoration;
		if (v == null && parentStyle != null)		v = parentStyle.decoration;

		return v;
	}
	
	
	private function getIndent ()
	{
		var v = _indent;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.indent;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.indent;
		if (v.notSet() && superStyle != null)		v = superStyle.indent;
		if (v.notSet() && parentStyle != null)		v = parentStyle.indent;

		return v;
	}
	
	
	private function getTransform ()
	{
		var v = _transform;
		if (v == null && extendedStyle != null)		v = extendedStyle.transform;
		if (v == null && nestingStyle != null)		v = nestingStyle.transform;
		if (v == null && superStyle != null)		v = superStyle.transform;
		if (v == null && parentStyle != null)		v = parentStyle.transform;

		return v;
	}
	
	
	private function getTextWrap ()
	{
		var v = _textWrap;
		if (v == null && extendedStyle != null)		v = extendedStyle.textWrap;
		if (v == null && nestingStyle != null)		v = nestingStyle.textWrap;
		if (v == null && superStyle != null)		v = superStyle.textWrap;
		if (v == null && parentStyle != null)		v = parentStyle.textWrap;

		return v;
	}
	
	
	private function getColumnCount ()
	{
		var v = _columnCount;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.columnCount;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.columnCount;
		if (v.notSet() && superStyle != null)		v = superStyle.columnCount;
		if (v.notSet() && parentStyle != null)		v = parentStyle.columnCount;

		return v;
	}
	
	
	private function getColumnGap ()
	{
		var v = _columnGap;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.columnGap;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.columnGap;
		if (v.notSet() && superStyle != null)		v = superStyle.columnGap;
		if (v.notSet() && parentStyle != null)		v = parentStyle.columnGap;

		return v;
	}
	
	
	private function getColumnWidth ()
	{
		var v = _columnWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.columnWidth;
		if (v.notSet() && nestingStyle != null)		v = nestingStyle.columnWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.columnWidth;
		if (v.notSet() && parentStyle != null)		v = parentStyle.columnWidth;

		return v;
	}
	
	
	
	
	//
	// SETTERS
	//
	
	private function setSize (v)
	{
		if (v != _size) {
			_size = v;
			markProperty( Flags.SIZE, v.isSet() );
		}
		return v;
	}
	
	
	private function setFamily (v)
	{
		if (v != _family) {
			_family = v;
			markProperty( Flags.FAMILY, v != null );
		}
		return v;
	}
	
	
	private function setColor (v:Null<RGBA>)
	{
		if (v != null)
			v = v.validate();
		
		if (v != _color) {
			_color = v;
			markProperty( Flags.COLOR, v != null );
		}
		return v;
	}
	
	
	private function setWeight (v)
	{
		if (v != _weight) {
			_weight = v;
			markProperty( Flags.WEIGHT, v != null );
		}
		return v;
	}
	
	
	private function setStyle (v)
	{
		if (v != _style) {
			_style = v;
			markProperty( Flags.STYLE, v != null );
		}
		return v;
	}
	
	
	private function setLetterSpacing (v)
	{
		if (v != _letterSpacing) {
			_letterSpacing = v;
			markProperty( Flags.LETTER_SPACING, v.isSet() );
		}
		return v;
	}
	
	
	private function setAlign (v)
	{
		if (v != _align) {
			_align = v;
			markProperty( Flags.ALIGN, v != null );
		}
		return v;
	}
	
	
	private function setDecoration (v)
	{
		if (v != _decoration) {
			_decoration = v;
			markProperty( Flags.DECORATION, v != null );
		}
		return v;
	}
	
	
	private function setIndent (v)
	{
		if (v != _indent) {
			_indent = v;
			markProperty( Flags.INDENT, v.isSet() );
		}
		return v;
	}
	
	
	private function setTransform (v)
	{
		if (v != _transform) {
			_transform = v;
			markProperty( Flags.TRANSFORM, v != null );
		}
		return v;
	}
	
	
	private function setTextWrap (v)
	{
		if (v != _textWrap) {
			_textWrap = v;
			markProperty( Flags.TEXTWRAP, v != null );
		}
		return v;
	}
	
	
	private function setColumnCount (v)
	{
		if (v != _columnCount) {
			_columnCount = v;
			markProperty( Flags.COLUMN_COUNT, v.isSet() );
		}
		return v;
	}
	
	
	private function setColumnGap (v)
	{
		if (v != _columnGap) {
			_columnGap = v;
			markProperty( Flags.COLUMN_GAP, v.isSet() );
		}
		return v;
	}
	
	
	private function setColumnWidth (v)
	{
		if (v != _columnWidth) {
			_columnWidth = v;
			markProperty( Flags.COLUMN_WIDTH, v.isSet() );
		}
		return v;
	}
	
	
	

#if neko
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
	
	
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
			code.construct( this, [ _size, _family, _color, _weight, _style, _letterSpacing, _align, _decoration, _indent, _transform, _textWrap, _columnCount, _columnGap, _columnWidth ] );
	}
	
	override public function cleanUp () {}
#end

#if debug
	override public function readProperties (flags:Int = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;
		
		return Flags.readProperties( flags );
	}
#end
}