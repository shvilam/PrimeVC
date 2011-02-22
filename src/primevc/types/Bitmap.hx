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
 import primevc.core.traits.IDisposable;
 import primevc.core.traits.IValueObject;
  using primevc.utils.Bind;

#if flash9
 import flash.display.DisplayObject;
 import primevc.core.geom.Matrix2D;
 import primevc.gui.display.Loader;
 import primevc.utils.TypeUtil;
  using primevc.utils.NumberMath;


typedef FlashBitmap = flash.display.Bitmap;

#elseif neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.types.Reference;
 import primevc.utils.ID;
  using primevc.types.Reference;
#end


typedef AssetClass	= #if neko		Reference					#else Class<Dynamic>	#end;
typedef BitmapData	= #if flash9	flash.display.BitmapData	#else Dynamic			#end;


/**
 * This class makes it easy to load images from several sources, e.g. load from
 * an URL, instantiate from an embedded asset, set the BitmapData directly,
 * give it an Bitmap instance or copy the pixels of a given DisplayObject.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class Bitmap
				implements IDisposable
			,	implements IValueObject
#if neko	,	implements ICodeFormattable		#end
{
	private var _data					: BitmapData;
	
	/**
	 * Bitmapdata of the given source
	 */
	public var data (getData, setData)	: BitmapData;
#if flash9
	private var loader					: Loader;
#end

#if (neko || debug)
	public var _oid (default, null)		: Int;
#end
	
	public var state (default, null)	: SimpleStateMachine < BitmapStates >;
	
	/**
	 * URL of the loaded bitmap (if it's loaded from an external image).
	 * Used for internal caching of bitmaps.
	 */
	public var url (default, null)		: URI;
	
	/**
	 * Class of the current bitmap (if it's loaded from a class).
	 * Used for internal caching of bitmaps.
	 */
	public var asset (default, null)	: AssetClass;
	
	
	public function new (url:URI = null, asset:AssetClass = null, data:BitmapData = null)
	{
		state	= new SimpleStateMachine < BitmapStates >(empty);
#if neko
		_oid	= ID.getNext();
#end
		if (url != null)	setURI( url );
		if (asset != null)	setClass( asset );
		if (data != null)	this.data = data;
	}
	
	
	public function dispose ()
	{
		disposeLoader();
		state.dispose();
		asset	= null;
		url		= null;
		_data	= null;
		state	= null;
#if neko
		_oid	= 0;
#end
	}
	
	
	private function disposeLoader ()
	{
#if flash9
		if (loader != null)
		{
			if (state.is(loading))
				loader.close();
			
			loader.dispose();
			loader = null;
			
			if (_data == null)
				state.current = empty;
		}
#end
	}
	
	
	public function load ()
	{
		if (state.current == loadable) {
			if (url != null)			loadUrl();
			else if (asset != null)		loadClass();
		}
	}
	
	
	private inline function setData (v:BitmapData)
	{
		if (v != _data)
		{
#if flash9	if (_data != null)
				_data.dispose();
#end
			_data = v;
			state.current = v == null ? empty : ready;
		}
		return v;
	}
	
	
	private inline function getData () : BitmapData
	{
#if flash9
		if (_data == null || state.current != ready)
			load();
#end
		
		return _data;
	}
	
	
	
	
	//
	// IMAGE LOAD METHODS
	//
	
	public function loadUrl (?v:URI)
	{
		if (v != url || (v == null && url != null))
		{
			if (v != null)
				setURI(v);
#if flash9
			state.current = loading;
			
			var context = new flash.system.LoaderContext(true);			//add context to check policy file
			loader.load( url, context );
#end
		}
	}
	
	
	/**
	 * Method will set the given URI as uri that should be loaded next time
	 * but holds off with the loading itself. This comes in handy when a bitmap
	 * should get loaded at the moment that it's used for the first time.
	 */
	public inline function setURI (v:URI)
	{
		if (v != url)
		{
			disposeLoader();
			state.current = loadable;
			asset	= null;
			url		= v;
#if flash9
			loader	= new Loader();
			disposeLoader	.onceOn( loader.events.load.error, this );
			handleLoadError	.onceOn( loader.events.load.error, this );
			setLoadedData	.onceOn( loader.events.load.completed, this );
#end
		}
	}
	
	
	/**
	 * LoadString with call setURI with the given url and then try to load
	 * the url.
	 * If there's no parameter given, it will try to load the current 'url' 
	 * value.
	 */
	public inline function loadString (v:String)
	{
		loadUrl( new URI(v) );
	}
	
	
	public inline function setString (v:String)
	{
		setURI( new URI(v) );
	}
	
	
