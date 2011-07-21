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
 import primevc.core.validators.PercentIntRangeValidator;
// import primevc.gui.layout.IAdvancedLayoutClient;
 import primevc.gui.layout.ILayoutContainer;
 import primevc.gui.styling.StyleCollectionBase;
 import primevc.gui.traits.ILayoutable;
 import primevc.types.Number;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


private typedef Flags		= LayoutStyleFlags;
private typedef Validator	= IntRangeValidator;
private typedef PValidator	= PercentIntRangeValidator;



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
		
		var target	= elementStyle.target.as( ILayoutable );
		var layout	= target.layout;
		
		var widthRange:Validator	= null;
		var heightRange:Validator	= null;
	//	untyped(target.layout).filledProperties = filledProperties;
		
		//create size constraint for layout client
		if (changes.has( Flags.HEIGHT_CONSTRAINTS ))
		{
			if (filledProperties.hasNone(Flags.HEIGHT_CONSTRAINTS)) {
				layout.heightValidator = null;
				changes = changes.unset( Flags.HEIGHT_CONSTRAINTS);
			}
			else
			{
				if (filledProperties.has(Flags.PERCENT_HEIGHT_CONSTRAINTS))
					heightRange = layout.heightValidator.is(PValidator) ? layout.heightValidator : new PValidator();
				else
					heightRange = layout.heightValidator.is(Validator) ? layout.heightValidator : new Validator();
			}
		}
		
		
		
		if (changes.has( Flags.WIDTH_CONSTRAINTS ))
		{
			if (filledProperties.hasNone(Flags.WIDTH_CONSTRAINTS)) {
				layout.widthValidator = null;
				changes = changes.unset( Flags.WIDTH_CONSTRAINTS );
			}
			else
			{
				if (filledProperties.has(Flags.PERCENT_WIDTH_CONSTRAINTS))
					widthRange = layout.widthValidator.is(PValidator) ? layout.widthValidator : new PValidator();
				else
					widthRange = layout.widthValidator.is(Validator) ? layout.widthValidator : new Validator();
			}
		}
		
		
		
		if (!layout.is(ILayoutContainer))
			changes = changes.unset( Flags.ALGORITHM | Flags.CHILD_WIDTH | Flags.CHILD_HEIGHT );
		
		if (changes == 0)
			return;
		
		
		var maintainAspect = layout.maintainAspectRatio;
		layout.maintainAspectRatio = false;
	//	trace(target + ".applyLayoutStyling1 "+readProperties( changes )+"; changes "+changes);
		
		for (styleObj in this)
		{
			if (changes == 0)
				break;
			
			if (!styleObj.allFilledProperties.has( changes ))
				continue;
			
			//find the properties that the changeflag and the styleobject have in common
			var propsToSet	 = styleObj.allFilledProperties.filter( changes );
			
			//make sure a style-obj doens't have a percent size value and a size value at the same time <-- assertions are failing since size values can also be Number.EMPTY
		//	Assert.that( !propsToSet.hasAll( Flags.WIDTH | Flags.PERCENT_WIDTH ), target+"."+styleObj+" can't have and a percent-width and a width value. Width: "+styleObj.width+"; pWidth: "+styleObj.percentWidth+"; props: "+Flags.readProperties(propsToSet) );
		//	Assert.that( !propsToSet.hasAll( Flags.HEIGHT | Flags.PERCENT_HEIGHT ), target+"."+styleObj+" can't have and a percent-height and a height value. Height: "+styleObj.height+"; pHeight: "+styleObj.percentHeight+"; props: "+Flags.readProperties(propsToSet) );
			
			//prevent the width to be set when percent-width is already set, etc.
			var propsToUnset = 0;
			if		(propsToSet.has( Flags.WIDTH ) && changes.has( Flags.PERCENT_WIDTH ))	propsToUnset |= Flags.PERCENT_WIDTH;
			else if (propsToSet.has( Flags.PERCENT_WIDTH ) && changes.has( Flags.WIDTH ))	propsToUnset |= Flags.WIDTH;
			if		(propsToSet.has( Flags.HEIGHT ) && changes.has( Flags.PERCENT_HEIGHT ))	propsToUnset |= Flags.PERCENT_HEIGHT;
			else if (propsToSet.has( Flags.PERCENT_HEIGHT ) && changes.has( Flags.HEIGHT ))	propsToUnset |= Flags.HEIGHT;
			
			changes  = changes.unset( propsToSet | propsToUnset );
			applyStyleObject( propsToSet, styleObj, widthRange, heightRange );
		}
		
		
		
		//properties that are changed but are not found in any style-object need to be unset
		if (changes > 0) {
			applyStyleObject( changes, null, widthRange, heightRange );
			changes = 0;
		}
		
		//set the validators after they are filled, otherwise the width or height will be updated to soon.
		if (widthRange != null && layout.widthValidator == null)
			layout.widthValidator = widthRange;
		
		if (heightRange != null && layout.heightValidator == null)
			layout.heightValidator = heightRange;
		
		layout.maintainAspectRatio = maintainAspect;
	}
	
	
	
	
	
	private function applyStyleObject (propsToSet:Int, styleObj:LayoutStyle, widthRange:Validator = null, heightRange:Validator = null)
	{
		var layout		= elementStyle.target.as( ILayoutable ).layout;
		var notEmpty	= styleObj != null;
		
		
		/*if (propsToSet.has( Flags.WIDTH | Flags.HEIGHT ))
		{
			if (layout.is( IAdvancedLayoutClient )) {
				var l = layout.as( IAdvancedLayoutClient );
				if (propsToSet.has( Flags.WIDTH ))		l.explicitWidth		= notEmpty && styleObj.width.notEmpty()		? styleObj.width	: Number.INT_NOT_SET;
				if (propsToSet.has( Flags.HEIGHT ))		l.explicitHeight	= notEmpty && styleObj.height.notEmpty()	? styleObj.height	: Number.INT_NOT_SET;
			}
			else {
				if (propsToSet.has( Flags.WIDTH ))		layout.width		= notEmpty && styleObj.width.notEmpty()		? styleObj.width	: Number.INT_NOT_SET;
				if (propsToSet.has( Flags.HEIGHT ))		layout.height		= notEmpty && styleObj.height.notEmpty()	? styleObj.height	: Number.INT_NOT_SET;
	//		}
		}*/
		
		if		(propsToSet.has( Flags.WIDTH ))				layout.width		 	= notEmpty ? styleObj.width.getValue()				: Number.INT_NOT_SET;
		else if (propsToSet.has( Flags.PERCENT_WIDTH ))		layout.percentWidth  	= notEmpty ? styleObj.percentWidth.getValue()		: Number.FLOAT_NOT_SET;
		if		(propsToSet.has( Flags.HEIGHT ))			layout.height		 	= notEmpty ? styleObj.height.getValue()				: Number.INT_NOT_SET;
		else if (propsToSet.has( Flags.PERCENT_HEIGHT ))	layout.percentHeight 	= notEmpty ? styleObj.percentHeight.getValue()		: Number.FLOAT_NOT_SET;
		
		var pWidthRange		= propsToSet.has( Flags.PERCENT_WIDTH_CONSTRAINTS )  ? widthRange .as(PValidator) : null;
		var pHeightRange	= propsToSet.has( Flags.PERCENT_HEIGHT_CONSTRAINTS ) ? heightRange.as(PValidator) : null;
		
		if (propsToSet.has( Flags.RELATIVE ))			layout.relative				= notEmpty ? styleObj.relative						: null;
		if (propsToSet.has( Flags.INCLUDE ))			layout.includeInLayout		= notEmpty ? styleObj.includeInLayout				: null;
		if (propsToSet.has( Flags.MAINTAIN_ASPECT ))	layout.maintainAspectRatio	= notEmpty ? styleObj.maintainAspectRatio			: null;
		if (propsToSet.has( Flags.PADDING ))			layout.padding				= notEmpty ? styleObj.padding						: null;
		if (propsToSet.has( Flags.MARGIN ))				layout.margin				= notEmpty ? styleObj.margin						: null;
		
		if (propsToSet.has( Flags.PERCENT_MIN_WIDTH ))	pWidthRange.percentMin		= notEmpty ? styleObj.percentMinWidth.getValue()	: Number.FLOAT_NOT_SET;
		else if (propsToSet.has( Flags.MIN_WIDTH ))		widthRange.min				= notEmpty ? styleObj.minWidth.getValue()			: Number.INT_NOT_SET;
		if (propsToSet.has( Flags.PERCENT_MAX_WIDTH ))	pWidthRange.percentMax		= notEmpty ? styleObj.percentMaxWidth.getValue()	: Number.FLOAT_NOT_SET;
		else if (propsToSet.has( Flags.MAX_WIDTH ))		widthRange.max				= notEmpty ? styleObj.maxWidth.getValue()			: Number.INT_NOT_SET;
		
		if (propsToSet.has( Flags.PERCENT_MIN_HEIGHT ))	pHeightRange.percentMin		= notEmpty ? styleObj.percentMinHeight.getValue()	: Number.FLOAT_NOT_SET;
		else if (propsToSet.has( Flags.MIN_HEIGHT ))	heightRange.min				= notEmpty ? styleObj.minHeight.getValue()			: Number.INT_NOT_SET;
		if (propsToSet.has( Flags.PERCENT_MAX_HEIGHT ))	pHeightRange.percentMax		= notEmpty ? styleObj.percentMaxHeight.getValue()	: Number.FLOAT_NOT_SET;
		else if (propsToSet.has( Flags.MAX_HEIGHT ))	heightRange.max				= notEmpty ? styleObj.maxHeight.getValue()			: Number.INT_NOT_SET;
		
		
		if (propsToSet > 0 && layout.is(ILayoutContainer))
		{
			var l = layout.as(ILayoutContainer);
			if (propsToSet.has( Flags.CHILD_WIDTH ))	l.childWidth				= notEmpty ? styleObj.childWidth					: Number.INT_NOT_SET;
			if (propsToSet.has( Flags.CHILD_HEIGHT ))	l.childHeight				= notEmpty ? styleObj.childHeight					: Number.INT_NOT_SET;
			if (propsToSet.has( Flags.ALGORITHM ))
			{
				var old		= l.algorithm;
				l.algorithm	= notEmpty ? styleObj.algorithm() : null;
				
				if (old != null)
					old.dispose();	//dispose after changing the algorithm in layoutcontainer.. otherwise errors in LayoutContainer.setAlgorithm
			}
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