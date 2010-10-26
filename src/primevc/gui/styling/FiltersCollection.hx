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
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.styling.StyleCollectionBase;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = FilterFlags;
private typedef Filter = FilterCollectionType;

/**
 * @author Ruben Weijers
 * @creation-date Sep 29, 2010
 */
class FiltersCollection extends StyleCollectionBase < FiltersStyle >
{
	private var type : Filter;
	
	
	public function new (elementStyle:IUIElementStyle, type:Filter)
	{
		var flag = (type == Filter.background) ? StyleFlags.BACKGROUND_FILTERS : StyleFlags.BOX_FILTERS;
		super( elementStyle, flag );
		this.type = type;
	}
	override public function forwardIterator ()					{ return cast new FiltersCollectionForwardIterator( elementStyle, propertyTypeFlag, type); }
	override public function reversedIterator ()				{ return cast new FiltersCollectionReversedIterator( elementStyle, propertyTypeFlag, type); }

#if debug
	override public function readProperties (props:Int = -1)	{ return Flags.readProperties( (props == -1) ? filledProperties : props ); }
#end
	
	
	override public function apply ()
	{
		if (changes == 0)
			return;
		
		if (type == Filter.box)
			applyBoxFilters();
	}
	
	
	private function applyBoxFilters ()
	{
		if (!elementStyle.target.is(IDisplayObject))
			return;
		
		var target	= elementStyle.target.as(IDisplayObject);
		var filters	= target.filters;
	//	trace(target + ".applyBoxFilterStyling "+style.readProperties( changes ));
		
		if (filters == null)
			filters = [];
		
		for (styleObj in this)
		{
			if (changes == 0)
				break;
			
			if (!styleObj.allFilledProperties.has( changes ))
				continue;
			
			var propsToSet = styleObj.allFilledProperties.filter( changes );
			if (propsToSet.has( Flags.SHADOW ))				filters.push( styleObj.shadow );
			if (propsToSet.has( Flags.BEVEL ))				filters.push( styleObj.bevel );
			if (propsToSet.has( Flags.BLUR ))				filters.push( styleObj.blur );
			if (propsToSet.has( Flags.GLOW ))				filters.push( styleObj.glow );
			if (propsToSet.has( Flags.GRADIENT_BEVEL ))		filters.push( styleObj.gradientBevel );
			if (propsToSet.has( Flags.GRADIENT_GLOW ))		filters.push( styleObj.gradientGlow );
			
			changes = changes.unset( propsToSet );
		}
		
		//set new array with filters
		if (filters.length > 0)
			target.filters = filters;
		
		//TODO: should actually check if there are any filters that need to be removed!...
		changes = 0;
	}
}


class FiltersCollectionForwardIterator extends StyleCollectionForwardIterator < FiltersStyle >
{
	private var type : Filter;
	
	
	public function new (elementStyle:IUIElementStyle, groupFlag:UInt, type:Filter)
	{
		this.type = type;
		super( elementStyle, groupFlag );
	}
	
	override public function next ()
	{
		if (type == Filter.background)
			return setNext().data.bgFilters;
		else
			return setNext().data.boxFilters;
	}
}


class FiltersCollectionReversedIterator extends StyleCollectionReversedIterator < FiltersStyle >
{
	private var type : Filter;
	
	
	public function new (elementStyle:IUIElementStyle, groupFlag:UInt, type:Filter)
	{
		this.type = type;
		super( elementStyle, groupFlag );
	}
	

	override public function next ()
	{
		if (type == Filter.background)
			return setNext().data.bgFilters;
		else
			return setNext().data.boxFilters;
	}
}