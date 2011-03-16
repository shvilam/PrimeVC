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
package primevc.gui.components;
 import primevc.core.dispatcher.Wire;
 import primevc.core.RevertableBindable;
 import primevc.gui.core.UIDataComponent;
 import primevc.gui.events.MouseEvents;
 import primevc.types.Bitmap;
 import primevc.types.RGBA;
  using primevc.utils.Bind;
  using primevc.utils.Color;
  using primevc.utils.NumberMath;
  using primevc.utils.TypeUtil;


//private typedef DataType = RevertableBindable<RGBA>;


/**
 * @author			Ruben Weijers
 * @creation-date	Feb 14, 2011
 */
class ColorPicker extends UIDataComponent<RevertableBindable<RGBA>>
{
	private var beginBinding	: Wire<Dynamic>;
	private var updateBinding	: Wire<Dynamic>;
	private var stopBinding		: Wire<Dynamic>;
	
	private var spectrum		: Bitmap;
	
	
	public function new (id:String = null, data:RevertableBindable<RGBA> = null)
	{
		if (data == null) {
			data = new RevertableBindable<RGBA>(0x00);
			data.dispatchAfterCommit();
			data.updateBeforeCommit();
			data.beginEdit();		//force the data to be always editable..
		}
		super(id, data);
	}
	
	
	override public function dispose ()
	{
		if (isInitialized()) {
			beginBinding.dispose();
			updateBinding.dispose();
			stopBinding.dispose();
			spectrum.dispose();
			
			spectrum		= null;
			beginBinding	= updateBinding = stopBinding = null;
		}
		super.dispose();
	}
	
	
/*	override private function init ()
	{
		super.init();
#if debug
		Assert.notNull( graphicData.fill, "Make sure you set a bitmapfill with a colorspectrum as background" );
		Assert.that( graphicData.fill.is(BitmapFill), "Make sure you set a bitmapfill with a colorspectrum as background" );
#end
	}*/
	
	
	override private function createBehaviours ()
	{
		super.createBehaviours();
		beginBinding	= beginUpdating.on( userEvents.mouse.down, this );
		updateBinding	= updateColor.on( userEvents.mouse.move, this );
		stopBinding		= stopUpdating.on( userEvents.mouse.up, this );
		
		beginBinding.enable();
		updateBinding.disable();
		stopBinding.disable();
	}
	
	
	private inline function getColorAt( x:Float, y:Float ) : RGBA 
	{
#if flash9
		if (spectrum == null) {
		//	trace(layout.width+", "+layout.height);
			//not sure if this is the best way but using the original bitmapdata from the fill doesnt give correct results since it's unscaled.
		//	spectrum = Bitmap.createEmpty( layout.width, layout.height, false );
		//	spectrum.draw(this);
			spectrum = Bitmap.fromDisplayObject( this, false );
		}
	//	var l = layout.innerBounds;
	//	var b = new BitmapDataType( l.width, l.height, false );
	//	b.draw(this);
	//	addChild( new flash.display.Bitmap(b));
	//	trace(l.width+", "+l.height+"; "+b.getPixel( x.roundFloat(), y.roundFloat() ).uintToString() );
	//	return b.getPixel( x.roundFloat(), y.roundFloat() ).rgbToRgba();
	//	trace( spectrum.data.)
		
		return spectrum.data.getPixel( x.roundFloat(), y.roundFloat() ).rgbToRgba();
#end
	}
	
	
	
	//
	// EVENTHANDLERS FOR UPDATING SELECTED COLOR
	//
	
	
	private function beginUpdating (mouse:MouseState) : Void
	{
		beginBinding.disable();
		updateBinding.enable();
		stopBinding.enable();
		
		updateColor( mouse );
	}
	
	
	private function updateColor (mouse:MouseState) : Void
	{
		//get color underneath mouse
		data.value = data.value.setRgb( getColorAt( mouse.local.x, mouse.local.y ) );
	}
	
	
	private function stopUpdating (mouse:MouseState) : Void 
	{
		beginBinding.enable();
		updateBinding.disable();
		stopBinding.disable();
		
		data.commitEdit();
		data.beginEdit();
	}
}