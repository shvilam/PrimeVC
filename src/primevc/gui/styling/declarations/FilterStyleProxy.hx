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
 import primevc.gui.styling.StyleSheet;
  using primevc.utils.BitUtil;


private typedef Flags = FilterFlags;

/**
 * @author Ruben Weijers
 * @creation-date Sep 29, 2010
 */
class FilterStyleProxy extends FilterStyleDeclarations
{
	private var target : StyleSheet;
	
	
	public function new (target:StyleSheet, type:FilterCollectionType)
	{
		this.target = target;
		super(type);
	}
	
	
	override public function updateAllFilledPropertiesFlag () : Void
	{
		super.updateAllFilledPropertiesFlag();
		
		if (type == FilterCollectionType.box)
		{
			//box filters
			for (styleObj in target) {
				if (styleObj.has( StyleFlags.BOX_FILTERS ))
					allFilledProperties = allFilledProperties.set( styleObj.boxFilters.allFilledProperties );
				
				if (allFilledProperties == Flags.ALL_PROPERTIES)
					break;
			}
		}
		else
		{
			//background filters
			for (styleObj in target) {
				if (styleObj.has( StyleFlags.BACKGROUND_FILTERS ))
					allFilledProperties = allFilledProperties.set( styleObj.bgFilters.allFilledProperties );
				
				if (allFilledProperties == Flags.ALL_PROPERTIES)
					break;
			}
		}
	}
	
	
	override private function getShadow ()
	{
		if (!has(Flags.SHADOW))
			return null;
		
		var v = super.getShadow();
		
		if (v == null)
			if (type == FilterCollectionType.box)
			{
				//box filters
				for (styleObj in target)
					if (styleObj.boxFilters != null && null != (v = styleObj.boxFilters.shadow))
						break;
			}
			else
			{
				//background filters
				for (styleObj in target)
					if (styleObj.bgFilters != null && null != (v = styleObj.bgFilters.shadow))
						break;
			}
		return v;
	}
	
	
	
	override private function getBevel ()
	{	
		if (!has(Flags.BEVEL))
			return null;
		
		var v = super.getBevel();
		
		if (v == null)
			if (type == FilterCollectionType.box)
			{
				//box filters
				for (styleObj in target)
					if (styleObj.boxFilters != null && null != (v = styleObj.boxFilters.bevel))
						break;
			}
			else
			{
				//background filters
				for (styleObj in target)
					if (styleObj.bgFilters != null && null != (v = styleObj.bgFilters.bevel))
						break;
			}
		
		return v;
	}
	
	
	
	override private function getBlur ()
	{
		if (!has(Flags.BLUR))
			return null;
		
		var v = super.getBlur();
		
		if (v == null)
			if (type == FilterCollectionType.box)
			{
				//box filters
				for (styleObj in target)
					if (styleObj.boxFilters != null && null != (v = styleObj.boxFilters.blur))
						break;
			}
			else
			{
				//background filters
				for (styleObj in target)
					if (styleObj.bgFilters != null && null != (v = styleObj.bgFilters.blur))
						break;
			}
		
		return v;
	}
	
	
	
	override private function getGlow ()
	{
		if (!has(Flags.GLOW))
			return null;
		
		var v = super.getGlow();
		
		if (v == null)
			if (type == FilterCollectionType.box)
			{
				//box filters
				for (styleObj in target)
					if (styleObj.boxFilters != null && null != (v = styleObj.boxFilters.glow))
						break;
			}
			else
			{
				//background filters
				for (styleObj in target)
					if (styleObj.bgFilters != null && null != (v = styleObj.bgFilters.glow))
						break;
			}
		
		return v;
	}
	
	
	
	override private function getGradientBevel ()
	{
		if (!has(Flags.GRADIENT_BEVEL))
			return null;
		
		var v = super.getGradientBevel();
		
		if (v == null)
			if (type == FilterCollectionType.box)
			{
				//box filters
				for (styleObj in target)
					if (styleObj.boxFilters != null && null != (v = styleObj.boxFilters.gradientBevel))
						break;
			}
			else
			{
				//background filters
				for (styleObj in target)
					if (styleObj.bgFilters != null && null != (v = styleObj.bgFilters.gradientBevel))
						break;
			}
		
		return v;
	}
	
	
	
	override private function getGradientGlow ()
	{
		if (!has(Flags.GRADIENT_GLOW))
			return null;
		
		var v = super.getGradientGlow();
		
		if (v == null)
			if (type == FilterCollectionType.box)
			{
				//box filters
				for (styleObj in target)
					if (styleObj.boxFilters != null && null != (v = styleObj.boxFilters.gradientGlow))
						break;
			}
			else
			{
				//background filters
				for (styleObj in target)
					if (styleObj.bgFilters != null && null != (v = styleObj.bgFilters.gradientGlow))
						break;
			}
		
		return v;
	}
}