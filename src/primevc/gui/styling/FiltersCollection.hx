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
 import primevc.gui.filters.BitmapFilter;
 import primevc.gui.styling.StyleCollectionBase;
 import primevc.utils.FastArray;
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
	private var type			: Filter;
	private var filterPositions	: FastArray<Int>;
	
	
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
		
		if (type == Filter.box && elementStyle.target.is(IDisplayObject))
			applyBoxFilters();
	}
	
	
	private function applyBoxFilters ()
	{
		var target	= elementStyle.target.as(IDisplayObject);
		var filters	= target.filters;
	//	trace(target + ".applyBoxFilterStyling "+Flags.readProperties( changes ));
		
		if (filledProperties == 0)
		{	
			changes = 0;
			if (filters != null)
				while( filters.length > 0 )
					filters.pop();
			
			if (filterPositions != null)
				while( filterPositions.length > 0 )
					filterPositions.pop();
		}
		else
		{
			if (filters == null)			filters			= new Array<Dynamic>();
			if (filterPositions == null)	filterPositions	= FastArrayUtil.create();
			
			for (styleObj in this)
			{
				if (changes == 0)
					break;
			
				if (!styleObj.allFilledProperties.has( changes ))
					continue;
				
				var propsToSet = styleObj.allFilledProperties.filter( changes );
				if (propsToSet.has( Flags.SHADOW ))				setFilter( filters, Flags.SHADOW,			styleObj.shadow );
				if (propsToSet.has( Flags.BEVEL ))				setFilter( filters, Flags.BEVEL,			styleObj.bevel );
				if (propsToSet.has( Flags.BLUR ))				setFilter( filters, Flags.BLUR,				styleObj.blur );
				if (propsToSet.has( Flags.GLOW ))				setFilter( filters, Flags.GLOW,				styleObj.glow );
				if (propsToSet.has( Flags.GRADIENT_BEVEL ))		setFilter( filters, Flags.GRADIENT_BEVEL,	styleObj.gradientBevel );
				if (propsToSet.has( Flags.GRADIENT_GLOW ))		setFilter( filters, Flags.GRADIENT_GLOW,	styleObj.gradientGlow );
				
				changes = changes.unset( propsToSet );
			}
		
			if (changes > 0) {
				removeBoxFilters(changes, filters);
				changes = 0;
			}
		}
		
		//set new array with filters
		target.filters = filters;
	}
	
	
	private function setFilter ( filters:Array<Dynamic>, flag:UInt, filter:BitmapFilter = null )
	{
		Assert.notNull(filter);
		
		var pos = filterPositions.indexOf(flag);
		if (pos == -1)
		{
			//add filter
			filters.push( filter );
			filterPositions.push( flag );
		}
		else
			filters[ pos ] = filter;
		
		Assert.equal( filters.length, filterPositions.length );
	}
	
	
	private function unsetFilter ( filters:Array<Dynamic>, flag:UInt )
	{
		//remove filter
		var pos = filterPositions.indexOf( flag );
		if (pos > -1)
		{
			if (pos == 0) {
				filters.shift();
				filterPositions.shift();
			}
			else if	(pos == (filters.length - 1)) {
				filters.pop();
				filterPositions.pop();
			}
			else {
				filters.splice(pos, 1);
				filterPositions.splice(pos, 1);
			}
		}
		
		Assert.equal( filters.length, filterPositions.length );
	}
	
	
	private inline function removeBoxFilters (filtersToRemove:UInt, filters:Array<Dynamic>)
	{
		if (filtersToRemove.has( Flags.SHADOW ))			unsetFilter( filters, Flags.SHADOW );
		if (filtersToRemove.has( Flags.BEVEL ))				unsetFilter( filters, Flags.BEVEL );
		if (filtersToRemove.has( Flags.BLUR ))				unsetFilter( filters, Flags.BLUR );
		if (filtersToRemove.has( Flags.GLOW ))				unsetFilter( filters, Flags.GLOW );
		if (filtersToRemove.has( Flags.GRADIENT_BEVEL ))	unsetFilter( filters, Flags.GRADIENT_BEVEL );
		if (filtersToRemove.has( Flags.GRADIENT_GLOW ))		unsetFilter( filters, Flags.GRADIENT_GLOW );
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