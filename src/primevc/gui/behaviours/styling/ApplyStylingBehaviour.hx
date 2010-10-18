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
package primevc.gui.behaviours.styling;
 import primevc.core.geom.constraints.SizeConstraint;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.core.IUIContainer;
 import primevc.gui.core.IUIElement;
 import primevc.gui.effects.UIElementEffects;
 import primevc.gui.graphics.GraphicProperties;
 import primevc.gui.styling.declarations.EffectStyleDeclarations;
 import primevc.gui.styling.declarations.FilterStyleDeclarations;
 import primevc.gui.styling.declarations.LayoutStyleDeclarations;
 import primevc.gui.styling.declarations.StyleFlags;
 import primevc.gui.traits.IDrawable;
 import primevc.gui.traits.ISkinnable;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = StyleFlags;

/**
 * Behaviour to apply styling to a IUIElement
 * 
 * @author Ruben Weijers
 * @creation-date Oct 14, 2010
 */
class ApplyStylingBehaviour extends BehaviourBase < IUIElement >
{
	override private function init ()
	{
		applyStyling.on( target.style.change, this );
		applyStyling( target.style.filledProperties );
	}
	
	
	override private function reset ()
	{
		target.style.change.unbind( this );
	}
	
	
	private function applyStyling (propsToSet:UInt) : Void
	{
		var style	= target.style;
		var it		= style.iterator();
		
		if (!target.is(ISkinnable))		propsToSet = propsToSet.unset( Flags.SKIN );
		if (!target.is(IDrawable))		propsToSet = propsToSet.unset( Flags.BACKGROUND | Flags.BORDER | Flags.SHAPE );
		if (!target.is(IUIContainer))	propsToSet = propsToSet.unset( Flags.OVERFLOW );
		
		//remove flags that don't influence the target's style
		propsToSet = propsToSet.unset( Flags.STATES | Flags.INHERETING_STYLES );
		
		//check properties that will be checked using a seperate proxy
		if (propsToSet.has( Flags.LAYOUT ))			applyLayoutStyling( style.layout );
		if (propsToSet.has( Flags.BOX_FILTERS ))	applyBoxFilterStyling( style.boxFilters );
		if (propsToSet.has( Flags.EFFECTS ))		applyEffectStyling( style.effects );
		
		//remove checked properties
		propsToSet = propsToSet.unset( Flags.LAYOUT | Flags.FONT | Flags.BACKGROUND_FILTERS | Flags.BOX_FILTERS | Flags.EFFECTS );
		trace(target + ".applyStyling - "+Flags.readProperties( propsToSet ));
		
		if (propsToSet == 0)
			return;
		
		//
		// LOOP THROUGH ALL AVAILABLE STLYE-BLOCKS TO FIND THE STYLING PROPERTIES
		//
		
		while (it.hasNext() && propsToSet > 0)
		{
			var styleObj = it.next();
			if (!styleObj.allFilledProperties.has( propsToSet ))
				continue;
			
			var curStyleProps = styleObj.allFilledProperties.filter( propsToSet );
			trace("\t\tgonna find the props "+Flags.readProperties(curStyleProps));
			
			//read skin
			if ( curStyleProps.has( StyleFlags.SKIN ) )
				target.as(ISkinnable).skin = Type.createInstance( styleObj.skin, null );

			//read shape
			if ( curStyleProps.has( StyleFlags.SHAPE ) )
			{
				createGraphicDataObj();
				target.as(IDrawable).graphicData.value.shape	= styleObj.shape;
			//	target.as(IDrawable).graphicData.value.layout	= target.rect;
			}
			
			//read fill
			if ( curStyleProps.has( StyleFlags.BACKGROUND ) )
			{
				createGraphicDataObj();
				target.as(IDrawable).graphicData.value.fill = styleObj.background;
			}
			
			//read border
			if ( curStyleProps.has( StyleFlags.BORDER ) )
			{
				createGraphicDataObj();
				target.as(IDrawable).graphicData.value.border = styleObj.border;
			}
			
			//read opacity
			if ( curStyleProps.has( StyleFlags.OPACITY ) )
				target.alpha = styleObj.opacity;
			
			//read visable
			if ( curStyleProps.has( StyleFlags.VISIBLE ) )
				target.visible = styleObj.visible;
			
			//read overflow
			if ( curStyleProps.has( StyleFlags.OVERFLOW ) )
				target.behaviours.add( Type.createInstance( styleObj.overflow, [ target ] ) );
			
			//read font properties
			//...
			
			propsToSet = propsToSet.unset( curStyleProps );
		}
	}
	
	
	private function createGraphicDataObj ()
	{
		if (target.as(IDrawable).graphicData.value == null)
			target.as(IDrawable).graphicData.value = new GraphicProperties(null, target.rect);
	}
	
	
	private function applyLayoutStyling (style:LayoutStyleDeclarations) : Void
	{
		var layout = target.layout;
	//	trace(target + ".applyLayoutStyling "+style.readProperties());
		if (style.width.isSet())				layout.width				= style.width;
		if (style.height.isSet())				layout.height				= style.height;
		if (style.percentWidth.isSet())			layout.percentWidth			= style.percentWidth;
		if (style.percentHeight.isSet())		layout.percentHeight		= style.percentHeight;
		if (style.relative != null)				layout.relative				= style.relative;
		if (style.includeInLayout != null)		layout.includeInLayout		= style.includeInLayout;
		if (style.maintainAspectRatio != null)	layout.maintainAspectRatio	= style.maintainAspectRatio;
		if (style.padding != null)				layout.padding				= style.padding;
		
		//size constraintss
		var minW = style.minWidth, maxW = style.maxWidth, minH = style.minHeight, maxH = style.maxHeight;
		if (minW.isSet() || maxW.isSet() || minH.isSet() || maxH.isSet())
		{
			//create size constraint for layout client
			if (layout.sizeConstraint == null)
				layout.sizeConstraint = new SizeConstraint( minW, maxW, minH, maxH );
			else
			{
				var c = layout.sizeConstraint;
				if (minW.isSet())	c.width.min		= minW;
				if (minH.isSet())	c.height.min	= minH;
				if (maxW.isSet())	c.width.max		= maxW;
				if (maxH.isSet())	c.height.max	= maxH;
			}
		}
		
		if (target.is(IUIContainer))
		{
			var t = target.as(IUIContainer);
			if (style.algorithm != null)	t.layoutContainer.algorithm		= style.algorithm;
			if (style.childWidth.isSet())	t.layoutContainer.childWidth	= style.childWidth;
			if (style.childHeight.isSet())	t.layoutContainer.childHeight	= style.childHeight;
		}
	}
	
	
	private function applyBoxFilterStyling (style:FilterStyleDeclarations) : Void
	{
		var filters	= target.filters;
	//	trace(target + ".applyBoxFilterStyling "+style.readProperties());
		if (filters == null)
			filters = [];
		
		if (style.shadow != null)			filters.push( style.shadow );
		if (style.bevel != null)			filters.push( style.bevel );
		if (style.blur != null)				filters.push( style.blur );
		if (style.glow != null)				filters.push( style.glow );
		if (style.gradientBevel != null)	filters.push( style.gradientBevel );
		if (style.gradientGlow != null)		filters.push( style.gradientGlow );
		
		//set new array with filters
		if (filters.length > 0)
			target.filters = filters;
	}
	
	
	private function applyEffectStyling (style:EffectStyleDeclarations) : Void
	{	
	//	trace(target + ".applyEffectStyling "+style.readProperties());
		if (style.show != null || style.hide != null || style.scale != null || style.resize != null || style.rotate != null || style.move != null)
		{
			if (target.effects == null)
				target.effects = new UIElementEffects(target, style);
			else
				target.effects.collection = style;
		}
	}
}