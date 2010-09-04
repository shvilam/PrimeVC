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
 import primevc.gui.text.FontStyle;
 import primevc.gui.text.FontWeight;
 import primevc.gui.text.TextAlign;
 import primevc.types.Number;
 import primevc.types.RGBA;
  using primevc.utils.IntUtil;


/**
 * Class holding all style properties for fonts.
 * Font properties are also inheritable of the container object.
 * 
 * @author Ruben Weijers
 * @creation-date Aug 05, 2010
 */
class FontStyleDeclarations extends StyleDeclarationBase < FontStyleDeclarations >
{
	public var size		(getSize,	setSize)	: Int;
	public var family	(getFamily,	setFamily)	: String;
	public var color	(getColor,	setColor)	: Null<RGBA>;
	public var align	(getAlign,	setAlign)	: TextAlign;
	public var weight	(getWeight, setWeight)	: FontWeight;
	public var style	(getStyle,	setStyle)	: FontStyle;
	
	
	public function new (
		size:Int			= Number.INT_NOT_SET,
		family:String		= null,
		color:RGBA			= null,
		align:TextAlign		= null,
		weight:FontWeight	= null,
		style:FontStyle		= null
	)
	{
		super();
		this.size	= size;
		this.family	= family;
		this.color	= color;
		this.align	= align;
		this.weight	= weight;
		this.style	= null;
	}
	
	
	override public function dispose ()
	{
		family	= null;
		align	= null;
		weight	= null;
		style	= null;
		super.dispose();
	}
	
	
	//
	// GETTERS
	//
	
	private function getSize ()
	{
		if		(size.isSet())				return size;
		else if (extendedStyle != null)		return extendedStyle.size;
		else if (nestingInherited != null)	return nestingInherited.size;
		else if (superInherited != null)	return superInherited.size;
		else								return Number.INT_NOT_SET;
	}
	
	
	private function getFamily ()
	{
		if		(family != null)			return family;
		else if (extendedStyle != null)		return extendedStyle.family;
		else if (nestingInherited != null)	return nestingInherited.family;
		else if (superInherited != null)	return superInherited.family;
		else								return null;
	}
	
	
	private function getColor ()
	{
		if		(color != null)				return color;
		else if (extendedStyle != null)		return extendedStyle.color;
		else if (nestingInherited != null)	return nestingInherited.color;
		else if (superInherited != null)	return superInherited.color;
		else								return null;
	}
	
	
	private function getAlign ()
	{
		if		(align != null)				return align;
		else if (extendedStyle != null)		return extendedStyle.align;
		else if (nestingInherited != null)	return nestingInherited.align;
		else if (superInherited != null)	return superInherited.align;
		else								return null;
	}
	
	
	private function getWeight ()
	{
		if		(weight != null)			return weight;
		else if (extendedStyle != null)		return extendedStyle.weight;
		else if (nestingInherited != null)	return nestingInherited.weight;
		else if (superInherited != null)	return superInherited.weight;
		else								return null;
	}
	
	
	private function getStyle ()
	{
		if		(style != null)				return style;
		else if (extendedStyle != null)		return extendedStyle.style;
		else if (nestingInherited != null)	return nestingInherited.style;
		else if (superInherited != null)	return superInherited.style;
		else								return null;
	}
	
	
	//
	// SETTERS
	//
	
	private inline function setSize (v)		{ return size = v; }
	private inline function setFamily (v)	{ return family = v; }
	private inline function setColor (v)	{ return color = v; }
	private inline function setAlign (v)	{ return align = v; }
	private inline function setWeight (v)	{ return weight = v; }
	private inline function setStyle (v)	{ return style = v; }
}