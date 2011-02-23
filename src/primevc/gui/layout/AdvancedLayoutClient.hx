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
 import primevc.utils.NumberMath;
  using primevc.utils.BitUtil;
  using primevc.utils.IfUtil;
  using primevc.utils.NumberUtil;
 

private typedef Flags = LayoutFlags;


/**
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class AdvancedLayoutClient extends LayoutClient, implements IAdvancedLayoutClient
{
	public function new (newWidth:Int = Number.INT_NOT_SET, newHeight:Int = Number.INT_NOT_SET)
	{
		super(newWidth, newHeight);
		(untyped this).explicitWidth	= newWidth;
		(untyped this).explicitHeight	= newHeight;
		(untyped this).measuredWidth	= Number.INT_NOT_SET;
		(untyped this).measuredHeight	= Number.INT_NOT_SET;
		
		changes = changes.set(
				Flags.EXPLICIT_WIDTH * newWidth.isSet().boolCalc()
			|	Flags.EXPLICIT_HEIGHT * newHeight.isSet().boolCalc()
		);
	}
	
	
	override private function resetProperties () : Void
	{
		(untyped this).explicitWidth = (untyped this).explicitHeight = (untyped this).measuredWidth = (untyped this).measuredHeight = Number.INT_NOT_SET;
		super.resetProperties();
	}
	
	
	public inline function isVisible ()
	{
		return (explicitWidth.notSet() || explicitWidth > 0) && (explicitHeight.notSet() || explicitHeight > 0);
	}
	
	
	
	/**
	 * Method will update the measuredWidth and measuredHeight and invalidate
	 * the aspect-ratio if maintain-aspectratio is set to true.
	 */
	public function measuredResize (newW:Int, newH:Int)
	{
		invalidatable = false;
		
		(untyped this).measuredWidth	= newW;
		(untyped this).measuredHeight	= newH;
		resize( newW, newH );
		invalidate( Flags.MEASURED_SIZE );
		
		invalidatable = true;
	}
	
	
	/**
	 * @see super.updateAllWidths
	 */
	override public function updateAllWidths (v:Int, force:Bool = false)
	{
		if (v.notSet() && measuredWidth.isSet() && explicitWidth.notSet())
			v = measuredWidth;
		
	//	var oldW	= _width;
		v = super.updateAllWidths(v, force);
		
		if (measuredWidth.notSet() || explicitWidth.isSet())
			(untyped this).explicitWidth = _width;
	//	else
	//		(untyped this).measuredWidth = _width;
		
		return v;
	}
	
	
	/**
	 * @see super.updateAllHeights
	 */
	override public function updateAllHeights (v:Int, force:Bool = false)
	{
		if (v.notSet() && measuredHeight.isSet() && explicitHeight.notSet())
			v = measuredHeight;
		
	//	var oldH	= _height;
		v = super.updateAllHeights(v, force);
		
		if (measuredHeight.notSet() || explicitHeight.isSet())
			(untyped this).explicitHeight = _height;
	//	else
	//		(untyped this).measuredHeight = _height;
		
		return v;
	}
	
	
	
	//
	// SIZE PROPERTIES
	//
	
	public var explicitWidth	(default, setExplicitWidth)		: Int;
	public var explicitHeight	(default, setExplicitHeight)	: Int;
	
	public var measuredWidth	(default, setMeasuredWidth) 	: Int;
	public var measuredHeight	(default, setMeasuredHeight)	: Int;
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setExplicitWidth (v:Int)
	{
		if (explicitWidth != v) {
			explicitWidth = width = v;
			invalidate( Flags.EXPLICIT_WIDTH );
		}
		return v;
	}
	
	
	private inline function setExplicitHeight (v:Int)
	{
		if (explicitHeight != v) {
			explicitHeight = height = v;
			invalidate( Flags.EXPLICIT_HEIGHT );
		}
		return v;
	}
	
	
	private inline function setMeasuredWidth (v:Int)
	{
		if (measuredWidth != v)
		{
			measuredWidth = v;
			if (explicitWidth.notSet())
				width = v;
			
			invalidate( Flags.MEASURED_WIDTH );
		}
		return v;
	}
	
	
	private inline function setMeasuredHeight (v:Int)
	{
		if (measuredHeight != v)
		{
			measuredHeight = v;
			if (explicitHeight.notSet())
				height = v;
			
			invalidate( Flags.MEASURED_HEIGHT );
		}
		return v;
	}
}