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
 import primevc.core.geom.Matrix2D;
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.traits.IDisposable;
 import primevc.core.traits.IValueObject;
  using primevc.utils.Bind;

#if flash9
 import primevc.gui.display.Loader;
 import primevc.utils.TypeUtil;
  using primevc.utils.NumberMath;

#elseif neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.types.Reference;
 import primevc.utils.ID;
  using primevc.types.Reference;
#end


typedef FlashBitmap		= #if flash9	flash.display.Bitmap		#else Dynamic			#end;
typedef AssetClass		= #if neko		Reference					#else Class<Dynamic>	#end;
typedef BitmapData		= #if flash9	flash.display.BitmapData	#else Dynamic			#end;
typedef DisplayObject	= #if flash9	flash.display.DisplayObject	#else Dynamic			#end;


/**
 * This class makes it easy to load images from several sources, e.g. load from
 * an URL, instantiate from an embedded asset, set the BitmapData directly,
 * give it an Bitmap instance or copy the pixels of a given DisplayObject.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class Asset
				implements IDisposable
			,	implements IValueObject
#if neko	,	implements ICodeFormattable		#end
{
#if flash9
	private var loader							: Loader;
#end

#if (neko || debug)
	public var _oid			(default, null)		: Int;
#end
	
	public var state		(default, null)		: SimpleStateMachine < AssetStates >;
	
	/**
	 * URL of the loaded bitmap (if it's loaded from an external image).
	 * Used for internal caching of bitmaps.
	 */
	public var url			(default, null)		: URI;
	public var type			(default, null)		: AssetType;
	
	/**
	 * cached bitmapdata of the given source
	 */
	private var bitmapData		: BitmapData;
	private var displaySource	: DisplayObject;
	private var assetClass		: AssetClass;
	
	
	
	
	public function new (url:URI = null, asset:AssetClass = null, data:BitmapData = null, bitmap:FlashBitmap = null, displaySource:DisplayObject = null)
	{
		state	= new SimpleStateMachine<AssetStates>(empty);
#if neko
		_oid	= ID.getNext();
#end
		if		(url != null)				setURI( url );
		else if (asset != null)				setClass( asset );
		else if (data != null)				setBitmapData( data );
		else if (bitmap != null)			setFlashBitmap( bitmap );
		else if (displaySource != null)		setDisplayObject( displaySource );
	}
	
	
	public function dispose ()
	{
		unsetData();
		state.dispose();
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
			
			if (bitmapData == null)
				state.current = empty;
		}
#end
	}
	
	
	public function load ()
	{
		if (state.current == loadable) {
			if (url != null)
				loadUrl();
		}
	}
	
	
/*	private inline function setData (v:BitmapData)
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
	
	
	public function getData () : BitmapData
	{
#if flash9
		if (_data == null || state.current != ready)
			load();
#end
		
		return _data;
	}*/
	
	
	public function getBitmapData (matrix:Matrix2D = null, transparant:Null<Bool> = null, fillColor:Null<UInt> = null) : BitmapData
	{
		if (state.current == loadable)
			load();
		
		if (state.current != ready || type == null)
			return null;
		
		if (bitmapData != null && matrix == null && transparant == null && fillColor == null)
			return bitmapData;
		
		if (transparant == null)	transparant = true;
		if (fillColor == null)		fillColor	= 0x00ffffff;
		
#if flash9
		var source:flash.display.IBitmapDrawable = null;
		var w:Int = 0;
		var h:Int = 0;
		
		switch (type) {
			case AssetType.bitmapData:
				source	= bitmapData;
				w		= bitmapData.height;
				h		= bitmapData.width;
			
			case AssetType.displayObject:
				source	= displaySource;
				w		= displaySource.width.roundFloat();
				h		= displaySource.height.roundFloat();
			
			case AssetType.vector:
				source	= displaySource = createAssetInstance();
				w		= displaySource.width.roundFloat();
				h		= displaySource.height.roundFloat();
		}
		
		bitmapData = new BitmapData( w, h, transparant, fillColor );
		bitmapData.draw( source, matrix );
#end
		return bitmapData;
	}
	
	
#if flash9
	public function getDisplayObject () : flash.display.DisplayObject
	{
		if (type == null)
			return null;
		
		if (state.current == loadable)
			load();
		
		Assert.notNull(type);
		return switch (type) {
			//don't use flashes own bitmap class but use the bitmap of prime instead..
			case AssetType.bitmapData:		cast new primevc.gui.display.BitmapShape( bitmapData );
			case AssetType.vector:			cast createAssetInstance();
			case AssetType.displayObject:	cast displaySource;
		}
	}
