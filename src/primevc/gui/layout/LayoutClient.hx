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
 import primevc.core.geom.constraints.ConstrainedInt;
 import primevc.core.geom.constraints.ConstrainedRect;
 import primevc.core.geom.constraints.SizeConstraint;
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.traits.Invalidatable;
#if debug
 import primevc.core.traits.IUIdentifiable;
 import primevc.utils.StringUtil;
#end
 import primevc.types.Number;
 import primevc.gui.events.LayoutEvents;
 import primevc.gui.states.ValidateStates;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


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
	
	public var parent				(default, setParent)				: ILayoutContainer<Dynamic>;
	public var events				(default, null)						: LayoutEvents;
	
	public var bounds				(default, null)						: ConstrainedRect;
	public var relative				(default, setRelative)				: RelativeLayout;	//rules for sizing / positioning the layout with relation to the parent
	public var sizeConstraint		(default, setSizeConstraint)		: SizeConstraint;
	
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
	
	public var width				(getWidth, setWidth)				: Int;
		private var _width			(default, null)						: ConstrainedInt;
	
	public var height				(getHeight, setHeight)				: Int;
		private var _height 		(default, null)						: ConstrainedInt;
	
	public var percentWidth			(default, setPercentWidth)			: Float;
	public var percentHeight		(default, setPercentHeight)			: Float;
	
	public var padding				(default, setPadding)				: Box;
	
#if debug
	public var uuid					(default, null)						: String;
