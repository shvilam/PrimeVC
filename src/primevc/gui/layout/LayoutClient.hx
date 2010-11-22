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
 import primevc.core.geom.Box;
 import primevc.core.geom.IntRectangle;
 import primevc.core.geom.RectangleFlags;
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.traits.IInvalidatable;
 import primevc.core.traits.Invalidatable;
 import primevc.core.validators.ValidatingValue;
#if debug
 import primevc.core.traits.IUIdentifiable;
 import primevc.utils.StringUtil;
#end
 import primevc.types.Number;
 import primevc.gui.events.LayoutEvents;
 import primevc.gui.layout.ILayoutClient;
 import primevc.gui.states.ValidateStates;
// import primevc.utils.NumberMath;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
  using Std;


private typedef Flags = LayoutFlags;


/**
 * Base class for layout clients without implementing x, y, width and height.
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class LayoutClient extends Invalidatable
			,	implements ILayoutClient
#if debug	,	implements IUIdentifiable #end
{
	public var validateOnPropertyChange									: Bool;
	public var changes 													: Int;
	public var includeInLayout		(default, setIncludeInLayout)		: Bool;
	
	public var parent				(default, setParent)				: ILayoutContainer;
	public var events				(default, null)						: LayoutEvents;
	
	
	/**
	 * Size of the layouclient including the padding but without the margin
	 */
	public var innerBounds			(default, null)						: IntRectangle;
	/**
	 * Size of the layouclient including the padding and margin
	 */
	public var outerBounds			(default, null)						: IntRectangle;
	
	
	public var relative				(default, setRelative)				: RelativeLayout;	//rules for sizing / positioning the layout with relation to the parent
//	public var sizeConstraint		(default, setSizeConstraint)		: SizeConstraint;
	
	/**
	 * @default	false
	 */
	public var maintainAspectRatio	(default, setAspectRatio)			: Bool;
	private var aspectRatio			(default, default)					: Float;
	
	
	public var state				(default, null)						: SimpleStateMachine < ValidateStates >;
	public var hasValidatedWidth	(default, null)						: Bool;
	public var hasValidatedHeight	(default, null)						: Bool;
	
	public var isValidating			(getIsValidating, never)			: Bool;
	public var isInvalidated		(getIsInvalidated, never)			: Bool;
	
	
	//
	// POSITION PROPERTIES
	//
	
	public var x					(default, setX)						: Int;
	public var y					(default, setY)						: Int;
	
	public var width				(default, null)						: SizeType;
//		private var _width			(default, null)						: ConstrainedInt;
	
	public var height				(default, null)						: SizeType;
//		private var _height 		(default, null)						: ConstrainedInt;
	
	public var percentWidth			(default, setPercentWidth)			: Float;
	public var percentHeight		(default, setPercentHeight)			: Float;
	
	public var padding				(default, setPadding)				: Box;
	public var margin				(default, setMargin)				: Box;
	
#if debug
	public var uuid					(default, null)						: String;
