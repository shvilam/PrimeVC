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
 import primevc.core.geom.IntPoint;
 import primevc.gui.graphics.GraphicFlags;


/**
 * @author Ruben Weijers
 * @creation-date Aug 01, 2010
 */
class Triangle extends ShapeBase
{
	public var direction (default, setDirection)	: TriangleDirection;
	
	
	public function new (?layout, ?fill, ?border, ?direction:TriangleDirection)
	{
		super(layout, fill, border);
		this.direction = direction;
	}
	
	
	override private function drawShape (target, x, y, width, height) : Void
	{
#if flash9
		var a:IntPoint = new IntPoint(), 
			b:IntPoint = new IntPoint(), 
			c:IntPoint = new IntPoint();
		
		switch (direction) {
			case LeftCenter:
				a.x = x + width;
				a.y = y;
				b.x = x;
				b.y = (y + height) * .5;
				c.x = a.x;
				c.y = y + height;
		
			case RightCenter:
				a.x = x;
				a.y = y;
				b.x = x + width;
				b.y = (y + height) * .5;
				c.x = x;
				c.y = y + height;
		
			case BottomCenter:
				a.x = x;
				a.y = y;
				b.x = x + width;
				b.y = y;
				c.x = (x + width) * .5;
				c.y = y + height;
		
			case TopCenter:
				a.x = x;
				a.y = height;
				b.x = (x + width) * .5;
				b.y = y;
				c.x = x + width;
				c.y = y + height;
			
			case TopLeftCorner:
				a.x = x;
				a.y = y;
				b.x = x + width;
				b.y = y;
				c.x = x;
				c.y = y + height;
			
			case TopRightCorner:
				a.x = x + width;
				a.y = y;
				b.x = x + width;
				b.y = y + height;
				c.x = x;
				c.y = y;
			
			case BottomLeftCorner:
				a.x = x;
				a.y = y + height;
				b.x = x + width;
				b.y = y + height;
				c.x = x;
				c.y = y;
			
			case BottomRightCorner:
				a.x = x + width;
				a.y = y + height;
				b.x = x + width;
				b.y = y;
				c.x = x;
				c.y = y + height;
		}
		
	#if flash10
		target.graphics.drawTriangles( new flash.Vector<Float>( a.x, a.y, b.x, b.y, c.x, c.y ) );
	#else
		target.graphics.moveTo( a.x, a.y );
		target.graphics.lineTo( b.x, b.y );
		target.graphics.lineTo( c.x, c.y );
		target.graphics.lineTo( a.x, a.y );
	#end
#end
	}
	
	
	private inline function setDirection (v:TriangleDirection)
	{
		if (v != direction) {
			direction = v;
			invalidate( GraphicFlags.SHAPE_CHANGED );
		}
		return v;
	}
}