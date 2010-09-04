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
package primevc.gui.layout.algorithms.tile;
 import primevc.core.collections.IList;
 import primevc.core.collections.ArrayList;
 import primevc.types.Number;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.ILayoutContainer;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.states.ValidateStates;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.IntUtil;
  using primevc.utils.TypeUtil;
 

/**
 * Group of tiles within a tile layout. Behaves as a LayoutContainer but without 
 * the properties of AdvancedLayoutContainer.
 * 
 * @creation-date	Jun 30, 2010
 * @author			Ruben Weijers
 */
class TileContainer <ChildType:LayoutClient> extends LayoutClient, implements ILayoutContainer <ChildType>
{
	public var algorithm	(default, setAlgorithm)		: ILayoutAlgorithm;
	public var children		(default, null)				: IList<ChildType>;
	
	public var childWidth	(default, setChildWidth)	: Int;
	public var childHeight	(default, setChildHeight)	: Int;
	
	
	public function new( list:IList<ChildType> = null )
	{
		super();
		children	= list == null ? new ArrayList<ChildType>() : list;
		childWidth	= Number.INT_NOT_SET;
		childHeight	= Number.INT_NOT_SET;
		
		childAddedHandler.on( children.events.added, this );
	//	childRemovedHandler.on( children.events.removed, this );
		
		invalidateChildList.on( children.events.added, this );
		invalidateChildList.on( children.events.moved, this );
		invalidateChildList.on( children.events.removed, this );
		
		setHorChildPosition.on( bounds.leftProp.change, this );
		setVerChildPosition.on( bounds.topProp.change, this );
	}
	
	
	override public function dispose ()
	{
		children.dispose();
		children	= null;
		algorithm	= null;
		
		super.dispose();
	}
	
	
	public function iterator () { return children.iterator(); }
	
	
	public function childInvalidated (childChanges:Int) : Bool
	{
		var r = false;
		algorithm.group = cast this;
		if (childChanges.has(LayoutFlags.LIST_CHANGED) || (algorithm != null && algorithm.isInvalid(childChanges)))
		{
			invalidate( LayoutFlags.CHILDREN_INVALIDATED );
			r = true;
		}
		return r;
	}
	
	
	override public function validate () 
	{
		if (changes == 0)
			return;
		
#if debug
		children.name = name;
#end
		validateHorizontal();
		validateVertical();
	}
	
	
	override public function validateHorizontal ()
	{
		if (changes == 0)
			return;
		
		Assert.that(algorithm != null);
		
		for (child in children)
			if (childInvalidated(child.changes))
				child.validateHorizontal();
		
		algorithm.group = cast this;
		algorithm.validateHorizontal();
		super.validateHorizontal();
	}
	
	
	override public function validateVertical ()
	{
		if (changes == 0)
			return;
		
		Assert.that(algorithm != null);
		for (child in children) {
			if (childInvalidated(child.changes))
				child.validateVertical();
		}
		
		algorithm.group = cast this;
		algorithm.validateVertical();
		super.validateVertical();
	}
	
	
	override public function validated ()
	{
		if (changes == 0)
			return;
		
		algorithm.group = cast this;
		algorithm.apply();
		changes = 0;
	}
	
	
	private function setHorChildPosition () {
		for (child in children)
			child.bounds.left = bounds.left;
	}
	
	
	private function setVerChildPosition () {
		for (child in children)
			child.bounds.top = bounds.top;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setAlgorithm (v:ILayoutAlgorithm)
	{
		if (v != algorithm)
		{
			if (algorithm != null) {
				algorithm.algorithmChanged.unbind(this);
				algorithm.group = null;
			}
			
			algorithm = v;
			invalidate( LayoutFlags.ALGORITHM_CHANGED );
			
			if (algorithm != null) {
				algorithmChangedHandler.on( algorithm.algorithmChanged, this );
				algorithm.group = cast this;
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
//	private function childRemovedHandler (child:ChildType, pos:Int)		{ if (child != null) { child.parent = null; } }
	
	private function childAddedHandler (child:ChildType, pos:Int)
	{
	//	child.parent = this;
		if (bounds.left != 0)	child.bounds.left	= bounds.left;
		if (bounds.top != 0)	child.bounds.top	= bounds.top;
	//	trace(name+".childAddedHandler "+child+"; bounds: "+bounds+"; child.bounds: "+child.bounds);
	}

	
#if debug
	override public function toString () { return "LayoutTileContainer( "+super.toString() + " ) - "/*+children*/; }
#end
}