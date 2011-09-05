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
package primevc.gui.layout;
 import primevc.core.collections.IEditableList;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;


/**
 * @since	mar 19, 2010
 * @author	Ruben Weijers
 */
interface ILayoutContainer implements ILayoutClient
{
	public var algorithm			(default, setAlgorithm)		: ILayoutAlgorithm;
	
	
	//
	// CHILDREN
	//
	
	/**
	 * List with all the children of the group
	 */
	public var children				(default, null)				: IEditableList<LayoutClient>;

	/**
	 * Property with the actual length of the children list. Use this property
	 * instead of 'children.length' when an algorithm is calculating the 
	 * measured size, since the property can also be set fixed and thus have a 
	 * different number then children.length.
	 * 
	 * When applying an algorithm you should still use children.length since 
	 * the algorithm will only be applied on the actual children in the list.
	 * 
	 * @see LayoutContainer.setFixedLength
	 */
	public var childrenLength		(default, null)				: Int;
	/**
	 * Number that tells the algorithms the fake-index of the first layoutclient.
	 * If it's bigger then 0 it means that the algorithm should also include the
	 * size of the children before when measuring the container.
	 *
	 * For example:
	 * 		fixedChildStart = 5
	 *		childrenLength	= 100
	 *		children.length	= 10
	 *
	 *		in this case, the layoutContainer knows that there should be 100 layout-children,
	 *		but only 10 are added (for performance sake). So the children that are added
	 *		are 5 - 15. That means the measuredWidth and height should include the 5 children
	 *		before and the 85 children after the current added children.
	 *
	 *		Off course, this is only possible if the layoutContainer has a childWidth and
	 *		a childHeight.
	 *
	 * @see IScrollableLayout.fixedChildStart
	 */
	public var fixedChildStart		(default, default)				: Int;
	/**
	 * Number of rows or columns (depending on the algorithm) that should be
	 * added before the first visible child (in case not all the layoutclients are added).
	 */
	public var invisibleBefore		(default, setInvisibleBefore)	: Int;
	/**
	 * @see invisibleBefore
	 */
	public var invisibleAfter		(default, setInvisibleAfter)	: Int;
	
	/**
	 * The maximum width of each child. Their orignal width will be ignored if
	 * the child is bigger then this number (it won't get resized).
	 * 
	 * @default		Number.INT_NOT_SET
	 */
	public var childWidth			(default, setChildWidth)	: Int;
	/**
	 * The maximum height of each child. Their orignal height will be ignored if
	 * the child is heigher then this number (it won't get resized).
	 * 
	 * @default		Number.INT_NOT_SET
	 */
	public var childHeight			(default, setChildHeight)	: Int;
}