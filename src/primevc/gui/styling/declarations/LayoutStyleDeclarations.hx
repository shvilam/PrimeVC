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
		this.relative			= rel;
		this.algorithm			= alg;
		this.padding			= padding;
		
		this.percentWidth		= percentW == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentW;
		this.percentHeight		= percentH == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : percentH;
		this.width				= width;
		this.height				= height;
		this.childWidth			= childWidth;
		this.childHeight		= childHeight;
		this.rotation			= rotation == Number.INT_NOT_SET ? Number.FLOAT_NOT_SET : rotation;
		
		maintainAspectRatio		= maintainAspect;
		includeInLayout			= include;
		
		minWidth	= Number.INT_NOT_SET;
		minHeight	= Number.INT_NOT_SET;
		maxWidth	= Number.INT_NOT_SET;
		maxHeight	= Number.INT_NOT_SET;
	}
	
	
	override public function dispose ()
	{
		if ((untyped this).relative != null)	relative.dispose();
		if ((untyped this).algorithm != null)	algorithm.dispose();
		
		maintainAspectRatio = null;
		includeInLayout	= null;
		relative		= null;
		algorithm		= null;
		padding			= null;
		percentWidth	= Number.FLOAT_NOT_SET;
		percentHeight	= Number.FLOAT_NOT_SET;
		width			= Number.INT_NOT_SET;
		height			= Number.INT_NOT_SET;
		childWidth		= Number.INT_NOT_SET;
		childHeight		= Number.INT_NOT_SET;
		rotation		= Number.FLOAT_NOT_SET;
		
		minWidth		= Number.INT_NOT_SET;
		minHeight		= Number.INT_NOT_SET;
		maxWidth		= Number.INT_NOT_SET;
		maxHeight		= Number.INT_NOT_SET;
		
		super.dispose();
	}
	
	
	
	//
	// GETTERS
	//
	
	private function getRelative ()
	{
		var v = relative;
		if (v == null && getExtended() != null)		v = getExtended().layout.relative;
		if (v == null && getSuper() != null)		v = getSuper().layout.relative;
		return v;
	}
	
	
	private function getAlgorithm ()
	{
		var v = algorithm;
		if (v == null && getExtended() != null)		v = getExtended().layout.algorithm;
		if (v == null && getSuper() != null)		v = getSuper().layout.algorithm;
		return v;
	}
	
	
	private function getPadding ()
	{
		var v = padding;
		if (v == null && getExtended() != null)		v = getExtended().layout.padding;
		if (v == null && getSuper() != null)		v = getSuper().layout.padding;
		return v;
	}
	
	
	private function getWidth ()
	{
		var v = width;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.width;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.width;
		return v;
	}
	
	
	private function getMaxWidth ()
	{
		var v = maxWidth;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.maxWidth;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.maxWidth;
		return v;
	}
	
	
	private function getMinWidth ()
	{
		var v = minWidth;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.minWidth;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.minWidth;
		return v;
	}
	
	
	private function getPercentWidth ()
	{
		var v = percentWidth;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.percentWidth;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.percentWidth;
		return v;
	}
	
	
	private function getHeight ()
	{
		var v = height;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.height;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.height;
		return v;
	}
	
	
	private function getMaxHeight ()
	{
		var v = maxHeight;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.maxHeight;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.maxHeight;
		return v;
	}
	
	
	private function getMinHeight ()
	{
		var v = minHeight;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.minHeight;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.minHeight;
		return v;
	}
	
	
	private function getPercentHeight ()
	{
		var v = percentHeight;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.percentHeight;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.percentHeight;
		return v;
	}
	
	
	private function getChildWidth ()
	{
		var v = childWidth;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.childWidth;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.childWidth;
		return v;
	}
	
	
	private function getChildHeight ()
	{
		var v = childHeight;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.childHeight;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.childHeight;
		return v;
	}
	
	
	private function getRotation ()
	{
		var v = rotation;
		if (v.notSet() && getExtended() != null)	v = getExtended().layout.rotation;
		if (v.notSet() && getSuper() != null)		v = getSuper().layout.rotation;
		return v;
	}


	private function getIncludeInLayout ()
	{
		var v = includeInLayout;
		if (v == null && getExtended() != null)		v = getExtended().layout.includeInLayout;
		if (v == null && getSuper() != null)		v = getSuper().layout.includeInLayout;
		return v;
	}
	
	
	private function getMaintainAspect ()
	{
		var v = maintainAspectRatio;
		if (v == null && getExtended() != null)		v = getExtended().layout.maintainAspectRatio;
		if (v == null && getSuper() != null)		v = getSuper().layout.maintainAspectRatio;
		return v;
	}
	
	
	
	//
	// SETTERS
	//
	
	
	private inline function setRelative (v)
	{
		if (v != relative) {
			relative = v;
			invalidate( LayoutFlags.RELATIVE );
		}
		return v;
	}
	
	
	private inline function setAlgorithm (v)
	{
		if (v != algorithm) {
			algorithm = v;
			invalidate( LayoutFlags.ALGORITHM );
		}
		return v;
	}
	
	
	private inline function setPadding (v)
	{
		if (v != padding) {
			padding = v;
			invalidate( LayoutFlags.PADDING );
		}
		return v;
	}
	
	
	private inline function setWidth (v)
	{
		if (v != width) {
			width = v;
			invalidate( LayoutFlags.WIDTH );
		}
		return v;
	}
	
	
	private inline function setMaxWidth (v)
	{
		if (v != maxWidth) {
			maxWidth = v;
			invalidate( LayoutFlags.MAX_WIDTH );
		}
		return v;
	}
	
	
	private inline function setMinWidth (v)
	{
		if (v != minWidth) {
			minWidth = v;
			invalidate( LayoutFlags.MIN_WIDTH );
		}
		return v;
	}
	
	
	private inline function setPercentWidth (v)
	{
		if (v != percentWidth) {
			percentWidth = v;
			invalidate( LayoutFlags.PERCENT_WIDTH );
		}
		return v;
	}
	
	
	private inline function setHeight (v)
	{
		if (v != height) {
			height = v;
			invalidate( LayoutFlags.HEIGHT );
		}
		return v;
	}
	
	
	private inline function setMaxHeight (v)
	{
		if (v != maxHeight) {
			maxHeight = v;
			invalidate( LayoutFlags.MAX_HEIGHT );
		}
		return v;
	}
	
	
	private inline function setMinHeight (v)
	{
		if (v != minHeight) {
			minHeight = v;
			invalidate( LayoutFlags.MIN_HEIGHT );
		}
		return v;
	}
	
	
	private inline function setPercentHeight (v)
	{
		if (v != percentHeight) {
			percentHeight = v;
			invalidate( LayoutFlags.PERCENT_HEIGHT );
		}
		return v;
	}
	
	private inline function setChildWidth (v)
	{
		if (v != childWidth) {
			childWidth = v;
			invalidate( LayoutFlags.CHILD_WIDTH );
		}
		return v;
	}
	
	
	private inline function setChildHeight (v)
	{
		if (v != childHeight) {
			childHeight = v;
			invalidate( LayoutFlags.CHILD_HEIGHT );
		}
		return v;
	}
	
	
	private inline function setRotation (v)
	{
		if (v != rotation) {
			rotation = v;
			invalidate( LayoutFlags.ROTATION );
		}
		return v;
	}


	private inline function setIncludeInLayout (v)
	{
		if (v != includeInLayout) {
			includeInLayout = v;
			invalidate( LayoutFlags.INCLUDE );
		}
		return v;
	}
	
	
	private inline function setMaintainAspect (v)
	{
		if (v != maintainAspectRatio) {
			maintainAspectRatio = v;
			invalidate( LayoutFlags.MAINTAIN_ASPECT );
		}
		return v;
	}
	
	
