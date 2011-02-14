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
 import primevc.core.Bindable;
 import primevc.gui.core.UIDataComponent;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.graphics.fills.BitmapFill;
 import primevc.types.Bitmap;
 import primevc.types.RGBA;
  using primevc.utils.Bind;
  using primevc.utils.Color;
  using primevc.utils.NumberMath;
  using primevc.utils.TypeUtil;


/**
 * @author			Ruben Weijers
 * @creation-date	Feb 14, 2011
 */
class ColorPicker extends UIDataComponent<Bindable<RGBA>>
{
	private var beginBinding	: Wire<Dynamic>;
	private var updateBinding	: Wire<Dynamic>;
	private var stopBinding		: Wire<Dynamic>;
	
	private var spectrum		: Bitmap;
	
	
	public function new (id:String = null)
	{
		super(id, new Bindable<RGBA>(0x00));
	}
	
	
	override public function dispose ()
	{
		if (isInitialized()) {
			beginBinding.dispose();
			updateBinding.dispose();
			stopBinding.dispose();
			
			spectrum		= null;
			beginBinding	= updateBinding = stopBinding = null;
		}
		super.dispose();
	}
	
	
	override private function init ()
	{
		super.init();
#if debug
		Assert.notNull( graphicData.fill, "Make sure you set a bitmapfill with a colorspectrum as background" );
		Assert.that( graphicData.fill.is(BitmapFill), "Make sure you set a bitmapfill with a colorspectrum as background" );
#end
		spectrum = graphicData.fill.as(BitmapFill).bitmap;
	}
	
	
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
		return spectrum.data.getPixel( x.roundFloat(), y.roundFloat() );
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
		data.value = getColorAt( mouse.local.x, mouse.local.y );
	}
	
	
	private function stopUpdating (mouse:MouseState) : Void 
	{
		beginBinding.enable();
		updateBinding.disable();
		stopBinding.disable();
	}
}