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
package primevc.gui.layout.algorithms.float;
 import primevc.core.geom.space.Horizontal;
 import primevc.core.geom.IRectangle;
 import primevc.gui.layout.algorithms.HorizontalBaseAlgorithm;
 import primevc.gui.layout.algorithms.IHorizontalAlgorithm;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.utils.NumberMath;
  using primevc.utils.NumberMath;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
  using Std;
 

/**
 * Floating algorithm for horizontal layouts
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class HorizontalFloatAlgorithm extends HorizontalBaseAlgorithm, implements IHorizontalAlgorithm
{
	/**
	 * Measured point of the right side of the middlest child (rounded above) 
	 * when the direction is center.
	 */
	private var halfWidth			: Int;
	
	
	public inline function validate ()
	{
		if (group.children.length == 0)
			return;

		validateHorizontal();
		validateVertical();
	}
	
	
	/**
	 * Method will return the total width of all the children.
	 */
	public function validateHorizontal ()
	{
		var width:Int = halfWidth = 0;
		
		if (group.childWidth.notSet())
		{
			var i:Int = 0;
			for (child in group.children)
			{
				if (!child.includeInLayout)
					continue;
				
				width += child.outerBounds.width;
				
				//only count even children
				if (i % 2 == 0)
					halfWidth += child.outerBounds.width;
				
				i++;
			}
		}
		else
		{
			width		= group.childWidth * group.children.length;
			halfWidth	= group.childWidth * group.children.length.divCeil(2);
		}
		
		setGroupWidth(width);
	}


	override public function apply ()
	{
		switch (direction) {
			case Horizontal.left:		applyLeftToRight();
			case Horizontal.center:		applyCentered();
			case Horizontal.right:		applyRightToLeft();
		}
		super.apply();
	}
	
	
	private inline function applyLeftToRight (next:Int = -1) : Void
	{
		if (group.children.length > 0)
		{
			if (next == -1)
				next = getLeftStartValue();
		
			//use 2 loops for algorithms with and without a fixed child-width. This is faster than doing the if statement inside the loop!
			if (group.childWidth.notSet())
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.left	= next;
					next					= child.outerBounds.right;
				}
			} 
			else
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.left	 = next;
					next					+= group.childWidth;
				}
			}
		}
	}
	
	
	private inline function applyCentered () : Void
	{
		applyLeftToRight( getHorCenterStartValue() );
		/*if (group.children.length > 0)
		{
			var i:Int = 0;
			var evenPos:Int, oddPos:Int;
			evenPos = oddPos = halfWidth + getLeftStartValue();
		
			//use 2 loops for algorithms with and without a fixed child-width. This is faster than doing the if statement inside the loop!
			if (group.childWidth.notSet())
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					if (i % 2 == 0) {
						//even
						child.bounds.right	= evenPos;
						evenPos				= child.bounds.left;
					} else {
						//odd
						child.bounds.left	= oddPos;
						oddPos				= child.bounds.right;
					}
					i++;
				}
			}
			else
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					if (i % 2 == 0) {
						//even
						child.bounds.right	 = evenPos;
						evenPos				-= group.childWidth;
					} else {
						//odd
						child.bounds.left	 = oddPos;
						oddPos				+= group.childWidth;
					}
					i++;
				}
			}
		}*/
	}
	
	
	private inline function applyRightToLeft () : Void
	{
		if (group.children.length > 0)
		{
			var next = getRightStartValue();
		
			//use 2 loops for algorithms with and without a fixed child-width. This is faster than doing the if statement inside the loop!
			if (group.childWidth.notSet())
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.right	= next;
					next					= child.outerBounds.left;
				}
			}
			else
			{
				next -= group.childWidth;
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.left	= next;
					next					= child.outerBounds.left - group.childWidth;
				}
			}
		}
	}

	
	public inline function getDepthForBounds (bounds:IRectangle) : Int
	{
		return switch (direction) {
			case Horizontal.left:		getDepthForBoundsLtR(bounds);
			case Horizontal.center:		getDepthForBoundsC(bounds);
			case Horizontal.right:		getDepthForBoundsRtL(bounds);
		}
	}
	
	
	private inline function getDepthForBoundsLtR (bounds:IRectangle) : Int
	{
		var depth:Int	= 0;
		var posX:Int	= bounds.left;
		var centerX:Int	= bounds.left + (bounds.width * .5).int();
		
		if (group.childWidth.isSet())
		{
			depth = posX.divRound(group.childWidth);
		}
		else
		{
			//if pos <= 0, the depth will be 0
			if (posX > 0)
			{
				//check if it's smart to start searching at the end or at the beginning..
				var groupWidth = group.width.value;
				if (group.is(AdvancedLayoutClient))
					groupWidth = IntMath.max( 0, group.as(AdvancedLayoutClient).measuredWidth );
				
				var halfW = groupWidth * .5;
				if (posX < halfW) {
					//start at beginning
					for (child in group.children) {
						if (child.includeInLayout && centerX <= child.outerBounds.right && centerX >= child.outerBounds.left)
							break;
						
						depth++;
					}
				}
				else
				{
					//start at end
					var itr	= group.children.reversedIterator();
					depth	= group.children.length;
					while (itr.hasNext()) {
						var child = itr.next();
						if (child.includeInLayout && centerX >= child.outerBounds.right)
							break;
						
						depth--;
					}
				}
			}
		}
		return depth;
	}
	
	
	private inline function getDepthForBoundsC (bounds:IRectangle) : Int
	{
		Assert.abstract( "Wrong implementation since the way centered layouts behave is changed");
		var depth:Int	= 0;
		var posX:Int	= bounds.left;
		var centerX:Int	= bounds.left + (bounds.width * .5).int();
		
		var groupWidth	= group.width.value;
		if (group.is(AdvancedLayoutClient))
			groupWidth	= IntMath.max( 0, group.as(AdvancedLayoutClient).measuredWidth );

		var halfW = groupWidth * .5;

		for (child in group.children) {
			if (child.includeInLayout 
				&& (
						(centerX <= child.outerBounds.right && centerX >= halfW)
					||	(centerX >= child.outerBounds.right && centerX <= halfW)
				)
			)
				break;

			depth++;
		}
		return depth;
	}
	
	
	private inline function getDepthForBoundsRtL (bounds:IRectangle) : Int
	{
		var depth:Int	= 0;
		var posX:Int	= bounds.left;
		var centerX:Int	= bounds.left + (bounds.width * .5).int();
		
		var groupWidth = group.width.value;
		var emptyWidth = 0;
		if (group.is(AdvancedLayoutClient))
		{
			groupWidth	= IntMath.max( 0, group.as(AdvancedLayoutClient).measuredWidth );
			//check if there's any width left. This happens when there's an explicitWidth set.
			emptyWidth	= IntMath.max( 0, group.width.value - groupWidth );
		}
		
		if (group.childWidth.isSet())
		{
			depth = group.children.length - ( posX - emptyWidth ).divRound( group.childWidth );
		}
		else
		{
			//if pos <= emptyWidth, the depth will be at the end of the list
			if (posX <= emptyWidth)
				depth = group.children.length;
			
			//if bounds.right < maximum group width, then the depth is at the beginning of the list
			else if (bounds.right < IntMath.max(group.width.value, groupWidth))
			{
				//check if it's smart to start searching at the end or at the beginning..
				var halfW = groupWidth * .5;

				if (posX > (emptyWidth + halfW)) {
					//start at beginning
					for (child in group.children) {
						if (child.includeInLayout && centerX >= child.outerBounds.left)
							break;
						
						depth++;
					}
				}
				else
				{
					//start at end
					var itr	= group.children.reversedIterator();
					depth	= group.children.length - 1;
					while (itr.hasNext()) {
						var child = itr.next();
						if (child.includeInLayout && centerX <= child.outerBounds.right)
							break;

						depth--;
					}
				}
			}

		}
		return depth;
	}
	
	
#if (neko || debug)
	override public function toCSS (prefix:String = "") : String
	{
		return "float-hor (" + direction + ", " + vertical + ")";
	}
#end
}