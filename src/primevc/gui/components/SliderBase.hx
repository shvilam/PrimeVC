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
package primevc.gui.components;
 import primevc.core.dispatcher.Wire;
 import primevc.core.events.ActionEvent;
 import primevc.core.geom.space.Direction;
 import primevc.core.geom.IntPoint;
 import primevc.core.geom.Point;
 import primevc.core.math.PercentageHelper;
 import primevc.core.Bindable;
 import primevc.gui.components.Button;
 import primevc.gui.core.UIElementFlags;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.events.MouseEvents;
  using primevc.gui.utils.UIElementActions;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using Std;


private typedef DataType = PercentageHelper; //Bindable<Float>;


/**
 * Slider component
 * 
 * @author Ruben Weijers
 * @creation-date Nov 05, 2010
 */
class SliderBase extends UIDataContainer < DataType >
{
	/**
	 * Defines if the slider is horizontal or vertical
	 * @default		horizontal
	 */
	public var direction	(default, setDirection)		: Direction;
	
	/**
	 * Eventgroup with events that are dispatched when the user starts sliding
	 * the slider.
	 */
	public var sliding		(default, null)				: ActionEvent;
	
	
	private var mouseMoveBinding		: Wire < Dynamic >;
	private var mouseBgDownBinding		: Wire < Dynamic >;
	private var mouseBtnDownBinding		: Wire < Dynamic >;
	private var mouseUpBinding			: Wire < Dynamic >;
//	private var updatePercBinding		: Wire < Dynamic >;
	
	
	
	
	public function new (id:String = null, value:Float = 0.0, minValue:Float = 0.0, maxValue:Float = 1.0, direction:Direction = null)
	{
		super(id, new DataType(value, minValue, maxValue));
		(untyped this).inverted		= false;
	//	(untyped this).showButtons	= false;
		this.direction				= direction == null ? horizontal : direction;
	//	validator					= new FloatRangeValidator( minValue, maxValue );
		sliding						= new ActionEvent();
	}
	
	
	override public function dispose ()
	{
	/*	if (validator != null)
		{
			validator.dispose();
			validator = null;
		}*/
		
	//	if (updatePercBinding != null)		updatePercBinding.dispose();
		if (data != null)					data.dispose();
		if (mouseMoveBinding != null)		mouseMoveBinding.dispose();
		if (mouseUpBinding != null)			mouseUpBinding.dispose();
		if (mouseBgDownBinding != null)		mouseBgDownBinding.dispose();
		if (mouseBtnDownBinding != null)	mouseBtnDownBinding.dispose();
		
		mouseBgDownBinding = mouseBtnDownBinding = mouseUpBinding = mouseMoveBinding = null;
		sliding.dispose();
		
		if (isInitialized())
		{
			dragBtn.dispose();
			dragBtn = null;
		}
		
		sliding	= null;
		direction = null;
		super.dispose();
	}
	
	
	override private function init ()
	{
		super.init();
		
		mouseBgDownBinding	= jumpToPosition	.on( userEvents.mouse.down, this );
		mouseBtnDownBinding	= enableMoveWires	.on( dragBtn.userEvents.mouse.down, this );
		mouseUpBinding		= disableMoveWires	.on( window.mouse.events.up, this );
		mouseUpBinding.disable();
		createMouseMoveBinding();
	}
	
	
	override private function initData ()
	{
	//	calculatePercentage();
		invalidatePercentage.on( data.perc.change, this );
		updateChildren();
	//	validateData.on( validator.change, this );
	//	updatePercBinding = calculatePercentage.on( data.change, this );
	}
	
	
	override private function removeData ()
	{
		data.perc.change.unbind( this );
	//	if (updatePercBinding != null)
	//		updatePercBinding.dispose();
	}
	
	
	override public function validate ()
	{
		var changes = this.changes;
		super.validate();
		
		if (changes.has(UIElementFlags.PERCENTAGE))
			if (!updateChildren())		//updating children fails if the width or height in layout isn't set yet
				invalidate(UIElementFlags.PERCENTAGE);
		
		if (changes.has(UIElementFlags.DIRECTION))
			createMouseMoveBinding();
	}
	
	
	private inline function createMouseMoveBinding ()
	{
		if (mouseMoveBinding != null)
		{
			mouseMoveBinding.dispose();
			mouseMoveBinding = null;
		}
		
		if (window != null && direction != null)
		{
			var calculateValue	= direction == horizontal ? calculateHorValue : calculateVerValue;
			mouseMoveBinding	= calculateValue.on( window.mouse.events.move, this );
			mouseMoveBinding.disable();
		}
	}
	
	
	private function invalidatePercentage ()
	{
		invalidate( UIElementFlags.PERCENTAGE );
	}
	
	
	
