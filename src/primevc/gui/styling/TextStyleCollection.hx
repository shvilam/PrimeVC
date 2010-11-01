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
 import primevc.gui.components.ITextArea;
 import primevc.gui.styling.StyleCollectionBase;
 import primevc.gui.text.FontStyle;
 import primevc.gui.text.FontWeight;
 import primevc.gui.text.TextAlign;
 import primevc.gui.text.TextDecoration;
 import primevc.gui.text.TextFormat;
 import primevc.gui.text.TextTransform;
 import primevc.gui.traits.ITextStylable;
 import primevc.types.Number;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = TextStyleFlags;

/**
 * @author Ruben Weijers
 * @creation-date Okt 24, 2010
 */
class TextStyleCollection extends StyleCollectionBase < TextStyle >
{
	public function new (elementStyle:IUIElementStyle)			{ super( elementStyle, StyleFlags.FONT ); }
	override public function forwardIterator ()					{ return cast new TextStyleCollectionForwardIterator( elementStyle, propertyTypeFlag); }
	override public function reversedIterator ()				{ return cast new TextStyleCollectionReversedIterator( elementStyle, propertyTypeFlag); }

#if debug
	override public function readProperties (props:Int = -1)	{ return Flags.readProperties( (props == -1) ? filledProperties : props ); }
#end
	
	
	override public function apply ()
	{
		if (changes == 0 || !elementStyle.target.is(ITextStylable))
			return;
		
		var target		= elementStyle.target.as(ITextStylable);
#if flash9
		var textFormat	= target.textStyle;
		if (textFormat == null)
			textFormat	= new TextFormat();
		
	//	trace(target + ".applyFontStyling1 "+readProperties( changes )+"; changes "+changes);
		
		for (styleObj in this)
		{
			if (changes == 0)
				break;
			
			if (!styleObj.allFilledProperties.has( changes ))
				continue;
			
			var propsToSet	= styleObj.allFilledProperties.filter( changes );
			changes			= changes.unset( propsToSet );
			applyStyleObject( propsToSet, styleObj, textFormat );
		}
		
		if (changes > 0)
		{
			applyStyleObject( changes, null, textFormat );
			changes = 0;
		}
		
		target.textStyle = textFormat;
#end
	}
	
	
#if flash9
	private function applyStyleObject ( propsToSet:UInt, styleObj:TextStyle, textFormat:TextFormat )
	{
		var empty		= styleObj == null;
		var target		= elementStyle.target.as(ITextStylable);
		
		if (propsToSet.has( Flags.ALIGN ))			textFormat.align			= empty ? TextAlign.LEFT		: styleObj.align;
		if (propsToSet.has( Flags.COLOR ))			textFormat.color			= empty ? 0x00					: styleObj.color;
		if (propsToSet.has( Flags.DECORATION ))		textFormat.underline		= empty ? false					: styleObj.decoration == TextDecoration.underline;
		if (propsToSet.has( Flags.FAMILY ))			textFormat.font				= empty ? "Times New Roman"		: styleObj.family;
		if (propsToSet.has( Flags.INDENT ))			textFormat.indent			= empty ? 0						: styleObj.indent;
		if (propsToSet.has( Flags.LETTER_SPACING ))	textFormat.letterSpacing	= empty ? 0						: styleObj.letterSpacing;
		if (propsToSet.has( Flags.SIZE ))			textFormat.size				= empty ? 12					: styleObj.size;
		if (propsToSet.has( Flags.STYLE ))			textFormat.italic			= empty ? false					: styleObj.style == FontStyle.italic;
		if (propsToSet.has( Flags.WEIGHT ))			textFormat.bold				= empty ? false					: styleObj.weight != FontWeight.normal;
		
		if (propsToSet.has( Flags.TRANSFORM ))		textFormat.transform		= empty ? TextTransform.none	: styleObj.transform;
		if (propsToSet.has( Flags.TEXTWRAP ))		target.wordWrap				= empty ? false					: styleObj.textWrap;
		
		if (propsToSet.has( Flags.COLUMN_PROPERTIES ) && elementStyle.target.is(ITextArea))
		{
			var textArea = elementStyle.target.as(ITextArea);
			if (propsToSet.has( Flags.COLUMN_COUNT ))	textArea.maxColumns		= empty ? Number.INT_NOT_SET : styleObj.columnCount;
			if (propsToSet.has( Flags.COLUMN_GAP ))		textArea.columnGap		= empty ? Number.INT_NOT_SET : styleObj.columnGap;
			if (propsToSet.has( Flags.COLUMN_WIDTH ))	textArea.columnWidth	= empty ? Number.INT_NOT_SET : styleObj.columnWidth;
		}
	}
#end
}



class TextStyleCollectionForwardIterator extends StyleCollectionForwardIterator < TextStyle >
{
	override public function next ()	{ return setNext().data.font; }
}


class TextStyleCollectionReversedIterator extends StyleCollectionReversedIterator < TextStyle >
{
	override public function next ()	{ return setNext().data.font; }
}