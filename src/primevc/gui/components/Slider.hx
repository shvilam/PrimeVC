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
 import primevc.core.geom.space.Direction;
 import primevc.core.validators.FloatRangeValidator;
 import primevc.core.Bindable;
 import primevc.gui.behaviours.UpdateMaskBehaviour;
 import primevc.gui.components.DragButton;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.core.UIGraphic;
 import primevc.gui.display.VectorShape;
 import primevc.gui.events.MouseEvents;
  using primevc.gui.utils.UIElementActions;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberMath;
  using primevc.utils.NumberUtil;
  using Std;


private typedef DataType = Bindable<Float>;


/**
 * Slider component
 * 
 * @author Ruben Weijers
 * @creation-date Nov 05, 2010
 */
class Slider extends UIDataContainer < DataType >
{
	public static inline var PERCENTAGE : Int = 32768;
	
	/**
	 * Defines if the slider is horizontal or vertical
	 * @default		horizontal
	 */
	public var direction	(default, setDirection)		: Direction;
	
	/**
	 * Constraint defining the minimal and maximum value
	 * @default		0 - 1
	 */
	public var validator	(default, null)				: FloatRangeValidator;
	
	/**
	 * Percentage indicating the value on a scale of 0 - 1
	 */
	public var percentage	(default, setPercentage)	: Float;
	
	private var mouseMoveBinding		: Wire < Dynamic >;
	private var mouseDownBinding		: Wire < Dynamic >;
	private var mouseUpBinding			: Wire < Dynamic >;
	private var dataChangeBinding		: Wire < Dynamic >;
	
	
	public function new (id:String = null, ?value:Float, minValue:Float = 0, maxValue:Float = 1, direction:Direction = null)
	{
		super(id, new DataType(value));
		this.direction	= direction == null ? horizontal : direction;
		validator		= new FloatRangeValidator( minValue, maxValue );
	}
	
	
	override public function dispose ()
	{
		if (validator != null)
		{
			validator.dispose();
			validator = null;
		}
		
		if (dataChangeBinding != null)		dataChangeBinding.dispose();
		if (mouseMoveBinding != null)		mouseMoveBinding.dispose();
		if (mouseUpBinding != null)			mouseUpBinding.dispose();
		if (mouseDownBinding != null)		mouseDownBinding.dispose();
		
		dataChangeBinding = mouseDownBinding = mouseDownBinding = mouseDownBinding = null;
		
		direction = null;
		super.dispose();
	}
	
	
	override private function init ()
	{
		super.init();
		
		behaviours.add( new UpdateMaskBehaviour( maskShape, this ) );
		
		mouseMoveBinding	= calculateValue	.on( window.mouse.events.move, this );
		mouseDownBinding	= enableMoveWires	.on( userEvents.mouse.down, this );
	//	mouseUpBinding		= disableMouseWires	.on( userEvents.mouse.up, this );
		mouseUpBinding		= disableMoveWires	.on( window.mouse.events.up, this );
		
		mouseMoveBinding.disable();
		mouseUpBinding.disable();
	}
	
	
	override private function initData ()
	{
		calculatePercentage();
		updateChildren();
		validateData.on( validator.change, this );
		dataChangeBinding = calculatePercentage.on( data.change, this );
	}
	
	
	override private function removeData ()
	{
		if (dataChangeBinding != null)
			dataChangeBinding.dispose();
	}
	
	
	override public function validate ()
	{
		if (changes.has(PERCENTAGE))
			updateChildren();

		super.validate();
	}
	
	
	
	//
	// CHILDREN
	//
	
	/**
	 * Shape that is used to fill the part of the slider that is slided
	 */
	private var background	: UIGraphic;
	private var dragBtn		: DragButton;
	private var maskShape	: VectorShape;
	
	
	override private function createChildren ()
	{
		maskShape	= new VectorShape();
		background	= new UIGraphic();
		dragBtn		= new DragButton();
		
#if debug
		dragBtn.id.value	= id.value + "DragBtn";
		background.id.value	= id.value + "Background";
#end
		
		layoutContainer.children.add( background.layout );
		layoutContainer.children.add( dragBtn.layout );
		children.add( background );
		children.add( dragBtn );
		children.add( maskShape );

		background.mask = maskShape;
	}
	
	
	
	//
	// PROPERTIES
	//
	
	private inline function setDirection (v)
	{
		if (direction != v)
		{
			if (direction != null)
				styleClasses.remove( direction.string()+"Slider" );
			
			direction = v;
			
			if (v != null)
				styleClasses.add( direction.string()+"Slider" );
		}
		return v;
	}
	
	
	private inline function setPercentage (v:Float)
	{
		if (percentage != v)
		{
			Assert.that( v <= 1 );
			Assert.that( v >= 0 );
			percentage = v;
			
			invalidate(PERCENTAGE);
		}
		return v;
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function enableMoveWires (mouseObj:MouseState)
	{
		mouseDownBinding.disable();
		mouseUpBinding.enable();
		mouseMoveBinding.enable();
		
		calculateValue( mouseObj );
		dragBtn.mouseEnabled				= false;
		dragBtn.layout.includeInLayout		= false;
	}
	
	
	private function disableMoveWires (mouseObj:MouseState)
	{
		mouseDownBinding.enable();
		mouseUpBinding.disable();
		mouseMoveBinding.disable();
		
		calculateValue( mouseObj );
		dragBtn.mouseEnabled				= true;
		dragBtn.layout.includeInLayout		= true;
	}
	
	
	private function calculatePercentage ()
	{
		validateData();
		percentage = ( data.value - validator.min ) / (validator.getDiff());
	}
	
	
	/**
	 * Method is called after the position of the dragButton is changed or
	 * when the user clicked somewhere in the background
	 */
	private function calculateValue (mouseObj:MouseState)
	{
		var mousePos = mouseObj.local;
		if (mouseObj.target != this)
			mousePos = globalToLocal(mouseObj.stage);
		
		var newPercentage = (direction == horizontal)
								? ((mousePos.x - layout.padding.left) / layout.width.value).within(0, 1)
								: 1 - ((mousePos.y - layout.padding.top) / layout.height.value).within(0, 1);
		
		var newValue = validator.min + (newPercentage * (validator.max - validator.min));
		
	//	trace(this+".calculateValue "+percentage + " => " + newPercentage+"% v: "+data.value+"; -> "+newValue+"; "+mouseObj.target);
		
		//set the newvalue
		dataChangeBinding.disable();
		data.value	= validator.validate( newValue );
		percentage	= newPercentage;
		dataChangeBinding.enable();
	}
	
	
	/**
	 * Method is called when a property of the constraint changes. This method
	 * will make sure the current value of the slider is within the boundaries
	 * of the constraint.
	 */
	private inline function validateData ()
	{
		Assert.that( validator.min.isSet() );
		Assert.that( validator.max.isSet() );
		data.value = validator.validate( data.value );
	}
	
	
	private function updateChildren ()
	{
		if (direction == horizontal)
		{
			dragBtn.x			= layout.padding.left + ( percentage * ( layout.width.value - dragBtn.layout.outerBounds.width ) );
			dragBtn.layout.x	= dragBtn.x.roundFloat();
			background.layout.percentWidth = percentage;
		}
		else
		{
			dragBtn.y			= layout.padding.top + ( (1 - percentage) * (layout.height.value - dragBtn.layout.outerBounds.height) );
			dragBtn.layout.y	= dragBtn.y.roundFloat();
			background.layout.percentHeight = percentage;
		}
	}
}