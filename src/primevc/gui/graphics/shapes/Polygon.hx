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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.graphics.shapes;
 import primevc.core.geom.Corners;
 import primevc.core.geom.IRectangle;
 import primevc.gui.traits.IGraphicsOwner;
 import primevc.utils.Formulas;
  using primevc.gui.utils.GraphicsUtil;



/**
 * Class to draw a polygon with x-sides (minimal 3)
 * 
 * @author Ruben Weijers
 * @creation-date Apr 19, 2011
 */
class Polygon extends ShapeBase, implements IGraphicShape
{
	private var sides : Int;
	
	
	public function new (sides:Int = 3)
	{
		super();
		Assert.that( sides > 2 );
		this.sides = sides;
	}
	
	
	public function draw (target:IGraphicsOwner, bounds:IRectangle, borderRadius:Corners) : Void
	{
		var radius = Formulas.getCircleRadius( bounds.width, bounds.height );
#if flash9
		target.drawPolygon( sides, bounds.left + radius, bounds.top + radius, radius );
#end
	}
	
	
	public function drawFraction (target:IGraphicsOwner, bounds:IRectangle, borderRadius:Corners, percentage:Float) : Void
	{
		var radius = Formulas.getCircleRadius( bounds.width, bounds.height );
#if flash9
		target.drawPolygonFraction( sides, bounds.left + radius, bounds.top + radius, radius, percentage );
#end
	}
	

#if (neko || debug)
	override public function toCSS (prefix:String = "") : String
	{
		return "polygon("+sides+")";
	}
#end
}