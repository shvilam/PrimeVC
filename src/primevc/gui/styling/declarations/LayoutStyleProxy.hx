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
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.styling.declarations.StyleProxyBase;
 import primevc.gui.styling.IElementStyle;
  using primevc.utils.BitUtil;


private typedef Flags = LayoutFlags;


/**
 * @author Ruben Weijers
 * @creation-date Sep 23, 2010
 */
class LayoutStyleProxy extends StyleProxyBase < LayoutStyleDeclarations >
{
	public function new (styleSheet:IElementStyle)				{ super( styleSheet, StyleFlags.LAYOUT ); }
	override public function forwardIterator ()					{ return cast new LayoutGroupForwardIterator( styleSheet, propertyTypeFlag); }
	override public function reversedIterator ()				{ return cast new LayoutGroupReversedIterator( styleSheet, propertyTypeFlag); }

#if debug
	override public function readProperties (props:Int = -1)	{ return Flags.readProperties( (props == -1) ? filledProperties : props ); }
#end
}


class LayoutGroupForwardIterator extends StyleGroupForwardIterator < LayoutStyleDeclarations >
{
	override public function next ()	{ return setNext().data.layout; }
}


class LayoutGroupReversedIterator extends StyleGroupReversedIterator < LayoutStyleDeclarations >
{
	override public function next ()	{ return setNext().data.layout; }
}


