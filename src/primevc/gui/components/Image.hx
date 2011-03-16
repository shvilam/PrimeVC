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
#if flash9
 import flash.geom.ColorTransform;
#end
 import primevc.gui.core.IUIDataElement;
 import primevc.gui.core.UIElementFlags;
 import primevc.gui.core.UIGraphic;
 import primevc.gui.graphics.fills.BitmapFill;
 import primevc.gui.graphics.fills.SolidFill;
 import primevc.gui.graphics.shapes.RegularRectangle;
 import primevc.gui.graphics.GraphicProperties;
 import primevc.gui.graphics.IGraphicElement;
 import primevc.gui.layout.AdvancedLayoutClient;
 import primevc.gui.layout.LayoutFlags;
 import primevc.types.Asset;
 import primevc.types.Number;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.Color;
  using primevc.utils.TypeUtil;


/**
 * @author Ruben Weijers
 * @creation-date Oct 31, 2010
 */
class Image extends UIGraphic, implements IUIDataElement < Asset >
{
	public var data					(default, setData) : Asset;
	
	/**
	 * Bool indicating wether the image should maintain it's aspect-ratio
	 * @default true
	 */
	public var maintainAspectRatio	(default, setMaintainAspectRatio)	: Bool;
	
	
	public function new (id:String = null, data:Asset = null)
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
			else
				updateSize();	//data is set to null
		}
		
		super.validate();
	}
	
	
	override private function createLayout ()	{ layout = new AdvancedLayoutClient(); }
	public function getDataCursor ()			{ return null; }
	
	
	private function initData () : Void
	{
		if (!data.state.is(AssetStates.ready))
			assetStateChangeHandler.on( data.state.change, this );
		else
			updateSize();
	//	bitmapStateChangeHandler( data.state.current, null );
		
		if (graphicData.fill == null || !graphicData.fill.is(BitmapFill))
			graphicData.fill = new BitmapFill( data, null, false );
		
		else if (graphicData.fill.is(BitmapFill))
			graphicData.fill.as(BitmapFill).asset = data;	
	}
	
	
	private function removeData () : Void
	{
		data.state.change.unbind(this);
		if (graphicData.fill.is(BitmapFill))
			graphicData.fill = null; //.as(BitmapFill).bitmap = null;
	}
	
	
	public function colorize (fill:IGraphicElement)
	{
#if flash9
		if (fill == null || !fill.is(SolidFill))
			return;
		
		var a = alpha;
		var t = new ColorTransform();
		t.color						= fill.as(SolidFill).color.rgb();
		t.alphaMultiplier			= a;
		transform.colorTransform	= t;
#end
	}
	
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function setData (v:Asset)
	{
		if (v != data)
		{
			if (data != null && window != null)
				removeData();
			
			data = v;
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
		
		if (data != null && data.state.is( AssetStates.ready ))
		{
		//	if (id.value == "Image70")
		//		trace(container+"."+this+"; "+data.data.width+", "+data.data.height+"; expl size? "+l.explicitWidth+", "+l.explicitHeight+"; size: "+l.width+", "+l.height+"; padding: "+l.padding+"; margin:"+l.margin);
		//		trace("\t\t\twidthBounds: "+layout.widthValidator+"; heightBounds: "+layout.heightValidator+"; aspect: "+layout.aspectRatio);
			l.maintainAspectRatio	= maintainAspectRatio;
			l.measuredResize( data.data.width, data.data.height );
		//	if (id.value == "Image70")
		//	trace("\t\t\t measured: "+l.measuredWidth+", "+l.measuredHeight+"; explicit: "+l.explicitWidth+", "+l.explicitHeight+"; size: "+l.width+", "+l.height+"; name: "+l.name);
		}
		else
		{	
			l.maintainAspectRatio	= false;
			l.measuredWidth			= Number.INT_NOT_SET;
			l.measuredHeight		= Number.INT_NOT_SET;
		}
	//	trace("\t\t\t measured: "+this+"; "+l.measuredWidth+", "+l.measuredHeight);
	}
	
	
	private function assetStateChangeHandler (newState:AssetStates, oldState:AssetStates)
	{
		switch (newState)
		{
			case AssetStates.ready:	updateSize();
			case AssetStates.empty:	updateSize();
			default:
		}
	}
}