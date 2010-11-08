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
 import primevc.core.geom.BindablePoint;
 import primevc.core.geom.Box;
 import primevc.core.geom.IntPoint;
 import primevc.core.traits.IInvalidatable;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.states.ValidateStates;
 import primevc.types.Number;
 import primevc.utils.FastArray;
 import primevc.utils.NumberMath;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberMath;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = LayoutFlags;


/**
 * @since	mar 20, 2010
 * @author	Ruben Weijers
 */
class LayoutContainer extends AdvancedLayoutClient, implements ILayoutContainer, implements IScrollableLayout
{
	public static inline var EMPTY_BOX : Box = new Box(0,0);
	
	
	public var algorithm			(default, setAlgorithm)			: ILayoutAlgorithm;
	public var children				(default, null)					: IList<LayoutClient>;
	
	public var childWidth			(default, setChildWidth)		: Int;
	public var childHeight			(default, setChildHeight)		: Int;
	
	public var scrollPos			(default, null)					: BindablePoint;
	public var scrollableWidth		(getScrollableWidth, never)		: Int;
	public var scrollableHeight		(getScrollableHeight, never)	: Int;
	
	
	public function new (newWidth:Int = primevc.types.Number.INT_NOT_SET, newHeight:Int = primevc.types.Number.INT_NOT_SET)
	{
		padding				= EMPTY_BOX;
		margin				= EMPTY_BOX;
		children			= new ArrayList<LayoutClient>();
		scrollPos			= new BindablePoint();
		
		childWidth			= Number.INT_NOT_SET;
		childHeight			= Number.INT_NOT_SET;
		
		childrenChangeHandler.on( children.change, this );
		super(newWidth, newHeight);
	}
	
	
	override public function dispose ()
	{
		children.change.unbind( this );
		children.dispose();
		children	= null;
		algorithm	= null;
		
		super.dispose();
	}
	
	
	
	
	//
	// LAYOUT METHODS
	//
	
