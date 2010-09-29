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
package primevc.gui.styling.declarations;
#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
 import primevc.core.geom.Box;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.RelativeLayout;
 import primevc.types.Number;
 import primevc.utils.NumberUtil;
  using primevc.utils.NumberUtil;



/**
 * Class to hold all styling properties for the layout
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class LayoutStyleDeclarations extends StylePropertyGroup
{
	private var _relative				: RelativeLayout;
	private var _algorithm				: ILayoutAlgorithm;
	private var _padding				: Box;
	
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
	public var algorithm			(getAlgorithm,			setAlgorithm)		: ILayoutAlgorithm;
	public var padding				(getPadding,			setPadding)			: Box;
	
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
		alg:ILayoutAlgorithm		= null,
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
		_relative				= rel;
		_algorithm				= alg;
		_padding				= padding;
		
		_percentWidth			= percentW == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentW;
		_percentHeight			= percentH == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentH;
		_width					= width;
		_height					= height;
		_childWidth				= childWidth;
		_childHeight			= childHeight;
		_rotation				= rotation == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : rotation;
		
		_maintainAspectRatio	= maintainAspect;
		_includeInLayout		= include;
		
		_minWidth	= Number.INT_NOT_SET;
		_minHeight	= Number.INT_NOT_SET;
		_maxWidth	= Number.INT_NOT_SET;
		_maxHeight	= Number.INT_NOT_SET;
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
	
	
	
	//
	// GETTERS
	//
	
	private function getRelative ()
	{
		var v = _relative;
		if (v == null && getExtended() != null)		v = getExtended().layout.relative;
		if (v == null && getSuper() != null)		v = getSuper().layout.relative;
		return v;
	}
	
	
	private function getAlgorithm ()
	{
		var v = _algorithm;
		if (v == null && getExtended() != null)		v = getExtended().layout.algorithm;
		if (v == null && getSuper() != null)		v = getSuper().layout.algorithm;
		return v;
	}
	
	
	private function getPadding ()
	{
		var v = _padding;
		if (v == null && getExtended() != null)		v = getExtended().layout.padding;
		if (v == null && getSuper() != null)		v = getSuper().layout.padding;
		return v;
	}
	
	
	private function getWidth ()
	{
		var v = _width;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.width;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.width;
		return v;
	}
	
	
	private function getMaxWidth ()
	{
		var v = _maxWidth;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.maxWidth;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.maxWidth;
		return v;
	}
	
	
	private function getMinWidth ()
	{
		var v = _minWidth;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.minWidth;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.minWidth;
		return v;
	}
	
	
	private function getPercentWidth ()
	{
		var v = _percentWidth;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.percentWidth;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.percentWidth;
		return v;
	}
	
	
	private function getHeight ()
	{
		var v = _height;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.height;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.height;
		return v;
	}
	
	
	private function getMaxHeight ()
	{
		var v = _maxHeight;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.maxHeight;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.maxHeight;
		return v;
	}
	
	
	private function getMinHeight ()
	{
		var v = _minHeight;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.minHeight;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.minHeight;
		return v;
	}
	
	
	private function getPercentHeight ()
	{
		var v = _percentHeight;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.percentHeight;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.percentHeight;
		return v;
	}
	
	
	private function getChildWidth ()
	{
		var v = _childWidth;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.childWidth;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.childWidth;
		return v;
	}
	
	
	private function getChildHeight ()
	{
		var v = _childHeight;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.childHeight;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.childHeight;
		return v;
	}
	
	
	private function getRotation ()
	{
		var v = _rotation;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.rotation;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.rotation;
		return v;
	}


	private function getIncludeInLayout ()
	{
		var v = _includeInLayout;
		if (v == null && getExtended() != null)		v = getExtended().layout.includeInLayout;
		if (v == null && getSuper() != null)		v = getSuper().layout.includeInLayout;
		return v;
	}
	
	
	private function getMaintainAspect ()
	{
		var v = _maintainAspectRatio;
		if (v == null && getExtended() != null)		v = getExtended().layout.maintainAspectRatio;
		if (v == null && getSuper() != null)		v = getSuper().layout.maintainAspectRatio;
		return v;
	}
	
	
	
	//
	// SETTERS
	//
	
	
	private function setRelative (v)
	{
		if (v != _relative) {
			_relative = v;
			invalidate( LayoutFlags.RELATIVE );
		}
		return v;
	}
	
	
	private function setAlgorithm (v)
	{
		if (v != _algorithm) {
			_algorithm = v;
			invalidate( LayoutFlags.ALGORITHM );
		}
		return v;
	}
	
	
	private function setPadding (v)
	{
		if (v != _padding) {
			_padding = v;
			invalidate( LayoutFlags.PADDING );
		}
		return v;
	}
	
	
	private function setWidth (v)
	{
		if (v != _width) {
			_width = v;
			invalidate( LayoutFlags.WIDTH );
		}
		return v;
	}
	
	
	private function setMaxWidth (v)
	{
		if (v != maxWidth) {
			_maxWidth = v;
			invalidate( LayoutFlags.MAX_WIDTH );
		}
		return v;
	}
	
	
	private function setMinWidth (v)
	{
		if (v != _minWidth) {
			_minWidth = v;
			invalidate( LayoutFlags.MIN_WIDTH );
		}
		return v;
	}
	
	
	private function setPercentWidth (v)
	{
		if (v != _percentWidth) {
			_percentWidth = v;
			invalidate( LayoutFlags.PERCENT_WIDTH );
		}
		return v;
	}
	
	
	private function setHeight (v)
	{
		if (v != _height) {
			_height = v;
			invalidate( LayoutFlags.HEIGHT );
		}
		return v;
	}
	
	
	private function setMaxHeight (v)
	{
		if (v != _maxHeight) {
			_maxHeight = v;
			invalidate( LayoutFlags.MAX_HEIGHT );
		}
		return v;
	}
	
	
	private function setMinHeight (v)
	{
		if (v != _minHeight) {
			_minHeight = v;
			invalidate( LayoutFlags.MIN_HEIGHT );
		}
		return v;
	}
	
	
	private function setPercentHeight (v)
	{
		if (v != _percentHeight) {
			_percentHeight = v;
			invalidate( LayoutFlags.PERCENT_HEIGHT );
		}
		return v;
	}
	
	private function setChildWidth (v)
	{
		if (v != _childWidth) {
			_childWidth = v;
			invalidate( LayoutFlags.CHILD_WIDTH );
		}
		return v;
	}
	
	
	private function setChildHeight (v)
	{
		if (v != _childHeight) {
			_childHeight = v;
			invalidate( LayoutFlags.CHILD_HEIGHT );
		}
		return v;
	}
	
	
	private function setRotation (v)
	{
		if (v != _rotation) {
			_rotation = v;
			invalidate( LayoutFlags.ROTATION );
		}
		return v;
	}


	private function setIncludeInLayout (v)
	{
		if (v != _includeInLayout) {
			_includeInLayout = v;
			invalidate( LayoutFlags.INCLUDE );
		}
		return v;
	}
	
	
	private function setMaintainAspect (v)
	{
		if (v != _maintainAspectRatio) {
			_maintainAspectRatio = v;
			invalidate( LayoutFlags.MAINTAIN_ASPECT );
		}
		return v;
	}
	
	
#if (debug || neko)
	override public function toCSS (prefix:String = "") : String
	{
		var css = [];
		
		if (_padding != null)				css.push("padding: " + _padding.toCSS());
		if (_algorithm != null)				css.push("algorithm: " + _algorithm.toCSS());
		if (_relative != null)				css.push("relative: " + _relative.toCSS());
		
		if (_width.isSet())					css.push("width: " + _width + "px");
		if (_percentWidth.isSet())			css.push("width: " + _percentWidth + "%");
		if (_minWidth.isSet())				css.push("min-width: " + _minWidth + "px");
		if (_maxWidth.isSet())				css.push("max-width: " + _maxWidth + "px");
		
		if (_height.isSet())				css.push("height: " + _height + "px");
		if (_percentHeight.isSet())			css.push("height: " + _percentHeight + "%");
		if (_minHeight.isSet())				css.push("min-height: " + _minHeight + "px");
		if (_maxHeight.isSet())				css.push("max-height: " + _maxHeight + "px");
		
		if (_childWidth.isSet())			css.push("child-width: " + _childWidth + "px");
		if (_childHeight.isSet())			css.push("child-height: " + _childHeight + "px");
		
		if (_rotation.isSet())				css.push("rotation: " + _rotation + "degr");
		if (_includeInLayout != null)		css.push("position: " + (_maintainAspectRatio ? "relative" : "absolute"));
		if (_maintainAspectRatio != null)	css.push("maintainAspectRatio: " + (_maintainAspectRatio ? "true" : "false"));
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
	
	
	override public function isEmpty () : Bool
	{
		return	_width.notSet() && 
				_height.notSet() && 
				
				_percentWidth.notSet() && 
				_percentHeight.notSet() && 
				
				_minWidth.notSet() && 
				_minHeight.notSet() && 
				_maxWidth.notSet() && 
				_maxHeight.notSet() && 
				
				_childWidth.notSet() && 
				_childHeight.notSet() && 
				
				(_padding == null || _padding.isEmpty()) &&
				_algorithm == null &&
				(_relative == null || _relative.isEmpty()) &&
				
				_rotation.notSet() && 
				_includeInLayout == null &&
				_maintainAspectRatio == null;
	}
#end


#if neko
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
		{
			code.construct( this, [ _relative, _padding, _algorithm, _percentWidth, _percentHeight, _width, _height, _childWidth, _childHeight, _rotation, _includeInLayout, _maintainAspectRatio ] );
			
			if (_minWidth.isSet())		code.setProp( this, "minWidth", minWidth );
			if (_minHeight.isSet())		code.setProp( this, "minHeight", minHeight );
			if (_maxWidth.isSet())		code.setProp( this, "maxWidth", maxWidth );
			if (_maxHeight.isSet())		code.setProp( this, "maxHeight", maxHeight );
		}
	}
#end
}