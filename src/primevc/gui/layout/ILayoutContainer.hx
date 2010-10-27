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
 import primevc.core.collections.IList;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;


/**
 * @since	mar 19, 2010
 * @author	Ruben Weijers
 */
interface ILayoutContainer <ChildType:LayoutClient> implements ILayoutClient
{
	public var algorithm			(default, setAlgorithm)		: ILayoutAlgorithm;
	/**
	 * Method that is called by a child of the layoutgroup to let the group
	 * know that the child is changed. The layoutgroup can than decide, based 
	 * on the used algorithm, if the group should be invalidated as well or
	 * if the change in the child is not important.
	 * 
	 * @param	change		integer containing the change flags of the child
	 * 			that is changed
	 * @return	true if the change invalidates the parent as well, otherwise 
	 * 			false
	 */
//	public function childInvalidated (childChanges:Int)			: Bool;
	
	/**
	 * List with all the children of the group
	 */
	public var children				(default, null)				: IList<ChildType>;
	
	
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