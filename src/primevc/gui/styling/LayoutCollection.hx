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
 import primevc.core.geom.constraints.SizeConstraint;
 import primevc.gui.core.IUIContainer;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.styling.StyleCollectionBase;
 import primevc.gui.traits.ILayoutable;
 import primevc.types.Number;
  using primevc.utils.BitUtil;
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
		
		//create size constraint for layout client
		if (changes.has( Flags.CONSTRAINT_PROPERTIES ) && target.layout.sizeConstraint == null)
			target.layout.sizeConstraint = new SizeConstraint();
		
		if (!target.is(IUIContainer))
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
			applyStyleObject( propsToSet, styleObj );
		}
		
		//properties that are changed but are not found in any style-object need to be unset
		if (changes > 0) {
			applyStyleObject( changes, null );
			changes = 0;
		}
	}
	
	
	private function applyStyleObject (propsToSet:UInt, styleObj:LayoutStyle)
	{
		var layout	= elementStyle.target.as( ILayoutable ).layout;
		
		if (propsToSet.has( LayoutFlags.WIDTH ))			layout.width						= styleObj != null ? styleObj.width					: Number.INT_NOT_SET;
		if (propsToSet.has( LayoutFlags.HEIGHT ))			layout.height						= styleObj != null ? styleObj.height				: Number.INT_NOT_SET;
		if (propsToSet.has( LayoutFlags.PERCENT_WIDTH ))	layout.percentWidth					= styleObj != null ? styleObj.percentWidth			: 0; //Number.FLOAT_NOT_SET;
		if (propsToSet.has( LayoutFlags.PERCENT_HEIGHT ))	layout.percentHeight				= styleObj != null ? styleObj.percentHeight			: 0; //Number.FLOAT_NOT_SET;
		if (propsToSet.has( LayoutFlags.RELATIVE ))			layout.relative						= styleObj != null ? styleObj.relative				: null;
		if (propsToSet.has( LayoutFlags.INCLUDE ))			layout.includeInLayout				= styleObj != null ? styleObj.includeInLayout		: null;
		if (propsToSet.has( LayoutFlags.MAINTAIN_ASPECT ))	layout.maintainAspectRatio			= styleObj != null ? styleObj.maintainAspectRatio	: null;
		if (propsToSet.has( LayoutFlags.PADDING ))			layout.padding						= styleObj != null ? styleObj.padding				: null;
		
		if (propsToSet.has( LayoutFlags.MIN_WIDTH ))		layout.sizeConstraint.width.min		= styleObj != null ? styleObj.minWidth				: Number.INT_NOT_SET;
		if (propsToSet.has( LayoutFlags.MIN_HEIGHT ))		layout.sizeConstraint.height.min	= styleObj != null ? styleObj.minHeight				: Number.INT_NOT_SET;
		if (propsToSet.has( LayoutFlags.MAX_HEIGHT ))		layout.sizeConstraint.width.max		= styleObj != null ? styleObj.maxWidth				: Number.INT_NOT_SET;
		if (propsToSet.has( LayoutFlags.MAX_WIDTH ))		layout.sizeConstraint.height.max	= styleObj != null ? styleObj.maxHeight				: Number.INT_NOT_SET;
		
		if (elementStyle.target.is( IUIContainer ))
		{
			var tCont = elementStyle.target.as( IUIContainer );
			
			if (propsToSet.has( LayoutFlags.ALGORITHM ))	tCont.layoutContainer.algorithm		= styleObj != null ? styleObj.algorithm				: null;
			if (propsToSet.has( LayoutFlags.CHILD_WIDTH ))	tCont.layoutContainer.childWidth	= styleObj != null ? styleObj.childWidth			: Number.INT_NOT_SET;
			if (propsToSet.has( LayoutFlags.CHILD_HEIGHT ))	tCont.layoutContainer.childHeight	= styleObj != null ? styleObj.childHeight			: Number.INT_NOT_SET;
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