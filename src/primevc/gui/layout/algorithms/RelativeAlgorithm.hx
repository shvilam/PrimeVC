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
 import primevc.core.geom.constraints.ConstrainedRect;
 import primevc.core.geom.Box;
 import primevc.core.geom.IRectangle;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.algorithms.LayoutAlgorithmBase;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.RelativeLayout;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;



/**
 * Relative Algorithm allows layout-children to apply relative properties.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 12, 2010
 */
class RelativeAlgorithm extends LayoutAlgorithmBase, implements ILayoutAlgorithm
{
	private var validatePreparedHor : Bool;
	private var validatePreparedVer : Bool;
	
	
	public inline function isInvalid (changes:Int)
	{
		return changes.has( LayoutFlags.WIDTH ) 
				|| changes.has( LayoutFlags.HEIGHT )
				|| changes.has( LayoutFlags.X )
				|| changes.has( LayoutFlags.Y )
				|| changes.has( LayoutFlags.RELATIVE );
	}
	
	
	override public function prepareValidate ()
	{
		if (!validatePrepared)
		{
			if (group.validatedHorizontal && !validatePreparedHor)
			{
				for (child in group.children) {
					if (child.relative == null || !child.includeInLayout)
						continue;
					
					if (child.relative.left.isSet() && child.relative.right.isSet())
						child.bounds.width	= group.width - child.relative.right - child.relative.left;
				}
				
				validatePreparedHor = true;
			}
			
			
			if (group.validatedVertical && !validatePreparedVer)
			{
				for (child in group.children) {
					if (child.relative == null || !child.includeInLayout)
						continue;
					
					if (child.relative.top.isSet() && child.relative.bottom.isSet())
						child.bounds.height	= group.height - child.relative.bottom - child.relative.top;
				}
				
				validatePreparedVer = true;
			}
			
			if (validatePreparedVer && validatePreparedHor)
				validatePrepared = true;
		}
	}
	
	
	public inline function validate () {
		validateHorizontal();
		validateVertical();
	}
	public inline function validateHorizontal () {
		if (!validatePrepared)
			prepareValidate();
	}
	public inline function validateVertical () {
		if (!validatePrepared)
			prepareValidate();
	}
	
	
	public inline function apply ()
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
			
			if		(childProps.left.isSet())		child.bounds.left	= padding.left + childProps.left;
			else if (childProps.right.isSet())		child.bounds.right	= group.bounds.width - padding.right - childProps.right;
			else if (childProps.hCenter.isSet())	child.bounds.left	= Std.int( ( group.bounds.width - child.bounds.width ) * .5 );			
			
			
			//
			//apply vertical
			//
			
			if		(childProps.top.isSet())		child.bounds.top	= padding.top + childProps.top;
			else if (childProps.bottom.isSet())		child.bounds.bottom	= group.bounds.height - padding.bottom - childProps.bottom;
			else if (childProps.vCenter.isSet())	child.bounds.top	= Std.int( ( group.bounds.height - child.bounds.height ) * .5 );
		}
		
		validatePrepared	= false;
		validatePreparedHor	= false;
		validatePreparedVer	= false;
	}
	
	
	/**
	 * When the relative algorithm is used, the position of an object doesn't
	 * have any influence on the depth. That's why the algorithm will always 
	 * return the position at the end of the child-list.
	 */
	public inline function getDepthForBounds (bounds:IRectangle) : Int
	{
		return group.children.length;
	}


#if debug
	public function toString ()
	{
		return group + ".RelativeAlgorithm ( " + group.bounds.width + " -> " + group.bounds.height + " ) ";
	}
#end
}