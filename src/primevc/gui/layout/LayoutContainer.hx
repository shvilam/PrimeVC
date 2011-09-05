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
 import primevc.core.collections.IEditableList;
 import primevc.core.collections.ListChange;
 import primevc.core.geom.BindablePoint;
 import primevc.core.geom.Box;
 import primevc.core.geom.IntPoint;
 import primevc.core.traits.IInvalidatable;
 import primevc.core.validators.PercentIntRangeValidator;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.states.ValidateStates;
 import primevc.types.Number;
 import primevc.utils.FastArray;
 import primevc.utils.NumberUtil;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.FastArray;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = LayoutFlags;


/**
 * @since	Mar 20, 2010
 * @author	Ruben Weijers
 */
class LayoutContainer extends AdvancedLayoutClient, implements ILayoutContainer, implements IScrollableLayout
{
	public static inline var EMPTY_BOX : Box = new Box(0,0);
	
	public var algorithm			(default, setAlgorithm)			: ILayoutAlgorithm;
	
	public var childWidth			(default, setChildWidth)		: Int;
	public var childHeight			(default, setChildHeight)		: Int;
	
	public var scrollPos			(default, null)					: BindablePoint;
	public var scrollableWidth		(getScrollableWidth, never)		: Int;
	public var scrollableHeight		(getScrollableHeight, never)	: Int;
	public var minScrollXPos		(default, setMinScrollXPos)		: Int;
	public var minScrollYPos		(default, setMinScrollYPos)		: Int;
	
	
	
	
	public function new (newWidth = primevc.types.Number.INT_NOT_SET, newHeight = primevc.types.Number.INT_NOT_SET)
	{
		super(newWidth, newHeight);
		
		(untyped this).padding		= EMPTY_BOX;
		(untyped this).margin		= EMPTY_BOX;
		(untyped this).childWidth	= Number.INT_NOT_SET;
		(untyped this).childHeight	= Number.INT_NOT_SET;
		
		childrenLength	= 0;
		children		= new ArrayList<LayoutClient>();
		scrollPos		= new BindablePoint();
		minScrollXPos	= minScrollYPos = 0;
		
		childrenChangeHandler.on( children.change, this );
	}
	
	
	override public function dispose ()
	{
		super.dispose();
		if (algorithm != null) {
			algorithm.dispose();
			(untyped this).algorithm = null;
		}
		scrollPos.dispose();
		children.dispose();
		children	= null;
		scrollPos	= null;
	}
	
	
	@:keep public inline function attach (target:LayoutClient, depth:Int = -1) : LayoutContainer
	{
		children.add( target, depth );
		return this;
	}
	
	
	
	//
	// LAYOUT METHODS
	//
	
	override public function invalidateCall (childChanges:Int, sender:IInvalidatable) : Void
	{
		if (!sender.is(LayoutClient))
			return super.invalidateCall( childChanges, sender );
		
		var isInvalid = false;
		if (isInvalid = childChanges.has(Flags.INCLUDE))
			invalidate( Flags.LIST );
		
		if (isInvalid || algorithm == null || algorithm.isInvalid(childChanges))
		{
			var child = sender.as(LayoutClient);
			invalidate( Flags.CHILDREN_INVALIDATED );
			
			if (!child.isValidating())
				child.state.current = ValidateStates.parent_invalidated;
		}
		return;
	}
	
	
	
