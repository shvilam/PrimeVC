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
 import primevc.core.dispatcher.Signal1;
 import primevc.core.geom.Corners;
 import primevc.core.geom.IntRectangle;
 import primevc.core.geom.RectangleFlags;
 import primevc.core.traits.IInvalidatable;
 import primevc.core.traits.IInvalidateListener;
 import primevc.gui.graphics.borders.IBorder;
 import primevc.gui.graphics.shapes.IGraphicShape;
 import primevc.gui.graphics.GraphicFlags;
 import primevc.gui.traits.IGraphicsOwner;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


#if neko
 import primevc.tools.generator.ICodeGenerator;
#end
#if (debug || neko)
 import primevc.utils.StringUtil;
#end



/**
 * Collection of a fill, border, layout and shape object.
 * Object can fire an event when a property in one of these objects is changed.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 09, 2010
 */
class GraphicProperties implements IGraphicElement
{
	public var uuid			(default, null)				: String;
	public var listeners	(default, null)				: FastList< IInvalidateListener >;
	/**
	 * Signal to notify other objects than IGraphicElement of changes within
	 * the shape.
	 */
	public var changeEvent	(default, null)				: Signal1 < Int >;

	public var fill			(default, setFill)			: IGraphicProperty;
	public var border		(default, setBorder)		: IBorder;
	public var shape		(default, setShape)			: IGraphicShape;
	public var layout		(default, setLayout)		: IntRectangle;
	public var borderRadius	(default, setBorderRadius)	: Corners;
	
	
	public function new (layout:IntRectangle = null, shape:IGraphicShape = null, fill:IGraphicProperty = null, border:IBorder = null, borderRadius:Corners = null)
	{
#if (debug || neko)
		uuid = StringUtil.createUUID();
#end
		listeners			= new FastList< IInvalidateListener >();
		this.shape			= shape;
		this.layout			= layout;
		this.fill			= fill;
		this.border			= border;
		this.borderRadius	= borderRadius;
		changeEvent			= new Signal1();
	}
	
	
	public function dispose ()
	{
		while (!listeners.isEmpty())
			listeners.pop();
		
		changeEvent.dispose();
		changeEvent	= null;
		listeners	= null;
		borderRadius= null;
		border		= null;
		fill		= null;
		layout		= null;
#if (debug || neko)
		uuid		= null;
#end
	}
	

