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
 import primevc.core.validators.IntRangeValidator;
 import primevc.gui.layout.IAdvancedLayoutClient;
 import primevc.gui.layout.ILayoutContainer;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.styling.StyleCollectionBase;
 import primevc.gui.traits.ILayoutable;
 import primevc.types.Number;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = LayoutFlags;



/**
 * @author Ruben Weijers
 * @creation-date Sep 23, 2010
 */
class LayoutCollection extends StyleCollectionBase < LayoutStyle >
{
	public function new (elementStyle:IUIElementStyle)			{ super( elementStyle, StyleFlags.LAYOUT ); }
	override public function forwardIterator ()					{ return cast new LayoutCollectionForwardIterator( elementStyle, propertyTypeFlag); }
	override public function reversedIterator ()				{ return cast new LayoutCollectionReversedIterator( elementStyle, propertyTypeFlag); }

#if debug
	override public function readProperties (props:Int = -1)	{ return Flags.readProperties( (props == -1) ? filledProperties : props ); }
#end

	
	override public function apply ()
	{
		if (changes == 0 || !elementStyle.target.is( ILayoutable ))
			return;
		
		var target = elementStyle.target.as( ILayoutable );
		
		var widthRange:IntRangeValidator = null;
		var heightRange:IntRangeValidator = null;
		
		
		
		//create size constraint for layout client
		if (changes.has( Flags.HEIGHT_CONSTRAINTS ))
		{
			if (!filledProperties.has(Flags.HEIGHT_CONSTRAINTS)) {
				target.layout.height.validator = null;
				changes = changes.unset( Flags.HEIGHT_CONSTRAINTS);
			}
			
			else
				heightRange = (target.layout.height.validator == null) ? new IntRangeValidator() : target.layout.height.validator.as( IntRangeValidator );
		}
		
		
		
		if (changes.has( Flags.WIDTH_CONSTRAINTS ))
		{
			if (!filledProperties.has(Flags.WIDTH_CONSTRAINTS)) {
				target.layout.width.validator = null;
				changes = changes.unset( Flags.WIDTH_CONSTRAINTS );
			}
			
			else
				widthRange = (target.layout.width.validator == null) ? new IntRangeValidator() : target.layout.width.validator.as( IntRangeValidator );
		}
		
		
		
		if (!target.layout.is(ILayoutContainer))
			changes = changes.unset( Flags.ALGORITHM | Flags.CHILD_WIDTH | Flags.CHILD_HEIGHT );
		
		if (changes == 0)
			return;
		
		
	//	trace(target + ".applyLayoutStyling1 "+readProperties( changes )+"; changes "+changes);
		
		for (styleObj in this)
		{
			if (changes == 0)
				break;
			
			if (!styleObj.allFilledProperties.has( changes ))
				continue;
			
			var propsToSet	= styleObj.allFilledProperties.filter( changes );
			changes			= changes.unset( propsToSet );
			applyStyleObject( propsToSet, styleObj, widthRange, heightRange );
		}
		
		
		
		//properties that are changed but are not found in any style-object need to be unset
		if (changes > 0) {
			applyStyleObject( changes, null );
			changes = 0;
		}
		
		
		
		//set the validators after they are filled, otherwise the width or height will be updated to soon.
		if (widthRange != null && target.layout.width.validator == null)
			target.layout.width.validator = widthRange;
		
		if (heightRange != null && target.layout.height.validator == null)
			target.layout.height.validator = heightRange;
	}
	
	
	
	
	
	private function applyStyleObject (propsToSet:Int, styleObj:LayoutStyle, widthRange:IntRangeValidator = null, heightRange:IntRangeValidator = null)
	{
		var layout		= elementStyle.target.as( ILayoutable ).layout;
		var notEmpty	= styleObj != null;
		
		if (propsToSet.has( Flags.WIDTH | Flags.HEIGHT ))
		{
			if (layout.is( IAdvancedLayoutClient )) {
				var l = layout.as( IAdvancedLayoutClient );
				if (propsToSet.has( Flags.WIDTH ))		l.explicitWidth		= notEmpty && styleObj.width.notEmpty()		? styleObj.width	: Number.INT_NOT_SET;
				if (propsToSet.has( Flags.HEIGHT ))		l.explicitHeight	= notEmpty && styleObj.height.notEmpty()	? styleObj.height	: Number.INT_NOT_SET;
			}
			else
				if (propsToSet.has( Flags.WIDTH ))		layout.width.value	= notEmpty && styleObj.width.notEmpty()		? styleObj.width	: Number.INT_NOT_SET;
				if (propsToSet.has( Flags.HEIGHT ))		layout.height.value	= notEmpty && styleObj.height.notEmpty()	? styleObj.height	: Number.INT_NOT_SET;
		}
		
		
		if (propsToSet.has( Flags.PERCENT_WIDTH ))
				layout.percentWidth = (notEmpty && styleObj.percentWidth.notEmpty()) ? styleObj.percentWidth : Number.FLOAT_NOT_SET;
		
		if (propsToSet.has( Flags.PERCENT_HEIGHT ))
			layout.percentHeight = (notEmpty && styleObj.percentHeight.notEmpty()) ? styleObj.percentHeight : Number.FLOAT_NOT_SET;
		
		
		if (propsToSet.has( Flags.RELATIVE ))			layout.relative				= notEmpty ? styleObj.relative				: null;
		if (propsToSet.has( Flags.INCLUDE ))			layout.includeInLayout		= notEmpty ? styleObj.includeInLayout		: null;
		if (propsToSet.has( Flags.MAINTAIN_ASPECT ))	layout.maintainAspectRatio	= notEmpty ? styleObj.maintainAspectRatio	: null;
		if (propsToSet.has( Flags.PADDING ))			layout.padding				= notEmpty ? styleObj.padding				: null;
		if (propsToSet.has( Flags.MARGIN ))				layout.margin				= notEmpty ? styleObj.margin				: null;
		
		if (propsToSet.has( Flags.MIN_WIDTH ))			widthRange.min				= notEmpty ? styleObj.minWidth				: Number.INT_NOT_SET;
		if (propsToSet.has( Flags.MIN_HEIGHT ))			heightRange.min				= notEmpty ? styleObj.minHeight				: Number.INT_NOT_SET;
		if (propsToSet.has( Flags.MAX_WIDTH ))			widthRange.max				= notEmpty ? styleObj.maxWidth				: Number.INT_NOT_SET;
		if (propsToSet.has( Flags.MAX_HEIGHT ))			heightRange.max				= notEmpty ? styleObj.maxHeight				: Number.INT_NOT_SET;
		
		if (propsToSet > 0 && layout.is(ILayoutContainer))
		{
			var l = layout.as(ILayoutContainer);
			if (propsToSet.has( Flags.CHILD_WIDTH ))	l.childWidth				= notEmpty ? styleObj.childWidth			: Number.INT_NOT_SET;
			if (propsToSet.has( Flags.CHILD_HEIGHT ))	l.childHeight				= notEmpty ? styleObj.childHeight			: Number.INT_NOT_SET;
			if (propsToSet.has( Flags.ALGORITHM ))		l.algorithm					= notEmpty ? styleObj.algorithm.create()	: null;
		}
	}
}


class LayoutCollectionForwardIterator extends StyleCollectionForwardIterator < LayoutStyle >
{
	override public function next ()	{ return setNext().data.layout; }
}


class LayoutCollectionReversedIterator extends StyleCollectionReversedIterator < LayoutStyle >
{
	override public function next ()	{ return setNext().data.layout; }
}