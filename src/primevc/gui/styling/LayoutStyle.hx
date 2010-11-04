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
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.RelativeLayout;
 import primevc.types.Number;
 import primevc.utils.NumberUtil;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;


private typedef Flags = LayoutFlags;


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

	private var _relative				: RelativeLayout;
	private var _algorithm				: LayoutAlgorithmInfo;
	private var _padding				: Box;
	private var _margin					: Box;
	
	private var _width					: Int;
	private var _minWidth				: Int;
	private var _maxWidth				: Int;
	private var _percentWidth			: Float;
	
	private var _height					: Int;
	private var _minHeight				: Int;
	private var _maxHeight				: Int;
	private var _percentHeight			: Float;
	
	private var _childWidth				: Int;
	private var _childHeight			: Int;	
	private var _rotation				: Float;
	private var _maintainAspectRatio	: Null < Bool >;
	private var _includeInLayout		: Null < Bool >;
	
	
	public var relative				(getRelative,			setRelative)		: RelativeLayout;
	public var algorithm			(getAlgorithm,			setAlgorithm)		: LayoutAlgorithmInfo;
	public var padding				(getPadding,			setPadding)			: Box;
	public var margin				(getMargin,				setMargin)			: Box;
	
	public var width				(getWidth,				setWidth)			: Int;
	public var maxWidth				(getMaxWidth,			setMaxWidth)		: Int;
	public var minWidth				(getMinWidth,			setMinWidth)		: Int;
	public var percentWidth			(getPercentWidth,		setPercentWidth)	: Float;
	
	public var height				(getHeight,				setHeight)			: Int;
	public var maxHeight			(getMaxHeight,			setMaxHeight)		: Int;
	public var minHeight			(getMinHeight,			setMinHeight)		: Int;
	public var percentHeight		(getPercentHeight,		setPercentHeight)	: Float;
	
	public var childWidth			(getChildWidth,			setChildWidth)		: Int;
	public var childHeight			(getChildHeight,		setChildHeight)		: Int;
	
	public var rotation				(getRotation,			setRotation)		: Float;
	public var maintainAspectRatio	(getMaintainAspect,		setMaintainAspect)	: Null< Bool >;
	
	public var includeInLayout		(getIncludeInLayout,	setIncludeInLayout)	: Null< Bool >;
	
	
	public function new (
		rel:RelativeLayout			= null,
		padding:Box					= null,
		margin:Box					= null,
		alg:LayoutAlgorithmInfo		= null,
		percentW:Float				= Number.INT_NOT_SET,
		percentH:Float				= Number.INT_NOT_SET,
		width:Int					= Number.INT_NOT_SET,
		height:Int					= Number.INT_NOT_SET,
		childWidth:Int				= Number.INT_NOT_SET,
		childHeight:Int				= Number.INT_NOT_SET,
		rotation:Float				= Number.INT_NOT_SET,
		include:Null<Bool>			= null,
		maintainAspect:Null<Bool> 	= null
	)
	{
		super();
		this.relative				= rel;
		this.algorithm				= alg;
		this.padding				= padding;
		this.margin					= margin;
		
		this.percentWidth			= percentW == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentW;
		this.percentHeight			= percentH == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentH;
		this.width					= width;
		this.height					= height;
		this.childWidth				= childWidth;
		this.childHeight			= childHeight;
		this.rotation				= rotation == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : rotation;
		
		this.maintainAspectRatio	= maintainAspect;
		this.includeInLayout		= include;
		
		this.minWidth	= Number.INT_NOT_SET;
		this.minHeight	= Number.INT_NOT_SET;
		this.maxWidth	= Number.INT_NOT_SET;
		this.maxHeight	= Number.INT_NOT_SET;
	}
	
	
	override public function dispose ()
	{
		if (_relative != null)		_relative.dispose();
		if (_algorithm != null)		_algorithm.dispose();
		
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
		
		super.dispose();
	}
	
	
	override private function updateOwnerReferences (changedReference:UInt) : Void
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
	}
	
	
	override public function updateAllFilledPropertiesFlag ()
	{
		super.updateAllFilledPropertiesFlag();
		
		if (allFilledProperties < Flags.ALL_PROPERTIES && extendedStyle != null)	allFilledProperties |= extendedStyle.allFilledProperties;
		if (allFilledProperties < Flags.ALL_PROPERTIES && superStyle != null)		allFilledProperties |= superStyle.allFilledProperties;
	}
	
	
	/**
	 * Method is called when a property in the super- or extended-style is 
	 * changed. If the property is not set in this style-object, it means that 
	 * the allFilledPropertiesFlag needs to be changed..
	 */
	override public function invalidateCall ( changeFromOther:UInt, sender:IInvalidatable ) : Void
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
		return v;
	}
	
	
	private function getAlgorithm ()
	{
		var v = _algorithm;
		if (v == null && extendedStyle != null)		v = extendedStyle.algorithm;
		if (v == null && superStyle != null)		v = superStyle.algorithm;
		return v;
	}
	
	
	private function getPadding ()
	{
		var v = _padding;
		if (v == null && extendedStyle != null)		v = extendedStyle.padding;
		if (v == null && superStyle != null)		v = superStyle.padding;
		return v;
	}
	
	
	private function getMargin ()
	{
		var v = _margin;
		if (v == null && extendedStyle != null)		v = extendedStyle.margin;
		if (v == null && superStyle != null)		v = superStyle.margin;
		return v;
	}
	
	
	private function getWidth ()
	{
		var v = _width;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.width;
		if (v.notSet() && superStyle != null)		v = superStyle.width;
		return v;
	}
	
	
	private function getMaxWidth ()
	{
		var v = _maxWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.maxWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.maxWidth;
		return v;
	}
	
	
	private function getMinWidth ()
	{
		var v = _minWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.minWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.minWidth;
		return v;
	}
	
	
	private function getPercentWidth ()
	{
		var v = _percentWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.percentWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.percentWidth;
		return v;
	}
	
	
	private function getHeight ()
	{
		var v = _height;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.height;
		if (v.notSet() && superStyle != null)		v = superStyle.height;
		return v;
	}
	
	
	private function getMaxHeight ()
	{
		var v = _maxHeight;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.maxHeight;
		if (v.notSet() && superStyle != null)		v = superStyle.maxHeight;
		return v;
	}
	
	
	private function getMinHeight ()
	{
		var v = _minHeight;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.minHeight;
		if (v.notSet() && superStyle != null)		v = superStyle.minHeight;
		return v;
	}
	
	
	private function getPercentHeight ()
	{
		var v = _percentHeight;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.percentHeight;
		if (v.notSet() && superStyle != null)		v = superStyle.percentHeight;
		return v;
	}
	
	
	private function getChildWidth ()
	{
		var v = _childWidth;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.childWidth;
		if (v.notSet() && superStyle != null)		v = superStyle.childWidth;
		return v;
	}
	
	
	private function getChildHeight ()
	{
		var v = _childHeight;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.childHeight;
		if (v.notSet() && superStyle != null)		v = superStyle.childHeight;
		return v;
	}
	
	
	private function getRotation ()
	{
		var v = _rotation;
		if (v.notSet() && extendedStyle != null)	v = extendedStyle.rotation;
		if (v.notSet() && superStyle != null)		v = superStyle.rotation;
		return v;
	}


	private function getIncludeInLayout ()
	{
		var v = _includeInLayout;
		if (v == null && extendedStyle != null)		v = extendedStyle.includeInLayout;
		if (v == null && superStyle != null)		v = superStyle.includeInLayout;
		return v;
	}
	
	
	private function getMaintainAspect ()
	{
		var v = _maintainAspectRatio;
		if (v == null && extendedStyle != null)		v = extendedStyle.maintainAspectRatio;
		if (v == null && superStyle != null)		v = superStyle.maintainAspectRatio;
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
		if (v != maxWidth) {
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
	
	
#if (debug || neko)
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
			else								css.push("width: " + _percentWidth + "%");
		}
		if (_minWidth.isSet())					css.push("min-width: " + _minWidth + "px");
		if (_maxWidth.isSet())					css.push("max-width: " + _maxWidth + "px");
		
		if (_height.isSet())					css.push("height: " + _height + "px");
		if (_percentHeight.isSet()) {
			if (_percentHeight == Flags.FILL)	css.push("height: auto");
			else								css.push("hieght: " + _percentHeight + "%");
		}
		if (_minHeight.isSet())					css.push("min-height: " + _minHeight + "px");
		if (_maxHeight.isSet())					css.push("max-height: " + _maxHeight + "px");
		
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
#end


#if neko
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
		{
			code.construct( this, [ _relative, _padding, _margin, _algorithm, _percentWidth, _percentHeight, _width, _height, _childWidth, _childHeight, _rotation, _includeInLayout, _maintainAspectRatio ] );
			
			if (_minWidth.isSet())		code.setProp( this, "minWidth", minWidth );
			if (_minHeight.isSet())		code.setProp( this, "minHeight", minHeight );
			if (_maxWidth.isSet())		code.setProp( this, "maxWidth", maxWidth );
			if (_maxHeight.isSet())		code.setProp( this, "maxHeight", maxHeight );
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