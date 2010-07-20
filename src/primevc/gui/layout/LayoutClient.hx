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
 import primevc.core.Number;
 import primevc.gui.events.LayoutEvents;
 import primevc.gui.states.LayoutStates;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.IntUtil;
  using primevc.utils.TypeUtil;


private typedef Flags = LayoutFlags;

/**
 * Base class for layout clients without implementing x, y, width and height.
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class LayoutClient implements ILayoutClient
{
	public var validateOnPropertyChange									: Bool;
	public var changes 				(default, setChanges)				: Int;
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
	
	
	public var states				(default, null)						: SimpleStateMachine < LayoutStates >;
	public var isValidating			(getIsValidating, never)			: Bool;
	
	
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
	
	
	//
	// METHODS
	//
	
	
	public function new (validateOnPropertyChange = false)
	{
#if debug
		name = "LayoutClient" + counter++;
#end
		this.validateOnPropertyChange	= validateOnPropertyChange;
	//	(untyped this).includeInLayout	= true;
		maintainAspectRatio				= false;
		
		states	= new SimpleStateMachine( LayoutStates.validated );
		events	= new LayoutEvents();
		bounds	= new ConstrainedRect();
		_width	= new ConstrainedInt();
		_height	= new ConstrainedInt();
		
		percentWidth	= 0;
		percentHeight	= 0;
		includeInLayout	= true;
		
		setX		.on( bounds.props.left.change, this );
		setY		.on( bounds.props.top.change, this );
		updateWidth	.on( bounds.size.xProp.change, this );
		updateHeight.on( bounds.size.yProp.change, this );
		
		changes = changes.set(Flags.X_CHANGED);
		changes = changes.set(Flags.Y_CHANGED);
	}
	
	
	public function dispose ()
	{
		_width.dispose();
		_height.dispose();
		bounds.dispose();
		states.dispose();
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
		states	= null;
		events	= null;
		parent	= null;
		
	}
	
	
	private function resetProperties () : Void
	{
		validateOnPropertyChange = false;
		parent	= null;
		padding = null;
		x = y = width = height = 0;
		measure();
		changes	= 0;
	}
	
	
	
	
	//
	// LAYOUT METHODS
	//
	
	
	public function invalidate (change:Int)
	{
		changes = changes.set(change);
		
		if (changes == 0 || states.current ==  null)
			return;
		
		if (isValidating)
			return;
		
		if (parent == null || !parent.childInvalidated(changes))
		{
			if (!states.is(LayoutStates.parent_invalidated))
				states.current = LayoutStates.invalidated;
			
			if (validateOnPropertyChange && (parent == null || !parent.validateOnPropertyChange))
				measure();
		}
	}
	
	
	public function measure ()
	{
		if (changes == 0)
			return;
		
		states.current = LayoutStates.measuring;
		measureHorizontal();
		measureVertical();
		
		//auto validate when there is no parent or when the parent isn't invalidated
		if (parent == null || parent.changes == 0)
			validate();
	}
	
	
	public function measureHorizontal ()
	{
		if (changes.has(Flags.WIDTH_CHANGED))
			bounds.setWidth( width + getHorPadding() );
	}
	
	
	public function measureVertical ()
	{
		if (changes.has(Flags.HEIGHT_CHANGED))
			bounds.setHeight( height + getVerPadding() );
	}
	
	
	public function validate ()
	{
		if (changes == 0)
			return;
		
		states.current = LayoutStates.validating;
		
		if (changes.has(Flags.WIDTH_CHANGED) || changes.has(Flags.HEIGHT_CHANGED))
			events.sizeChanged.send();
		
		if (changes.has(Flags.X_CHANGED) || changes.has(Flags.Y_CHANGED))
			events.posChanged.send();
		
		states.current	= LayoutStates.validated;
		changes			= 0;
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
		var validating = states.is(LayoutStates.measuring) || states.is(LayoutStates.validating);
		if (!validating && parent != null)
			validating = parent.isValidating;
		return validating;
	}
	
	
	
	//
	// BOUNDARY SETTERS
	//
	
	private inline function updateWidth (v:Int)		{ width = v - getHorPadding(); }
	private inline function updateHeight (v:Int)	{ height = v - getVerPadding(); }
	
	
	
	//
	// POSITION SETTERS
	//
	
	private inline function setX (v:Int) : Int
	{
		bounds.left = v;
		if (x != bounds.left) {
			x = bounds.left;
			invalidate( Flags.X_CHANGED );
		}
		return x;
	}
	
	
	private inline function setY (v:Int) : Int
	{
		bounds.top = v;
		if (y != bounds.top) {
			y = bounds.top;
			invalidate( Flags.Y_CHANGED );
		}
		return y;
	}
	
	
	
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
			bounds.setWidth( _width.value + getHorPadding() );
			
			if (maintainAspectRatio && newH != height)
				height = newH; //will trigger the height constraints
			
			invalidate( Flags.WIDTH_CHANGED );
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
			bounds.setHeight( _height.value + getVerPadding() );
			
			if (maintainAspectRatio && newW != width)
				width = newW; //will trigger the width constraints
			
			invalidate( Flags.HEIGHT_CHANGED );
		}
		return _height.value;
	}
	
	
	private inline function setPercentWidth (v)
	{
		if (v != percentWidth)
		{
			percentWidth = v;
			invalidate( Flags.WIDTH_CHANGED );
		}
		return v;
	}
	
	
	private inline function setPercentHeight (v)
	{
		if (v != percentHeight)
		{
			percentHeight = v;
			invalidate( Flags.HEIGHT_CHANGED );
		}
		return v;
	}
	
	
	
	private inline function setPadding (v:Box)
	{
		if (padding != v) {
			padding = v;
			invalidate( Flags.HEIGHT_CHANGED | Flags.WIDTH_CHANGED );
		}
		return padding;
	}
	
	
	private inline function setParent (v)
	{
		if (parent != v)
		{
			if (parent != null && parent.states != null)
				parent.states.change.unbind( this );
		
			parent = v;
		
			if (parent != null)
				handleParentStateChange.on( parent.states.change, this );
		}
		return v;
	}
	
	
	private inline function setIncludeInLayout (v:Bool)
	{
		if (includeInLayout != v) {
			includeInLayout = v;
			invalidate( Flags.INCLUDE_CHANGED );
		}
		return includeInLayout;
	}
	
	
	private inline function setChanges (v:Int)
	{
		return changes = v;
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
		invalidate( Flags.SIZE_CONSTRAINT_CHANGED );
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
		invalidate(Flags.RELATIVE_CHANGED);
	}
	
	
	private function handleParentStateChange (oldState, newState)
	{
		switch (newState) {
			case LayoutStates.invalidated:
				states.current = LayoutStates.parent_invalidated;
		}
	}
	
	
#if debug
	public inline function readChanges ()
	{
		var output	= [];
		var result	= "none";
		
		if (changes > 0)
		{
			if (changes.has( Flags.WIDTH_CHANGED ))				output.push("width");
			if (changes.has( Flags.HEIGHT_CHANGED ))			output.push("height");
			if (changes.has( Flags.X_CHANGED ))					output.push("x");
			if (changes.has( Flags.Y_CHANGED ))					output.push("y");
			if (changes.has( Flags.INCLUDE_CHANGED ))			output.push("include_in_layout");
			if (changes.has( Flags.RELATIVE_CHANGED ))			output.push("relative_properties");
			if (changes.has( Flags.LIST_CHANGED ))				output.push("list");
			if (changes.has( Flags.CHILDREN_INVALIDATED ))		output.push("children_invalidated");
			if (changes.has( Flags.ALGORITHM_CHANGED ))			output.push("algorithm");
			if (changes.has( Flags.SIZE_CONSTRAINT_CHANGED ))	output.push("size constraint");
			result = output.join(", ");
		}
		return "changes: " + result;
	}
	
	public static var counter:Int = 0;
	public var name:String;
	public function toString() { return name; }
#end
}