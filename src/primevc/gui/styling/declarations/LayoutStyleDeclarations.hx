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
 import primevc.core.geom.Box;
 import primevc.gui.layout.algorithms.ILayoutAlgorithm;
 import primevc.gui.layout.LayoutFlags;
 import primevc.gui.layout.RelativeLayout;
 import primevc.types.Number;
  using primevc.utils.NumberUtil;



/**
 * Class to hold all styling properties for the layout
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class LayoutStyleDeclarations extends StyleDeclarationBase <LayoutStyleDeclarations>
{
	public var relative				(getRelative,		setRelative)		: RelativeLayout;
	public var algorithm			(getAlgorithm,		setAlgorithm)		: ILayoutAlgorithm;
	public var padding				(getPadding,		setPadding)			: Box;
	
	public var width				(getWidth,			setWidth)			: Int;
	public var maxWidth				(getMaxWidth,		setMaxWidth)		: Int;
	public var minWidth				(getMinWidth,		setMinWidth)		: Int;
	public var percentWidth			(getPercentWidth,	setPercentWidth)	: Float;
	
	public var height				(getHeight,			setHeight)			: Int;
	public var maxHeight			(getMaxHeight,		setMaxHeight)		: Int;
	public var minHeight			(getMinHeight,		setMinHeight)		: Int;
	public var percentHeight		(getPercentHeight,	setPercentHeight)	: Float;
	
	public var childWidth			(getChildWidth,		setChildWidth)		: Int;
	public var childHeight			(getChildHeight,	setChildHeight)		: Int;
	
	public var rotation				(getRotation,		setRotation)		: Float;
	public var maintainAspectRatio	(getMaintainAspect,	setMaintainAspect)	: Null< Bool >;
	
	
	public function new (
		rel:RelativeLayout		= null,
		padding:Box				= null,
		alg:ILayoutAlgorithm	= null,
		percentW:Float			= Number.INT_NOT_SET,
		percentH:Float			= Number.INT_NOT_SET,
		width:Int				= Number.INT_NOT_SET,
		height:Int				= Number.INT_NOT_SET,
		childWidth:Int			= Number.INT_NOT_SET,
		childHeight:Int			= Number.INT_NOT_SET,
		rotation:Float			= Number.INT_NOT_SET,
		maintainAspect:Bool 	= null
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
	}
	
	
	override public function dispose ()
	{
		if ((untyped this).relative != null)	relative.dispose();
		if ((untyped this).algorithm != null)	algorithm.dispose();
		
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
		
		super.dispose();
	}
	
	
	
	//
	// GETTERS
	//
	
	private function getRelative ()
	{
		if		(relative != null)				return relative;
		else if (extendedStyle != null)			return extendedStyle.relative;
		else if	(superStyle != null)			return superStyle.relative;
		else									return null;
	}
	
	
	private function getAlgorithm ()
	{
		if		(algorithm != null)				return algorithm;
		else if (extendedStyle != null)			return extendedStyle.algorithm;
		else if	(superStyle != null)			return superStyle.algorithm;
		else									return null;
	}
	
	
	private function getPadding ()
	{
		if		(padding != null)				return padding;
		else if (extendedStyle != null)			return extendedStyle.padding;
		else if (superStyle != null)			return superStyle.padding;
		else									return null;
	}
	
	
	private function getWidth ()
	{
		if		(width.isSet())					return width;
		else if (extendedStyle != null)			return extendedStyle.width;
		else if (superStyle != null)			return superStyle.width;
		else									return Number.INT_NOT_SET;
	}
	
	
	private function getMaxWidth ()
	{
		if		(maxWidth.isSet())				return maxWidth;
		else if (extendedStyle != null)			return extendedStyle.maxWidth;
		else if (superStyle != null)			return superStyle.maxWidth;
		else									return Number.INT_NOT_SET;
	}
	
	
	private function getMinWidth ()
	{
		if		(minWidth.isSet())				return minWidth;
		else if (extendedStyle != null)			return extendedStyle.minWidth;
		else if (superStyle != null)			return superStyle.minWidth;
		else									return Number.INT_NOT_SET;
	}
	
	
	private function getPercentWidth ()
	{
		if		(percentWidth.isSet())			return percentWidth;
		else if (extendedStyle != null)			return extendedStyle.percentWidth;
		else if (superStyle != null)			return superStyle.percentWidth;
		else									return Number.FLOAT_NOT_SET;
	}
	
	
	private function getHeight ()
	{
		if		(height.isSet())				return height;
		else if (extendedStyle != null)			return extendedStyle.height;
		else if (superStyle != null)			return superStyle.height;
		else									return Number.INT_NOT_SET;
	}
	
	
	private function getMaxHeight ()
	{
		if		(maxHeight.isSet())				return maxHeight;
		else if (extendedStyle != null)			return extendedStyle.maxHeight;
		else if (superStyle != null)			return superStyle.maxHeight;
		else									return Number.INT_NOT_SET;
	}
	
	
	private function getMinHeight ()
	{
		if		(minHeight.isSet())				return minHeight;
		else if (extendedStyle != null)			return extendedStyle.minHeight;
		else if (superStyle != null)			return superStyle.minHeight;
		else									return Number.INT_NOT_SET;
	}
	
	
	private function getPercentHeight ()
	{
		if		(percentHeight.isSet())			return percentHeight;
		else if (extendedStyle != null)			return extendedStyle.percentHeight;
		else if (superStyle != null)			return superStyle.percentHeight;
		else									return Number.FLOAT_NOT_SET;
	}
	
	
	private function getChildWidth ()
	{
		if		(childWidth.isSet())			return childWidth;
		else if (extendedStyle != null)			return extendedStyle.childWidth;
		else if (superStyle != null)			return superStyle.childWidth;
		else									return Number.INT_NOT_SET;
	}
	
	
	private function getChildHeight ()
	{
		if		(childHeight.isSet())			return childHeight;
		else if (extendedStyle != null)			return extendedStyle.childHeight;
		else if (superStyle != null)			return superStyle.childHeight;
		else									return Number.INT_NOT_SET;
	}
	
	
	private function getRotation ()
	{
		if		(rotation.isSet())				return rotation;
		else if (extendedStyle != null)			return extendedStyle.rotation;
		else if (superStyle != null)			return superStyle.rotation;
		else									return Number.FLOAT_NOT_SET;
	}
	
	
	private function getMaintainAspect ()
	{
		if		(maintainAspectRatio != null)	return maintainAspectRatio;
		else if (extendedStyle != null)			return extendedStyle.maintainAspectRatio;
		else if (superStyle != null)			return superStyle.maintainAspectRatio;
		else									return null;
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
	
	
	private inline function setMaintainAspect (v)
	{
		if (v != maintainAspectRatio) {
			maintainAspectRatio = v;
			invalidate( LayoutFlags.MAINTAIN_ASPECT );
		}
		return v;
	}
	
	
#if debug
	public function toString ()
	{
		var css = [];
		
		if (padding != null)				css.push("padding: " + padding);
		if (algorithm != null)				css.push("algorithm: " + algorithm);
		if (relative != null)				css.push("relative: " + relative.toCSSString());
		
		if (width.isSet())					css.push("width: " + width + "px");
		if (percentWidth.isSet())			css.push("width: " + percentWidth + "%");
		if (minWidth.isSet())				css.push("min-width: " + minWidth + "px");
		if (maxWidth.isSet())				css.push("max-width: " + maxWidth + "px");
		
		if (height.isSet())					css.push("height: " + height + "px");
		if (percentHeight.isSet())			css.push("height: " + percentHeight + "%");
		if (minHeight.isSet())				css.push("min-height: " + minHeight + "px");
		if (maxHeight.isSet())				css.push("max-height: " + maxHeight + "px");
		
		if (childWidth.isSet())				css.push("child-width: " + childWidth + "px");
		if (childHeight.isSet())			css.push("child-height: " + childHeight + "px");
		
		if (rotation.isSet())				css.push("rotation: " + rotation + "degr");
		if (maintainAspectRatio != null)	css.push("maintainAspectRatio: " + (maintainAspectRatio ? "true" : "false"));
		
		if (css.length > 0)
			return "\n\t" + css.join(";\n\t") + ";";
		else
			return "";
	}
#end
}