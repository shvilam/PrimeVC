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
		(untyped this).explicitWidth	= newWidth;
		(untyped this).explicitHeight	= newHeight;
		(untyped this).measuredWidth	= Number.INT_NOT_SET;
		(untyped this).measuredHeight	= Number.INT_NOT_SET;
		
	//	changes = changes.unset( Flags.MEASURED_HEIGHT | Flags.MEASURED_WIDTH );
		if (explicitWidth.isSet())		changes = changes.set( Flags.EXPLICIT_WIDTH );
		if (explicitHeight.isSet())		changes = changes.set( Flags.EXPLICIT_HEIGHT );
	}
	
	
	override private function resetProperties () : Void
	{
		explicitWidth = explicitHeight = measuredWidth = measuredHeight = Number.INT_NOT_SET;
		super.resetProperties();
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
			explicitWidth = width.value = v;
			invalidate( Flags.EXPLICIT_WIDTH );
		}
		return v;
	}
	
	
	private inline function setExplicitHeight (v:Int)
	{
		if (explicitHeight != v) {
			explicitHeight = height.value = v;
			invalidate( Flags.EXPLICIT_HEIGHT );
		}
		return v;
	}
	
	
	private inline function setMeasuredWidth (v:Int)
	{
		if (measuredWidth != v)
		{
			if (explicitWidth.notSet())
				measuredWidth = width.value = v;
			else
				measuredWidth = v;
			
			invalidate( Flags.MEASURED_WIDTH );
		}
		return v;
	}
	
	
	private inline function setMeasuredHeight (v:Int)
	{
		if (measuredHeight != v)
		{
			if (explicitHeight.notSet())
				measuredHeight = height.value = v;
			else
				measuredHeight = v;
			
			invalidate( Flags.MEASURED_HEIGHT );
		}
		return v;
	}
	
	
	override public function validateHorizontal ()
	{
		if (hasValidatedWidth)
			return;
		
		/*if (name == "spreadToolBarLayout") {
			trace(this+".validateHorizontal 1 "+width.value+"; explicit: "+explicitWidth+"; measured: "+measuredWidth);
			trace("\t\tchanges: "+Flags.readProperties(changes));
		}*/
		
	//	if (changes.has( Flags.BOUNDARY_WIDTH ))
	//		super.validateHorizontal();
		
		if (changes.has(Flags.WIDTH) && changes.hasNone( Flags.MEASURED_WIDTH | Flags.EXPLICIT_WIDTH ))
		{
		//	explicitWidth = width.value;
			if (measuredWidth.isSet() && explicitWidth.notSet())
				measuredWidth = width.value;
			else
				explicitWidth = width.value;
		}
		else
		{
			if ((changes.has(Flags.MEASURED_WIDTH) || width.value.notSet()) && explicitWidth.notSet())
				width.value = measuredWidth;
			
			else if (changes.has(Flags.EXPLICIT_WIDTH))
				width.value = explicitWidth;
		}
		
		if (changes.has( Flags.WIDTH ))
		{
			hasValidatedWidth = false;
			super.validateHorizontal();
		}
	//	trace(this+".validateHorizontal 2 "+width.value+"; explicit: "+explicitWidth+"; measured: "+measuredWidth+"; "+Flags.readProperties(changes.filter( Flags.WIDTH_PROPERTIES )));
	}
	
	
	
	override public function validateVertical ()
	{
		if (hasValidatedHeight)
			return;
		
	//	if (changes.has( Flags.BOUNDARY_HEIGHT ))
	//		super.validateVertical();
		
	//	trace(this+".validateVertical 1 "+height.value+"; explicit: "+explicitHeight+"; measured: "+measuredHeight+"; "+Flags.readProperties( changes.filter( Flags.HEIGHT_PROPERTIES ) ));
	//	trace(this+".validateVertical "+Flags.readProperties(changes));
		if (changes.has(Flags.HEIGHT) && changes.hasNone( Flags.MEASURED_HEIGHT | Flags.EXPLICIT_HEIGHT ))
		{
		//	explicitHeight = height.value;	
			if (measuredHeight.isSet() && explicitHeight.notSet())
				measuredHeight = height.value;
			else
				explicitHeight = height.value;
		}
		else
		{
			if ((changes.has(Flags.MEASURED_HEIGHT) || height.value.notSet()) && explicitHeight.notSet())
				height.value = measuredHeight;
			
			if (changes.has(Flags.EXPLICIT_HEIGHT))
				height.value = explicitHeight;
		}
		
		if (changes.has( Flags.HEIGHT ))
		{
			hasValidatedHeight = false;
			super.validateVertical();
		}
	//	trace(this+".validateVertical 2 "+height.value+"; explicit: "+explicitHeight+"; measured: "+measuredHeight+"; "+Flags.readProperties(changes.filter( Flags.HEIGHT_PROPERTIES )));
	}
	
	
	
	/**
	 * Method will update the measuredWidth and measuredHeight and invalidate
	 * the aspect-ratio if maintain-aspectratio is set to true.
	 */
	public function measuredResize (newW:Int, newH:Int)
	{
		measuredWidth	= newW;
		measuredHeight	= newH;
		if (maintainAspectRatio)
			calculateAspectRatio(newW, newH);
	}
}