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
package ;
 import primevc.core.geom.Corners;
 import primevc.core.geom.IRectangle;
 import primevc.gui.graphics.shapes.IGraphicShape;
 import primevc.gui.graphics.shapes.ShapeBase;
 import primevc.gui.traits.IGraphicsOwner;



/**
 * @author Ruben Weijers
 * @creation-date Nov 11, 2010
 */
class ZoomSliderShape extends ShapeBase, implements IGraphicShape 
{
	public inline function draw (target:IGraphicsOwner, bounds:IRectangle, borderRadius:Corners) : Void
	{
#if flash9
		var g = target.graphics;
		
		var halfHeight	= bounds.top + (bounds.height * .5);
		var leftTopX	= bounds.left + borderRadius.topLeft;
		var leftTopY	= bounds.top + halfHeight - borderRadius.topLeft;
		var leftBottomY	= bounds.top + halfHeight + borderRadius.bottomLeft;
		
		g.moveTo(  leftTopX, leftTopY );																	//left top starting point
		g.lineTo(  bounds.right - borderRadius.topRight, bounds.top );										//right top point
		g.curveTo( bounds.right, bounds.top, bounds.right, halfHeight );									//right half-height point
		g.curveTo( bounds.right, bounds.bottom, bounds.right - borderRadius.topRight, bounds.bottom );		//right bottom point
		g.lineTo(  bounds.left + borderRadius.bottomLeft, halfHeight + borderRadius.bottomLeft );			//left bottom point
	//	g.curveTo( bounds.left, bounds.bottom, bounds.left, halfHeight );									//left half-height point
		g.curveTo( bounds.left, halfHeight, leftTopX, leftTopY );											//left top-starting point
#end
	}
	
	
#if neko
	override public function toCSS (prefix:String = "") : String
	{
		return "custom( ZoomSliderShape )";
	}
#end
}