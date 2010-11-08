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
package primevc.gui.layout.algorithms.circle;
 import primevc.core.geom.space.Horizontal;
 import primevc.core.geom.space.Vertical;
 import primevc.core.geom.IRectangle;
 import primevc.gui.layout.algorithms.IVerticalAlgorithm;
 import primevc.gui.layout.algorithms.VerticalBaseAlgorithm;
 import primevc.utils.Formulas;
 import primevc.utils.NumberMath;
  using primevc.utils.Formulas;
  using primevc.utils.NumberUtil;
 

/**
 * Algorithm to place layoutClients in a horizontal circle
 * 
 * @creation-date	Jul 7, 2010
 * @author			Ruben Weijers
 */
class VerticalCircleAlgorithm extends VerticalBaseAlgorithm, implements IVerticalAlgorithm
{
	/**
	 * isEllipse defines if the circle that is drawn can be an ellipse or should
	 * always be a complete circle (by using the same radius for both hor and
	 * vertical).
	 * 
	 * @default		true
	 */
	public var isEllipse	(default, null)				: Bool;
	
	
	public function new ( ?direction:Vertical, ?horizontal:Horizontal = null, ?isEllipse:Bool = true )
	{
		super(direction, horizontal);
		this.isEllipse	= isEllipse;
	}
	
	
	
	//
	// LAYOUT
	//
	
	
	public inline function validate ()
	{
		if (group.children.length == 0)
			return;
		
		validateHorizontal();
		validateVertical();
	}
	
	
	public inline function validateVertical ()
	{
		var height:Int = group.height.value;
	/*	
		if (group.childHeight.notSet())
		{
			for (child in group.children)
				if (child.includeInLayout)
					height += child.bounds.height;
		}
		else
		{
			height = group.childHeight * (group.children.length.divCeil(2) + 1);
		}
		*/
		setGroupHeight(height);
	}
	
	
	override public function apply ()
	{
		switch (direction) {
			case Vertical.top:		applyTopToBottom();
			case Vertical.center:	applyCentered();
			case Vertical.bottom:	applyBottomToTop();
		}
		super.apply();
	}
	
	
	private inline function applyCircle (startRadians)
	{
		if (group.children.length > 0)
		{
			var childAngle		= (360 / group.children.length).degreesToRadians();
			var angle:Float		= 0;
			var radius:Int		= getRadius();
			var i:Int			= 0;
			var pos:Int			= 0;
			var start			= getTopStartValue() + getRadius();
			
			for (child in group.children)
			{
				if (!child.includeInLayout)
					continue;
				
				angle	= (childAngle * i) + startRadians;
				pos		= start + Std.int( radius * Math.sin(angle) );
				
				var halfChildHeight	= Std.int( child.outerBounds.height * .5 );
				var doCenter		= pos.isWithin( radius - halfChildHeight, radius + halfChildHeight );
				
				if		(doCenter)				child.outerBounds.centerY	= pos;
				else if	(pos > radius)			child.outerBounds.bottom	= pos;
				else							child.outerBounds.top		= pos;
				i++;
			}
		}
	}
	
	
	private inline function applyTopToBottom ()	: Void		{ applyCircle( 0 ); }				//   0 degrees
	private inline function applyCentered ()	: Void		{ applyCircle( -Math.PI / 2 ); }	//- 90 degrees
	private inline function applyBottomToTop () : Void		{ applyCircle( -Math.PI ); }		//-180 degrees
	
	
	public inline function getDepthForBounds (bounds:IRectangle)
	{
		var childAngle		= (360 / group.children.length).degreesToRadians();
		var posY:Float		= IntMath.max(0, bounds.top - getTopStartValue()) - getRadius();
		var radius:Float	= getRadius();
		var startRadians	= switch (direction) {
			case Vertical.top:	   	0;
			case Vertical.center:	-Math.PI / 2;
			case Vertical.bottom:	-Math.PI;
		}
		
		//the formula of applyCircle reversed..
		var itemRadians = Math.asin(posY / radius) - startRadians;
		return Std.int( Math.round( itemRadians / childAngle ) );
	}
	
	
	
	//
	// START VALUES
	//
	
	private inline function getRadius () : Int {
		return isEllipse ?
			Std.int( group.height.value * .5 ) : 
			Std.int( Math.round( Formulas.getCircleRadius(group.width.value, group.height.value) ) );
	}
	
#if (neko || debug)
	override public function toCSS (prefix:String = "") : String
	{
		return "ver-circle (" + direction + ", " + horizontal + ")";
	}
#end
}