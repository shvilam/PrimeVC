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
package primevc.gui.components;
 import primevc.gui.core.UIGraphic;
 import primevc.gui.graphics.fills.BitmapFill;
 import primevc.gui.graphics.shapes.RegularRectangle;
 import primevc.gui.graphics.GraphicProperties;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.types.Bitmap;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/**
 * @author Ruben Weijers
 * @creation-date Oct 31, 2010
 */
class Image extends UIGraphic
{
	public var source	(default, setSource) : Bitmap;
	
	
	public function new (id:String = null, source:Bitmap = null)
	{
		super(id);
		this.source = source;
	}
	
	
	override private function createGraphics ()
	{
		Assert.notNull(graphicData.value);
		graphicData.value.fill = new BitmapFill( source );
	}
	
	
	override private function createLayout ()
	{
		layout = new AdvancedLayoutClient();
	}
	
	
	private inline function setSource (v:Bitmap)
	{
		if (source != v)
		{
			if (source != null)
			{
				source.state.change.unbind(this);
				bitmapStateChangeHandler( BitmapStates.empty, null );
				
				if (state.current == state.initialized)
					graphicData.value.fill.as(BitmapFill).bitmap = null;
			}
			
			source = v;
			
			if (v != null)
			{
				bitmapStateChangeHandler.on( v.state.change, this );
				bitmapStateChangeHandler( v.state.current, null );
				
				if (state.current == state.initialized)
					graphicData.value.fill.as(BitmapFill).bitmap = v;
			}
		}
		return v;
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function updateSize ()
	{
		var l = layout.as(AdvancedLayoutClient);
		if (source.state.is( BitmapStates.ready ))
		{
			l.measuredWidth		= source.data.width;
			l.measuredHeight	= source.data.height;
		}
		else
		{
			l.measuredWidth		= 0;
			l.measuredHeight	= 0;
		}
	}
	
	private function bitmapStateChangeHandler (newState:BitmapStates, oldState:BitmapStates)
	{
		switch (newState)
		{
			case BitmapStates.ready:	updateSize();
			case BitmapStates.empty:	updateSize();
			default:
		}
	}
}