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
package primevc.gui.layout.algorithms.relative;
// import primevc.core.Number;
 import primevc.core.geom.constraints.ConstrainedRect;
 import primevc.core.geom.Box;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.algorithms.LayoutAlgorithmBase;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.RelativeLayout;
  using primevc.utils.BitUtil;
  using primevc.utils.IntUtil;



/**
 * Relative Algorithm allows layout-children to apply relative properties.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 12, 2010
 */
class RelativeAlgorithm extends LayoutAlgorithmBase, implements ILayoutAlgorithm
{
	public function isInvalid (changes:Int)
	{
		return changes.has( LayoutFlags.WIDTH_CHANGED ) 
				|| changes.has( LayoutFlags.HEIGHT_CHANGED )
				|| changes.has( LayoutFlags.X_CHANGED )
				|| changes.has( LayoutFlags.Y_CHANGED )
				|| changes.has( LayoutFlags.RELATIVE_CHANGED );
	}
	
	
	public function measure () {}
	public function measureHorizontal () {}
	public function measureVertical () {}
	
	
	public function apply ()
	{
		var childProps	: RelativeLayout;
		var childBounds	: ConstrainedRect;
		var padding = group.padding;
		
		for (child in group.children)
		{
			if (child.relative == null || !child.includeInLayout)
				continue;
			
			childProps	= child.relative;
			childBounds	= child.bounds;
			
			
			
			//
			//apply horizontal
			//
			
			if (childProps.left.isSet() && childProps.right.isSet()) {
				child.bounds.left	= padding.left + childProps.left;
				child.bounds.width	= group.bounds.right - padding.right - padding.left - childProps.right - childProps.left;
			}
			else if (childProps.left.isSet())		child.bounds.left	= padding.left + childProps.left;
			else if (childProps.right.isSet())		child.bounds.right	= group.bounds.right - padding.right - childProps.right;
			else if (childProps.hCenter.isSet())	child.bounds.left	= Std.int( ( group.bounds.width - child.bounds.width ) * .5 );		
			
			
			
			//
			//apply vertical
			//
			
			if (childProps.top.isSet() && childProps.bottom.isSet()) {
				child.bounds.top	= padding.top + childProps.top;
				child.bounds.height	= group.bounds.bottom - padding.bottom - padding.top - childProps.bottom - childProps.top;
			}
			else if (childProps.top.isSet())		child.bounds.top	= padding.top + childProps.top;
			else if (childProps.bottom.isSet())		child.bounds.bottom	= group.bounds.bottom - padding.bottom - childProps.bottom;
			else if (childProps.vCenter.isSet())	child.bounds.top	= Std.int( ( group.bounds.height - child.bounds.height ) * .5 );
		}
	}
}