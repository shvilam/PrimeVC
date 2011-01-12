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
 import primevc.gui.core.IUIDataElement;
 import primevc.gui.core.UIElementFlags;
 import primevc.gui.core.UIGraphic;
 import primevc.gui.graphics.fills.BitmapFill;
 import primevc.gui.graphics.shapes.RegularRectangle;
 import primevc.gui.graphics.GraphicProperties;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.types.Bitmap;
 import primevc.types.Number;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.TypeUtil;


/**
 * @author Ruben Weijers
 * @creation-date Oct 31, 2010
 */
class Image extends UIGraphic, implements IUIDataElement < Bitmap >
{
	public var data					(default, setData) : Bitmap;
	
	/**
	 * Bool indicating wether the image should maintain it's aspect-ratio
	 * @default true
	 */
	public var maintainAspectRatio	(default, setMaintainAspectRatio)	: Bool;
	
	
	public function new (id:String = null, data:Bitmap = null)
	{
		super(id);
		this.data = data;
		this.maintainAspectRatio = true;
	}
	
	
	override public function dispose ()
	{
		if (data != null)
			data = null;

		super.dispose();
	}
	
	
	override public function validate ()
	{
		if (changes.has( UIElementFlags.DATA ))
		{
			if (data != null)
				initData();
			
			updateSize();
		}
		
		super.validate();
	}
	
	
	override private function createLayout ()	{ layout = new AdvancedLayoutClient(); }
	public function getDataCursor ()			{ return null; }
	
	
	private function initData () : Void
	{
		bitmapStateChangeHandler.on( data.state.change, this );
	//	bitmapStateChangeHandler( data.state.current, null );
		
		if (graphicData.fill == null || !graphicData.fill.is(BitmapFill))
			graphicData.fill = new BitmapFill( data, null, false );
		
		else if (graphicData.fill.is(BitmapFill))
			graphicData.fill.as(BitmapFill).bitmap = data;	
	}
	
	
	private function removeData () : Void
	{
		data.state.change.unbind(this);
		if (graphicData.fill.is(BitmapFill))
			graphicData.fill.as(BitmapFill).bitmap = null;
	}
	
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setData (v:Bitmap)
	{
		if (v != data)
		{
			if (data != null && window != null)
				removeData();
			
			data = v;
		//	trace(this+".invalidateData "+v);
			invalidate( UIElementFlags.DATA );
		}
		
		return v;
	}
	
	
	private inline function setMaintainAspectRatio (v:Bool) : Bool
	{
		if (v != maintainAspectRatio)
		{
			maintainAspectRatio = v;
			if (layout != null)
				layout.maintainAspectRatio = v;
		}
		return v;
	}
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private inline function updateSize ()
	{
		var l = layout.as(AdvancedLayoutClient);
		if (data.state.is( BitmapStates.ready ))
		{
		//	trace("Image.updateSize; "+data.data.width+", "+data.data.height+"; expl size? "+l.explicitWidth+", "+l.explicitHeight);
			l.maintainAspectRatio	= maintainAspectRatio;
			l.measuredResize( data.data.width, data.data.height );
		}
		else
		{	
			l.maintainAspectRatio	= false;
			l.measuredWidth			= Number.INT_NOT_SET;
			l.measuredHeight		= Number.INT_NOT_SET;
		}
	}
	
	
	private function bitmapStateChangeHandler (newState:BitmapStates, oldState:BitmapStates)
	{
	//	trace(this+".bitmapStateChangeHandler "+data.state.current);
		switch (newState)
		{
			case BitmapStates.ready:	updateSize();
			case BitmapStates.empty:	updateSize();
			default:
		}
	}
}