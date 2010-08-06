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
 import primevc.gui.layout.RelativeLayout;
 import primevc.types.Number;
  using primevc.utils.IntUtil;
  using primevc.utils.FloatUtil;



/**
 * Class to hold all styling properties for the layout
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class LayoutStyleDeclarations extends StyleDeclarationBase <LayoutStyleDeclarations>
{
	public var relative				(getRelative,		null)	: RelativeLayout;
	public var algorithm			(getAlgorithm,		null)	: ILayoutAlgorithm;
	public var padding				(getPadding,		null)	: Box;
	
	public var width				(getWidth,			null)	: Int;
	public var height				(getHeight,			null)	: Int;
	public var percentWidth			(getPercentWidth,	null)	: Float;
	public var percentHeight		(getPercentHeight,	null)	: Float;
	public var rotation				(getRotation,		null)	: Float;
	
	public var maintainAspectRatio	(getMaintainAspect,	null)	: Null< Bool >;
	
	
	public function new (
		percentW:Float			= Number.INT_NOT_SET,
		percentH:Float			= Number.INT_NOT_SET,
		rel:RelativeLayout		= null,
		padding:Box				= null,
		alg:ILayoutAlgorithm	= null,
		width:Int				= Number.INT_NOT_SET,
		height:Int				= Number.INT_NOT_SET,
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
		rotation		= Number.FLOAT_NOT_SET;
		
		super.dispose();
	}
	
	
	
	//
	// GETTERS
	//
	
	private function getRelative ()
	{
		if		(relative != null)				return relative;
		else if	(superInherited != null)		return superInherited.relative;
		else									return null;
	}
	
	
	private function getAlgorithm ()
	{
		if		(algorithm != null)				return algorithm;
		else if	(superInherited != null)		return superInherited.algorithm;
		else									return null;
	}
	
	
	private function getPadding ()
	{
		if		(padding != null)				return padding;
		else if (superInherited != null)		return superInherited.padding;
		else									return null;
	}
	
	
	private function getWidth ()
	{
		if		(width.isSet())					return width;
		else if (superInherited != null)		return superInherited.width;
		else									return Number.INT_NOT_SET;
	}
	
	
	private function getHeight ()
	{
		if		(height.isSet())				return height;
		else if (superInherited != null)		return superInherited.height;
		else									return Number.INT_NOT_SET;
	}
	
	
	private function getPercentWidth ()
	{
		if		(percentWidth.isSet())			return percentWidth;
		else if (superInherited != null)		return superInherited.percentWidth;
		else									return Number.FLOAT_NOT_SET;
	}
	
	
	private function getPercentHeight ()
	{
		if		(percentHeight.isSet())			return percentHeight;
		else if (superInherited != null)		return superInherited.percentHeight;
		else									return Number.FLOAT_NOT_SET;
	}
	
	
	private function getRotation ()
	{
		if		(rotation.isSet())				return rotation;
		else if (superInherited != null)		return superInherited.rotation;
		else									return Number.FLOAT_NOT_SET;
	}
	
	
	private function getMaintainAspect ()
	{
		if		(maintainAspectRatio != null)	return maintainAspectRatio;
		else if (superInherited != null)		return superInherited.maintainAspectRatio;
		else									return null;
	}
}