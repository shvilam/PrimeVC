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
package primevc.gui.graphics.borders;
 import primevc.gui.graphics.ComposedGraphicProperty;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.gui.graphics.IGraphicProperty;
  using primevc.utils.TypeUtil;



/**
 * @author Ruben Weijers
 * @creation-date Nov 04, 2010
 */
class ComposedBorder extends ComposedGraphicProperty, implements IBorder
{
	public var weight		(default, setWeight)		: Float;
	public var innerBorder	(default, setInnerBorder)	: Bool;
	
	
	public function new ()
	{
		weight = 0;
		super();
	}
	
	
	override public function add (property:IGraphicProperty) : Bool
	{
		if (!super.add( property ))
			return false;
		
		var border = property.as(BorderBase);
		if (!border.innerBorder)
			weight += border.weight;
		
		invalidate( GraphicFlags.BORDER );
		return true;
	}
	
	
	override public function remove (property:IGraphicProperty) : Bool
	{
		if (!super.remove( property ))
			return false;
		
		var border = property.as(BorderBase);
		if (!border.innerBorder)
			weight -= border.weight;
		
		invalidate( GraphicFlags.BORDER );
		return true;
	}
	
	
	private inline function setWeight (v:Float)
	{
		if (v != weight) {
			weight = v;
	//		invalidate( GraphicFlags.BORDER );
		}
		return v;
	}
	
	
	private inline function setInnerBorder (v:Bool)
	{
		Assert.abstract();
		return v;
	}
}