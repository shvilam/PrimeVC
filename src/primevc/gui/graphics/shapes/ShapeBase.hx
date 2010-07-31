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
 import primevc.core.geom.IRectangle;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.GraphicElement;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.gui.layout.LayoutClient;
 import primevc.gui.traits.IDrawable;



/**
 * Base class for shapes
 * 
 * @author Ruben Weijers
 * @creation-date Aug 01, 2010
 */
class ShapeBase extends GraphicElement, implements IShape
{
	public var fill		(default, setFill)		: IFill;
	public var border	(default, setBorder)	: IBorder;
	public var layout	(default, setLayout)	: LayoutClient;
	
	
	public function new (?layout:LayoutClient, ?fill:IFill, ?border:IBorder)
	{
		super();
		this.layout	= layout;
		this.fill	= fill;
		this.border	= border;
	}
	
	
	public function draw (target:IDrawable, ?useCoordinates:Bool = false) : Void
	{
		Assert.notNull(layaut);
		changes = 0;
		
		if (border != null)		border.begin();
		if (fill != null)		fill.begin();
		
		var l = layout.bounds;
		var x = useCoordinates ? l.left : 0;
		var y = useCoordinates ? l.top : 0;
		
		drawShape( target, x, y, l.width, l.height );
		
		if (border != null)		border.end();
		if (fill != null)		fill.end();
	}
	
	
	private function drawShape (target:IDrawable, x:Int, y:Int, width:Int, height:Int) : Void
	{
		Assert.that(false, "Method 'drawShape' should be overwritten.");
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setFill (v:IFill)
	{
		if (v != fill)
		{
			if (fill != null)
				fill.listeners.remove(this);

			fill = v;
			if (fill != null)
				fill.listeners.add(this);

			invalidate( GraphicFlags.FILL_CHANGED );
		}
		return v;
	}
	
	
	private inline function setBorder (v:IBorder)
	{
		if (v != border)
		{
			if (border != null)
				border.listeners.remove(this);

			border = v;
			if (border != null)
				border.listeners.add(this);

			invalidate( GraphicFlags.BORDER_CHANGED );
		}
		return v;
	}
	
	
	private inline function setLayout (v:LayoutClient)
	{
		if (v != layout)
		{
			layout = v;
			invalidate( GraphicFlags.LAYOUT_CHANGED );
		}
		return v;
	}
}