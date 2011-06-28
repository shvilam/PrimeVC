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
  using primevc.utils.IfUtil;
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
			for (i in 0...children.length) {
				var child = children.getItemAt(i);
				if (child.includeInLayout)
					child.listeners.add(this);
			}
		
		changes = 0;
	}
	
	
	override public function dispose ()
	{
		if (children != null)
		{
			while (children.length > 0) {
				var child = children.getItemAt(0);
				child.listeners.remove(this);
				children.remove(child);
			}
			
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
		
		var child = sender.as(LayoutClient);
		if (!isValidating() && (childChanges.has(Flags.LIST | Flags.WIDTH * childWidth.notSet().boolCalc() | Flags.HEIGHT * childHeight.notSet().boolCalc()) || algorithm.isInvalid(childChanges)))
			invalidate( Flags.CHILDREN_INVALIDATED );
	}
	
	
	override public function validateHorizontal ()
	{
		super.validateHorizontal();
		if (changes.hasNone( Flags.WIDTH | Flags.LIST | Flags.CHILDREN_INVALIDATED | Flags.CHILD_HEIGHT | Flags.CHILD_WIDTH | Flags.ALGORITHM ))
			return;
		
		Assert.that(algorithm != null);
		for (i in 0...children.length)
		{
			var child = children.getItemAt(i);
			if (child.changes > 0 && child.includeInLayout)
				child.validateHorizontal();
		}
		
		if (changes > 0)
		{
			algorithm.group = cast this;
			algorithm.validateHorizontal();
		}
		super.validateHorizontal();
	}
	
	
	override public function validateVertical ()
	{
		super.validateVertical();
		if (changes.hasNone( Flags.HEIGHT | Flags.LIST | Flags.CHILDREN_INVALIDATED | Flags.CHILD_HEIGHT | Flags.CHILD_WIDTH | Flags.ALGORITHM ))
			return;
		
		Assert.that(algorithm != null);
		for (i in 0...children.length)
		{
			var child = children.getItemAt(i);
			if (child.changes > 0 && child.includeInLayout)
				child.validateVertical();
		}

		if (changes > 0)
		{
			algorithm.group = cast this;
			algorithm.validateVertical();
		}
		super.validateVertical();
	}
	
	
	override public function validated ()
	{
		if (changes == 0 || !isValidating())
			return;
		
		if (algorithm != null)
		{
			algorithm.group = cast this;
			algorithm.apply();
		}
		
		state.current	= ValidateStates.validated;
		changes			= 0;
	}
	
	
	override private function setX (v)
	{
		if (v != x) {
			v = super.setX(v);
			for (i in 0...children.length)
			{
				var child = children.getItemAt(i);
			 	if (child.includeInLayout)
					child.outerBounds.left = innerBounds.left;
			}
		}
		return v;
	}
	
	
	override private function setY (v)
	{
		if (v != y) {
			v = super.setY(v);
			for (i in 0...children.length)
			{
				var child = children.getItemAt(i);
				if (child.includeInLayout)
					child.outerBounds.top = innerBounds.top;
			}
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
	
	//
	// CHILDREN
	//
	
	public var children			(default, null) : IEditableList<LayoutClient>;
	
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
	public var childrenLength	(default, null) : Int;
	public var fixedChildStart					: Int;
	
	/**
	 * Indicated wether the length of the children is fake d or not.
	 * 
	 * Layout-algorithms will only honor this property if the childWidth and 
	 * childHeight also have been set, otherwise it's impossible to calculate
	 * what the measured size of the container should be.
	 */
	public var fixedLength		(default, null) : Bool;
	
	
	
	private function childrenChangeHandler ( change:ListChange < LayoutClient > ) : Void
	{
		switch (change)
		{
			case added( child, newPos ):
				child.outerBounds.left	= innerBounds.left;
				child.outerBounds.top	= innerBounds.top;
				child.listeners.add(this);
				
				if (!fixedLength)			childrenLength++;
				if (child.includeInLayout)	invalidate( Flags.LIST );
			
			case removed( child, oldPos ):
				child.listeners.remove(this);
				
				if (!fixedLength)			childrenLength--;
				if (child.includeInLayout)	invalidate( Flags.LIST );
			
		
			case moved(child, newPos, oldPos):
				if (child.includeInLayout)	
					invalidate( Flags.LIST );
			
			case reset:
				invalidate( Flags.LIST );
		}
	}
	
	
	public inline function setFixedChildLength (length:Int)
	{
		fixedLength = true;
		if (childrenLength != length) {
			childrenLength = length;
			invalidate( Flags.LIST );
		}
	}
	
	
	public inline function unsetFixedChildLength ()
	{
		fixedLength = false;
		if (childrenLength != children.length) {
			childrenLength = children.length;
			invalidate( Flags.LIST );
		}
	}
	
#if debug
	override public function toString () { return "LayoutTileContainer( "+super.toString() + " ) - "/*+children*/; }
#end
}