#end
	
	
	private inline function createAssetInstance ()
	{
		Assert.notNull(assetClass);
		return #if flash9 Type.createInstance(assetClass, []); #else null; #end
	}
	
	
	
	
	//
	// IMAGE LOAD METHODS
	//
	
	
	private inline function unsetData ()
	{
		if (type != null)
		{
			disposeLoader();
			state.current	= AssetStates.empty;	//important to this first, other objects have a chance to remove their references then...
			url				= null;
			assetClass		= null;
			displaySource	= null;
			bitmapData		= null;
			type			= null;
		}
	}
	
	
	public function loadUrl (?v:URI)
	{
		if (v != url || (v == null && url != null))
		{
			if (v != null)
				setURI(v);
			
#if flash9
			type			= AssetType.displayObject;
			state.current	= AssetStates.loading;
			
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
			unsetData();
			state.current	= loadable;
			url				= v;
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
	
	
	public inline function setDisplayObject (v:DisplayObject)
	{
		if (v != displaySource)
		{
			unsetData();
			displaySource	= v;
			type			= AssetType.displayObject;
			state.current	= AssetStates.ready;
		}
	}
	
	
	public inline function setFlashBitmap (v:FlashBitmap)
	{
		setBitmapData(v.bitmapData);
	}
	
	
	public inline function setBitmapData (v:BitmapData)
	{
		if (v != bitmapData)
		{
			unsetData();
			type			= AssetType.bitmapData;
			bitmapData		= v;
			state.current	= AssetStates.ready;
		}
	}
	
	
	public inline function setVector (v:AssetClass)
	{
		if (v != assetClass)
		{
			unsetData();
			type			= AssetType.vector;
			assetClass		= v;
			state.current	= AssetStates.ready;
		}
	}
	
	
	public function setClass (v:AssetClass)
	{
		if (v != assetClass)
		{
			unsetData();
#if flash9
			if (v == null)
				return;
			
			try
			{
				Assert.notNull( v );
				var asset = v;
				
				while (asset != null)
				{
					if		(asset == BitmapData)		{ setBitmapData( Type.createInstance(v, []) );	break; }
					else if (asset == DisplayObject)	{ setVector( v ); break; }
					else if (asset == FlashBitmap)		{ setFlashBitmap( Type.createInstance(v, []) );	break; }
					
					asset = Type.getSuperClass( asset );
				}
			}
			catch (e:Dynamic) {
	#if debug
				throw "Error creating an instance of " + v+"; Error: "+e;
	#end
			}
#else
			assetClass = v;
#end
		}
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
			setDisplayObject( loader.content );
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
	
	public static inline function fromUrl (v:URI) : Asset
	{
		var b = new Asset();
		b.loadUrl(v);
		return b;
	}
	
	
	public static inline function fromString (v:String) : Asset
	{
		var b = new Asset();
		b.loadString(v);
		return b;
	}
	
	
#if flash9
	public static inline function fromDisplayObject (v:DisplayObject) : Asset
	{
		var b = new Asset();
		b.setDisplayObject(v);
		return b;
	}
	
	
	public static inline function fromFlashBitmap (v:FlashBitmap) : Asset
	{
		var b = new Asset();
		b.setFlashBitmap(v);
		return b;
	}
	
	
	public static inline function fromBitmapData (v:BitmapData) : Asset
	{
		var b = new Asset();
		b.setBitmapData(v);
		return b;
	}
	
	
	public static inline function createEmpty (width:Int, height:Int) : Asset
	{
		var b = new Asset();
		b.setBitmapData( new BitmapData(width, height) );
		return b;
	}
	
#end
	
	
	public static inline function fromClass (v:AssetClass) : Asset
	{
		var b = new Asset();
		b.setClass(v);
		return b;
	}


#if neko
	public function isEmpty ()
	{
		return url == null && assetClass == null && bitmapData == null && displaySource == null;
	}
	
	public function toString ()
	{
		return	if (url != null)				"url( "+url+" )";
				else							"Bitmap()";
	}
	
	public function cleanUp () : Void {}
	
	public function toCode (code:ICodeGenerator)
	{
		code.construct( this, [ url, assetClass, bitmapData, null, this.displaySource ] );
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



enum AssetStates {
	empty;		//there's no data in the Bitmap
	loadable;	//a loader object is created but not loaded yet
	loading;	//the loader is loading an external resource
	ready;		//the bitmap is filled with bitmap-data
}


enum AssetType {
	bitmapData;
	displayObject;
	vector;
}