#end
	
	
	
	//
	// METHODS
	//
	
	public function new (newWidth:Int = Number.INT_NOT_SET, newHeight:Int = Number.INT_NOT_SET, validateOnPropertyChange = false)
	{
		super();
#if debug
		name = "LayoutClient" + counter++;
		uuid = StringUtil.createUUID();
#end
		this.validateOnPropertyChange	= validateOnPropertyChange;
		maintainAspectRatio				= false;
		
		events		= new LayoutEvents();
		innerBounds	= new IntRectangle( x, y, newWidth.getBiggest( 0 ) + getHorPadding(), newHeight.getBiggest( 0 ) + getVerPadding() );
		outerBounds	= new IntRectangle( x, y, innerBounds.width + getHorMargin(), innerBounds.height + getVerMargin() );
		width		= new SizeType( newWidth );
		height		= new SizeType( newHeight );
		
		innerBounds	.listeners.add( this );
		outerBounds	.listeners.add( this );
		width		.listeners.add( this );
		height		.listeners.add( this );
		
		percentWidth	= Number.FLOAT_NOT_SET;
		percentHeight	= Number.FLOAT_NOT_SET;
		includeInLayout	= true;
		
		//remove and set correct flags
		changes = changes.unset( Flags.PERCENT_WIDTH | Flags.PERCENT_HEIGHT ).set( Flags.X | Flags.Y );
		if (width.value.isSet())	changes = changes.set( Flags.WIDTH );
		if (height.value.isSet())	changes = changes.set( Flags.HEIGHT );
		
		state				= new SimpleStateMachine<ValidateStates>( ValidateStates.validated );
		hasValidatedHeight	= false;
		hasValidatedWidth	= false;
	}
	
	
	override public function dispose ()
	{
		//remove the layoutclient from the parents layout.
		if (parent != null && parent.children.has(this))
			parent.children.remove(this);
		
		width.dispose();
		height.dispose();
		innerBounds.dispose();
		outerBounds.dispose();
		state.dispose();
		events.dispose();
		
		if (relative != null) {
			relative.dispose();
			relative = null;
		}
		
		percentWidth	= percentHeight	= Number.FLOAT_NOT_SET;
		width			= height		= null;
		innerBounds		= outerBounds	= null;
		padding			= margin		= null;
		state	= null;
		events	= null;
		parent	= null;
		
		super.dispose();
	}
	
	
	private function resetProperties () : Void
	{
		validateOnPropertyChange = false;
		parent	= null;
		margin	= null;
		padding = null;
		x = y = width.value = height.value = 0;
		validate();
		changes	= 0;
	}
	
	
	
	
	//
	// LAYOUT METHODS
	//
	
	
	override public function invalidate (change:Int)
	{
		var oldChanges = changes;
		changes = changes.set(change);
		
		if (changes == 0 || changes == oldChanges || state == null || state.current == null)
			return;
		
		if (includeInLayout && parent != null)
			super.invalidate(change);
		
		if (isValidating) // && (parent == null || parent.isValidating))
		{
		//	trace(this+".NOT invalidating; "+Flags.readProperties(change)+"; "+isValidating+"; "+parent.isValidating);
			if (changes.has(Flags.WIDTH) && hasValidatedWidth)		hasValidatedWidth	= false;
			if (changes.has(Flags.HEIGHT) && hasValidatedHeight)	hasValidatedHeight	= false;
			return;
		}
		
	//	if (parent != null)
	//		trace(this+".invalidate; "+Flags.readProperties(change)); //" parent: "+parent+"; parent changes: "+Flags.readProperties(parent.changes));
		
		if (state.is(ValidateStates.validated))
			state.current = ValidateStates.invalidated;
		
		if (state.is( ValidateStates.invalidated ) && validateOnPropertyChange && (parent == null || !parent.validateOnPropertyChange))
			validate();
	}
	
	
	public function validate ()
	{
		if (changes == 0)
			return;
		
		state.current = ValidateStates.validating;
		validateHorizontal();
		validateVertical();
		
	//	trace("\t outer: "+outerBounds);
	//	trace("\t inner: "+innerBounds);
		
		//auto validate when there is no parent or when the parent isn't invalidated
	//	if (parent != null)
	//		trace(this+".validate; "+readChanges() + "; p: "+parent+"; pchanges: "+Flags.readProperties(parent.changes)+"; parent.isValidating? "+parent.isValidating);
		
		if (parent == null || !parent.isValidating)
			validated();
	}
	
	
	public function validateHorizontal ()
	{
		if (hasValidatedWidth || changes == 0)
			return;
		
		state.current = ValidateStates.validating;
		
		//force width validation if there's a validator buth there's no width set yet
		if (width.value.notSet() && width.validator != null)
			width.validateValue();
		
		innerBounds.invalidatable = outerBounds.invalidatable = false;
		
		if (changes.has(Flags.WIDTH))
		{
			if (maintainAspectRatio)
				height.value = (width.value / aspectRatio).int();
			
			innerBounds.width = width.value.getBiggest( 0 ) + getHorPadding();
			outerBounds.width = innerBounds.width + getHorMargin();
		}
		
		if (changes.has(Flags.MARGIN))
			innerBounds.left = (margin == null) ? outerBounds.left : outerBounds.left + margin.left;
		
		innerBounds.resetValidation();
		outerBounds.resetValidation();
		hasValidatedWidth = true;
	}
	
	
	public function validateVertical ()
	{
		if (hasValidatedHeight || changes == 0)
			return;
		
		state.current = ValidateStates.validating;
		
		//force height validation if there's a validator buth there's no height set yet
		if (height.value.notSet() && height.validator != null)
			height.validateValue();
		
		innerBounds.invalidatable = outerBounds.invalidatable = false;
		if (changes.has(Flags.HEIGHT))
		{
			if (maintainAspectRatio)
				width.value = (height.value / aspectRatio).int();
			
			innerBounds.height = height.value.getBiggest( 0 ) + getVerPadding();
			outerBounds.height = innerBounds.height + getVerMargin();
		}
		
		if (changes.has(Flags.MARGIN))
			innerBounds.top = (margin == null) ? outerBounds.top : outerBounds.top + margin.top;
		
		innerBounds.resetValidation();
		outerBounds.resetValidation();
		hasValidatedHeight = true;
	}
	
	
	public function validated ()
	{
		if (changes > 0)
		{
			if (changes.has(Flags.WIDTH | Flags.HEIGHT))	events.sizeChanged.send();
			if (changes.has(Flags.X | Flags.Y))				events.posChanged.send();
			changes = 0;
		}
		
		state.current = ValidateStates.validated;
		hasValidatedWidth	= false;
		hasValidatedHeight	= false;
	}
	
	
	public inline function getHorPosition ()
	{
		var pos = innerBounds.left;
		if (parent.is(VirtualLayoutContainer))
			pos += parent.getHorPosition();
		
		return pos;
	}
	
	
	public inline function getVerPosition ()
	{
		var pos = innerBounds.top;
		if (parent.is(VirtualLayoutContainer))
			pos += parent.getVerPosition();
		
		return pos;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getHorPadding () : Int	{ return padding == null ? 0 : padding.left + padding.right; }
	private inline function getVerPadding() : Int	{ return padding == null ? 0 : padding.top + padding.bottom; }
	private inline function getHorMargin () : Int	{ return margin == null ? 0 : margin.left + margin.right; }
	private inline function getVerMargin() : Int	{ return margin == null ? 0 : margin.top + margin.bottom; }
	
	
	private inline function getIsValidating () : Bool {
		return state.is(ValidateStates.validating) || (parent != null && parent.isValidating);
	}
	
	
	private inline function getIsInvalidated () : Bool {
		return state == null ? false : state.is(ValidateStates.invalidated) || state.is(ValidateStates.parent_invalidated);
	}
	
	
	//
	// POSITION SETTERS
	//
	
	private function setX (v:Int) : Int
	{
		if (x != v)
		{
			x = v;
			invalidate( Flags.X );
			outerBounds.left = v;
			innerBounds.left = (margin == null) ? outerBounds.left : outerBounds.left + margin.left;
		}
		return x;
	}
	
	
	private function setY (v:Int) : Int
	{
		if (y != v)
		{
			y = v;
			invalidate( Flags.Y );
			outerBounds.top = v;
			innerBounds.top = (margin == null) ? outerBounds.top : outerBounds.top + margin.top;
		}
		return y;
	}
	
	
	override public function invalidateCall (propChanges:Int, sender:IInvalidatable)
	{
		if (propChanges == 0)
			return;
		
		if (sender.is(IntRectangle))
		{
			if (/*state.current == ValidateStates.invalidated || */propChanges == RectangleFlags.BOTTOM || propChanges == RectangleFlags.RIGHT)
				return;
		
			var box = sender.as(IntRectangle);
		
			if (box == outerBounds)
			{
				if (propChanges.has( RectangleFlags.LEFT ))		x = box.left;
				if (propChanges.has( RectangleFlags.TOP ))		y = box.top;
				if (propChanges.has( RectangleFlags.WIDTH ))	width.value		= box.width - getHorPadding() - getHorMargin();
				if (propChanges.has( RectangleFlags.HEIGHT ))	height.value	= box.height - getVerPadding() - getVerMargin();
			//	trace("\t\t\t"+this+".outerBounds changed "+box+"; "+getVerPadding()+"; "+getVerMargin());
			//	trace(this+".invalidateCall from outerBounds "+RectangleFlags.readProperties(propChanges) + "; state: "+state.current + "; w: "+width+"; h: "+height+"; x: "+x+"; y: "+y);
			}
		
			else if (box == innerBounds)
			{
				if (propChanges.has( RectangleFlags.LEFT ))		x = margin == null ? box.left : box.left - margin.left;
				if (propChanges.has( RectangleFlags.TOP ))		y = margin == null ? box.top : box.top - margin.top;
				if (propChanges.has( RectangleFlags.WIDTH ))	width.value		= box.width - getHorPadding();
				if (propChanges.has( RectangleFlags.HEIGHT ))	height.value	= box.height - getVerPadding();
			//	trace(this+".invalidateCall from innerBounds "+RectangleFlags.readProperties(propChanges) + "; state: "+state.current+"; w: "+width+"; h: "+height+"; x: "+x+"; y: "+y);
			}
		}
		
		else if (sender == width)
		{
			if (propChanges.has( ValueFlags.VALUE ))		invalidate( Flags.WIDTH );
			if (propChanges.has( ValueFlags.VALIDATOR ))	invalidate( Flags.WIDTH_VALIDATOR );
		}
		else if (sender == height)
		{
			if (propChanges.has( ValueFlags.VALUE ))		invalidate( Flags.HEIGHT );
			if (propChanges.has( ValueFlags.VALIDATOR ))	invalidate( Flags.HEIGHT_VALIDATOR );
		}
		else
			super.invalidateCall( propChanges, sender );
	}
	
	
	private inline function setPercentWidth (v)
	{
		if (v != percentWidth)
		{
			percentWidth = v;
			invalidate( Flags.WIDTH | Flags.PERCENT_WIDTH );
		}
		return v;
	}
	
	
	private inline function setPercentHeight (v:Float)
	{
		if (v != percentHeight)
		{
			percentHeight = v;
			invalidate( Flags.HEIGHT | Flags.PERCENT_HEIGHT );
		}
		return v;
	}
	
	
	private function setPadding (v:Box)
	{
		if (padding != v) {
			padding = v;
			invalidate( Flags.HEIGHT | Flags.WIDTH | Flags.PADDING );
		}
		return padding;
	}
	
	
	private function setMargin (v:Box)
	{
		if (margin != v) {
			margin = v;
			invalidate( Flags.HEIGHT | Flags.WIDTH | Flags.MARGIN );
		}
		return padding;
	}
	
	
	private inline function setParent (v)
	{
		if (parent != v)
		{
		//	if (parent != null && parent.state != null)
		//		parent.state.change.unbind( this );
			
			parent = v;
		
		//	if (parent != null)
		//		handleParentStateChange.on( parent.state.change, this );
		}
		return v;
	}
	
	
	private inline function setIncludeInLayout (v:Bool)
	{
		if (includeInLayout != v) {
			includeInLayout = v;
			invalidate( Flags.INCLUDE );
		}
		return includeInLayout;
	}
	
	
	private inline function setAspectRatio (v:Bool) : Bool
	{
		if (v != maintainAspectRatio)
		{
			if (maintainAspectRatio)
				aspectRatio = 0;
			
			maintainAspectRatio = v;
			
			if (maintainAspectRatio)
				aspectRatio = width.value / height.value;
		}
		return v;
	}
	
	
	private inline function setRelative (v:RelativeLayout)
	{
		if (relative != v)
		{
			if (relative != null)
				relative.changed.unbind( this );
		
			relative = v;
			if (relative != null)
				handleRelativeChange.on( relative.changed, this );
		}
		return v;
	}
	
	
	
	//
	// EVEMT HANDLERS
	//
	
	
	private function handleRelativeChange ()
	{
		invalidate(Flags.RELATIVE);
	}
	
	
#if debug
	public inline function readChanges (changes:Int = -1) : String
	{
		if (changes == -1)
			changes = this.changes;
		
		return Flags.readProperties(changes);
	}
	
	
	public inline function readChange (change:Int) : String
	{
		return Flags.readProperty(change);
	}
	
	
	public static var counter:Int = 0;
	public var name:String;
	public function toString() { return name; } //state.current+"_"+name; } // + " - " + uuid; }
#end
}