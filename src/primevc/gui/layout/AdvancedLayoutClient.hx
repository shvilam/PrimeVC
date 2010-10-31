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
 import primevc.types.Number;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
 

private typedef Flags = LayoutFlags;


/**
 * Description
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class AdvancedLayoutClient extends LayoutClient, implements IAdvancedLayoutClient
{
	public function new (newWidth:Int = Number.INT_NOT_SET, newHeight:Int = Number.INT_NOT_SET, validateOnPropertyChange = false)
	{
		super(newWidth, newHeight, validateOnPropertyChange);
		explicitWidth	= newWidth;
		explicitHeight	= newHeight;
		measuredWidth	= Number.INT_NOT_SET;
		measuredHeight	= Number.INT_NOT_SET;
	}
	
	
	override private function resetProperties () : Void
	{
		explicitWidth = explicitHeight = measuredWidth = measuredHeight = Number.INT_NOT_SET;
		super.resetProperties();
	}
	
	
	
	//
	// SIZE PROPERTIES
	//
	
	private var _explicitWidth	: Int;
	private var _explicitHeight	: Int;
	private var _measuredWidth	: Int;
	private var _measuredHeight	: Int;
	
	
	public var explicitWidth	(getExplicitWidth, setExplicitWidth)	: Int;
	public var explicitHeight	(getExplicitHeight, setExplicitHeight)	: Int;
	
	public var measuredWidth	(getMeasuredWidth, setMeasuredWidth) 	: Int;
	public var measuredHeight	(getMeasuredHeight, setMeasuredHeight)	: Int;
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
	private inline function getMeasuredWidth ()		{ return _measuredWidth; }
	private inline function getMeasuredHeight ()	{ return _measuredHeight; }
	private inline function getExplicitWidth ()		{ return _explicitWidth; }
	private inline function getExplicitHeight ()	{ return _explicitHeight; }
	
	
	private inline function setExplicitWidth (v:Int)
	{
		if (_explicitWidth != v) {
			_explicitWidth = v;
			invalidate( Flags.EXPLICIT_WIDTH | Flags.WIDTH );
		//	if (v.isSet())
		//		explicitWidth = width = v;		//setWidth can trigger a size constraint.
		//	else
		//		width = measuredWidth;
			
		}
		return v;
	}
	
	
	private inline function setExplicitHeight (v:Int)
	{
		if (_explicitHeight != v) {
			_explicitHeight = v;
			invalidate( Flags.EXPLICIT_HEIGHT | Flags.HEIGHT );
		//	if (v.isSet())
		//		explicitHeight = height = v;	//setHeight can trigger a size constraint
		//	else
		//		height = measuredHeight;
		}
		return v;
	}
	
	
	private inline function setMeasuredWidth (v:Int)
	{
		if (_measuredWidth != v) {
			_measuredWidth = v;
			invalidate( Flags.MEASURED_WIDTH );
		//	if (explicitWidth.notSet())
		//		measuredWidth = width = v;		//setWidth can trigger a size constraint..
		}
		return v;
	}
	
	
	private inline function setMeasuredHeight (v:Int)
	{
		if (_measuredHeight != v) {
			_measuredHeight = v;
			invalidate( Flags.MEASURED_HEIGHT );
		//	if (explicitHeight.notSet())
		//		measuredHeight = height = v;	//setHeight can trigger a size constraint
		}
		return v;
	}
	
	
	override public function validateHorizontal ()
	{
		if (hasValidatedWidth)
			return;

		super.validateHorizontal();
		
		if (changes.has(Flags.MEASURED_WIDTH | Flags.EXPLICIT_WIDTH) && _explicitWidth.notSet() && _measuredWidth.isSet())
			width = _measuredWidth;
		
		if (changes.has(Flags.EXPLICIT_WIDTH) && _explicitWidth.isSet())
			width = _explicitWidth;
		
		if (_explicitWidth.notSet() && width != _measuredWidth && width.isSet())
			_measuredWidth = width;
		
		if (_explicitWidth.isSet() && width != _explicitWidth && width.isSet())
			_explicitWidth = width;
		
		if (changes.has(Flags.WIDTH))
			bounds.width = width + getHorPadding();
	}
	
	
	
	override public function validateVertical ()
	{
		if (hasValidatedHeight)
			return;
		
		super.validateVertical();
		
		if (changes.has(Flags.MEASURED_HEIGHT | Flags.EXPLICIT_HEIGHT) && _explicitHeight.notSet() && _measuredHeight.isSet())
			height = _measuredHeight;
		
		if (changes.has(Flags.EXPLICIT_HEIGHT) && _explicitHeight.isSet())
			height = _explicitHeight;
		
		if (_explicitHeight.notSet() && height != _measuredHeight && height.isSet())
			_measuredHeight = height;
		
		if (_explicitHeight.isSet() && height != _explicitHeight && height.isSet())	
			_explicitHeight = height;
		
		if (changes.has(Flags.HEIGHT))
			bounds.height = height + getVerPadding();
	}
	
	
	/*override private function setWidth (v:Int)
	{
		trace(this+".setWidth "+width+"; v "+v);
		var newV = super.setWidth(v);
		
		//set the explicitWidth property if height is set directly and there's no measuredWidth
		if (measuredWidth != v && explicitWidth != v)
			explicitWidth = newV;
		
		trace("\t" + this+".END setWidth "+width+"; newV "+newV+"; v "+v+"; explicit: "+explicitWidth+"; measured "+measuredWidth);
		return newV;
	}
	
	
	override private function setHeight (v:Int)
	{
		var newV = super.setHeight(v);
		//set the explicitHeight property if height is set directly and there's no measuredHeight
		if (measuredHeight != v && explicitHeight != v)
			explicitHeight = newV;
		
		return newV;
	}*/
}