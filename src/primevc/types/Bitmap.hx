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
package primevc.types;
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.IDisposable;
 import primevc.gui.display.IDisplayObject;
 import primevc.gui.display.Loader;
  using primevc.utils.Bind;


#if flash9
 import flash.display.BitmapData;
 import flash.display.DisplayObject;
 import primevc.core.geom.Matrix2D;
  using	Std;


typedef FlashBitmap = flash.display.Bitmap;

#end



/**
 * This class makes it easy to load images from several sources, e.g. load from
 * an URL, instantiate from an embedded asset, set the BitmapData directly,
 * give it an Bitmap instance or copy the pixels of a given DisplayObject.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class Bitmap implements IDisposable
{
#if flash9
	/**
	 * Bitmapdata of the given source
	 */
	public var data (default, null)		: BitmapData;
#else
	public var data (default, null)		: Dynamic;
#end
	public var state (default, null)	: SimpleStateMachine < BitmapStates >;
	private var loader					: Loader;
	
	
	public function new ()
	{
		state = new SimpleStateMachine < BitmapStates >(empty);
	}
	
	
	public function dispose ()
	{	
		state.dispose();
		
		if (loader != null)
			loader.dispose();
		
		data	= null;
		state	= null;
		loader	= null;
	}
	
	
	
#if flash9
	private inline function setData (v:BitmapData)
	{
		if (v != data) {
			data = v;
			state.current = v == null ? empty : loaded;
		}
		return v;
	}
#else
	private inline function setData (v:Dynamic)
	{
		if (v != data) {
			if (data != null)
				state.current = empty;
			
			data = v;
			
			if (data != null)
				state.current = loaded;
		}
		return v;
	}
#end
	
	
	
	//
	// IMAGE LOAD METHODS
	//
	
	public inline function loadUrl (v:URL)
	{
		loadString( v.toString() );
	}
	
	
	public inline function loadString (v:String)
	{
		if (loader != null) {
			if (state.is(loading))
				loader.close();
			
			loader.dispose();
		}
		
		state.current = loading;
		loader = new Loader();
		setLoadedData.onceOn( loader.events.loaded, this );
		
#if flash9
		loader.load( new flash.net.URLRequest(v) );
#else
		loader.load( v );
#end
		
	}
	
	
#if flash9
	
	public inline function loadDisplayObject (v:IDisplayObject, ?transform:Matrix2D)
	{
		var d = new BitmapData( v.width.int(), v.height.int(), true, 0 );
		d.draw( v, transform );
		setData(d);
	}
	
	
	public inline function loadFlashBitmap (v:FlashBitmap)
	{	
		setData(v.bitmapData);
	}
	
	
	public inline function loadBitmapData (v:BitmapData)
	{	
		setData(v);
	}
	
	
	public inline function loadClass (v:Class<DisplayObject>)
	{
		var i = untyped __new__(v);
		loadDisplayObject(i);
	}
#end

	
	
	//
	// EVENT HANDLERS
	//
	
	private inline function setLoadedData ()
	{
		if (loader == null || !loader.isLoaded)
			return;
		
#if flash9
		try {
			var d = new BitmapData( loader.content.width.int(), loader.content.height.int(), true, 0x00000000 );
			d.draw( loader.content );
			setData( d );
		}
		catch (e:flash.errors.Error) {
			throw "Loading bitmap error. Check policy settings. "+e.message;
			state.current = empty;
		}
		
		loader.dispose();
		loader = null;
#end
	}
	
	
	//
	// IMAGE CREATE METHODS
	//
	
	public static inline function fromUrl (v:URL) : Bitmap
	{
		var b = new Bitmap();
		b.loadUrl(v);
		return b;
	}
	
	
	public static inline function fromString (v:String) : Bitmap
	{
		var b = new Bitmap();
		b.loadString(v);
		return b;
	}
	
	
#if flash9
	public static inline function fromDisplayObject (v:IDisplayObject, ?transform:Matrix2D) : Bitmap
	{
		var b = new Bitmap();
		b.loadDisplayObject(v, transform);
		return b;
	}
	
	
	public static inline function fromFlashBitmap (v:FlashBitmap) : Bitmap
	{
		var b = new Bitmap();
		b.loadFlashBitmap(v);
		return b;
	}
	
	
	public static inline function fromBitmapData (v:BitmapData) : Bitmap
	{
		var b = new Bitmap();
		b.loadBitmapData(v);
		return b;
	}
	
	
	public static inline function fromClass (v:Class<DisplayObject>) : Bitmap
	{
		var b = new Bitmap();
		b.loadClass(v);
		return b;
	}
#end
}



enum BitmapStates {
	empty;
	loading;
	loaded;
}