#if (debug || neko)
	override public function toCSS (prefix:String = "") : String
	{
		var css = [];
		
		if ((untyped padding) != null)					css.push("padding: " + padding.toCSS());
		if ((untyped algorithm) != null)				css.push("algorithm: " + algorithm.toCSS());
		if ((untyped relative) != null)					css.push("relative: " + relative.toCSS());
		
		if (IntUtil.isSet( untyped width ))				css.push("width: " + width + "px");
		if (FloatUtil.isSet( untyped percentWidth ))	css.push("width: " + percentWidth + "%");
		if (IntUtil.isSet( untyped minWidth ))			css.push("min-width: " + minWidth + "px");
		if (IntUtil.isSet( untyped maxWidth ))			css.push("max-width: " + maxWidth + "px");
		
		if (IntUtil.isSet( untyped height ))			css.push("height: " + height + "px");
		if (FloatUtil.isSet( untyped percentHeight ))	css.push("height: " + percentHeight + "%");
		if (IntUtil.isSet( untyped minHeight ))			css.push("min-height: " + minHeight + "px");
		if (IntUtil.isSet( untyped maxHeight ))			css.push("max-height: " + maxHeight + "px");
		
		if (IntUtil.isSet( untyped childWidth ))		css.push("child-width: " + childWidth + "px");
		if (IntUtil.isSet( untyped childHeight ))		css.push("child-height: " + childHeight + "px");
		
		if (FloatUtil.isSet( untyped rotation ))		css.push("rotation: " + rotation + "degr");
		if ((untyped includeInLayout) != null)			css.push("position: " + (maintainAspectRatio ? "relative" : "absolute"));
		if ((untyped maintainAspectRatio) != null)		css.push("maintainAspectRatio: " + (maintainAspectRatio ? "true" : "false"));
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
	
	
	override public function isEmpty () : Bool
	{
		return	IntUtil.notSet(untyped width) && 
				IntUtil.notSet(untyped height) && 
				
				FloatUtil.notSet(untyped percentWidth) && 
				FloatUtil.notSet(untyped percentHeight) && 
				
				IntUtil.notSet(untyped minWidth) && 
				IntUtil.notSet(untyped minHeight) && 
				IntUtil.notSet(untyped maxWidth) && 
				IntUtil.notSet(untyped maxHeight) && 
				
				IntUtil.notSet(untyped childWidth) && 
				IntUtil.notSet(untyped childHeight) && 
				
				((untyped padding) == null || (untyped padding).isEmpty()) &&
				(untyped algorithm) == null &&
				((untyped relative) == null || (untyped relative).isEmpty()) &&
				
				FloatUtil.notSet(untyped rotation) && 
				(untyped includeInLayout) == null &&
				(untyped maintainAspectRatio) == null;
	}
#end


#if neko
	override public function toCode (code:ICodeGenerator)
	{
		if (!isEmpty())
		{
			code.construct( this, [
				untyped relative, untyped padding, untyped algorithm, 
				untyped percentWidth, untyped percentHeight, untyped width, untyped height, 
				untyped childWidth, untyped childHeight, 
				untyped rotation, untyped includeInLayout, untyped maintainAspectRatio
			] );
		
			if (IntUtil.isSet(untyped minWidth))		code.setProp( this, "minWidth", minWidth );
			if (IntUtil.isSet(untyped minHeight))		code.setProp( this, "minHeight", minHeight );
			if (IntUtil.isSet(untyped maxWidth))		code.setProp( this, "maxWidth", maxWidth );
			if (IntUtil.isSet(untyped maxHeight))		code.setProp( this, "maxHeight", maxHeight );
		
			super.toCode(code);
		}
	}
#end
}