	public function invalidate (change:Int) : Void
	{
		if (change <= 0)
			return;
		
		if (listeners != null)
			for (listener in listeners)
				listener.invalidateCall( change, this );
		
		if (changeEvent != null)
			changeEvent.send( change );
	}
	
	
	public function invalidateCall (changeFromOther:Int, sender:IInvalidatable) : Void
	{
		var change = switch (sender) {
			case cast border:	GraphicFlags.BORDER;
			case cast shape:	GraphicFlags.SHAPE;
			case cast fill:		GraphicFlags.FILL;
			case cast layout:
				if (changeFromOther.has( RectangleFlags.WIDTH | RectangleFlags.HEIGHT ))
					GraphicFlags.LAYOUT;
				else
					0;
			default: 0;
		}
		invalidate( change );
	}
	
	
	/**
	* @param	target
	* target in which the graphics will be drawn
	* 
	* @param	useCoordinates
	 * Flag indicating if the draw method should also use the coordinates of the
	 * layoutclient.
	 * 
	 * If a shape is directly drawn into a IGraphicsOwner element, this is not the 
	 * case. If a shape is part of a composition of shapes, then the shape 
	 * should respect the coordinates of the LayoutClient.
	 */
	public function draw (target:IGraphicsOwner, ?useCoordinates:Bool = false) : Void
	{
#if debug
		Assert.notNull(layout, "layout is null for "+target);
		Assert.notNull(shape, "shape is null for "+target);
	//	Assert.notThat(border == null && fill == null, "Graphic property must have a border or a fill when drawing to "+target);
#end
		if (layout == null || shape == null || (border == null && fill == null))
			return;
		
	//	trace(target+".drawing; "+target.rect.width+", "+target.rect.height);
		var layout:IntRectangle = cast this.layout.clone();
		if (!useCoordinates)
			layout.left = layout.top = 0;
		
		Assert.that( layout.width.isSet() );
		Assert.that( layout.height.isSet() );
		
		var hasComposedFill		= fill != null && fill.is(IComposedGraphicProperty);
		var hasComposedBorder	= border != null && border.is(IComposedGraphicProperty);
		
		//if both the fill and shape aren't a list of fills or borders, use only one draw operation to draw the properties
		if (!hasComposedFill && !hasComposedBorder)
		{
			if (border != null)		border.begin( target, layout );
			if (fill != null)		fill.begin( target, layout );
			
			shape.draw( target, layout, borderRadius );
			
			if (border != null)		border.end( target, layout );
			if (fill != null)		fill.end( target, layout );
		}
		else
		{
			if (fill != null)
			{
				//if there is more then one fill, the draw method needs to be called multiple times
				if (hasComposedFill)
				{
					//draw fills in loop
					var cFill = fill.as(IComposedGraphicProperty);
					cFill.rewind();
					while (cFill.hasNext())
						drawFill( target, cFill, layout );
				}
				else
					drawFill( target, fill, layout );
			}
			
			
			if (border != null)
			{
				//if there is more then one border, the draw method needs to be called multiple times
				if (hasComposedBorder)
				{
					//draw fills in loop
					var cBorder = border.as(IComposedGraphicProperty);
					cBorder.rewind();
					while (cBorder.hasNext())
						drawBorder( target, border, layout );
				}
				else
					drawBorder( target, border, layout );
			}
		}
	}
	
	
	private inline function drawFill (target:IGraphicsOwner, fill:IGraphicProperty, layout:IntRectangle)
	{
		fill.begin( target, layout );
		shape.draw( target, layout, borderRadius );
		fill.end( target, layout );
	}
	
	
	private inline function drawBorder (target:IGraphicsOwner, border:IBorder, layout:IntRectangle)
	{
		border.begin( target, layout );
		shape.draw( target, layout, borderRadius );
		border.end( target, layout );
	}
	


	//
	// GETTERS / SETTERS
	//
	
	
	private inline function setShape (v:IGraphicShape)
	{
		if (v != shape)
		{
			if (shape != null && shape.listeners != null)
				shape.listeners.remove(this);

			shape = v;
			if (shape != null)
				shape.listeners.add(this);

			invalidate( GraphicFlags.SHAPE );
		}
		return v;
	}
	
	
	private inline function setFill (v:IGraphicProperty)
	{
		if (v != fill)
		{
			if (fill != null && fill.listeners != null)
				fill.listeners.remove(this);
			
			fill = v;
			if (fill != null)
				fill.listeners.add(this);

			invalidate( GraphicFlags.FILL );
		}
		return v;
	}


	private inline function setBorder (v:IBorder)
	{
		if (v != border)
		{
			if (border != null && border.listeners != null)
				border.listeners.remove(this);

			border = v;
			if (border != null)
				border.listeners.add(this);

			invalidate( GraphicFlags.BORDER );
		}
		return v;
	}


	private inline function setLayout (v)
	{
		if (v != layout)
		{
			if (layout != null)
				layout.listeners.remove(this);

			layout = v;
			if (layout != null)
				layout.listeners.add(this);
			
			invalidate( GraphicFlags.LAYOUT );
		}
		return v;
	}
	
	
	private inline function setBorderRadius (v:Corners)
	{
		if (v != borderRadius) {
			borderRadius = v;
			invalidate( GraphicFlags.SHAPE );
		}
		return v;
	}
	
	
	public function isEmpty () : Bool
	{
		return (layout == null || layout.isEmpty()) || shape == null;
	}
	
	
#if neko
	public function toString ()						{ return "GraphicProperties: l: "+layout+"; s: "+shape+"; f: "+fill+"; b: "+border; }
	public function toCSS (prefix:String = "")		{ Assert.abstract(); return ""; }
	public function toCode (code:ICodeGenerator)	{ code.construct(this, [ layout, shape, fill, border, borderRadius ]); }
#end
}