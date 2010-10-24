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
 import primevc.gui.effects.EffectFlags;
 import primevc.gui.effects.UIElementEffects;
 import primevc.gui.graphics.GraphicProperties;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.styling.EffectsStyle;
 import primevc.gui.styling.FilterFlags;
 import primevc.gui.styling.FiltersStyle;
 import primevc.gui.styling.IStyleDeclaration;
 import primevc.gui.styling.LayoutStyle;
 import primevc.gui.styling.StyleFlags;
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
		applyGeneralStyling		.on( target.style.change, this );
		applyLayoutStyling		.on( target.style.layout.change, this );
		applyEffectStyling		.on( target.style.effects.change, this );
		applyBoxFilterStyling	.on( target.style.boxFilters.change, this );
		
		applyGeneralStyling(	target.style.filledProperties );
		applyLayoutStyling(		target.style.layout.filledProperties );
		applyEffectStyling(		target.style.effects.filledProperties );
		applyBoxFilterStyling(	target.style.boxFilters.filledProperties );
	}
	
	
	override private function reset ()
	{
		target.style.change.unbind( this );
		target.style.layout.change.unbind( this );
		target.style.effects.change.unbind( this );
		target.style.boxFilters.change.unbind( this );
	}
	
		
	private function applyGeneralStyling (propsToSet:UInt)
	{
		if (!target.is(ISkinnable))		propsToSet = propsToSet.unset( Flags.SKIN );
		if (!target.is(IDrawable))		propsToSet = propsToSet.unset( Flags.BACKGROUND | Flags.BORDER | Flags.SHAPE );
		if (!target.is(IUIContainer))	propsToSet = propsToSet.unset( Flags.OVERFLOW );
		
		//remove flags that won't be used in this method
		propsToSet = propsToSet.unset( Flags.STATES | Flags.INHERETING_STYLES | Flags.LAYOUT | Flags.FONT | Flags.BACKGROUND_FILTERS | Flags.BOX_FILTERS | Flags.EFFECTS );
		
		if (propsToSet == 0)
			return;
		
		//
		// LOOP THROUGH ALL AVAILABLE STLYE-BLOCKS TO FIND THE STYLING PROPERTIES
		//
	//	trace(target + ".applyGeneralStyling "+target.style.readProperties( propsToSet ));
		
		for (styleObj in target.style)
		{
			if (propsToSet == 0)
				break;
			
			if (!styleObj.allFilledProperties.has( propsToSet ))
				continue;
			
			var curProps = styleObj.allFilledProperties.filter( propsToSet );
			
			if ( curProps.has( Flags.SKIN ) )			target.as(ISkinnable).skin	= Type.createInstance( styleObj.skin, null );
			if ( curProps.has( Flags.SHAPE ) )			getGraphicsObj().shape		= styleObj.shape;
			if ( curProps.has( Flags.BACKGROUND ) )		getGraphicsObj().fill		= styleObj.background;
			if ( curProps.has( Flags.BORDER ) )			getGraphicsObj().border		= styleObj.border;
			if ( curProps.has( Flags.OPACITY ) )		target.alpha				= styleObj.opacity;
			if ( curProps.has( Flags.VISIBLE ) )		target.visible				= styleObj.visible;
			if ( curProps.has( Flags.OVERFLOW ) )		target.behaviours.add( Type.createInstance( styleObj.overflow, [ target ] ) );
			
			propsToSet = propsToSet.unset( curProps );
		}
	}
	
	
	
	
	private function getGraphicsObj () : GraphicProperties
	{
		if (target.as(IDrawable).graphicData.value == null)
			return target.as(IDrawable).graphicData.value = new GraphicProperties(null, target.rect);
		else
			return target.as(IDrawable).graphicData.value;
	}
	
	
	
	
	private function applyLayoutStyling (propsToSet:UInt) : Void
	{
		if (propsToSet == 0)
			return;
		
		var layout	= target.layout;
		var style	= target.style.layout;
		
	//	trace(target + ".applyLayoutStyling "+style.readProperties( propsToSet ));
		
		//create size constraint for layout client
		if (propsToSet.has( LayoutFlags.CONSTRAINT_PROPERTIES ) && layout.sizeConstraint == null)
			layout.sizeConstraint = new SizeConstraint();
		
		if (!target.is(IUIContainer))
			propsToSet = propsToSet.unset( LayoutFlags.ALGORITHM | LayoutFlags.CHILD_WIDTH | LayoutFlags.CHILD_HEIGHT );
		
		if (propsToSet == 0)
			return;
		
		var styleCell	= target.style.styles.first;
		var tCont		= target.is(IUIContainer) ? target.as(IUIContainer) : null;
		
		for (styleObj in style)
		{
			if (propsToSet == 0)
				break;
			
			if (!styleObj.allFilledProperties.has( propsToSet ))
				continue;
			
			var curProps = styleObj.allFilledProperties.filter( propsToSet );
			
			if (curProps.has( LayoutFlags.WIDTH ))				layout.width						= styleObj.width;
			if (curProps.has( LayoutFlags.HEIGHT ))				layout.height						= styleObj.height;
			if (curProps.has( LayoutFlags.PERCENT_WIDTH ))		layout.percentWidth					= styleObj.percentWidth;
			if (curProps.has( LayoutFlags.PERCENT_HEIGHT ))		layout.percentHeight				= styleObj.percentHeight;
			if (curProps.has( LayoutFlags.RELATIVE ))			layout.relative						= styleObj.relative;
			if (curProps.has( LayoutFlags.INCLUDE ))			layout.includeInLayout				= styleObj.includeInLayout;
			if (curProps.has( LayoutFlags.MAINTAIN_ASPECT ))	layout.maintainAspectRatio			= styleObj.maintainAspectRatio;
			if (curProps.has( LayoutFlags.PADDING ))			layout.padding						= styleObj.padding;
			
			if (curProps.has( LayoutFlags.MIN_WIDTH ))			layout.sizeConstraint.width.min		= styleObj.minWidth;
			if (curProps.has( LayoutFlags.MIN_HEIGHT ))			layout.sizeConstraint.height.min	= styleObj.minHeight;
			if (curProps.has( LayoutFlags.MAX_HEIGHT ))			layout.sizeConstraint.width.max		= styleObj.maxWidth;
			if (curProps.has( LayoutFlags.MAX_WIDTH ))			layout.sizeConstraint.height.max	= styleObj.maxHeight;
			
			if (curProps.has( LayoutFlags.ALGORITHM ))			tCont.layoutContainer.algorithm		= styleObj.algorithm;
			if (curProps.has( LayoutFlags.CHILD_WIDTH ))		tCont.layoutContainer.childWidth	= styleObj.childWidth;
			if (curProps.has( LayoutFlags.CHILD_HEIGHT ))		tCont.layoutContainer.childHeight	= styleObj.childHeight;
			
			propsToSet	= propsToSet.unset( curProps );
		}
	}
	
	
	
	
	private function applyBoxFilterStyling (propsToSet:UInt) : Void
	{
		if (propsToSet == 0)
			return;

		var filters	= target.filters;
		var style	= target.style.boxFilters;
	//	trace(target + ".applyBoxFilterStyling "+style.readProperties( propsToSet ));
		
		if (filters == null)
			filters = [];
		
		for (styleObj in style)
		{
			if (propsToSet == 0)
				break;
			
			if (!styleObj.allFilledProperties.has( propsToSet ))
				continue;
			
			var curProps = styleObj.allFilledProperties.filter( propsToSet );
			if (curProps.has( FilterFlags.SHADOW ))				filters.push( styleObj.shadow );
			if (curProps.has( FilterFlags.BEVEL ))				filters.push( styleObj.bevel );
			if (curProps.has( FilterFlags.BLUR ))				filters.push( styleObj.blur );
			if (curProps.has( FilterFlags.GLOW ))				filters.push( styleObj.glow );
			if (curProps.has( FilterFlags.GRADIENT_BEVEL ))		filters.push( styleObj.gradientBevel );
			if (curProps.has( FilterFlags.GRADIENT_GLOW ))		filters.push( styleObj.gradientGlow );
		}
		
		//set new array with filters
		if (filters.length > 0)
			target.filters = filters;
	}
	
	
	
	
	
	private function applyEffectStyling (propsToSet:UInt) : Void
	{
		if (propsToSet == 0)
			return;
		
		if (target.effects == null)
			target.effects = new UIElementEffects(target);
		
		var effects	= target.effects;
		var style	= target.style.effects;
	//	trace(target + ".applyEffectStyling "+style.readProperties( propsToSet )+"; has "+style.readProperties());
		
		for (styleObj in style)
		{
			if (propsToSet == 0)
				break;
			
			if (!styleObj.allFilledProperties.has( propsToSet ))
				continue;
			
			var curProps = styleObj.allFilledProperties.filter( propsToSet );
			if (curProps.has( EffectFlags.MOVE ))		effects.move	= styleObj.move.createEffectInstance( target );
			if (curProps.has( EffectFlags.RESIZE ))		effects.resize	= styleObj.resize.createEffectInstance( target );
			if (curProps.has( EffectFlags.ROTATE ))		effects.rotate	= styleObj.rotate.createEffectInstance( target );
			if (curProps.has( EffectFlags.SCALE ))		effects.scale	= styleObj.scale.createEffectInstance( target );
			if (curProps.has( EffectFlags.SHOW ))		effects.show	= styleObj.show.createEffectInstance( target );
			if (curProps.has( EffectFlags.HIDE ))		effects.hide	= styleObj.hide.createEffectInstance( target );
		}
	}
}