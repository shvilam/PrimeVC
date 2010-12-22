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
 import primevc.core.collections.ArrayList;
 import primevc.core.collections.IEditableList;
 import primevc.core.collections.ListChange;
 import primevc.core.traits.IInvalidatable;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.ILayoutContainer;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.states.ValidateStates;
 import primevc.types.Number;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
 

private typedef Flags = LayoutFlags;

/**
 * Group of tiles within a tile layout. Behaves as a LayoutContainer but without 
 * the properties of AdvancedLayoutContainer.
 * 
 * @creation-date	Jun 30, 2010
 * @author			Ruben Weijers
 */
class TileContainer extends LayoutClient, implements ILayoutContainer
{
	public var algorithm	(default, setAlgorithm)		: ILayoutAlgorithm;
	public var children		(default, null)				: IEditableList<LayoutClient>;
	
	public var childWidth	(default, setChildWidth)	: Int;
	public var childHeight	(default, setChildHeight)	: Int;
	
	
	public function new( list:IEditableList<LayoutClient> = null )
	{
		super();
		children	= list == null ? new ArrayList<LayoutClient>() : list;
		childWidth	= Number.INT_NOT_SET;
		childHeight	= Number.INT_NOT_SET;
		
		childrenChangeHandler.on( children.change, this );
		
		if (children.length > 0)
			for (child in children)
				child.listeners.add(this);
		
		changes = 0;
	}
	
	
	override public function dispose ()
	{
		if (children != null)
		{
			for (child in children)
				child.listeners.remove(this);
			
			if (children.change != null) {
				children.change.unbind(this);
				children.dispose();
			}
			children = null;
		}
		algorithm = null;
		
		super.dispose();
	}
	
	
	public function iterator () { return children.iterator(); }
	
	
	override public function invalidateCall ( childChanges:Int, sender:IInvalidatable ) : Void
	{
		if (!sender.is(LayoutClient)) {
			super.invalidateCall( childChanges, sender );
			return;
		}
		
		Assert.that(algorithm != null);
		algorithm.group = cast this;
	//	trace(name+".childInvalidated; "+isValidating+"; "+Flags.readProperties(childChanges)+"; "+algorithm.isInvalid(childChanges)+"; algorithm "+algorithm);
		
		var child = sender.as(LayoutClient);
		if (!isValidating && (childChanges.has(Flags.LIST) || algorithm.isInvalid(childChanges)))
			invalidate( Flags.CHILDREN_INVALIDATED );
	}
	
	
	override public function validateHorizontal ()
	{
		if (hasValidatedWidth)
			return;
		
		Assert.that(algorithm != null);
		for (child in children)
			if (child.changes > 0)
				child.validateHorizontal();
		
		if (changes > 0)
		{
			algorithm.group = cast this;
			algorithm.validateHorizontal();
		}
		super.validateHorizontal();
	}
	
	
	override public function validateVertical ()
	{
		if (hasValidatedHeight)
			return;
		
		Assert.that(algorithm != null);
		for (child in children)
			if (child.changes > 0)
				child.validateVertical();

		if (changes > 0)
		{
			algorithm.group = cast this;
			algorithm.validateVertical();
		}
		super.validateVertical();
	}
	
	
	override public function validated ()
	{
		if (!isValidating)
			return;
		
		if (changes > 0)
		{
			algorithm.group = cast this;
			algorithm.apply();
		}
		
		state.current	= ValidateStates.validated;
		changes			= 0;
		
		hasValidatedWidth	= false;
		hasValidatedHeight	= false;
	}
	
	
	override private function setX (v)
	{
		if (v != x) {
			v = super.setX(v);
			for (child in children)
				child.outerBounds.left = innerBounds.left;
		}
		return v;
	}
	
	
	override private function setY (v)
	{
		if (v != y) {
			v = super.setY(v);
			for (child in children)
				child.outerBounds.top = innerBounds.top;
		}
		return v;
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
			invalidate( Flags.ALGORITHM );
			
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
			invalidate( Flags.CHILDREN_INVALIDATED );
		}
		return v;
	}


	private inline function setChildHeight (v)
	{
		if (v != childHeight)
		{
			childHeight = v;
			invalidate( Flags.CHILDREN_INVALIDATED );
		}
		return v;
	}
	
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function algorithmChangedHandler () { invalidate( Flags.ALGORITHM ); }
	
	private function childrenChangeHandler ( change:ListChange < LayoutClient > ) : Void
	{
	//	trace(this+".childrenChangeHandler "+change);
		switch (change)
		{
			case added( child, newPos ):
				child.listeners.add(this);
				if (innerBounds.left != 0)	child.outerBounds.left	= innerBounds.left;
				if (innerBounds.top != 0)	child.outerBounds.top	= innerBounds.top;
			
			case removed( child, oldPos ):
				child.listeners.remove(this);
			
			default:
		}
		
		invalidate( Flags.LIST );
	}
	
	
#if debug
	override public function toString () { return "LayoutTileContainer( "+super.toString() + " ) - "/*+children*/; }
#end
}