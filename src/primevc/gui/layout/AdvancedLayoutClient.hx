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
 import primevc.utils.IntMath;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
 

private typedef Flags = LayoutFlags;


/**
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
	
//	private var explicitWidth	: Int;
//	private var explicitHeight	: Int;
//	private var measuredWidth	: Int;
//	private var measuredHeight	: Int;
	
	
	public var explicitWidth	(default, setExplicitWidth)		: Int;
	public var explicitHeight	(default, setExplicitHeight)	: Int;
	
	public var measuredWidth	(default, setMeasuredWidth) 	: Int;
	public var measuredHeight	(default, setMeasuredHeight)	: Int;
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	
//	private inline function getMeasuredWidth ()		{ return measuredWidth; }
//	private inline function getMeasuredHeight ()	{ return measuredHeight; }
//	private inline function getExplicitWidth ()		{ return explicitWidth; }
//	private inline function getExplicitHeight ()	{ return explicitHeight; }
	
	
	private inline function setExplicitWidth (v:Int)
	{
		if (explicitWidth != v) {
			explicitWidth = v;
			invalidate( Flags.EXPLICIT_WIDTH | Flags.WIDTH );
		}
		return v;
	}
	
	
	private inline function setExplicitHeight (v:Int)
	{
		if (explicitHeight != v) {
			explicitHeight = v;
			invalidate( Flags.EXPLICIT_HEIGHT | Flags.HEIGHT );
		}
		return v;
	}
	
	
	private inline function setMeasuredWidth (v:Int)
	{
		if (measuredWidth != v) {
			measuredWidth = v;
			
			if (explicitWidth.isSet())		invalidate( Flags.MEASURED_WIDTH );
			else							invalidate( Flags.MEASURED_WIDTH | Flags.WIDTH );
		}
		return v;
	}
	
	
	private inline function setMeasuredHeight (v:Int)
	{
		if (measuredHeight != v) {
			measuredHeight = v;
			
			if (explicitWidth.isSet())		invalidate( Flags.MEASURED_HEIGHT );
			else							invalidate( Flags.MEASURED_HEIGHT | Flags.HEIGHT );
		}
		return v;
	}
	
	
	override public function validateHorizontal ()
	{
		if (hasValidatedWidth)
			return;

		super.validateHorizontal();
		
	//	trace(this+".validateHorizontal "+width+"; explicit: "+explicitWidth+"; measured: "+measuredWidth+"; "+Flags.readProperties(changes));
		if (changes.has(Flags.MEASURED_WIDTH | Flags.EXPLICIT_WIDTH) && explicitWidth.notSet() && measuredWidth.isSet())
			width = measuredWidth;
		
		if (changes.has(Flags.EXPLICIT_WIDTH) && explicitWidth.isSet())
			width = explicitWidth;
		
		if (changes.has(Flags.WIDTH))
		{
			bounds.width = IntMath.max( width, 0 ) + getHorPadding();
			
			if (width.isSet())
			{
				if (explicitWidth.isSet() || measuredWidth.notSet())
					explicitWidth	= width;
				else
					measuredWidth	= width;
			}
		}
	}
	
	
	
	override public function validateVertical ()
	{
		if (hasValidatedHeight)
			return;
		
		super.validateVertical();
		
		if (changes.has(Flags.MEASURED_HEIGHT | Flags.EXPLICIT_HEIGHT) && explicitHeight.notSet() && measuredHeight.isSet())
			height = measuredHeight;
		
		if (changes.has(Flags.EXPLICIT_HEIGHT) && explicitHeight.isSet())
			height = explicitHeight;
		
		if (changes.has(Flags.HEIGHT))
		{
			bounds.height = IntMath.max( height, 0 ) + getVerPadding();
			
			if (height.isSet())
			{
				if (explicitHeight.isSet() || measuredHeight.notSet())
					explicitHeight	= height;
				else
					measuredHeight	= height;
			}
		}
	}
}