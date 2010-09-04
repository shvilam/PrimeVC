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
 import haxe.FastList;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.geom.IRectangle;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.gui.graphics.IGraphicElement;
 import primevc.gui.traits.IDrawable;
  using primevc.utils.BitUtil;
  using Math;
  using Std;



/**
 * Base class for shapes
 * 
 * @author Ruben Weijers
 * @creation-date Aug 01, 2010
 */
class ShapeBase implements IGraphicShape
{
	public var changes		(default, null)			: UInt;
	public var listeners	(default, null)			: FastList< IGraphicElement >;
	public var changeEvent	(default, null)			: Signal0;
	
	public var fill			(default, setFill)		: IFill;
	public var border		(default, setBorder)	: IBorder <IFill>;
	public var layout		(default, setLayout)	: IRectangle;
	
	
	public function new (?layout:IRectangle, ?fill:IFill, ?border:IBorder <IFill>)
	{
		listeners	= new FastList< IGraphicElement >();
		this.layout	= layout;
		this.fill	= fill;
		this.border	= border;
		changeEvent	= new Signal0();
		changes		= 0;
	}
	
	
	public function dispose ()
	{
		if (border != null)	border.dispose();
		if (fill != null)	fill.dispose();
		
		changeEvent.dispose();
		changeEvent	= null;
		listeners	= null;
		border		= null;
		fill		= null;
		layout		= null;
	}
	
	
	public inline function invalidate (change:UInt) : Void
	{
		if (listeners != null)
		{
			changes = changes.set(change);
			for (listener in listeners)
				listener.invalidate( change );
			
			if (changeEvent != null)
				changeEvent.send();
		}	
	}
	
	
	public function draw (target:IDrawable, ?useCoordinates:Bool = false) : Void
	{
		Assert.notNull(layout);
		changes = 0;
		
		var l = layout;
		var x = useCoordinates ? l.left : 0;
		var y = useCoordinates ? l.top : 0;
		var w = l.width;
		var h = l.height;
		
		if (border != null) {
			border.begin(target, l);
			if (border.innerBorder) {
				x += border.weight.ceil().int();
				y += border.weight.ceil().int();
				w -= (border.weight * 2).ceil().int();
				h -= (border.weight * 2).ceil().int();
			}
		}
		if (fill != null)
			fill.begin(target, l);
		
		drawShape( target, x, y, w, h );
		
		if (border != null)		border.end(target);
		if (fill != null)		fill.end(target);
	}
	
	
	
	/**
	 * Method to overwrite in sub-shape-clases
	 */
	private function drawShape (target:IDrawable, x:Int, y:Int, width:Int, height:Int) : Void
	{
		Assert.abstract();
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
	
	
	private inline function setBorder (v)
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
	
	
	private inline function setLayout (v:IRectangle)
	{
		if (v != layout)
		{
			layout = v;
			invalidate( GraphicFlags.LAYOUT_CHANGED );
		}
		return v;
	}
}