/*
class LayoutStyleProxy extends LayoutStyleDeclarations
{
	private var target	: StyleSheet;
	public var change	(default, null)	: Signal1 < UInt >;
	
	
	public function new (newTarget:StyleSheet)
	{	
		target	= newTarget;
		change	= new Signal1();
		super();
	}
	
	
	override public function dispose ()
	{	
		change.dispose();
		change	= null;
		target	= null;
		super.dispose();
	}
	
	
	public function iterator () : Iterator < LayoutStyleDeclarations >
	{
		return new LayoutStyleIterator( target, StyleFlags.LAYOUT );
	}
	
	
	override public function updateAllFilledPropertiesFlag () : Void
	{
		super.updateAllFilledPropertiesFlag();
		
		for (styleObj in target)
		{
			if (styleObj.has( StyleFlags.LAYOUT ))
				allFilledProperties = allFilledProperties.set( styleObj.layout.allFilledProperties );
			
			if (allFilledProperties == Flags.ALL_PROPERTIES)
				break;
		}
	}
	
	
	override public function invalidateCall (changes:UInt, sender:IInvalidatable)
	{
		var t = sender.as(LayoutStyleDeclarations);
		
		if (t.owner.type != StyleDeclarationType.id)
		{
			for (styleObj in target)
			{
				if (!styleObj.has( StyleFlags.LAYOUT ))
					continue;
				
				if (styleObj.layout == t)
					break;
			
				changes = changes.unset( styleObj.layout.allFilledProperties );
			}
		}
		
		if (t.filledProperties.has(changes))	allFilledProperties = allFilledProperties.set( changes );
		else									updateAllFilledPropertiesFlag();
		
		invalidate( changes );
	}
	
	
	override public function invalidate (changes:UInt)
	{
		if (changes > 0)
			change.send( changes );
	}
	
	
	
	//
	// GETTERS
	//
	
	override private function getRelative ()
	{
		if (!has(Flags.RELATIVE))
			return _relative;
		
		var v = super.getRelative();
		if (v == null)
			for (styleObj in target)
				if (styleObj.layout != null && null != (v = styleObj.layout.relative))
					break;
		
		return v;
	}
	
	
	override private function getAlgorithm ()
	{
		if (!has(Flags.ALGORITHM))
			return _algorithm;
		
		var v = super.getAlgorithm();
		if (v == null)
			for (styleObj in target)
				if (styleObj.layout != null && null != (v = styleObj.layout.algorithm))
					break;
		
		return v;
	}
	
	
	override private function getPadding ()
	{
		if (!has(Flags.PADDING))
			return _padding;
		
		var v = super.getPadding();
		if (v == null)
			for (styleObj in target)
				if (styleObj.layout != null && null != (v = styleObj.layout.padding))
					break;
		
		return v;
	}
	
	
	override private function getWidth ()
	{
		if (!has(Flags.WIDTH))
			return _width;
		
		var v = super.getWidth();
		if (v.notSet())
			for (styleObj in target)
				if (styleObj.layout != null && (v = styleObj.layout.width).isSet())
					break;
		
		return v;
	}
	
	
	override private function getMaxWidth ()
	{
		if (!has(Flags.MAX_WIDTH))
			return _maxWidth;
		
		var v = super.getMaxWidth();
		if (v.notSet())
			for (styleObj in target)
				if (styleObj.layout != null && (v = styleObj.layout.maxWidth).isSet())
					break;
		
		return v;
	}
	
	
	
	override private function getMinWidth ()
	{
		if (!has(Flags.MIN_WIDTH))
			return _minWidth;
		
		var v = super.getMinWidth();
		if (v.notSet())
			for (styleObj in target)
				if (styleObj.layout != null && (v = styleObj.layout.minWidth).isSet())
					break;
		
		return v;
	}
	
	
	override private function getPercentWidth ()
	{
		if (!has(Flags.PERCENT_WIDTH))
			return _percentWidth;
		
		var v = super.getPercentWidth();
		if (v.notSet())
			for (styleObj in target)
				if (styleObj.layout != null && (v = styleObj.layout.percentWidth).isSet())
					break;
		
		return v;
	}
	
	
	override private function getHeight ()
	{
		if (!has(Flags.HEIGHT))
			return _height;
		
		var v = super.getHeight();
		if (v.notSet())
			for (styleObj in target)
				if (styleObj.layout != null && (v = styleObj.layout.height).isSet())
					break;
		
		return v;
	}
	
	
	override private function getMaxHeight ()
	{
		if (!has(Flags.MAX_HEIGHT))
			return _maxHeight;
		
		var v = super.getMaxHeight();
		if (v.notSet())
			for (styleObj in target)
				if (styleObj.layout != null && (v = styleObj.layout.maxHeight).isSet())
					break;
		
		return v;
	}
	
	
	override private function getMinHeight ()
	{
		if (!has(Flags.MIN_HEIGHT))
			return _minHeight;
		
		var v = super.getMinHeight();
		if (v.notSet())
			for (styleObj in target)
				if (styleObj.layout != null && (v = styleObj.layout.minHeight).isSet())
					break;
		
		return v;
	}
	
	
	override private function getPercentHeight ()
	{
		if (!has(Flags.PERCENT_HEIGHT))
			return _percentHeight;
		
		var v = super.getPercentHeight();
		if (v.notSet())
			for (styleObj in target)
				if (styleObj.layout != null && (v = styleObj.layout.percentHeight).isSet())
					break;
		
		return v;
	}
	
	
	override private function getChildWidth ()
	{
		if (!has(Flags.CHILD_WIDTH))
			return _childWidth;
		
		var v = super.getChildWidth();
		if (v.notSet())
			for (styleObj in target)
				if (styleObj.layout != null && (v = styleObj.layout.childWidth).isSet())
					break;
		
		return v;
	}
	
	
	override private function getChildHeight ()
	{
		if (!has(Flags.CHILD_HEIGHT))
			return _childHeight;
		
		var v = super.getChildHeight();
		if (v.notSet())
			for (styleObj in target)
				if (styleObj.layout != null && (v = styleObj.layout.childHeight).isSet())
					break;
		
		return v;
	}
	
	
	override private function getRotation ()
	{
		if (!has(Flags.ROTATION))
			return _rotation;
		
		var v = super.getRotation();
		if (v.notSet())
			for (styleObj in target)
				if (styleObj.layout != null && (v = styleObj.layout.rotation).isSet())
					break;
		
		return v;
	}


	override private function getIncludeInLayout ()
	{
		if (!has(Flags.INCLUDE))
			return _includeInLayout;
		
		var v = super.getIncludeInLayout();
		if (v == null)
			for (styleObj in target)
				if (styleObj.layout != null && null != (v = styleObj.layout.includeInLayout))
					break;
		
		return v;
	}
	
	
	override private function getMaintainAspect ()
	{
		if (!has(Flags.MAINTAIN_ASPECT))
			return _maintainAspectRatio;
		
		var v = super.getMaintainAspect();
		if (v == null)
			for (styleObj in target)
				if (styleObj.layout != null && null != (v = styleObj.layout.maintainAspectRatio))
					break;
		
		return v;
	}
}



import primevc.core.collections.DoubleFastCell;


private typedef StyleGroupType	= LayoutStyleDeclarations;
private typedef CellType		= DoubleFastCell < UIElementStyle >;


class LayoutStyleIterator  // < StyleGroupType > #if (flash9 || cpp) implements haxe.rtti.Generic #end
{
	private var target	: StyleSheet;
	private var current	: CellType;
	private var flag	: UInt;
	
	
	public function new (target:StyleSheet, groupFlag:UInt)
	{
		this.target	= target;
		flag		= groupFlag;
		setCurrent( target.styles.first );
	}
	
	
	public function hasNext ()
	{
		return current != null;
	}
	
	
	public function next () : LayoutStyleDeclarations
	{
		var c = current;
		current = current.next;
		return c.data.layout;
	}
	
	
	private function setCurrent ( styleCell:CellType )
	{
		if (styleCell == null)
			current = null;
		else if (styleCell.data.has( flag ))
			current = styleCell;
		else if (styleCell.next != null)
			setCurrent( styleCell.next );
		else
			current = null;
	}
}*/