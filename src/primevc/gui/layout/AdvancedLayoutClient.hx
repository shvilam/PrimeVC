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
import primevc.core.Number;
 

/**
 * Description
 * 
 * @creation-date	Jun 17, 2010
 * @author			Ruben Weijers
 */
class AdvancedLayoutClient extends LayoutClient, implements IAdvancedLayoutClient
{
	public function new (newWidth:Int = 0, newHeight:Int = 0, validateOnPropertyChange = false)
	{
		super(newWidth, newHeight, validateOnPropertyChange);
		explicitWidth	= newWidth > 0 ? newWidth : Number.NOT_SET;
		explicitHeight	= newHeight > 0 ? newHeight : Number.NOT_SET;
		measuredWidth	= Number.NOT_SET;
		measuredHeight	= Number.NOT_SET;
	}
	
	
	override private function resetProperties () : Void
	{
		explicitWidth	= Number.NOT_SET;
		explicitHeight	= Number.NOT_SET;
		measuredWidth	= Number.NOT_SET;
		measuredHeight	= Number.NOT_SET;
		
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
			explicitWidth = v;
			if (v != Number.NOT_SET)
				explicitWidth = width = v;		//setWidth can trigger a size constraint..
		}
		return explicitWidth;
	}
	
	
	private inline function setExplicitHeight (v:Int)
	{
		if (explicitHeight != v) {
			explicitHeight = v;
			if (v != Number.NOT_SET)
				explicitHeight = height = v;	//setHeight can trigger a size constraint
		}
		return explicitHeight;
	}
	
	
	private inline function setMeasuredWidth (v:Int)
	{
		if (measuredWidth != v) {
			measuredWidth = v;
			if (explicitWidth == Number.NOT_SET)
				measuredWidth = width = v;		//setWidth can trigger a size constraint..
		}
		return measuredWidth;
	}
	
	
	private inline function setMeasuredHeight (v:Int)
	{
		if (measuredHeight != v) {
			measuredHeight = v;
			if (explicitHeight == Number.NOT_SET)
				measuredHeight = height = v;	//setHeight can trigger a size constraint
		}
		return measuredHeight;
	}
	
	
	override private function setWidth (v:Int)
	{
		var newV = super.setWidth(v);
		
		//set the explicitWidth property if height is set directly and there's no measuredWidth
		if (measuredWidth != v && explicitWidth != v)
			explicitWidth = newV;
		
		return newV;
	}
	
	
	override private function setHeight (v:Int)
	{
		var newV = super.setHeight(v);
		//set the explicitHeight property if height is set directly and there's no measuredHeight
		if (measuredHeight != v && explicitHeight != v)
			explicitHeight = newV;
		
		return newV;
	}
}