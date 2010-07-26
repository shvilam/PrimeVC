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
 import primevc.core.geom.Point;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.algorithms.directions.Vertical;
 import primevc.gui.layout.algorithms.IVerticalAlgorithm;
 import primevc.gui.layout.algorithms.LayoutAlgorithmBase;
 import primevc.gui.layout.LayoutFlags;
 import primevc.utils.IntMath;
  using primevc.utils.BitUtil;
  using primevc.utils.IntMath;
  using primevc.utils.IntUtil;
  using primevc.utils.TypeUtil;
 

/**
 * Algorithm to place layoutClients in a horizontal circle
 * 
 * @creation-date	Jul 7, 2010
 * @author			Ruben Weijers
 */
class VerticalCircleAlgorithm extends LayoutAlgorithmBase, implements IVerticalAlgorithm
{
	public var direction	(default, setDirection)		: Vertical;
	
	
	public function new ( ?direction )
	{
		super();
		this.direction = direction == null ? Vertical.top : direction;
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	/**
	 * Setter for direction property. Method will change the apply method based
	 * on the given direction. After that it will dispatch a 'directionChanged'
	 * signal.
	 */
	private inline function setDirection (v) {
		if (v != direction) {
			direction = v;
			algorithmChanged.send();
		}
		return v;
	}
	
	
	
	//
	// LAYOUT
	//
	
	/**
	 * Method indicating if the size is invalidated or not.
	 */
	public inline function isInvalid (changes:Int)	: Bool
	{
		return changes.has( LayoutFlags.HEIGHT_CHANGED ) && group.childHeight.notSet();
	}
	
	
	public inline function measure ()
	{
		if (group.children.length == 0)
			return;
		
		measureHorizontal();
		measureVertical();
	}
	
	
	public inline function measureHorizontal ()
	{
		var width:Int = group.childWidth;
		
		if (group.childWidth.notSet())
		{
			for (child in group.children)
				if (child.includeInLayout && child.bounds.width > width)
					width = child.bounds.width;
		}
		
		setGroupWidth(width);
	}
	
	
	public inline function measureVertical ()
	{
		var height:Int = 0;
		
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
		
		setGroupHeight(height);
	}
	
	
	public inline function apply ()
	{
		switch (direction) {
			case Vertical.top:		applyTopToBottom();
			case Vertical.center:	applyCentered();
			case Vertical.bottom:	applyBottomToTop();
		}
		measurePrepared = false;
	}
	
	
	private inline function applyCircle (startRadians)
	{
		if (group.children.length > 0)
		{
			var childAngle		= (360 / group.children.length) * (Math.PI / 180);		//in radians
			var angle:Float		= 0;
			var radius:Int		= Std.int( group.height * .5 );
			var i:Int			= 0;
			var pos:Int			= 0;
			var start			= getTopStartValue() + radius;
			
			for (child in group.children)
			{
				if (!child.includeInLayout)
					continue;
				
				angle	= (childAngle * i);
				pos		= start + Std.int( radius * Math.sin(angle + startRadians) );
				
			//	trace("pos: " + pos + " - halfH: " + radius + " - PI: " + Math.PI + ", angle " + angle+ "; childAngle: "+childAngle+"; start: "+startRadians);
				var halfChildHeight	= Std.int( child.bounds.height * .5 );
				var doCenter		= pos.isWithin( radius - halfChildHeight, radius + halfChildHeight );
				
				if		(doCenter)				child.bounds.centerY	= pos;
				else if	(pos > radius)			child.bounds.bottom		= pos;
				else							child.bounds.top		= pos;
				i++;
			}
		}
	}
	
	
	private inline function applyTopToBottom ()	: Void		{ applyCircle( 0 ); }				//   0 degrees
	private inline function applyCentered ()	: Void		{ applyCircle( -Math.PI / 2 ); }	//- 90 degrees
	private inline function applyBottomToTop () : Void		{ applyCircle( -Math.PI ); }		//-180 degrees
	
	
	public inline function getDepthForPosition (pos:Point) {
		return group.children.length;
	}
	
	
	
	//
	// START VALUES
	//
	
	private inline function getTopStartValue ()		: Int
	{
		var top:Int = 0;
		if (group.padding != null)
			top = group.padding.top;
		
		return top;
	}
	
	
	private inline function getBottomStartValue ()	: Int	{
		var h:Int = group.height;
		if (group.is(AdvancedLayoutClient))
			h = IntMath.max(group.as(AdvancedLayoutClient).measuredHeight, h);
		
		if (group.padding != null)
			h += group.padding.top; // + group.padding.bottom;
		
		return h;
	}
	
	
#if debug
	public function toString ()
	{
		var start = direction == Vertical.top ? "top" : "bottom";
		var end = direction == Vertical.top ? "bottom" : "top";
		return "circle.ver ( " + start + " -> " + end + " ) ";
	}
#end
}