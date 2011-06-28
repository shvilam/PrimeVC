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
 import primevc.utils.NumberUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
 

/**
 * Floating algorithm for horizontal layouts
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class HorizontalFloatAlgorithm extends HorizontalBaseAlgorithm, implements IHorizontalAlgorithm
{
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
		var width:Int	= 0;
		var children	= group.children;
		
		if (group.childWidth.notSet())
		{
			for (i in 0...children.length)
			{
				var child = children.getItemAt(i);
				if (!child.includeInLayout)
					continue;
				
				width += child.outerBounds.width;
			}
		}
		else
			width = group.childWidth * group.childrenLength;
		
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
			
			var children = group.children;
			Assert.that(next.isSet());
			
			//use 2 loops for algorithms with and without a fixed child-width. This is faster than doing the if statement inside the loop!
			if (group.childWidth.notSet())
			{
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.left	= next;
					next					= child.outerBounds.right;
				}
			} 
			else
			{
				if (group.fixedChildStart.isSet())
					next += group.fixedChildStart * group.childWidth;
				
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
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
	}
	
	
	private inline function applyRightToLeft () : Void
	{
		if (group.children.length > 0)
		{
			var next		= getRightStartValue();
			var children	= group.children;
			Assert.that(next.isSet(), "beginvalue can't be unset for "+group+". Make sure the group has a width.");
			
			//use 2 loops for algorithms with and without a fixed child-width. This is faster than doing the if statement inside the loop!
			if (group.childWidth.notSet())
			{
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
					if (!child.includeInLayout)
						continue;
					
					child.outerBounds.right	= next;
					next					= child.outerBounds.left;
				}
			}
			else
			{
				next -= group.childWidth;
				if (group.fixedChildStart.isSet())
					next -= group.fixedChildStart * group.childWidth;
				
				for (i in 0...children.length)
				{
					var child = children.getItemAt(i);
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
		var centerX:Int	= bounds.left + (bounds.width >> 1); //* .5).roundFloat();
		var children	= group.children;
		
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
				var groupWidth = group.width;
				if (group.is(AdvancedLayoutClient))
					groupWidth = IntMath.max( 0, group.as(AdvancedLayoutClient).measuredWidth );
				
				var halfW = groupWidth >> 1; //* .5;
				if (posX < halfW) {
					//start at beginning
					for (i in 0...children.length)
					{
						var child = children.getItemAt(i);
						if (child.includeInLayout && centerX <= child.outerBounds.right && centerX >= child.outerBounds.left)
							break;
						
						depth++;
					}
				}
				else
				{
					//start at end
					var itr	= children.reversedIterator();
					depth	= children.length;
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
		var centerX:Int	= bounds.left + (bounds.width >> 1); // * .5).roundFloat();
		var children	= group.children;
		
		var groupWidth	= group.width;
		if (group.is(AdvancedLayoutClient))
			groupWidth	= IntMath.max( 0, group.as(AdvancedLayoutClient).measuredWidth );

		var halfW = groupWidth >> 1; // * .5;
		for (i in 0...children.length)
		{
			var child = children.getItemAt(i);
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
		var centerX:Int	= bounds.left + (bounds.width >> 1); //* .5).roundFloat();
		
		var children	= group.children;
		var groupWidth	= group.width;
		var emptyWidth	= 0;
		if (group.is(AdvancedLayoutClient))
		{
			groupWidth	= IntMath.max( 0, group.as(AdvancedLayoutClient).measuredWidth );
			//check if there's any width left. This happens when there's an explicitWidth set.
			emptyWidth	= IntMath.max( 0, group.width - groupWidth );
		}
		
		if (group.childWidth.isSet())
		{
			depth = children.length - ( posX - emptyWidth ).divRound( group.childWidth );
		}
		else
		{
			//if pos <= emptyWidth, the depth will be at the end of the list
			if (posX <= emptyWidth)
				depth = children.length;
			
			//if bounds.right < maximum group width, then the depth is at the beginning of the list
			else if (bounds.right < IntMath.max(group.width, groupWidth))
			{
				//check if it's smart to start searching at the end or at the beginning..
				var halfW = groupWidth >> 1; //* .5;

				if (posX > (emptyWidth + halfW)) {
					//start at beginning
					for (i in 0...children.length)
					{
						var child = children.getItemAt(i);
						if (child.includeInLayout && centerX >= child.outerBounds.left)
							break;
						
						depth++;
					}
				}
				else
				{
					//start at end
					var itr	= children.reversedIterator();
					depth	= children.length - 1;
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
	
	
	override public function getDepthOfFirstVisibleChild ()	: Int
	{
		if (group.childWidth.notSet())
			return 0;
		
		Assert.that(group.is(IScrollableLayout), group+" should be scrollable");
		var group	= group.as(IScrollableLayout);
		var childW	= group.childWidth;
		
		return switch (direction) {
			case Horizontal.left:	(group.scrollPos.x / childW).floorFloat();
			case Horizontal.center:	0;
			case Horizontal.right:	(group.scrollableWidth / childW).floorFloat();
		}
	}
	
	
	override public function getMaxVisibleChildren () : Int
	{
		var g = this.group;
		return g.childWidth.isSet() && g.width.isSet() ? IntMath.min( (g.width / g.childWidth).ceilFloat() + 1, g.childrenLength) : 0;
	}
	
	
#if (neko || debug)
	override public function toCSS (prefix:String = "") : String
	{
		return "float-hor (" + direction + ", " + vertical + ")";
	}
#end
}