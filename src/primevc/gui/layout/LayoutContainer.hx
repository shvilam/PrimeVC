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
 import primevc.core.Number;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.states.LayoutStates;
 import primevc.utils.FastArray;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.IntMath;
  using primevc.utils.IntUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = LayoutFlags;


/**
 * @since	mar 20, 2010
 * @author	Ruben Weijers
 */
class LayoutContainer extends AdvancedLayoutClient, implements ILayoutContainer<LayoutClient>, implements IAdvancedLayoutClient
{
	public var algorithm	(default, setAlgorithm)		: ILayoutAlgorithm;
	public var children		(default, null)				: IList<LayoutClient>;
	
	public var childWidth	(default, setChildWidth)	: Int;
	public var childHeight	(default, setChildHeight)	: Int;
	
	public var scrollX		: Int;
	public var scrollY		: Int;
	
	
	public function new (newWidth:Int = 0, newHeight:Int = 0)
	{
		padding				= new Box(0, 0);
		children			= new ArrayList<LayoutClient>();
		
		childWidth			= Number.NOT_SET;
		childHeight			= Number.NOT_SET;
		
		childAddedHandler	.on( children.events.added, this );
		childRemovedHandler	.on( children.events.removed, this );
		
		invalidateChildList	.on( children.events.added, this );
		invalidateChildList	.on( children.events.moved, this );
		invalidateChildList	.on( children.events.removed, this );
		super(newWidth, newHeight);
	}
	
	
	override public function dispose ()
	{
		children.events.added.unbind( this );
		children.events.removed.unbind( this );
		children.events.moved.unbind( this );
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
		if (!isValidating && algorithm != null && algorithm.isInvalid(childChanges)) {
			invalidate( LayoutFlags.CHILDREN_INVALIDATED );
			r = true;
		}
		return r;
	}
	
	
	private inline function checkIfChildGetsPercentageWidth (child:LayoutClient, widthToUse:Int) : Bool {
		return (changes.has(LayoutFlags.WIDTH_CHANGED) || child.changes.has(LayoutFlags.WIDTH_CHANGED))
					&& child.percentWidth > 0
					&& child.percentWidth != LayoutFlags.FILL
					&& widthToUse.isSet();
	}
	
	
	private inline function checkIfChildGetsPercentageHeight (child:LayoutClient, heightToUse:Int) : Bool {
		return (changes.has(LayoutFlags.HEIGHT_CHANGED) || child.changes.has(LayoutFlags.HEIGHT_CHANGED))
					&& child.percentHeight > 0
					&& child.percentHeight != LayoutFlags.FILL
					&& heightToUse.isSet();
	}
	
	
	override public function measureHorizontal ()
	{
		if (measuredHorizontal)
			return;
		
		if (explicitWidth.isSet() && explicitWidth <= 0)
			return;
		
		var fillingChildren	= FastArrayUtil.create();
		var childrenWidth	= 0;
		measuredHorizontal	= true;
		
		if (algorithm != null)
			algorithm.prepareMeasure();
		
		for (child in children)
		{
			if (child.percentWidth == LayoutFlags.FILL) {
				if (explicitWidth.isSet())
					fillingChildren.push( child );
				
				child.width = Number.NOT_SET;
			}
			
			//measure children with explicitWidth and no percentage size
			else if (checkIfChildGetsPercentageWidth(child, explicitWidth))
				child.bounds.width = Std.int(explicitWidth * child.percentWidth / 100);
			
			//measure children
			if (child.percentWidth != LayoutFlags.FILL && child.includeInLayout) {
				child.measureHorizontal();
				childrenWidth += child.bounds.width;
			}
		}
		
		if (fillingChildren.length > 0)
		{
			var sizePerChild = (width - childrenWidth).divFloor( fillingChildren.length );
			for (child in fillingChildren) {
				child.bounds.width = sizePerChild;
				child.measureHorizontal();
			}
		}
		
		if (algorithm != null)
			algorithm.measureHorizontal();
	}
	
	
	override public function measureVertical ()
	{
		if (measuredVertical)
			return;
		
		if (explicitHeight.isSet() && explicitHeight <= 0)
			return;
		
		var fillingChildren	= FastArrayUtil.create();
		var childrenHeight	= 0;
		measuredVertical	= true;
		
		if (algorithm != null)
			algorithm.prepareMeasure();
		
		for (child in children)
		{
			if (child.percentHeight == LayoutFlags.FILL) {
				if (explicitHeight.isSet())
					fillingChildren.push( child );
				
				child.height = Number.NOT_SET;
			}
			
			else if (checkIfChildGetsPercentageHeight(child, explicitHeight))
				child.bounds.height = Std.int(explicitHeight * child.percentHeight / 100);
			
			//measure children
			if (child.percentHeight != LayoutFlags.FILL && child.includeInLayout) {
				child.measureVertical();
				childrenHeight += child.bounds.height;
			}
		}
		
		if (fillingChildren.length > 0)
		{
			var sizePerChild = (height - childrenHeight).divFloor( fillingChildren.length );
			for (child in fillingChildren) {
				child.bounds.height = sizePerChild;
				child.measureVertical();
			}
		}
		
		super.measureVertical();
		
		if (algorithm != null)
			algorithm.measureVertical();
	}
	
	
	override public function validate ()
	{
		if (changes == 0 || !isValidating)
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


	private inline function setChildWidth (v)
	{
		if (v != childWidth)
		{
			childWidth = v;
			invalidate( LayoutFlags.CHILDREN_INVALIDATED );
		}
		return v;
	}


	private inline function setChildHeight (v)
	{
		if (v != childHeight)
		{
			childHeight = v;
			invalidate( LayoutFlags.CHILDREN_INVALIDATED );
		}
		return v;
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function algorithmChangedHandler ()							{ invalidate( LayoutFlags.ALGORITHM_CHANGED ); }
	private function invalidateChildList ()								{ invalidate( LayoutFlags.LIST_CHANGED ); }
	
	
	private function childRemovedHandler (child:LayoutClient, pos:Int)	{
		child.parent		= null;
		//reset boundary properties without validating
		child.bounds.left	= 0;
		child.bounds.top	= 0;
		child.changes		= 0;
	}
	
	
	private function childAddedHandler (child:LayoutClient, pos:Int)	{
		child.parent = this;
		
		//check first if the bound properties are zero. If they are not, they can have been set by a tile-container
		if (child.bounds.left == 0)		child.bounds.left	= padding.left;
		if (child.bounds.top == 0)		child.bounds.top	= padding.top;
	}
}