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
 import primevc.core.dispatcher.Signal1;
 import primevc.core.geom.Box;
 import primevc.core.geom.IntRectangle;
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.traits.IInvalidatable;
 import primevc.core.validators.ValidatingValue;
 import primevc.core.validators.IntRangeValidator;
 import primevc.core.traits.IDisposable;
 import primevc.gui.states.ValidateStates;


typedef SizeType = ValidatingValue < Int >;


/**
 * ILayoutClient is the most basic layouttype there is. It contains the size
 * and position of the layout-target.
 * 
 * @since	mar 19, 2010
 * @author	Ruben Weijers
 */
interface ILayoutClient 
		implements IInvalidatable
	,	implements IDisposable
{
	/**
	 * Flag indicating if the layout should be automaticly revalidated when a 
	 * property, such as height or width, is changed.
	 * 
	 * If the property is false, the target of the layout should call the 
	 * validate method before the layout is validated again. This could happen
	 * for example after an enterFrame event.
	 * 
	 * @default false
	 */
	public var validateOnPropertyChange										: Bool;
	
	/**
	 * Flags of properties that are changed
	 */
	public var changes				(default, null)							: Int;
	/**
	 * Flags with all the properties that are set for the layoutclient
	 */
	public var filledProperties		(default, null)							: Int;
	
	
	/**
	 * Flag indicating if this client should be included within the layout
	 * @default	true
	 */
	public var includeInLayout				(default, setIncludeInLayout)	: Bool;
	
	/**
	 * Layout-group to which this client belongs. By setting this property,
	 * the client can let the parent know when it's size or position has
	 * changed wich could result in revalidating the parents layout.
	 */
	public var parent						(default, setParent)			: ILayoutContainer;
	
	public var isValidating					(getIsValidating, never)		: Bool;
	public var isInvalidated				(getIsInvalidated, never)		: Bool;
	
	
	//
	// LAYOUT METHODS
	//

	/**
	 * Validate is called before the layout is validated. In validate, each 
	 * layout-object has a change to correct it's bounding-properties
	 * or measured size.
	 * 
	 * Validate is called when a layoutClient is invalidated and the movie
	 * has entered a new frame.
	 */
	public function validate ()					: Void;
	public function validateHorizontal ()		: Void;
	public function validateVertical ()			: Void;
	/**
	 * Method is called when a layout has run validate and is done with changing 
	 * it's properties.
	 */
	public function validated ()				: Void;
	/**
	 * This method is called when a property of a layoutclient is changed which
	 * would cause the layout the validate again.
	 */
	public function invalidate ( change:Int )	: Void;
	
	/**
	 * Method will return the x coordinate that a DisplayObject can use
	 * to positionate itself. The method will check if the clients parent is a
	 * VirtualLayoutContainer. If that's true, it will at the parent's position
	 * to the returned x coordinate.
	 * 
	 * This method will not affect the x property of the client itself.
	 * 
	 * @see primevc.gui.layout.VirtualLayoutContainer
	 */
	public function getHorPosition ()			: Int;
	/**
	 * Method will return the y coordinate that a DisplayObject can use
	 * to positionate itself. The method will check if the clients parent is a
	 * VirtualLayoutContainer. If that's true, it will at the parent's position
	 * to the returned y coordinates.
	 * 
	 * This method will not affect the y property of the client itself.
	 * 
	 * @see primevc.gui.layout.VirtualLayoutContainer
	 */
	public function getVerPosition ()			: Int;
	
	private function resetProperties ()			: Void;
	
	
	//
	// CONSTRAINT PROPERTIES
	//
	
	
	/**
	 * rules for sizing / positioning the layout with relation to the parent
	 */
	public var relative				(default, setRelative)				: RelativeLayout;
	
	/**
	 * @default	false
	 */
	public var maintainAspectRatio	(default, setAspectRatio)			: Bool;
	private var aspectRatio			(default, default)					: Float;
	
	
	//
	// EVENTS
	//
	
	public var changed				(default, null)						: Signal1<Int>;
	
	public var state				(default, null)						: SimpleStateMachine < ValidateStates >;
	public var hasValidatedWidth	(default, null)						: Bool;
	public var hasValidatedHeight	(default, null)						: Bool;
	
	
	
	//
	// SIZE PROPERTIES
	//
	
	/**
	 * Width of the LayoutClient. Changing the width will also change the width
	 * property in 'bounds'.
	 */
	public var width				(default, null)						: SizeType;
	/**
	 * Width of the LayoutClient. Changing the width will also change the height
	 * property in 'bounds'.
	 */
	public var height				(default, null)						: SizeType;
	
	/**
	 * If percent width is set, the width of the layoutclient will be 
	 * calculated by the width of the parent layoutContainer. This property
	 * also allow an object to fill up the available space by setting the 
	 * property to LayoutFlags.FILL.
	 * 
	 * The width of the percentWidth will be calculated when the layoutclient
	 * is measured.
	 * 
	 * @default		0
	 */
	public var percentWidth			(default, setPercentWidth)			: Float;
	/**
	 * If percent height is set, the height of the layoutclient will be 
	 * calculated by the height of the parent layoutContainer. This property
	 * also allow an object to fill up the available space by setting the 
	 * property to LayoutFlags.FILL.
	 * 
	 * The height of the percentHeight will be calculated when the layoutclient
	 * is measured.
	 * 
	 * @default		0
	 */
	public var percentHeight		(default, setPercentHeight)			: Float;
	
	/**
	 * Padding is the distance between the content of the layout and the rest
	 * of the elements. 
	 * 
	 * The property contains 4 values to define the padding for each side of 
	 * the layout.
	 * 
	 * The x and y properties contain the position of the content, the properties
	 * bottom and right contain the position including the padding.
	 * 
	 * For example.
	 * Layout:
	 * 		- width:	400
	 * 		- height:	300
	 * 		- x:		50
	 * 		- y			60
	 * 		- padding	{ 10, 10, 10, 10 }
	 * 
	 * The left, right, top and bottom properties of the bounds should then be:
	 * 		- left:		50
	 * 		- top:		60
	 * 		- right:	470 (400 + 50 + 20)
	 * 		- bottom:	380 (300 + 60 + 20)
	 */
	public var padding	(default, setPadding)	: Box;
	public var margin	(default, setMargin)	: Box;
	
	
	//
	// POSITION PROPERTIES
	//
	
	public var x		(default, setX)			: Int;
	public var y		(default, setY)			: Int;
	
	/**
	 * Size of the layouclient including the padding but without the margin
	 */
	public var innerBounds	(default, null)		: IntRectangle;
	/**
	 * Size of the layouclient including the padding and margin
	 */
	public var outerBounds	(default, null)		: IntRectangle;
	
	
#if debug
	public var name:String;
#end
}