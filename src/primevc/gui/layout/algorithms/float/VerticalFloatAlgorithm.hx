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
 import primevc.gui.layout.algorithms.directions.Vertical;
 import primevc.gui.layout.algorithms.IVerticalAlgorithm;
 import primevc.gui.layout.algorithms.LayoutAlgorithmBase;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.utils.IntMath;
  using primevc.utils.BitUtil;
  using primevc.utils.IntMath;
  using primevc.utils.IntUtil;
  using primevc.utils.TypeUtil;


/**
 * Floating algorithm for vertical layouts
 * 
 * @creation-date	Jun 24, 2010
 * @author			Ruben Weijers
 */
class VerticalFloatAlgorithm extends LayoutAlgorithmBase, implements IVerticalAlgorithm
{
	public var direction	(default, setDirection)		: Vertical;
	
	/**
	 * Measured point of the bottom side of the middlest child (rounded above)
	 * when the direction is center.
	 */
	private var halfHeight	: Int;
	
	
	public function new (?direction)
	{
		super();
		this.direction = direction == null ? Vertical.top : direction;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	/**
	 * Setter for direction property. Method will change the apply method based
	 * on the given direction. After that it will dispatch a 'directionChanged'
	 * signal.
	 */
	private inline function setDirection (v:Vertical) {
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
	public inline function isInvalid (changes:Int)	: Bool {
		return changes.has( LayoutFlags.HEIGHT_CHANGED ) && group.childHeight.notSet();
	}
	
	
	/**
	 * Method will return the total height of all the children.
	 */
	public inline function measure ()
	{
		if (group.children.length == 0)
			return;
		
		measureHorizontal();
		measureVertical();
	}
	
	
	public inline function measureHorizontal ()
	{
		var width:Int = group.childWidth;
		
		if (group.childWidth.notSet())
		{
			width = 0;
			for (child in group.children)
				if (child.includeInLayout && child.bounds.width > width)
					width = child.bounds.width;
		}
		setGroupWidth(width);
	}
	
	
	public function measureVertical ()
	{
		var height:Int = halfHeight = 0;
		
		if (group.childHeight.notSet())
		{
			var i:Int = 0;
			
			for (child in group.children) {
				if (!child.includeInLayout)
					continue;
				
				if (child.bounds.height.isSet())
				{
					height += child.bounds.height;
				
					//only count even children
					if (i % 2 == 0)
						halfHeight += child.bounds.height;
				}
				i++;
			}
		}
		else
		{
			height		= group.childHeight * group.children.length;
			halfHeight	= group.childHeight * group.children.length.divCeil(2);
		}
		
		setGroupHeight(height);
	}


	public inline function apply ()
	{
		switch (direction) {
			case Vertical.top:		applyTopToBottom();
			case Vertical.center:	applyCentered();
			case Vertical.bottom:	applyBottomToTop();
		}
		measurePrepared = false;
	}
	
	
	private inline function applyTopToBottom () : Void
	{
		if (group.children.length > 0)
		{
			var next = getTopStartValue();
		
			//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
			if (group.childHeight.notSet())
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.bounds.top	= next;
					next				= child.bounds.bottom;
				}
			}
			else
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.bounds.top	 = next;
					next				+= group.childHeight;
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
			evenPos = oddPos = halfHeight + getTopStartValue();
		
			//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
			if (group.childHeight.notSet())
			{
				for (child in group.children)
				{
					if (!child.includeInLayout)
						continue;
					
					if (i % 2 == 0) {
						//even
						child.bounds.bottom	= evenPos;
						evenPos				= child.bounds.top;
					} else {
						//odd
						child.bounds.top	= oddPos;
						oddPos				= child.bounds.bottom;
					}
					i++;
				}
			}
			else
			{
				for (child in group.children)
				{
					if (!child.includeInLayout)
						continue;
					
					if (i % 2 == 0) {
						//even
						child.bounds.bottom	 = evenPos;
						evenPos				-= group.childHeight;
					} else {
						//odd
						child.bounds.top	 = oddPos;
						oddPos				+= group.childHeight;
					}
					i++;
				}
			}
		}
	}
	
	
	private inline function applyBottomToTop () : Void
	{
		if (group.children.length > 0)
		{
			var next = getBottomStartValue();
			
			//use 2 loops for algorithms with and without a fixed child-height. This is faster than doing the if statement inside the loop!
			if (group.childHeight.notSet())
			{
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.bounds.bottom	= next;
					next				= child.bounds.top;
				}
			}
			else
			{
				next -= group.childHeight;
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.bounds.top	= next;
					next				= child.bounds.top - group.childHeight;
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
			case Vertical.top:		getDepthForPositionTtB(pos);
			case Vertical.center:	getDepthForPositionC(pos);
			case Vertical.bottom:	getDepthForPositionBtT(pos);
		}
	}


