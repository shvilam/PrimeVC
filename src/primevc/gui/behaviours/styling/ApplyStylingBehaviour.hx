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
 import primevc.gui.styling.declarations.EffectStyleDeclarations;
 import primevc.gui.styling.declarations.FilterFlags;
 import primevc.gui.styling.declarations.FilterStyleDeclarations;
 import primevc.gui.styling.declarations.IStyleDeclaration;
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
		applyGeneralStyling		.on( target.style.change, this );
		applyLayoutStyling		.on( target.style.layout.change, this );
		applyEffectStyling		.on( target.style.effects.change, this );
		applyBoxFilterStyling	.on( target.style.boxFilters.change, this );
		
		applyGeneralStyling(	target.style.filledProperties );
		applyLayoutStyling(		target.style.layout.allFilledProperties );
		applyEffectStyling(		target.style.effects.allFilledProperties );
		applyBoxFilterStyling(	target.style.boxFilters.allFilledProperties );
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
		var style = target.style;
		
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
		
		var it = style.iterator();
		while (it.hasNext() && propsToSet > 0)
		{
			var styleObj = it.next();
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
		
		if (propsToSet.has( LayoutFlags.WIDTH ))				layout.width				= style.width;
		if (propsToSet.has( LayoutFlags.HEIGHT ))				layout.height				= style.height;
		if (propsToSet.has( LayoutFlags.PERCENT_WIDTH ))		layout.percentWidth			= style.percentWidth;
		if (propsToSet.has( LayoutFlags.PERCENT_HEIGHT ))		layout.percentHeight		= style.percentHeight;
		if (propsToSet.has( LayoutFlags.RELATIVE ))				layout.relative				= style.relative;
		if (propsToSet.has( LayoutFlags.INCLUDE ))				layout.includeInLayout		= style.includeInLayout;
		if (propsToSet.has( LayoutFlags.MAINTAIN_ASPECT ))		layout.maintainAspectRatio	= style.maintainAspectRatio;
		if (propsToSet.has( LayoutFlags.PADDING ))				layout.padding				= style.padding;
		
		//size constraintss
		if (propsToSet.has( LayoutFlags.MIN_WIDTH | LayoutFlags.MIN_HEIGHT | LayoutFlags.MAX_WIDTH | LayoutFlags.MAX_HEIGHT ))
		{
			//create size constraint for layout client
			if (layout.sizeConstraint == null)
				layout.sizeConstraint = new SizeConstraint( style.minWidth, style.maxWidth, style.minHeight, style.maxHeight );
			else
			{
				var c = layout.sizeConstraint;
				if (propsToSet.has( LayoutFlags.MIN_WIDTH ))	c.width.min		= style.minWidth;
				if (propsToSet.has( LayoutFlags.MIN_HEIGHT ))	c.height.min	= style.minHeight;
				if (propsToSet.has( LayoutFlags.MAX_HEIGHT ))	c.width.max		= style.maxWidth;
				if (propsToSet.has( LayoutFlags.MAX_WIDTH ))	c.height.max	= style.maxHeight;
			}
		}
		
		if (target.is(IUIContainer))
		{
			var t = target.as(IUIContainer);
			if (propsToSet.has( LayoutFlags.ALGORITHM ))		t.layoutContainer.algorithm		= style.algorithm;
			if (propsToSet.has( LayoutFlags.CHILD_WIDTH ))		t.layoutContainer.childWidth	= style.childWidth;
			if (propsToSet.has( LayoutFlags.CHILD_HEIGHT ))		t.layoutContainer.childHeight	= style.childHeight;
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
		
		if (propsToSet.has( FilterFlags.SHADOW ))				filters.push( style.shadow );
		if (propsToSet.has( FilterFlags.BEVEL ))				filters.push( style.bevel );
		if (propsToSet.has( FilterFlags.BLUR ))					filters.push( style.blur );
		if (propsToSet.has( FilterFlags.GLOW ))					filters.push( style.glow );
		if (propsToSet.has( FilterFlags.GRADIENT_BEVEL ))		filters.push( style.gradientBevel );
		if (propsToSet.has( FilterFlags.GRADIENT_GLOW ))		filters.push( style.gradientGlow );
		
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
		
		var style	= target.style.effects;
		var effects	= target.effects;
	//	trace(target + ".applyEffectStyling "+style.readProperties( propsToSet )+"; has "+style.readProperties());
		
		if (propsToSet.has( EffectFlags.MOVE ))	{
			if (style.has(EffectFlags.MOVE))
				Assert.that( style.move != null );
			
			effects.move	= style.has(EffectFlags.MOVE)	? style.move.createEffectInstance( target ) : null;
		}
		if (propsToSet.has( EffectFlags.RESIZE ))	effects.resize	= style.has(EffectFlags.RESIZE)	? style.resize.createEffectInstance( target ) : null;
		if (propsToSet.has( EffectFlags.ROTATE ))	effects.rotate	= style.has(EffectFlags.ROTATE)	? style.rotate.createEffectInstance( target ) : null;
		if (propsToSet.has( EffectFlags.SCALE ))	effects.scale	= style.has(EffectFlags.SCALE)	? style.scale.createEffectInstance( target ) : null;
		if (propsToSet.has( EffectFlags.SHOW ))		effects.show	= style.has(EffectFlags.SHOW)	? style.show.createEffectInstance( target ) : null;
		if (propsToSet.has( EffectFlags.HIDE ))		effects.hide	= style.has(EffectFlags.HIDE)	? style.hide.createEffectInstance( target ) : null;
	}
}