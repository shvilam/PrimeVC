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
package primevc.gui.layout.algorithms;
 import primevc.core.geom.space.Horizontal;
 import primevc.core.geom.space.Vertical;
 import primevc.gui.layout.algorithms.LayoutAlgorithmBase;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.utils.IntMath;
  using primevc.utils.BitUtil;
  using primevc.utils.IntUtil;
  using primevc.utils.TypeUtil;
  using Std;



/**
 * Base class for horizontal layout algorithms
 * 
 * @author Ruben Weijers
 * @creation-date Sep 03, 2010
 */
class HorizontalBaseAlgorithm extends LayoutAlgorithmBase
{
	public var direction			(default, setDirection)	: Horizontal;
	
	/**
	 * Property indicating if and how the children of the group should be 
	 * positioned vertically.
	 * The algorithm won't touch the y position of the children when this 
	 * property is null.
	 * 
	 * @default null
	 */
	public var vertical				(default, setVertical)	: Vertical;
	
	
	public function new ( ?direction:Horizontal, ?vertical:Vertical = null )
	{
		super();
		this.direction	= direction == null ? Horizontal.left : direction;
		this.vertical	= vertical;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	/**
	 * Setter for direction property. Method will change the apply method based
	 * on the given direction. After that it will dispatch a 'directionChanged'
	 * signal.
	 */
	private inline function setDirection (v:Horizontal) : Horizontal
	{
		if (v != direction) {
			direction = v;
			algorithmChanged.send();
		}
		return v;
	}


	private inline function setVertical (v:Vertical) : Vertical
	{
		if (v != vertical) {
			vertical = v;
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
		return (changes.has( LayoutFlags.WIDTH_CHANGED ) && group.childWidth.notSet()) || ( vertical != null && changes.has( LayoutFlags.HEIGHT_CHANGED ) );
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


	public function apply ()
	{
		switch (vertical) {
			case Vertical.top:			applyVerticalTop();
			case Vertical.center:		applyVerticalCenter();
			case Vertical.bottom:		applyVerticalBottom();
		}
		measurePrepared = false;
	}
	


	private inline function applyVerticalTop ()
	{
		if (group.children.length > 0)
		{
			for (child in group.children) {
				if (!child.includeInLayout)
					continue;

				child.bounds.top = 0;
			}
		}
	}
	
	
	private inline function applyVerticalCenter ()
	{
		if (group.children.length > 0)
		{
			if (group.childHeight.notSet())
			{	
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.bounds.top = ( (group.bounds.height - child.bounds.height) * .5 ).int();
				}
			}
			else
			{
				var childY = ( (group.bounds.height - group.childHeight) * .5 ).int();
				for (child in group.children)
					if (child.includeInLayout)
						child.bounds.top = childY;
			}
		}
	}
	
	
	private inline function applyVerticalBottom ()
	{
		if (group.children.length > 0)
		{
			if (group.childHeight.notSet())
			{	
				for (child in group.children) {
					if (!child.includeInLayout)
						continue;
					
					child.bounds.top = group.bounds.height - child.bounds.height;
				}
			}
			else
			{
				var childY = group.bounds.height - group.childHeight;
				for (child in group.children)
					if (child.includeInLayout)
						child.bounds.top = childY;
			}
		}
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
}