#end
	
	
	
	//
	// METHODS
	//
	
	public function new (newWidth:Int = 0, newHeight:Int = 0, validateOnPropertyChange = false)
	{
		super();
#if debug
		name = "LayoutClient" + counter++;
		uuid = StringUtil.createUUID();
#end
		this.validateOnPropertyChange	= validateOnPropertyChange;
		maintainAspectRatio				= false;
		
		events	= new LayoutEvents();
		bounds	= new ConstrainedRect(0, newWidth + getHorPadding(), newHeight + getVerPadding(), 0);
		_width	= new ConstrainedInt( newWidth );
		_height	= new ConstrainedInt( newHeight );
		
		percentWidth	= 0;
		percentHeight	= 0;
		includeInLayout	= true;
		
		boundsLeftChangeHandler	.on( bounds.leftProp.change, this );
		boundsTopChangeHandler	.on( bounds.topProp.change, this );
		updateWidth				.on( bounds.size.xProp.change, this );
		updateHeight			.on( bounds.size.yProp.change, this );
		
		changes				= changes.set(Flags.X | Flags.Y | Flags.WIDTH | Flags.HEIGHT);
		state				= new SimpleStateMachine<ValidateStates>( ValidateStates.validated );
		hasValidatedHeight	= false;
		hasValidatedWidth	= false;
	}
	
	
	override public function dispose ()
	{
		//remove the layoutclient from the parents layout.
		if (parent != null && parent.children.has(this))
			parent.children.remove(this);
		
		_width.dispose();
		_height.dispose();
		bounds.dispose();
		state.dispose();
		events.dispose();
		
		if (relative != null) {
			relative.dispose();
			relative = null;
		}
		
		sizeConstraint	= null;		//do not dispose him. Sizeconstraints instances can be used across several clients.
		percentWidth	= 0;
		percentHeight	= 0;
		_width	= null;
		_height	= null;
		bounds	= null;
		padding	= null;
		state	= null;
		events	= null;
		parent	= null;
		
		super.dispose();
	}
	
	
	private function resetProperties () : Void
	{
		validateOnPropertyChange = false;
		parent	= null;
		padding = null;
		x = y = width = height = 0;
		validate();
		changes	= 0;
	}
	
	
	
	
	//
	// LAYOUT METHODS
	//
	
	
	override public function invalidate (change:Int)
	{
		changes = changes.set(change);
		
		if (changes == 0 || state == null || state.current == null)
			return;
		
		if (isValidating)
			return;
		
		if (includeInLayout && parent != null)
			super.invalidate(change);
		
		if (!state.is(ValidateStates.parent_invalidated))
		{
			state.current = ValidateStates.invalidated;
			
			if (validateOnPropertyChange && (parent == null || !parent.validateOnPropertyChange))
				validate();
		}
	}
	
	
	public function validate ()
	{
		if (changes == 0)
			return;
		
		state.current = ValidateStates.validating;
		if (!hasValidatedWidth)		validateHorizontal();
		if (!hasValidatedHeight)	validateVertical();
		
		//auto validate when there is no parent or when the parent isn't invalidated
		if (parent == null || parent.changes == 0)
			validated();
	}
	
	
	public function validateHorizontal ()
	{
		if (changes.has(Flags.WIDTH))
			bounds.width = width + getHorPadding();
		
		hasValidatedWidth = true;
	}
	
	
	public function validateVertical ()
	{
		if (changes.has(Flags.HEIGHT))
			bounds.height = height + getVerPadding();
		
		hasValidatedHeight = true;
	}
	
	
	public function validated ()
	{
		if (changes == 0)
			return;
		
		if (changes.has(Flags.WIDTH | Flags.HEIGHT))	events.sizeChanged.send();
		if (changes.has(Flags.X | Flags.Y))				events.posChanged.send();
		
		state.current	= ValidateStates.validated;
		changes			= 0;
		
		hasValidatedWidth	= false;
		hasValidatedHeight	= false;
	}
	
	
	public inline function getHorPosition () {
		var pos : Int = x;
		if (parent.is(VirtualLayoutContainer))
			pos += parent.getHorPosition();
		
		return pos;
	}
	
	
	public inline function getVerPosition ()
	{
		var pos : Int = y;
		if (parent.is(VirtualLayoutContainer))
			pos += parent.getVerPosition();
		
		return pos;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getHorPadding () : Int	{ return padding == null ? 0 : padding.left + padding.right; }
	private inline function getVerPadding() : Int	{ return padding == null ? 0 : padding.top + padding.bottom; }
	
	
	private inline function getIsValidating () : Bool {
		return state.is(ValidateStates.validating) || (parent != null && parent.isValidating);
	}
	
	
	private inline function getIsInvalidated () : Bool {
		return state == null ? false : state.is(ValidateStates.invalidated) || state.is(ValidateStates.parent_invalidated);
	}
	
	
	
	//
	// BOUNDARY SETTERS
	//
	
	private inline function updateWidth (newV:Int, oldV:Int)	{ width = newV - getHorPadding(); }
	private inline function updateHeight (newV:Int, oldV:Int)	{ height = newV - getVerPadding(); }
	
	
	
	//
	// POSITION SETTERS
	//
	
	private inline function setX (v:Int) : Int
	{
		bounds.left = v;
		if (x != bounds.left) {
			x = bounds.left;
			invalidate( Flags.X );
		}
		return x;
	}
	
	
	private inline function setY (v:Int) : Int
	{
		bounds.top = v;
		if (y != bounds.top) {
			y = bounds.top;
			invalidate( Flags.Y );
		}
		return y;
	}
	
	
	private function boundsLeftChangeHandler (newV:Int, oldV:Int) { x = newV; }
	private function boundsTopChangeHandler (newV:Int, oldV:Int) { y = newV; }
	
	
	
	
	//
	// SIZE GETTERS / SETTERS
	//
	
	private inline function getWidth ()		: Int { return _width.value; }
	private inline function getHeight ()	: Int { return _height.value; }
	
	
	private function setWidth (v:Int) : Int
	{
		var oldW		= _width.value;
		_width.value	= v;
		
		if (_width.value != oldW)
		{
			var newH:Int	= maintainAspectRatio ? Std.int(_width.value / aspectRatio) : height;
			bounds.width 	= _width.value + getHorPadding();
			
			if (maintainAspectRatio && newH != height)
				height = newH; //will trigger the height constraints
			
			invalidate( Flags.WIDTH );
		}
		return _width.value;
	}
	
	
	private function setHeight (v:Int) : Int
	{
		var oldH		= _height.value;
		_height.value	= v;
		
		if (_height.value != oldH)
		{
			var newW:Int	= maintainAspectRatio ? Std.int(_height.value * aspectRatio) : width;	
			bounds.height	= _height.value + getVerPadding();
			
			if (maintainAspectRatio && newW != width)
				width = newW; //will trigger the width constraints
			
			invalidate( Flags.HEIGHT );
		}
		return _height.value;
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
	
	
	private inline function setPercentHeight (v)
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
	
	
	//
	// CONSTRAINT METHODS
	//
	
	
	/**
	 * Setter will set the new sizeConstraint and bind it's change signals to this
	 * class. The SizeConstraint is meant for constrainting the size values by
	 * defining a min and max value for the width and the height.
	 */
	private inline function setSizeConstraint (v:SizeConstraint)
	{
		if (sizeConstraint != v)
		{
			if (sizeConstraint != null)
			{
				_width.constraint	= null;
				_height.constraint	= null;
				
				sizeConstraint.width.change.unbind(this);
				sizeConstraint.height.change.unbind(this);
			}
		
			sizeConstraint = v;
			invalidateSizeConstraint();
		
			if (sizeConstraint != null)
			{
				_width.constraint	= sizeConstraint.width;
				_height.constraint	= sizeConstraint.height;
			
				_width.validateValue.on( sizeConstraint.width.change, this );
				_height.validateValue.on( sizeConstraint.height.change, this );
				invalidateSizeConstraint.on( sizeConstraint.width.change, this );
				invalidateSizeConstraint.on( sizeConstraint.height.change, this );
				
				//force size constraints to run for the first time
				setWidth( width );
				setHeight( height );
			}
		}
		return v;
	}
	
	
	private inline function invalidateSizeConstraint () {
		invalidate( Flags.SIZE_CONSTRAINT );
	}
	
	
	private inline function setAspectRatio (v:Bool) : Bool
	{
		if (v != maintainAspectRatio)
		{
			if (maintainAspectRatio)
				aspectRatio = 0;
			
			maintainAspectRatio = v;
			
			if (maintainAspectRatio)
				aspectRatio = width / height;
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
	public function toString() { return name; } // + " - " + uuid; }
#end
}