#if flash9
	
	public inline function loadDisplayObject (v:DisplayObject, transform:Matrix2D = null, transparant:Bool = true, fillColor:UInt = 0x00ffffff)
	{
		var d = new BitmapData( v.width.roundFloat(), v.height.roundFloat(), transparant, fillColor );
		d.draw( v, transform );
		data = d;
	}
	
	
	public inline function loadFlashBitmap (v:FlashBitmap)
	{
		data = v.bitmapData;
	}
	
	
	public inline function loadBitmapData (v:BitmapData)
	{	
		data = v;
	}
#end
	
	public function loadClass (?v:AssetClass)
	{
		if (v != asset || (v == null && asset != null))
		{
			if (v != null)
				setClass(v);
			
#if flash9
			try
			{
				Assert.notNull( asset );
				var inst:Dynamic = Type.createInstance(asset, []);
				Assert.notNull(inst);
				if		(TypeUtil.is( inst, DisplayObject))		loadDisplayObject( cast inst );
				else if (TypeUtil.is( inst, BitmapData))		loadBitmapData( cast inst );
				else if (TypeUtil.is( inst, FlashBitmap))		loadFlashBitmap( cast inst );
				else											throw "unkown asset!";
			}
			catch (e:Dynamic) {
#if debug
				throw "Error creating an instance of " + v+"; Error: "+e;
#end
			}
#end
		}
	}
	
	
	public inline function setClass (v:AssetClass)
	{
		state.current = loadable;
		asset	= v;
		url		= null;
	}

	
	
	//
	// EVENT HANDLERS
	//
	
	private function setLoadedData ()
	{
#if flash9
		if (loader == null || !loader.isLoaded)
			return;

		try {
			var d = new BitmapData( loader.content.width.roundFloat(), loader.content.height.roundFloat(), true, 0x00000000 );
			d.draw( loader.content );
			data = d;	// <-- setData will change the bitmapState to the correct value
			disposeLoader();
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
	
	public static inline function fromUrl (v:URI) : Bitmap
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
	public static inline function fromDisplayObject (v:DisplayObject, ?transform:Matrix2D, transparant:Bool = true, fillColor:UInt = 0xffffffff) : Bitmap
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
	
	
	public static inline function createEmpty (width:Int, height:Int, transparant:Bool = true, fillColor:UInt = 0xffffffff) : Bitmap
	{
		var b	= new Bitmap();
		b.data	= new BitmapData(width, height);
		return b;
	}
	
#end
	
	
	public static inline function fromClass (v:AssetClass) : Bitmap
	{
		var b = new Bitmap();
		b.loadClass(v);
		return b;
	}


#if neko
	public function isEmpty ()
	{
		return url == null && asset == null && _data == null;
	}
	
	public function toString ()
	{
		return	if (url != null)		"url( "+url+" )";
				else if (asset != null)	asset.toCSS();
				else					"Bitmap()";
	}
	
	public function cleanUp () : Void {}
	
	public function toCode (code:ICodeGenerator)
	{
		code.construct( this, [ url, asset, _data ] );
	}
#end

#if (!neko && debug)
	public function toString ()
	{
		return	if (url != null)		"url( "+url+" )";
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