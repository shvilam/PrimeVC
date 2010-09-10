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
package primevc.gui.graphics;
 import haxe.FastList;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.geom.IRectangle;
 import primevc.core.traits.IInvalidatable;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.shapes.IGraphicShape;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.gui.traits.IDrawable;
  using primevc.utils.BitUtil;
  using Math;
  using Std;



/**
 * Collection of a fill, border, layout and shape object.
 * Object can fire an event when a property in one of these objects is changed.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 09, 2010
 */
class GraphicProperties implements IGraphicElement
{
	public var changes		(default, null)			: UInt;
	public var listeners	(default, null)			: FastList< IInvalidatable >;
	/**
	 * Signal to notify other objects than IGraphicElement of changes within
	 * the shape.
	 */
	public var changeEvent	(default, null)			: Signal0;

	public var fill			(default, setFill)		: IFill;
	public var border		(default, setBorder)	: IBorder < IFill >;
	public var shape		(default, setShape)		: IGraphicShape;
	public var layout		(default, setLayout)	: IRectangle;
	
	
	public function new (shape:IGraphicShape = null, layout:IRectangle = null, fill:IFill = null, border:IBorder <IFill> = null)
	{
		listeners	= new FastList< IInvalidatable >();
		this.shape	= shape;
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
	
	
	/**
	* @param	target
	* target in which the graphics will be drawn
	* 
	* @param	useCoordinates
	 * Flag indicating if the draw method should also use the coordinates of the
	 * layoutclient.
	 * 
	 * If a shape is directly drawn into a IDrawable element, this is not the 
	 * case. If a shape is part of a composition of shapes, then the shape 
	 * should respect the coordinates of the LayoutClient.
	 */
	public function draw (target:IDrawable, ?useCoordinates:Bool = false) : Void
	{
		Assert.notNull(layout);
		Assert.notNull(shape);
		
		changes = 0;

		var l = layout;
		var x = useCoordinates ? l.left : 0;
		var y = useCoordinates ? l.top : 0;
		var w = l.width;
		var h = l.height;

		if (border != null) {
			if (border.innerBorder) {
				x += border.weight.ceil().int();
				y += border.weight.ceil().int();
				w -= (border.weight * 2).ceil().int();
				h -= (border.weight * 2).ceil().int();
			}
		}
		
		beginDraw( target );
		shape.draw( target, x, y, w, h );
		endDraw( target );
	}
	
	
	private inline function beginDraw (target:IDrawable)
	{
		if (border != null)		border.begin(target, layout);
		if (fill != null)		fill.begin(target, layout);
	}
	
	private inline function endDraw (target:IDrawable)
	{
		if (border != null)		border.end(target);
		if (fill != null)		fill.end(target);
	}


	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setShape (v:IGraphicShape)
	{
		if (v != shape)
		{
			if (shape != null)
				shape.listeners.remove(this);

			shape = v;
			if (shape != null)
				shape.listeners.add(this);

			invalidate( GraphicFlags.SHAPE );
		}
		return v;
	}
	
	
	private inline function setFill (v:IFill)
	{
		if (v != fill)
		{
			if (fill != null)
				fill.listeners.remove(this);

			fill = v;
			if (fill != null)
				fill.listeners.add(this);

			invalidate( GraphicFlags.FILL );
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

			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}


	private inline function setLayout (v:IRectangle)
	{
		if (v != layout)
		{
			layout = v;
			invalidate( GraphicFlags.LAYOUT );
		}
		return v;
	}
}