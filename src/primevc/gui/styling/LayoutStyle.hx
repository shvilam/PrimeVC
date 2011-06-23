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
package primevc.gui.styling;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.core.geom.Box;
 import primevc.core.traits.IInvalidatable;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.RelativeLayout;
 import primevc.types.Factory;
 import primevc.types.Number;
 import primevc.utils.NumberUtil;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;


private typedef Flags		= LayoutStyleFlags;
private typedef Algorithm	= Factory<ILayoutAlgorithm>;


/**
 * Class to hold all styling properties for the layout
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class LayoutStyle extends StyleSubBlock
{
	private var extendedStyle			: LayoutStyle;
	private var superStyle				: LayoutStyle;
//	private var parentStyle				: LayoutStyle;

	private var _relative				: RelativeLayout;
	private var _algorithm				: Algorithm;
	private var _padding				: Box;
	private var _margin					: Box;
	
	private var _width					: Int;
	private var _minWidth				: Int;
	private var _maxWidth				: Int;
	private var _percentWidth			: Float;
	private var _percentMinWidth		: Float;
	private var _percentMaxWidth		: Float;
	
	private var _height					: Int;
	private var _minHeight				: Int;
	private var _maxHeight				: Int;
	private var _percentHeight			: Float;
	private var _percentMinHeight		: Float;
	private var _percentMaxHeight		: Float;
	
	private var _childWidth				: Int;
	private var _childHeight			: Int;	
	private var _rotation				: Float;
	private var _maintainAspectRatio	: Null < Bool >;
	private var _includeInLayout		: Null < Bool >;
	
	
	public var relative				(getRelative,			setRelative)		: RelativeLayout;
	public var algorithm			(getAlgorithm,			setAlgorithm)		: Algorithm;
	public var padding				(getPadding,			setPadding)			: Box;
	public var margin				(getMargin,				setMargin)			: Box;
	
	public var width				(getWidth,				setWidth)			: Int;
	public var maxWidth				(getMaxWidth,			setMaxWidth)		: Int;
	public var minWidth				(getMinWidth,			setMinWidth)		: Int;
	public var percentMinWidth		(getPercentMinWidth,	setPercentMinWidth)	: Float;
	public var percentMaxWidth		(getPercentMaxWidth,	setPercentMaxWidth)	: Float;
	public var percentWidth			(getPercentWidth,		setPercentWidth)	: Float;
	
	public var height				(getHeight,				setHeight)			: Int;
	public var maxHeight			(getMaxHeight,			setMaxHeight)		: Int;
	public var minHeight			(getMinHeight,			setMinHeight)		: Int;
	public var percentMinHeight		(getPercentMinHeight,	setPercentMinHeight): Float;
	public var percentMaxHeight		(getPercentMaxHeight,	setPercentMaxHeight): Float;
	public var percentHeight		(getPercentHeight,		setPercentHeight)	: Float;
	
	public var childWidth			(getChildWidth,			setChildWidth)		: Int;
	public var childHeight			(getChildHeight,		setChildHeight)		: Int;
	
	public var rotation				(getRotation,			setRotation)		: Float;
	public var maintainAspectRatio	(getMaintainAspect,		setMaintainAspect)	: Null< Bool >;
	
	public var includeInLayout		(getIncludeInLayout,	setIncludeInLayout)	: Null< Bool >;
	
	
	public function new (
		filledProps:Int				= 0,
		rel:RelativeLayout			= null,
		padding:Box					= null,
		margin:Box					= null,
		alg:Algorithm				= null,
		percentW:Float				= Number.INT_NOT_SET,
		percentH:Float				= Number.INT_NOT_SET,
		width:Int					= Number.INT_NOT_SET,
		height:Int					= Number.INT_NOT_SET,
		childWidth:Int				= Number.INT_NOT_SET,
		childHeight:Int				= Number.INT_NOT_SET,
		rotation:Float				= Number.INT_NOT_SET,
		include:Null<Bool>			= null,
		maintainAspect:Null<Bool> 	= null,
		
		minWidth:Int				= Number.INT_NOT_SET,
		maxWidth:Int				= Number.INT_NOT_SET,
		minHeight:Int				= Number.INT_NOT_SET,
		maxHeight:Int				= Number.INT_NOT_SET,
		
		percentMinWidth:Float		= Number.INT_NOT_SET,
		percentMaxWidth:Float		= Number.INT_NOT_SET,
		percentMinHeight:Float		= Number.INT_NOT_SET,
		percentMaxHeight:Float		= Number.INT_NOT_SET
	)
	{
		super(filledProps);
		#if flash9 this._relative				#else this.relative				#end = rel;
		#if flash9 this._algorithm				#else this.algorithm			#end = alg;
		#if flash9 this._padding				#else this.padding				#end = padding;
		#if flash9 this._margin					#else this.margin				#end = margin;

		#if flash9 this._percentWidth			#else this.percentWidth			#end = percentW == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentW;
		#if flash9 this._percentHeight			#else this.percentHeight		#end = percentH == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentH;

		#if flash9 this._width					#else this.width				#end = width;
		#if flash9 this._height					#else this.height				#end = height;

		#if flash9 this._childWidth				#else this.childWidth			#end = childWidth;
		#if flash9 this._childHeight			#else this.childHeight			#end = childHeight;
		#if flash9 this._rotation				#else this.rotation				#end = rotation == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : rotation;

		#if flash9 this._maintainAspectRatio	#else this.maintainAspectRatio	#end = maintainAspect;
		#if flash9 this._includeInLayout		#else this.includeInLayout		#end = include;

		#if flash9 this._minWidth				#else this.minWidth				#end = minWidth;
		#if flash9 this._minHeight				#else this.minHeight			#end = minHeight;
		#if flash9 this._maxWidth				#else this.maxWidth				#end = maxWidth;
		#if flash9 this._maxHeight				#else this.maxHeight			#end = maxHeight;

		#if flash9 this._percentMinWidth		#else this.percentMinWidth		#end = percentMinWidth  == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentMinWidth;
		#if flash9 this._percentMaxWidth		#else this.percentMaxWidth		#end = percentMaxWidth  == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentMaxWidth;
		#if flash9 this._percentMinHeight		#else this.percentMinHeight		#end = percentMinHeight == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentMinHeight;
		#if flash9 this._percentMaxHeight		#else this.percentMaxHeight		#end = percentMaxHeight == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentMaxHeight;
	}
	
	
	override public function dispose ()
	{
		if (_relative != null)		_relative.dispose();
	//	if (_algorithm != null)		_algorithm.dispose();
		
		_maintainAspectRatio	= null;
		_includeInLayout		= null;
		_relative				= null;
		_algorithm				= null;
		_padding				= null;
		_margin					= null;
		_percentWidth			= Number.FLOAT_NOT_SET;
		_percentHeight			= Number.FLOAT_NOT_SET;
		_width					= Number.INT_NOT_SET;
		_height					= Number.INT_NOT_SET;
		_childWidth				= Number.INT_NOT_SET;
		_childHeight			= Number.INT_NOT_SET;
		_rotation				= Number.FLOAT_NOT_SET;
		
		_minWidth				= Number.INT_NOT_SET;
		_minHeight				= Number.INT_NOT_SET;
		_maxWidth				= Number.INT_NOT_SET;
		_maxHeight				= Number.INT_NOT_SET;
		
		_percentMinWidth		= Number.FLOAT_NOT_SET;
		_percentMaxWidth		= Number.FLOAT_NOT_SET;
		_percentMinHeight		= Number.FLOAT_NOT_SET;
		_percentMaxHeight		= Number.FLOAT_NOT_SET;
		
		super.dispose();
	}
	
	
	override private function updateOwnerReferences (changedReference:Int) : Void
	{
		if (changedReference.has( StyleFlags.EXTENDED_STYLE ))
		{
			if (extendedStyle != null)
				extendedStyle.listeners.remove( this );
			
			extendedStyle = null;
			if (owner != null && owner.extendedStyle != null)
			{
				extendedStyle = owner.extendedStyle.layout;
				
				if (extendedStyle != null)
					extendedStyle.listeners.add( this );
			}
		}
		
		
		if (changedReference.has( StyleFlags.SUPER_STYLE ))
		{
			if (superStyle != null)
				superStyle.listeners.remove( this );
			
			superStyle = null;
			if (owner != null && owner.superStyle != null)
			{
				superStyle = owner.superStyle.layout;
				
				if (superStyle != null)
					superStyle.listeners.add( this );
			}
		}
		
		
	/*	if (changedReference.has( StyleFlags.PARENT_STYLE ))
		{
			if (parentStyle != null && parentStyle.listeners != null)
				parentStyle.listeners.remove( this );
			
			parentStyle = null;
			if (owner != null && owner.parentStyle != null)
			{
				parentStyle = owner.parentStyle.layout;
				
				if (parentStyle != null)
					parentStyle.listeners.add( this );
			}
		}*/
	}
	
	
	override public function updateAllFilledPropertiesFlag ()
	{
		inheritedProperties = 0;
		if (extendedStyle != null)	inheritedProperties  = extendedStyle.allFilledProperties;
		if (superStyle != null)		inheritedProperties |= superStyle.allFilledProperties;
		
		allFilledProperties = filledProperties | inheritedProperties;
		inheritedProperties	= inheritedProperties.unset( filledProperties );
	}
	
	
	override public function getPropertiesWithout (noExtendedStyle:Bool, noSuperStyle:Bool)
	{
		var props = filledProperties;
		if (!noExtendedStyle && extendedStyle != null)	props |= extendedStyle.allFilledProperties;
		if (!noSuperStyle && superStyle != null)		props |= superStyle.allFilledProperties;
		return props;
	}
	
	
	/**
	 * Method is called when a property in the super- or extended-style is 
	 * changed. If the property is not set in this style-object, it means that 
	 * the allFilledPropertiesFlag needs to be changed..
	 */
	override public function invalidateCall ( changeFromOther:Int, sender:IInvalidatable ) : Void
	{
		Assert.that(sender != null);
		
		if (sender == owner)
			return super.invalidateCall( changeFromOther, sender );
		
		if (filledProperties.has( changeFromOther ))
			return;
		
		//The changed property is not in this style-object.
		//Check if the change should be broadcasted..
		var propIsInExtended	= extendedStyle != null	&& extendedStyle.allFilledProperties.has( changeFromOther );
		var propIsInSuper		= superStyle != null	&& superStyle	.allFilledProperties.has( changeFromOther );
	//	var propIsInParent		= parentStyle != null	&& parentStyle	.allFilledProperties.has( changeFromOther );
		
		if (sender == extendedStyle)
		{
			if (propIsInExtended)	allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the super style and the extended-style doesn't have the property that is changed, broadcast the change as well
		else if (sender == superStyle && !propIsInExtended)
		{
			if (propIsInSuper)		allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}
		
		//if the sender is the parent style and the other styles doesn't have the property that is changed, broadcast the change as well
	/*	else if (sender == parentStyle && !propIsInExtended && !propIsInSuper)
		{
			if (propIsInParent)		allFilledProperties = allFilledProperties.set( changeFromOther );
			else					allFilledProperties = allFilledProperties.unset( changeFromOther );
			
			invalidate( changeFromOther );
		}*/
		
		return;
	}
	
	
	
	
	//
	// GETTERS
	//
	
	
	private function getRelative ()
	{
		var v = _relative;
		if (v == null && extendedStyle != null)		v = extendedStyle.relative;
		if (v == null && superStyle != null)		v = superStyle.relative;
	//	if (v == null && parentStyle != null)		v = parentStyle.relative;
		return v;
	}
	
	
	private function getAlgorithm ()
	{
		var v = _algorithm;
		if (v == null && extendedStyle != null)		v = extendedStyle.algorithm;
		if (v == null && superStyle != null)		v = superStyle.algorithm;
	//	if (v == null && parentStyle != null)		v = parentStyle.algorithm;
		return v;
	}
	
	
	private function getPadding ()
	{
		var v = _padding;
		if (v == null && extendedStyle != null)		v = extendedStyle.padding;
		if (v == null && superStyle != null)		v = superStyle.padding;
	//	if (v == null && parentStyle != null)		v = parentStyle.padding;
		return v;
	}
	
	
	private function getMargin ()
	{
		var v = _margin;
		if (v == null && extendedStyle != null)		v = extendedStyle.margin;
		if (v == null && superStyle != null)		v = superStyle.margin;
	//	if (v == null && parentStyle != null)		v = parentStyle.margin;
		return v;
	}
	
	
	private function getWidth ()
	{
		var v = _width;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.width;
		if (v.notSet() && superStyle != null)		v = superStyle.width;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.width;
		return v;
	}
	
	
	private function getMaxWidth ()
	{
		var v = _maxWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.maxWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.maxWidth;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.maxWidth;
		return v;
	}
	
	
	private function getMinWidth ()
	{
		var v = _minWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.minWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.minWidth;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.minWidth;
		return v;
	}
	
	
	private function getPercentWidth ()
	{
		var v = _percentWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.percentWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.percentWidth;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.percentWidth;
		return v;
	}
	
	
	private function getHeight ()
	{
		var v = _height;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.height;
		if (v.notSet() && superStyle != null)		v = superStyle.height;
	//	if (v.notSet() && superStyle != null)		v = parentStyle.height;
		return v;
	}
	
	
	private function getMaxHeight ()
	{
		var v = _maxHeight;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.maxHeight;
		if (v.notSet() && superStyle != null)		v = superStyle.maxHeight;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.maxHeight;
		return v;
	}
	
	
	private function getMinHeight ()
	{
		var v = _minHeight;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.minHeight;
		if (v.notSet() && superStyle != null)		v = superStyle.minHeight;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.minHeight;
		return v;
	}
	
	
	private function getPercentHeight ()
	{
		var v = _percentHeight;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.percentHeight;
		if (v.notSet() && superStyle != null)		v = superStyle.percentHeight;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.percentHeight;
		return v;
	}
	
	
	private function getChildWidth ()
	{
		var v = _childWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.childWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.childWidth;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.childWidth;
		return v;
	}
	
	
	private function getChildHeight ()
	{
		var v = _childHeight;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.childHeight;
		if (v.notSet() && superStyle != null)		v = superStyle.childHeight;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.childHeight;
		return v;
	}
	
	
	private function getRotation ()
	{
		var v = _rotation;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.rotation;
		if (v.notSet() && superStyle != null)		v = superStyle.rotation;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.rotation;
		return v;
	}


	private function getIncludeInLayout ()
	{
		var v = _includeInLayout;
		if (v == null && extendedStyle != null)		v = extendedStyle.includeInLayout;
		if (v == null && superStyle != null)		v = superStyle.includeInLayout;
	//	if (v == null && parentStyle != null)		v = parentStyle.includeInLayout;
		return v;
	}
	
	
	private function getMaintainAspect ()
	{
		var v = _maintainAspectRatio;
		if (v == null && extendedStyle != null)		v = extendedStyle.maintainAspectRatio;
		if (v == null && superStyle != null)		v = superStyle.maintainAspectRatio;
	//	if (v == null && parentStyle != null)		v = parentStyle.maintainAspectRatio;
		return v;
	}
	
	
	private function getPercentMinWidth ()
	{
		var v = _percentMinWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.percentMinWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.percentMinWidth;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.percentMinWidth;
		return v;
	}
	
	
	private function getPercentMaxWidth ()
	{
		var v = _percentMaxWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.percentMaxWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.percentMaxWidth;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.percentMaxWidth;
		return v;
	}
	
	
	private function getPercentMinHeight ()
	{
		var v = _percentMinHeight;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.percentMinHeight;
		if (v.notSet() && superStyle != null)		v = superStyle.percentMinHeight;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.percentMinHeight;
		return v;
	}
	
	
	private function getPercentMaxHeight ()
	{
		var v = _percentMaxHeight;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.percentMaxHeight;
		if (v.notSet() && superStyle != null)		v = superStyle.percentMaxHeight;
	//	if (v.notSet() && parentStyle != null)		v = parentStyle.percentMaxHeight;
		return v;
	}
	
	
	
	
	//
	// SETTERS
	//
	
	
	private function setRelative (v)
	{
		if (v != _relative) {
			_relative = v;
			markProperty( Flags.RELATIVE, v != null );
		}
		return v;
	}
	
	
	private function setAlgorithm (v)
	{
		if (v != _algorithm) {
			_algorithm = v;
			markProperty( Flags.ALGORITHM, v != null );
		}
		return v;
	}
	
	
	private function setPadding (v)
	{
		if (v != _padding) {
			_padding = v;
			markProperty( Flags.PADDING, v != null );
		}
		return v;
	}
	
	
	private function setMargin (v)
	{
		if (v != _margin) {
			_margin = v;
			markProperty( Flags.MARGIN, v != null );
		}
		return v;
	}
	
	
	private function setWidth (v)
	{
		if (v != _width) {
			_width = v;
			markProperty( Flags.WIDTH, v.isSet() );
		}
		return v;
	}
	
	
	private function setMaxWidth (v)
	{
		if (v != _maxWidth) {
			_maxWidth = v;
			markProperty( Flags.MAX_WIDTH, v.isSet() );
		}
		return v;
	}
	
	
	private function setMinWidth (v)
	{
		if (v != _minWidth) {
			_minWidth = v;
			markProperty( Flags.MIN_WIDTH, v.isSet() );
		}
		return v;
	}
	
	
	private function setPercentWidth (v)
	{
		if (v != _percentWidth) {
			_percentWidth = v;
			markProperty( Flags.PERCENT_WIDTH, v.isSet() );
		}
		return v;
	}
	
	
	private function setHeight (v)
	{
		if (v != _height) {
			_height = v;
			markProperty( Flags.HEIGHT, v.isSet() );
		}
		return v;
	}
	
	
	private function setMaxHeight (v)
	{
		if (v != _maxHeight) {
			_maxHeight = v;
			markProperty( Flags.MAX_HEIGHT, v.isSet() );
		}
		return v;
	}
	
	
	private function setMinHeight (v)
	{
		if (v != _minHeight) {
			_minHeight = v;
			markProperty( Flags.MIN_HEIGHT, v.isSet() );
		}
		return v;
	}
	
	
	private function setPercentHeight (v)
	{
		if (v != _percentHeight) {
			_percentHeight = v;
			markProperty( Flags.PERCENT_HEIGHT, v.isSet() );
		}
		return v;
	}
	
	private function setChildWidth (v)
	{
		if (v != _childWidth) {
			_childWidth = v;
			markProperty( Flags.CHILD_WIDTH, v.isSet() );
		}
		return v;
	}
	
	
	private function setChildHeight (v)
	{
		if (v != _childHeight) {
			_childHeight = v;
			markProperty( Flags.CHILD_HEIGHT, v.isSet() );
		}
		return v;
	}
	
	
	private function setRotation (v)
	{
		if (v != _rotation) {
			_rotation = v;
			markProperty( Flags.ROTATION, v.isSet() );
		}
		return v;
	}


	private function setIncludeInLayout (v)
	{
		if (v != _includeInLayout) {
			_includeInLayout = v;
			markProperty( Flags.INCLUDE, v != null );
		}
		return v;
	}
	
	
	private function setMaintainAspect (v)
	{
		if (v != _maintainAspectRatio) {
			_maintainAspectRatio = v;
			markProperty( Flags.MAINTAIN_ASPECT, v != null );
		}
		return v;
	}
	
	
	private function setPercentMaxHeight (v)
	{
		if (v != _percentMaxHeight) {
			_percentMaxHeight = v;
			markProperty( Flags.PERCENT_MAX_HEIGHT, v.isSet() );
		}
		return v;
	}
	
	
	private function setPercentMinHeight (v)
	{
		if (v != _percentMinHeight) {
			_percentMinHeight = v;
			markProperty( Flags.PERCENT_MIN_HEIGHT, v.isSet() );
		}
		return v;
	}
	
	
	private function setPercentMaxWidth (v)
	{
		if (v != _percentMaxWidth) {
			_percentMaxWidth = v;
			markProperty( Flags.PERCENT_MAX_WIDTH, v.isSet() );
		}
		return v;
	}
	
	
	private function setPercentMinWidth (v)
	{
		if (v != _percentMinWidth) {
			_percentMinWidth = v;
			markProperty( Flags.PERCENT_MIN_WIDTH, v.isSet() );
		}
		return v;
	}
	
	
#if neko
	override public function toCSS (prefix:String = "") : String
	{
		var css = [];
		
		if (_padding != null)					css.push("padding: " + _padding.toCSS());
		if (_margin != null)					css.push("margin: " + _margin.toCSS());
	//	if (_algorithm != null)					css.push("algorithm: " + _algorithm.toCSS());
		if (_relative != null)					css.push("relative: " + _relative.toCSS());
		
		if (_width.isSet())						css.push("width: " + _width + "px");
		if (_percentWidth.isSet()) {
			if (_percentWidth == Flags.FILL)	css.push("width: auto");
			else								css.push("width: " + (_percentWidth * 100) + "%");
		}
		if (_minWidth.isSet())					css.push("min-width: " + _minWidth + "px");
		if (_maxWidth.isSet())					css.push("max-width: " + _maxWidth + "px");
		
		if (_percentMinWidth.isSet())			css.push("percent-min-width: " + (_percentMinWidth * 100) + "%");
		if (_percentMaxWidth.isSet())			css.push("percent-max-width: " + (_percentMaxWidth * 100) + "%");
		
		if (_height.isSet())					css.push("height: " + _height + "px");
		if (_percentHeight.isSet()) {
			if (_percentHeight == Flags.FILL)	css.push("height: auto");
			else								css.push("hieght: " + (_percentHeight * 100) + "%");
		}
		if (_minHeight.isSet())					css.push("min-height: " + _minHeight + "px");
		if (_maxHeight.isSet())					css.push("max-height: " + _maxHeight + "px");
		
		if (_percentMinHeight.isSet())			css.push("percent-min-height: " + (_percentMinHeight * 100) + "%");
		if (_percentMaxHeight.isSet())			css.push("percent-max-height: " + (_percentMaxHeight * 100) + "%");
		
		if (_childWidth.isSet())				css.push("child-width: " + _childWidth + "px");
		if (_childHeight.isSet())				css.push("child-height: " + _childHeight + "px");
		
		if (_rotation.isSet())					css.push("rotation: " + _rotation + "degr");
		if (_includeInLayout != null)			css.push("position: " + (_maintainAspectRatio ? "relative" : "absolute"));
		if (_maintainAspectRatio != null)		css.push("maintainAspectRatio: " + (_maintainAspectRatio ? "true" : "false"));
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
	
	
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
		{
			code.construct( this, [
				filledProperties, 
				_relative, _padding, _margin, _algorithm,
				_percentWidth, _percentHeight,
				_width, _height,
				_childWidth, _childHeight,
				_rotation, _includeInLayout, _maintainAspectRatio,
				_minWidth, _maxWidth, _minHeight, _maxHeight,
				_percentMinWidth, _percentMaxWidth, _percentMinHeight, _percentMaxHeight
			] );
			
		/*	if (_minWidth.isSet())		code.setProp( this, "minWidth", minWidth );
			if (_minHeight.isSet())		code.setProp( this, "minHeight", minHeight );
			if (_maxWidth.isSet())		code.setProp( this, "maxWidth", maxWidth );
			if (_maxHeight.isSet())		code.setProp( this, "maxHeight", maxHeight );*/
		}
	}
	
	
	override public function cleanUp ()
	{
		if (_relative != null)
		{
			_relative.cleanUp();
			if (_relative.isEmpty()) {
				_relative.dispose();
				relative = null;
			}
		}
		
		if (_padding != null)
		{
			_padding.cleanUp();
			if (_padding.isEmpty())
				padding = null;
		}
		
		if (_margin != null)
		{
			_margin.cleanUp();
			if (_margin.isEmpty())
				margin = null;
		}
		
		if (_algorithm != null)
		{
			_algorithm.cleanUp();
			if (_algorithm.isEmpty()) {
				_algorithm.dispose();
				algorithm = null;
			}
		}
	}
#end

#if debug
	override public function readProperties (flags:Int = -1) : String
	{
		if (flags == -1)
			flags = filledProperties;
		
		return Flags.readProperties(flags);
	}
#end
}