	//
	// CHILDREN
	//
	
	public var dragBtn		(default, null)	: Button;
	
	
	override private function createChildren ()
	{
		dragBtn = new Button();
	//	dragBtn.layout.includeInLayout = false;
		dragBtn.id.value = id.value + "Btn";
		
		layoutContainer.children.add( dragBtn.layout );
		children.add( dragBtn );
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setDirection (v)
	{
		if (direction != v)
		{
			direction = v;
			invalidate(UIElementFlags.DIRECTION);
		}
		return v;
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private var originalPos		: IntPoint;
	private var mouseStartPos	: Point;
	
	
	/**
	 * Method is called when the user clicks somewhere on the slider but not
	 * on the dragBtn.
	 * The dragBtn should jump to the mouseposition and follow the cursor
	 * as long as the mouseBtn stays down.
	 */
	private function jumpToPosition (mouseObj:MouseState)
	{
		if (mouseObj.target != this)
			return;
		
		//jump to position
		var curMouse		= getLocalMousePos( mouseObj );
		data.percentage		= (direction == horizontal)
								? ((curMouse.x - layout.padding.left) / layout.width).within(0, 1)
								: ((curMouse.y - layout.padding.top) / layout.height).within(0, 1);
		
		validate();
		enableMoveWires(mouseObj);
	}
	
	
	private function enableMoveWires (mouseObj:MouseState)
	{
		originalPos		= new IntPoint( dragBtn.layout.x, dragBtn.layout.y );
		mouseStartPos	= getLocalMousePos( mouseObj );
		
		mouseBtnDownBinding.disable();
		mouseBgDownBinding.disable();
		mouseUpBinding.enable();
		mouseMoveBinding.enable();
		
	//	calculateValue( mouseObj );
	//	dragBtn.mouseEnabled				= false;
		dragBtn.layout.includeInLayout		= false;
		sliding.begin.send();
	}
	
	
	private function disableMoveWires (mouseObj:MouseState)
	{
		mouseStartPos	= null;
		originalPos		= null;
		
		mouseBtnDownBinding.enable();
		mouseBgDownBinding.enable();
		mouseUpBinding.disable();
		mouseMoveBinding.disable();
		
	//	calculateValue( mouseObj );
		dragBtn.mouseEnabled				= true;
		dragBtn.layout.includeInLayout		= true;
		sliding.apply.send();
	}
	
	
	private inline function getLocalMousePos (mouseObj:MouseState)
	{
		return (mouseObj.target == this) ? mouseObj.local : globalToLocal(mouseObj.stage);
	}
	
	
	/**
	 * Method is called after the position of the dragButton is changed or
	 * when the user clicked somewhere in the background
	 */
	private function calculateHorValue (mouseObj:MouseState)
	{
		var curMouse	= getLocalMousePos( mouseObj );
		var min			= layout.padding.left;
		var maxMouse	= layout.width + min;
		var max			= maxMouse - dragBtn.layout.outerBounds.width;
		
		if (!curMouse.x.isWithin( min, maxMouse ))
			return;
		
		var newX		= (originalPos.x + curMouse.x - mouseStartPos.x).within( min, max );
		data.percentage	= ((newX - min) / (max - min)).within(0, 1);
	}
	
	
	private function calculateVerValue (mouseObj:MouseState)
	{
		var curMouse	= getLocalMousePos( mouseObj );
		var min			= layout.padding.top;
		var maxMouse	= layout.height + min;
		var max			= maxMouse - dragBtn.layout.outerBounds.height;
		
		if (!curMouse.y.isWithin( min, maxMouse ))
			return;
		
		var newY		= (originalPos.y + curMouse.y - mouseStartPos.y).within( min, max );
		data.percentage	= (newY / max).within(0, 1);
	}
	
	
	private function updateChildren () : Bool
	{
		if (direction == horizontal)
		{
			if (layout.width.notSet())
				return false;
			
			dragBtn.x			= layout.padding.left + ( data.percentage * ( layout.width - dragBtn.layout.outerBounds.width ) );
			dragBtn.layout.x	= dragBtn.x.roundFloat();
		//	trace(this+"; "+dragBtn.x);
		}
		else
		{
			if (layout.height.notSet())
				return false;
			
			dragBtn.y			= layout.padding.top + ( data.percentage * (layout.height - dragBtn.layout.outerBounds.height) );
			dragBtn.layout.y	= dragBtn.y.roundFloat();
		}
		return true;
	}
	
	
#if debug
	override public function toString ()	{ return id.value+"( "+direction+" )"; }
#end
}