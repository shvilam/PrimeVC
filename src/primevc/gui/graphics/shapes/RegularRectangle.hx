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
package primevc.gui.graphics.shapes;
 import primevc.core.geom.Corners;
 import primevc.core.geom.IRectangle;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.gui.traits.IDrawable;


/**
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class RegularRectangle extends ShapeBase
{
	public var corners		(default, setCorners)	: Corners;
	
	
	public function new (?layout:IRectangle, ?fill:IFill, ?border:IBorder<IFill>, ?corners:Corners)
	{
		super(layout, fill, border);
		this.corners = corners;
	}
	
	
	override public function dispose ()
	{
		corners = null;
		super.dispose();
	}
	
	
	override private function drawShape (target:IDrawable, x:Int, y:Int, width:Int, height:Int) : Void
	{
#if flash9
		if (corners == null)
			target.graphics.drawRect( x, y, width, height );
		else
			target.graphics.drawRoundRectComplex(
				x, y, width, height, 
				corners.topLeft, corners.topRight, corners.bottomLeft, corners.bottomRight
			);
#end
	}
	
	
	//
	// SETTERS
	//
	
	private inline function setCorners (v:Corners)
	{
		if (v != corners) {
			corners = v;
			invalidate( GraphicFlags.SHAPE_CHANGED );
		}
		return v;
	}


#if debug
	public function toString ()
	{
		return "rectangle";
	}
#end
}