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
 import primevc.core.collections.ArrayList;
 import primevc.core.collections.IList;
 import primevc.core.geom.Box;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.states.LayoutStates;
 import primevc.utils.FastArray;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.IntMath;
  using primevc.utils.IntUtil;


private typedef Flags = LayoutFlags;


/**
 * @since	mar 20, 2010
 * @author	Ruben Weijers
 */
class LayoutContainer extends AdvancedLayoutClient, implements ILayoutContainer<LayoutClient>, implements IAdvancedLayoutClient
{
	public var algorithm	(default, setAlgorithm)		: ILayoutAlgorithm;
	public var children		(default, null)				: IList<LayoutClient>;
	
	
	public function new ()
	{
		super();
		padding		= new Box(0, 0);
		children	= new ArrayList<LayoutClient>();
		
		childAddedHandler.on( children.events.added, this );
		childRemovedHandler.on( children.events.removed, this );
		
		invalidateChildList.on( children.events.added, this );
		invalidateChildList.on( children.events.moved, this );
		invalidateChildList.on( children.events.removed, this );
	}
	
	
	override public function dispose ()
	{
		children.dispose();
		children	= null;
		algorithm	= null;
		
		super.dispose();
	}
	
	
	//
	// LAYOUT METHODS
	//
	
	public inline function childInvalidated (childChanges:Int) : Bool
	{
		var r = false;
		if (algorithm != null && algorithm.isInvalid(childChanges)) {
			invalidate( LayoutFlags.CHILDREN_INVALIDATED );
			r = true;
		}
		return r;
	}
	
	
	override public function measure ()
	{
		if (changes == 0)
			return;
		
		if ((explicitWidth.isSet() && explicitWidth <= 0) || (explicitHeight.isSet() && explicitHeight <= 0))
			return;
		
		states.current = LayoutStates.measuring;
		
		//set percentage size for children if there's a explicit size
		if (explicitWidth.isSet())		setWidthPercentages(explicitWidth);
		if (explicitHeight.isSet())		setHeightPercentages(explicitHeight);
		
		for (child in children)
			child.measure();
		
		if (algorithm != null)
			algorithm.measure();
		
		super.measure();
	}
	
	
	override public function validate ()
	{
		if (changes == 0)
			return;
		
		states.current = LayoutStates.validating;
		
		if (algorithm != null)
			algorithm.apply();
		
		for (child in children)
			child.validate();
		
		super.validate();
	}
	
	
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	override private function setWidth (v:Int)
	{
		var oldV = width;
		var newV = super.setWidth(v);
		
		if (newV != oldV && isValidating)
			setWidthPercentages(newV);
		
		return newV;
	}
	
	
	override private function setHeight (v:Int)
	{
		var oldV = height;
		var newV = super.setHeight(v);
		
		if (newV != oldV && isValidating)
			setHeightPercentages(newV);
		
		return newV;
	}
	
	
	private inline function setAlgorithm (v:ILayoutAlgorithm)
	{
		if (v != algorithm)
		{
			if (algorithm != null) {
				algorithm.group = null;
				algorithm.algorithmChanged.unbind(this);
			}
			
			algorithm = v;
			invalidate( LayoutFlags.ALGORITHM_CHANGED );
			
			if (algorithm != null) {
				algorithm.group = this;
				algorithmChangedHandler.on( algorithm.algorithmChanged, this );
			}
		}
		return v;
	}
	
	
	private inline function setWidthPercentages (width:Int)
	{
		var fillingChildren = FastArrayUtil.create();
		var fillingWidth	= width;
		
		for (child in children)
		{
			if (changes.has(LayoutFlags.WIDTH_CHANGED) && child.percentWidth == LayoutFlags.FILL)
			{
				fillingChildren.push(child);
				continue;
			}
			else if ((changes.has(LayoutFlags.WIDTH_CHANGED) || child.changes.has(LayoutFlags.WIDTH_CHANGED))
			 		&& child.percentWidth > 0 
					&& child.percentWidth != LayoutFlags.FILL
				) {
				child.bounds.width = Std.int(width * child.percentWidth / 100);
			}
			
			fillingWidth -= child.bounds.width;
		}
		
		//check if there are any children with a percentage of FILL and give them the width that is left over
		if (fillingChildren.length > 0)
		{
			var widthPerChild = fillingWidth.divFloor( fillingChildren.length );
			for (child in fillingChildren) {
				child.bounds.width = widthPerChild;
			}
		}
	}
	
	
	private inline function setHeightPercentages (height:Int)
	{
		var fillingChildren = FastArrayUtil.create();
		var fillingHeight	= height;
		
		for (child in children)
		{
			if (changes.has(LayoutFlags.HEIGHT_CHANGED) && child.percentHeight == LayoutFlags.FILL)
			{
				fillingChildren.push(child);
				continue;
			}
			else if ((changes.has(LayoutFlags.HEIGHT_CHANGED) || child.changes.has(LayoutFlags.HEIGHT_CHANGED))
					&& child.percentHeight > 0
					&& child.percentHeight != LayoutFlags.FILL
				)
			{
				child.bounds.height = Std.int(height * child.percentHeight / 100);
			}
			
			fillingHeight -= child.bounds.height;
		}
		
		if (fillingChildren.length > 0)
		{
			var heightPerChild = fillingHeight.divFloor( fillingChildren.length );
			for (child in fillingChildren) {
				child.bounds.height = heightPerChild;
			}
		}
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function algorithmChangedHandler ()							{ invalidate( LayoutFlags.ALGORITHM_CHANGED ); }
	private function invalidateChildList ()								{ invalidate( LayoutFlags.LIST_CHANGED ); }
	private function childAddedHandler (child:LayoutClient, pos:Int)	{ child.parent = this; }
	private function childRemovedHandler (child:LayoutClient, pos:Int)	{ child.parent = null; }
}