	private inline function checkIfChildGetsPercentageWidth (child:LayoutClient, widthToUse:Int) : Bool
	{
		return (
					changes.has( Flags.WIDTH | Flags.LIST ) 
				|| child.changes.has( Flags.PERCENT_WIDTH ) //|| child.width.notSet()
				||	( child.is(IAdvancedLayoutClient) && child.as(IAdvancedLayoutClient).explicitWidth.notSet() )
				)
				&& child.percentWidth.isSet()
				&& child.percentWidth > 0
				&& widthToUse > 0;
	}
	
	
	private inline function checkIfChildGetsPercentageHeight (child:LayoutClient, heightToUse:Int) : Bool
	{
		return (
						changes.has( Flags.HEIGHT | Flags.LIST )
					|| 	child.changes.has( Flags.PERCENT_HEIGHT ) //|| child.height.notSet()
					||	( child.is(IAdvancedLayoutClient) && child.as(IAdvancedLayoutClient).explicitHeight.notSet() )
				)
				&& child.percentHeight.isSet()
				&& child.percentHeight > 0
				&& heightToUse > 0;
	}
	
	
	/**
	 * Cached instance of the filling children list
	 */
	private var fillingChildrenCache : FastArray<LayoutClient>;

	
	override public function validateHorizontal ()
	{
		super.validateHorizontal();
		if (changes.hasNone( Flags.HORIZONTAL_INVALID ))
			return;
		
		if (fillingChildrenCache == null)
			fillingChildrenCache = FastArrayUtil.create();
		
		var fillingChildren	= fillingChildrenCache;
		var childrenWidth	= 0;
		
		if (algorithm != null)
			algorithm.prepareValidate();
		


		var childrenLength = children.length;
		for (i in 0...childrenLength)
		{
			Assert.equal(childrenLength, children.length); // Can the length of the children change during the loop?
			
			var child = children.getItemAt(i);
			if (!child.includeInLayout)
				continue;
			
			if (changes.has(Flags.WIDTH | Flags.LIST) && child.widthValidator != null && child.widthValidator.is( PercentIntRangeValidator ) && width.isSet())
				child.widthValidator.as( PercentIntRangeValidator ).calculateValues( width );
			
			if (child.percentWidth == Flags.FILL)
			{
				fillingChildren.push( child );
				child.width = Number.INT_NOT_SET;
			}
			
			//measure children with explicitWidth and no percentage size
			else if (checkIfChildGetsPercentageWidth(child, width)) {
				child.outerBounds.width = (width * child.percentWidth).roundFloat();
//#if debug		Assert.that( (width * child.percentWidth) > 0, "invalid width: "+(width * child.percentWidth)+"; groupWidth: "+width+"; child.percentWidth: "+child.percentWidth ); #end
			}
			
			
			//measure children
			if (child.percentWidth != Flags.FILL)
			{
				child.validateHorizontal();
				childrenWidth += child.outerBounds.width;
			}
		}
		

		// set height of horizontally filling children
		var fillingLength:Int = fillingChildren.length;		//define as int! otherwise it will be treated as UInt -> 0 - 4112123333 something but no negatives..
		if (fillingLength > 0)
		{
			if (width.isSet() && (width - childrenWidth) > 0)
			{
				var sizePerChild = ( width - childrenWidth ).divFloor(fillingLength);
				
				while (fillingLength--> 0)
				{
					var child = fillingChildren.pop();
					child.outerBounds.width = sizePerChild;
					child.validateHorizontal();
				}
			}
			else
				fillingChildren.removeAll();
			
			Assert.equal(fillingChildren.length, 0);
		}
		


		if (algorithm != null)
			algorithm.validateHorizontal();
		
		super.validateHorizontal();
	}
	
	
	
	
	override public function validateVertical ()
	{
		super.validateVertical();
		if (changes.hasNone( Flags.VERTICAL_INVALID ))
			return;
		
		if (fillingChildrenCache == null)
			fillingChildrenCache = FastArrayUtil.create();
		
		var fillingChildren	= fillingChildrenCache;
		var childrenHeight	= 0;
		
		if (algorithm != null)
			algorithm.prepareValidate();
		

		// validate children vertically
		var childrenLength = children.length;
		for (i in 0...childrenLength)
		{
			var child = children.getItemAt(i);
			
			if (!child.includeInLayout)
				continue;
			
			if (changes.has(Flags.HEIGHT | Flags.LIST) && child.heightValidator != null && child.heightValidator.is( PercentIntRangeValidator ) && height.isSet())
				child.heightValidator.as( PercentIntRangeValidator ).calculateValues( height );
			
			if (child.percentHeight == Flags.FILL)
			{
				fillingChildren.push( child );
				child.height = Number.INT_NOT_SET;
			}
			
			else if (checkIfChildGetsPercentageHeight(child, height))
				child.outerBounds.height = (height * child.percentHeight).roundFloat();
			
			//measure children
			if (child.percentHeight != Flags.FILL) {
				if (child.changes > 0)
					child.validateVertical();
				
				childrenHeight += child.outerBounds.height;
			}
		}
		
		
		// set height of vertically filling children
		var fillingLength:Int = fillingChildren.length;		//define as int! otherwise it will be treated as UInt -> 0 - 4112123333 something but no negatives..
		if (fillingLength > 0)
		{
			if (height.isSet() && (height - childrenHeight) > 0)
			{
				var sizePerChild = (height - childrenHeight).divFloor(fillingLength);
				while (fillingLength--> 0)
				{
					var child = fillingChildren.pop();
					child.outerBounds.height = sizePerChild;
					child.validateVertical();
				}
			}
			else
				fillingChildren.removeAll();

			Assert.equal(fillingChildren.length, 0);
		}
		

		// apply layout algorithm		
		if (algorithm != null)
			algorithm.validateVertical();
		
		super.validateVertical();
	}
	
	
	
	
	override public function validated ()
	{
		if (changes == 0 || !isValidating())
			return;
		
		if (!isVisible())
			return super.validated();
		
		if (!hasValidatedWidth)		validateHorizontal();
		if (!hasValidatedHeight)	validateVertical();

		if (changes.has( Flags.SIZE_PROPERTIES ))
			validateScrollPosition( scrollPos );
		
		if (algorithm != null) {
			algorithm.prepareValidate();
			
			if (height.isSet() && width.isSet())
				algorithm.apply();
		}
		
		var i = 0;
		while (i < children.length)		// use while loop instead of for loop since children can be removed during validation (== errors with a for loop)
		{
			var child = children.getItemAt(i);
			if (child.includeInLayout)
				child.validated();
			
			i++;
		}
		
		// It's important that super.validated get's called after the children are validated.
		// The process of validating children could otherwise invalidate the object again
		// since the x&y of the children can change when they are validated.
		return super.validated();
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setAlgorithm (v:ILayoutAlgorithm)
	{
		if (v != algorithm)
		{
			if (algorithm != null) {
				if (algorithm.group == this)
					algorithm.group = null;
				
				algorithm.algorithmChanged.unbind(this);
			}
			
			algorithm = v;
			
			if (algorithm != null) {
				algorithm.group = this;
				algorithmChangedHandler.on( algorithm.algorithmChanged, this );
			}
			
			invalidate( Flags.ALGORITHM );
		}
		return v;
	}


	private inline function setChildWidth (v)
	{
		if (v != childWidth)
		{
			childWidth = v;
			invalidate( Flags.CHILD_WIDTH | Flags.CHILDREN_INVALIDATED );
		}
		return v;
	}


	private inline function setChildHeight (v)
	{
		if (v != childHeight)
		{
			childHeight = v;
			invalidate( Flags.CHILD_HEIGHT | Flags.CHILDREN_INVALIDATED );
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
	
	public  inline function horScrollable ()						{ return width.isSet()  && measuredWidth.isSet()  && measuredWidth  > width; }
	public  inline function verScrollable ()						{ return height.isSet() && measuredHeight.isSet() && measuredHeight > height; }
	private inline function getScrollableWidth ()					{ return measuredWidth  - width; }
	private inline function getScrollableHeight ()					{ return measuredHeight - height; }
	
	private inline function setMinScrollXPos (v:Int)				{ return minScrollXPos = v <= 0 ? v : 0; }
	private inline function setMinScrollYPos (v:Int)				{ return minScrollYPos = v <= 0 ? v : 0; }
	
	public inline function validateScrollPosition (pos:IntPoint)
	{
		pos.x = horScrollable() ? pos.x.within( 0, scrollableWidth ) : 0;
		pos.y = verScrollable() ? pos.y.within( 0, scrollableHeight ) : 0;
		return pos;
	}
	
	
	public function scrollTo (child:ILayoutClient)
	{
	 // trace(child.outerBounds);
		var c = child.outerBounds;
		if (horScrollable())
		{
			var left	= scrollPos.x;
			var right	= left + width;
			
			if		(c.left < left)			scrollPos.x = c.left;
			else if (c.right > right)		scrollPos.x = c.right - width;
		}
		if (verScrollable())
		{
			var top		= scrollPos.y;
			var bottom	= top + height;
			
			if		(c.top < top)			scrollPos.y = c.top;
			else if (c.bottom > bottom)		scrollPos.y = c.bottom - height;
			
		}
	}
	
	
	public inline function scrollToDepth( index:Int )
	{
	//  trace("depth: "+index+"; fixedStart: "+fixedChildStart+"; length: "+children.length);
	    if (index >= fixedChildStart && index < (fixedChildStart + children.length))
	        scrollTo( children.getItemAt( index - fixedChildStart ) );
	    else
		    algorithm.scrollToDepth(index);
	}
	
	
	//
	// EVENT HANDLERS
	//
	
	private function algorithmChangedHandler ()	{ invalidate( Flags.ALGORITHM ); }
	
	
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
	 * @see LayoutContainer.setFixedChildLength
	 */
	public var childrenLength		(default, null)					: Int;
	public var fixedChildStart		(default, default)				: Int;
	public var invisibleBefore		(default, setInvisibleBefore)	: Int;
	public var invisibleAfter		(default, setInvisibleAfter)	: Int;
	
	/**
	 * Indicated wether the length of the children is fake d or not.
	 * 
	 * Layout-algorithms will only honor this property if the childWidth and 
	 * childHeight also have been set, otherwise it's impossible to calculate
	 * what the measured size of the container should be.
	 */
	public var fixedLength			(default, null)					: Bool;
	
	
	private function childrenChangeHandler ( change:ListChange <LayoutClient> ) : Void
	{
		switch (change)
		{
			case added( child, newPos ):
				child.parent = this;
				if (child.includeInLayout) {
					//check first if the bound properties are zero. If they are not, they can have been set by a tile-container
					if (child.outerBounds.left == 0)	child.outerBounds.left	= padding.left;
					if (child.outerBounds.top == 0)		child.outerBounds.top	= padding.top;
					invalidate( Flags.LIST );
				}
				child.listeners.add(this);
				
				if (!fixedLength)
					childrenLength++;
			
			
			case removed( child, oldPos ):
				child.parent = null;
				child.listeners.remove(this);
				
				//reset boundary properties without validating
				child.outerBounds.left	= 0;
				child.outerBounds.top	= 0;
				child.changes			= 0;
				
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


	private inline function setInvisibleBefore (v:Int)
	{
		if (v != invisibleBefore)
		{
			invisibleBefore = v;
			invalidate(Flags.LIST);
		}
		return v;
	}


	private inline function setInvisibleAfter (v:Int)
	{
		if (v != invisibleAfter)
		{
			invisibleAfter = v;
			invalidate(Flags.LIST);
		}
		return v;
	}
}