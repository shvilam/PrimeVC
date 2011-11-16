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
package primevc.gui.utils;
 import apparat.math.FastMath;
 import primevc.gui.traits.IGraphicsOwner;
  using apparat.math.FastMath;
  using primevc.utils.Formulas;
  using primevc.utils.NumberUtil;



/**
 * Helper class for drawings..
 * 
 * @author Ruben Weijers
 * @creation-date Apr 19, 2011
 */
class GraphicsUtil
{
	/**
	 * @param rotation		Rotation of the polygon in radians
	 */
	public static inline function drawArc (target:IGraphicsOwner, x:Float = 0, y:Float = 0, radius:Float = 1, percentage:Float = 1, rotation:Float = 0)
	{
#if flash9
		var g = target.graphics;
		
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		var segments		= (percentage * 8).ceilFloat();
		var segAngle		= ((percentage * 360) / segments).degreesToRadians();
		var halfSegAngle	= segAngle * .5;	//cached calculation needed to calculate the curve anchors
		var anchorRadius	= radius / halfSegAngle.cos();
		
		//move to the center of the circle
		g.moveTo( x, y );
		//draw first line from center to the outside of the arc
		g.lineTo( getCircleX(x, rotation, radius), getCircleY( y, rotation, radius ) );
		
		//draw the arc
		for (i in 0...segments)
		{
			rotation   			+= segAngle;
			var halfRotation	 = rotation - halfSegAngle;
			g.curveTo(
				getCircleX( x, halfRotation, anchorRadius ),
				getCircleY( y, halfRotation, anchorRadius ),
				getCircleX( x, rotation, radius ),
				getCircleY( y, rotation, radius )
			);
		}
		
		//close the arc
		g.lineTo( x, y );
#end
	}
	
	
	
	/**
	 * @param rotation		Rotation of the polygon in radians
	 */
	public static inline function drawEllipseArc (target:IGraphicsOwner, x:Float = 0, y:Float = 0, radiusX:Float = 1, radiusY:Float = 1, percentage:Float = 1, rotation:Float = 0)
	{
#if flash9
		var g = target.graphics;
		
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		var segments		= (percentage * 8).ceilFloat();
		var segAngle		= ((percentage * 360) / segments).degreesToRadians();
		var halfSegAngle	= segAngle * .5;	//cached calculation needed to calculate the curve anchors
		var anchorRadiusX	= radiusX / halfSegAngle.cos();
		var anchorRadiusY	= radiusY / halfSegAngle.cos();
		
		//move to the center of the circle
		g.moveTo( x, y );
		//draw first line from center to the outside of the arc
		g.lineTo( getCircleX(x, rotation, radiusX), getCircleY( y, rotation, radiusY ) );
		
		//draw the arc
		for (i in 0...segments)
		{
			rotation   			+= segAngle;
			var halfRotation	 = rotation - halfSegAngle;
			g.curveTo(
				getCircleX( x, halfRotation, anchorRadiusX ),
				getCircleY( y, halfRotation, anchorRadiusY ),
				getCircleX( x, rotation, radiusX ),
				getCircleY( y, rotation, radiusY )
			);
		}
		
		//close the arc
		g.lineTo( x, y );
#end
	}
	
	
	/**
	 * @param rotation		Rotation of the polygon in radians
	 */
	public static inline function drawPolygon (target:IGraphicsOwner, sides:Int, x:Float = 0, y:Float = 0, radius:Float = 1, rotation:Float = 0)
	{
#if flash9
		var g = target.graphics;
		
		//move to the last point of the polygon
		var angle = FastMath.DOUBLE_PI + rotation;
		g.moveTo( getCircleX(x, angle, radius), getCircleY( y, angle, radius ) );
		
		//draw all the sides
		for (i in 0...sides)
			drawPolygonLine( g, i / sides, x, y, radius, rotation );
#end
	}
	
	
	/**
	 * Method draws a part of a polygon
	 */
	public static inline function drawPolygonFraction (target:IGraphicsOwner, sides:Int, x:Float = 0, y:Float = 0, radius:Float = 1, percentage:Float = 1, rotation:Float = 0)
	{
#if flash9
		var g = target.graphics;
		//move to the center of the polygon
		g.moveTo( x, y );
		
		//first draw the sides of the polygon that are complete
		var sidesToDraw = (percentage * sides).ceilFloat();
		for (i in 0...sidesToDraw)
			drawPolygonLine( g, i / sides, x, y, radius, rotation );
		
		//draw the fractioned side of the polygon
		if ((percentage * sides) != sidesToDraw)
			drawPolygonLine( g, percentage, x, y, radius, rotation );
		
		//draw last line to close the polygon
		g.lineTo( x, y );
#end
	}
	
	
#if flash9
	/**
	 * Method draws a line for a polygon.
	 * @param	target
	 * @param	percentage		indicates the percentage of the angle of the polygon-line (0.5 = bottom center of polygon, 0.25 is the first quarter of the polygon, etc.)
	 * @param	radius			radius of the polygon
	 */
	private static inline function drawPolygonLine (g:flash.display.Graphics, percentage:Float, x:Float, y:Float, radius:Float, rotation:Float)
	{
		var angle = (percentage * FastMath.DOUBLE_PI) + rotation;
		g.lineTo( getCircleX( x, angle, radius ), getCircleY( y, angle, radius ) );
	}
	
	
	private static inline function getCircleX (x:Float, angle:Float, radius:Float) : Float		{ return x + (angle.cos() * radius); }
	private static inline function getCircleY (y:Float, angle:Float, radius:Float) : Float		{ return y + (angle.sin() * radius); }
#end
}