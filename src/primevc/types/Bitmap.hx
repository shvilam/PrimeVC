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
	
	/**
	 * URL of the loaded bitmap (if it's loaded from an external image).
	 * Used for internal caching of bitmaps.
	 */
	public var url (default, null)		: String;
	
	/**
	 * Class of the current bitmap (if it's loaded from a class).
	 * Used for internal caching of bitmaps.
	 */
	public var asset (default, null)	: Class <DisplayObject>;
	
	
	public function new ()
	{
		state = new SimpleStateMachine < BitmapStates >(empty);
	}
	
	
	public function dispose ()
	{
		disposeLoader();
		state.dispose();
		asset	= null;
		url		= null;
		data	= null;
		state	= null;
		loader	= null;
	}
	
	
	private inline function disposeLoader ()
	{
		if (loader != null) {
			if (state.is(loading))
				loader.close();
			
			loader.dispose();
			loader = null;
			state.current = empty;
		}
	}
	
	
	public inline function load ()
	{
		if (url != null)			loadString();
		else if (asset != null)		loadClass();
	}
	
	
#if flash9
	private inline function setData (v:BitmapData)
	{
		if (v != data) {
			data = v;
			state.current = v == null ? empty : ready;
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
				state.current = ready;
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
	
	
	/**
	 * Method will set the given URI as uri that should be loaded next time
	 * but holds off with the loading itself. This comes in handy when a bitmap
	 * should get loaded at the moment that it's used for the first time.
	 */
	public inline function setString (v:String)
	{
		if (v != url)
		{
			disposeLoader();
			state.current = loadable;
			asset	= null;
			url		= v;
			loader	= new Loader();
			disposeLoader.onceOn( loader.events.error, this );
			handleLoadError.onceOn( loader.events.error, this );
			setLoadedData.onceOn( loader.events.loaded, this );
		}
	}
	
	
	/**
	 * LoadString with call setString with the given url and then try to load
	 * the url.
	 * If there's no parameter given, it will try to load the current 'url' 
	 * value.
	 */
	public inline function loadString (?v:String)
	{
		if (v != url || (v == null && url != null))
		{
			if (v != null)
				setString(v);
			
			state.current = loading;
#if flash9	loader.load( new flash.net.URLRequest(url) );
#else		loader.load( url ); #end
		}
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
	
	
	public inline function loadClass (?v:Class<DisplayObject>)
	{
		if (v != asset || (v == null && asset != null))
		{
			if (v != null)
				setClass(v);
			
			loadDisplayObject(untyped __new__(v));
		}
	}
	
	
	public inline function setClass (v:Class<DisplayObject>)
	{
		state.current = loadable;
		asset	= v;
		url		= null;
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
			disposeLoader();
			setData( d );
		}
		catch (e:flash.errors.Error) {
			throw "Loading bitmap error. Check policy settings. "+e.message;
			disposeLoader();
		}
#end
	}
	
	
	private inline function handleLoadError (err:String) : Void
	{
		trace("Bitmap load-error: "+err);
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


#if debug
	public function toString () {
		return		 if (url != null)	"url( "+url+" )";
				else if (asset != null)	"Class( "+asset+" )";
				else					"Bitmap()";
	}
#end
}



enum BitmapStates {
	empty;		//there's no data in the Bitmap
	loadable;	//a loader object is created but not loaded yet
	loading;	//the loader is loading an external resource
	ready;		//the bitmap is filled with bitmap-data
}