	private inline function getDepthForPositionTtB (pos:Point) : Int
	{
		var depth:Int	= 0;
		var posY:Int	= Std.int( pos.y + group.scrollY );

		if (group.childHeight.isSet())
		{
			depth = posY.divRound(group.childHeight);
		}
		else
		{
			//if pos <= 0, the depth will be 0
			if (posY > 0)
			{
				//check if it's smart to start searching at the end or at the beginning..
				var groupHeight = group.height;
				if (group.is(AdvancedLayoutClient))
					groupHeight = IntMath.min( group.as(AdvancedLayoutClient).measuredHeight, group.as(AdvancedLayoutClient).explicitHeight );
				
				var halfH = groupHeight * .5;

				if (posY < halfH) {
					//start at beginning
					for (child in group.children) {
						if (child.includeInLayout && posY <= child.bounds.centerY)
							break;

						depth++;
					}
				}
				else
				{
					//start at end
					var itr		= group.children.getReversedIterator();
					var depth	= group.children.length;
					while (itr.hasNext()) {
						var child = itr.next();
						if (child.includeInLayout && posY >= child.bounds.centerY)
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
		var posY:Int	= Std.int( pos.y + group.scrollY );
		var length		= group.children.length;

		if (posY < halfHeight)
		{
			if (length % 2 == 1)
				length -= 1;

			var topDepth	= getDepthForPositionTtB(pos);
			depth			= length - (2 * topDepth);
		}
		else
		{
			var bottomDepth	= getDepthForPositionBtT(pos);
			depth			= length - (2 * bottomDepth);
		}
		return depth;
	}


	private inline function getDepthForPositionBtT (pos:Point) : Int
	{
		var depth:Int	= 0;
		var posY:Int	= Std.int( pos.y + group.scrollY );

		if (group.childHeight.isSet())
		{
			depth = group.children.length - posY.divRound(group.childHeight);
		}
		else
		{
			var groupHeight = group.height;
			if (group.is(AdvancedLayoutClient))
				groupHeight = IntMath.min( group.as(AdvancedLayoutClient).measuredHeight, group.as(AdvancedLayoutClient).explicitHeight );
			
			//if pos <= 0, the depth will be 0
			if (posY > groupHeight)
			{
				//check if it's smart to start searching at the end or at the beginning..
				var halfH = groupHeight * .5;

				if (posY < halfH) {
					//start at beginning
					for (child in group.children) {
						if (child.includeInLayout && posY <= child.bounds.centerY)
							break;

						depth++;
					}
				}
				else
				{
					//start at end
					var itr		= group.children.getReversedIterator();
					var depth	= group.children.length;
					while (itr.hasNext()) {
						var child = itr.next();
						if (child.includeInLayout && posY >= child.bounds.centerY)
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
	
	private inline function getTopStartValue ()		: Int
	{
		var top:Int = 0;
		if (group.padding != null)
			top = group.padding.top;
		
		return top;
	}
	
	
	private inline function getBottomStartValue ()	: Int	{
		var h:Int = group.height;
		if (group.is(AdvancedLayoutClient))
			h = IntMath.max(group.as(AdvancedLayoutClient).measuredHeight, h);
		
		if (group.padding != null)
			h += group.padding.top; // + group.padding.bottom;
		
		return h;
	}
	
	
#if debug
	public function toString ()
	{
		var start = direction == Vertical.top ? "top" : "bottom";
		var end = direction == Vertical.top ? "bottom" : "top";
		return group + ".Float.ver ( " + start + " -> " + end + " ) ";
	}
#end
}