	override public function invalidateCall ( childChanges:UInt, sender:IInvalidatable ) : Void
	{
		if (!sender.is(LayoutClient)) {
			super.invalidateCall( childChanges, sender );
			return;
		}
		
	//	trace(this+".invalidateCall "+Flags.readProperties(childChanges)+"; sender "+sender);
	//	trace("\t\tisValidating? "+isValidating+"; "+(algorithm != null)+"; algorithm "+algorithm.isInvalid(childChanges));
		var child = sender.as(LayoutClient);
		if (!isValidating && algorithm != null && algorithm.isInvalid(childChanges)) {
			invalidate( Flags.CHILDREN_INVALIDATED );
			child.state.current = ValidateStates.parent_invalidated;
		}
	}
	
	
	private inline function checkIfChildGetsPercentageWidth (child:LayoutClient, widthToUse:Int) : Bool {
		return (changes.has( Flags.WIDTH ) || child.changes.has( Flags.PERCENT_WIDTH ))
					&& child.percentWidth > 0
					/*&& child.percentWidth != Flags.FILL*/
					&& widthToUse.isSet();
	}
	
	
	private inline function checkIfChildGetsPercentageHeight (child:LayoutClient, heightToUse:Int) : Bool {
		return (changes.has( Flags.HEIGHT ) || child.changes.has( Flags.PERCENT_HEIGHT ))
					&& child.percentHeight > 0
					/*&& child.percentHeight != Flags.FILL*/
					&& heightToUse.isSet();
	}
	
	
	private inline function isVisible () {
		return (explicitWidth.notSet() || explicitWidth > 0) && (explicitHeight.notSet() || explicitHeight > 0);
	} 
	
	
	override public function validateHorizontal ()
	{
		if (hasValidatedWidth)
			return;
		
		if (changes.has( Flags.WIDTH | Flags.EXPLICIT_WIDTH ))
			super.validateHorizontal();
		
		if (!changes.has( Flags.WIDTH | Flags.LIST | Flags.CHILDREN_INVALIDATED | Flags.CHILD_HEIGHT | Flags.CHILD_WIDTH | Flags.ALGORITHM ))
			return;
		
		trace(this+".validateHorizontal");
		var fillingChildren	= FastArrayUtil.create();
		var childrenWidth	= 0;
		
		if (algorithm != null)
			algorithm.prepareValidate();
		
		for (child in children)
		{
			if (child.percentWidth == Flags.FILL) {
			//	if (explicitWidth.isSet())
				fillingChildren.push( child );
				child.width.value = Number.INT_NOT_SET;
			}
			
			//measure children with explicitWidth and no percentage size
			else if (checkIfChildGetsPercentageWidth(child, explicitWidth))
				child.outerBounds.width = Std.int(explicitWidth * child.percentWidth / 100);
			
			//measure children
			if (child.percentWidth != Flags.FILL && child.includeInLayout) {
				child.validateHorizontal();
				childrenWidth += child.outerBounds.width;
			}
		}
		
		if (fillingChildren.length > 0)
		{
			var sizePerChild = IntMath.max(width.value - childrenWidth, 0).divFloor( fillingChildren.length );
			for (child in fillingChildren) {
				child.outerBounds.width = sizePerChild;
				child.validateHorizontal();
			}
		}
		
		if (algorithm != null)
			algorithm.validateHorizontal();
		
		hasValidatedWidth = false;
		super.validateHorizontal();
	}
	
	
	override public function validateVertical ()
	{
		if (hasValidatedHeight)
			return;
		
		if (changes.has( Flags.HEIGHT | Flags.EXPLICIT_HEIGHT ))
			super.validateVertical();
		
		if (!changes.has( Flags.HEIGHT | Flags.LIST | Flags.CHILDREN_INVALIDATED | Flags.CHILD_HEIGHT | Flags.CHILD_WIDTH | Flags.ALGORITHM ))
			return;
		
		trace(this+".validateVertical");
		var fillingChildren	= FastArrayUtil.create();
		var childrenHeight	= 0;
		
		if (algorithm != null)
			algorithm.prepareValidate();
		
		for (child in children)
		{
			if (child.percentHeight == Flags.FILL) {
			//	if (explicitHeight.isSet())
				fillingChildren.push( child );
				child.height.value = Number.INT_NOT_SET;
			}
			
			else if (checkIfChildGetsPercentageHeight(child, explicitHeight))
				child.outerBounds.height = Std.int(explicitHeight * child.percentHeight / 100);
			
			//measure children
			if (child.percentHeight != Flags.FILL && child.includeInLayout) {
				child.validateVertical();
				childrenHeight += child.outerBounds.height;
			}
		}
		
		if (fillingChildren.length > 0)
		{
			var sizePerChild = (height.value - childrenHeight).divFloor( fillingChildren.length );
			for (child in fillingChildren) {
				child.outerBounds.height = sizePerChild;
				child.validateVertical();
			}
		}
		
		if (algorithm != null)
			algorithm.validateVertical();
		
		hasValidatedHeight = false;
		super.validateVertical();
	}
	
	
	override public function validate ()
	{
		trace(this+".validate "+Flags.readProperties(changes));
		super.validate();
	}
	
	
	override public function validated ()
	{
		trace(this+".validated");
		if (changes == 0 || !isValidating)
			return;
		
		if (!isVisible())
		{
			super.validated();
			return;
		}
		
	//	trace(this+".validated; size: "+width+", "+height+"; explicitSize "+explicitWidth+", "+explicitHeight+"; measured: "+measuredWidth+", "+measuredHeight);
	//	Assert.that(hasValidatedWidth, "To be validated, the layout should be validated horizontally for "+this);
	//	Assert.that(hasValidatedHeight, "To be validated, the layout should be validated vertically for "+this);
		
		if (algorithm != null)
			algorithm.apply();
		
		for (child in children)
			if (child.includeInLayout)
				child.validated();
		
		super.validated();
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
			invalidate( Flags.ALGORITHM );
			
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
			invalidate( Flags.CHILD_WIDTH );
			invalidate( Flags.CHILDREN_INVALIDATED );
		}
		return v;
	}


	private inline function setChildHeight (v)
	{
		if (v != childHeight)
		{
			childHeight = v;
			invalidate( Flags.CHILD_HEIGHT );
			invalidate( Flags.CHILDREN_INVALIDATED );
		}
		return v;
	}
	
	
	override private function setPadding (v:Box)
	{	
		if (v == null)
			v = EMPTY_BOX;
		
		return super.setPadding(v);
	}
	
	
	override private function setMargin (v:Box)
	{	
		if (v == null)
			v = EMPTY_BOX;
		
		return super.setMargin(v);
	}
	
	
	
	//
	// ISCROLLABLE LAYOUT IMPLEMENTATION
	//
	
	public inline function horScrollable ()							{ return explicitWidth.isSet() && measuredWidth > explicitWidth; }
	public inline function verScrollable ()							{ return explicitHeight.isSet() && measuredHeight > explicitHeight; }
	public inline function getScrollableWidth ()					{ return measuredWidth - explicitWidth; }
	public inline function getScrollableHeight ()					{ return measuredHeight - explicitHeight; }
	public inline function validateScrollPosition (pos:IntPoint)
	{
		if (horScrollable())	pos.x = pos.x.within( 0, scrollableWidth );
		if (verScrollable())	pos.y = pos.y.within( 0, scrollableHeight );
		return pos;
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function childrenChangeHandler ( change:ListChange <LayoutClient> ) : Void
	{
		trace(this+".childrenChangeHandler "+change);
		switch (change)
		{
			case added( child, newPos ):
				child.parent = this;
				//check first if the bound properties are zero. If they are not, they can have been set by a tile-container
				if (child.outerBounds.left == 0)	child.outerBounds.left	= padding.left;
				if (child.outerBounds.top == 0)		child.outerBounds.top	= padding.top;
				child.listeners.add(this);
			
			case removed( child, oldPos ):
				child.parent		= null;
				child.listeners.remove(this);
				
				//reset boundary properties without validating
				child.outerBounds.left	= 0;
				child.outerBounds.top	= 0;
				child.changes			= 0;
			
			default:
		}
		
		invalidate( Flags.LIST );
	}
	
	
	private function algorithmChangedHandler ()	{ invalidate( Flags.ALGORITHM ); }
}