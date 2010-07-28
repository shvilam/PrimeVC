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
 import primevc.core.geom.Point;
 import primevc.gui.layout.algorithms.directions.Horizontal;
 import primevc.gui.layout.algorithms.IHorizontalAlgorithm;
 import primevc.gui.layout.algorithms.LayoutAlgorithmBase;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.utils.IntMath;
  using primevc.utils.BitUtil;
  using primevc.utils.IntMath;
  using primevc.utils.IntUtil;
  using primevc.utils.TypeUtil;
 

/**
 * Floating algorithm for horizontal layouts
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class HorizontalFloatAlgorithm extends LayoutAlgorithmBase, implements IHorizontalAlgorithm
{
	public var direction			(default, setDirection)	: Horizontal;
	
	/**
	 * Measured point of the right side of the middlest child (rounded above) 
	 * when the direction is center.
	 */
	private var halfWidth			: Int;
	
	
	public function new ( ?direction )
	{
		super();
		this.direction = direction == null ? Horizontal.left : direction;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	/**
	 * Setter for direction property. Method will change the apply method based
	 * on the given direction. After that it will dispatch a 'directionChanged'
	 * signal.
	 */
	private inline function setDirection (v:Horizontal)
	{
		if (v != direction) {
			direction = v;
			algorithmChanged.send();
		}
		return v;
	}
	
	
	
	//
	// LAYOUT
	//
	
	/**
	 * Method indicating if the size is invalidated or not.
	 */
	public inline function isInvalid (changes:Int)	: Bool
	{
		return changes.has( LayoutFlags.WIDTH_CHANGED ) && group.childWidth.notSet();
	}
	
	
	public inline function measure ()
	{
		if (group.children.length == 0)
			return;
		
		measureHorizontal();
		measureVertical();
	}
	
	
	public inline function measureVertical ()
	{
		var height:Int = group.childHeight;
		
		if (group.childHeight.notSet())
		{
			height = 0;
			for (child in group.children)
				if (child.includeInLayout && child.bounds.height > height)
					height = child.bounds.height;
		}
		
		setGroupHeight(height);
	}
	
	
	/**
	 * Method will return the total width of all the children.
	 */
	public function measureHorizontal ()
	{
		var width:Int = halfWidth = 0;
		
		if (group.childWidth.notSet())
		{
			var i:Int = 0;
			
			for (child in group.children) {
				if (!child.includeInLayout)
					continue;
				
				if (child.bounds.width.isSet())
				{
					width += child.bounds.width;
				
					//only count even children
					if (i % 2 == 0)
						halfWidth += child.bounds.width;
				}
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


	public inline function apply ()
	{
		switch (direction) {
			case Horizontal.left:		applyLeftToRight();
			case Horizontal.center:		applyCentered();
			case Horizontal.right:		applyRightToLeft();
		}
		measurePrepared = false;
	}
	
	
	private inline function applyLeftToRight () : Void
	{
		if (group.children.length > 0)
		{
			var next = getLeftStartValue();
		
			//use 2 loops for algorithms with and without a fixed child-width. This is faster than doing the if statement inside the loop!
			if (group.childWidth.notSet())
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.bounds.left	= next;
					next				= child.bounds.right;
				}
			} 
			else
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.bounds.left	 = next;
					next				+= group.childWidth;
				}
			}
		}
	}
	
	
	private inline function applyCentered () : Void
	{
		if (group.children.length > 0)
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
		}
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
					
					child.bounds.right	= next;
					next				= child.bounds.left;
				}
			}
			else
			{
				next -= group.childWidth;
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.bounds.left	= next;
					next				= child.bounds.left - group.childWidth;
				}
			}
		}
	}


	/**
	 * 
	 */
	public inline function getDepthForPosition (pos:Point) : Int
	{
		return switch (direction) {
			case Horizontal.left:		getDepthForPositionLtR(pos);
			case Horizontal.center:		getDepthForPositionC(pos);
			case Horizontal.right:		getDepthForPositionRtL(pos);
		}
	}
	
	
	private inline function getDepthForPositionLtR (pos:Point) : Int
	{
		var depth:Int	= 0;
		var posX:Int	= Std.int( pos.x + group.scrollX );
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
					groupWidth = IntMath.min( group.as(AdvancedLayoutClient).measuredWidth, group.as(AdvancedLayoutClient).explicitWidth );
				
				var halfW = groupWidth * .5;
				
				if (posX < halfW) {
					//start at beginning
					for (child in group.children) {
						if (child.includeInLayout && posX <= child.bounds.centerX)
							break;
						
						depth++;
					}
				}
				else
				{
					//start at end
					var itr	= group.children.getReversedIterator();
					depth	= group.children.length;
					while (itr.hasNext()) {
						var child = itr.next();
						if (child.includeInLayout && posX >= child.bounds.centerX)
							break;
						
						depth--;
					}
				}
			}
		}
		return depth;
	}
	
	
	private inline function getDepthForPositionC (pos:Point) : Int
	{
		var depth:Int	= 0;
		var posX:Int	= Std.int( pos.x + group.scrollX );
		var groupWidth = group.width;
		if (group.is(AdvancedLayoutClient))
			groupWidth = IntMath.min( group.as(AdvancedLayoutClient).measuredWidth, group.as(AdvancedLayoutClient).explicitWidth );

		var halfW = groupWidth * .5;

		for (child in group.children) {
			if (child.includeInLayout 
				&& (
						(posX <= child.bounds.centerX && posX >= halfW)
					||	(posX >= child.bounds.centerX && posX <= halfW)
				)
			)
				break;

			depth++;
		}
		return depth;
	}
	
	
	private inline function getDepthForPositionRtL (pos:Point) : Int
	{
		var depth:Int	= 0;
		var posX:Int	= Std.int( pos.x + group.scrollX );
		
		if (group.childWidth.isSet())
		{
			depth = group.children.length - posX.divRound(group.childWidth);
		}
		else
		{
			var groupWidth = group.width;
			if (group.is(AdvancedLayoutClient))
				groupWidth = IntMath.min( group.as(AdvancedLayoutClient).measuredWidth, group.as(AdvancedLayoutClient).explicitWidth );
			
			//if pos <= 0, the depth will be at the end of the list
			if (posX <= 0)
				depth = group.children.length;
			
			else if (posX < groupWidth)
			{
				//check if it's smart to start searching at the end or at the beginning..
				var halfW = groupWidth * .5;

				if (posX > halfW) {
					//start at beginning
					for (child in group.children) {
						if (child.includeInLayout && posX >= child.bounds.centerX)
							break;
						
						depth++;
					}
				}
				else
				{
					//start at end
					var itr	= group.children.getReversedIterator();
					depth	= group.children.length;
					while (itr.hasNext()) {
						var child = itr.next();
						if (child.includeInLayout && posX <= child.bounds.centerX)
							break;

						depth--;
					}
				}
			}

		}
		return depth;
	}
	
	
	
	
	//
	// START VALUES
	//
	
	private inline function getLeftStartValue ()	: Int
	{
		var left:Int = 0;
		if (group.padding != null)
			left = group.padding.left;
		
		return left;
	}
	
	
	private inline function getRightStartValue ()	: Int
	{
		var w = group.width;
		if (group.is(AdvancedLayoutClient))
			w = IntMath.max(group.as(AdvancedLayoutClient).measuredWidth, w);
		
		if (group.padding != null)
			w += group.padding.left; // + group.padding.right;
		return w;
	}
	
	
#if debug
	public function toString ()
	{
		var start	= direction == Horizontal.left ? "left" : "right";
		var end		= direction == Horizontal.left ? "right" : "left";
		return group.name + ".Float.hor " + start + " -> " + end;
	}
#end
}