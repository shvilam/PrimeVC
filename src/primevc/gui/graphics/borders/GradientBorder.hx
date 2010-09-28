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
 import primevc.core.geom.IRectangle;
 import primevc.core.geom.Matrix2D;
 import primevc.gui.graphics.fills.GradientFill;
 import primevc.gui.traits.IDrawable;
  using primevc.utils.Color;
  using primevc.utils.RectangleUtil;
  using primevc.utils.TypeUtil;


/**
 * GradientBorder implementation
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class GradientBorder extends BorderBase <GradientFill>
{
	private var lastBounds		: IRectangle;
	private var lastMatrix		: Matrix2D;
	
	
	override public function begin (target:IDrawable, ?bounds:IRectangle) : Void
	{
		changes = 0;
#if flash9
		if (lastMatrix == null || bounds != lastBounds || !bounds.isEqualTo(lastBounds))
			lastMatrix = fill.createMatrix(bounds);
		
		//TODO: MORE EFFICIENT TO CACHE THIS? MEMORY vs. SPEED
		var colors	= new Array();
		var alphas	= new Array();
		var ratios	= new Array();
		
		for (fill in fill.gradientStops) {
			colors.push( fill.color.rgb() );
			alphas.push( fill.color.alpha().float() );
			ratios.push( fill.position );
		}
		
		target.graphics.lineStyle( weight, 0, 1, pixelHinting, flash.display.LineScaleMode.NORMAL, caps, joint );
		target.graphics.lineGradientStyle( fill.getFlashType(), colors, alphas, ratios, lastMatrix );
#end
		lastBounds = bounds.clone().as(IRectangle);
	}
}