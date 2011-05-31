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
 import primevc.types.Number;
 import primevc.types.URI;
  using primevc.utils.Bind;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
  using Type;

#if flash9
 import primevc.core.net.ICommunicator;
 import primevc.core.net.URLLoader;
 import primevc.gui.display.Loader;

#elseif neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.types.Reference;
 import primevc.utils.ID;
  using primevc.types.Reference;
#end


private typedef FlashBitmap		= #if flash9	flash.display.Bitmap		#else Dynamic			#end;
private typedef AssetClass		= primevc.types.Factory<Dynamic>; //#if neko		Reference					#else Class<Dynamic>	#end;
private typedef BitmapData		= #if flash9	flash.display.BitmapData	#else Dynamic			#end;
private typedef DisplayObject	= #if flash9	flash.display.DisplayObject	#else Dynamic			#end;
private typedef BytesData		= haxe.io.BytesData; //#if flash9	flash.utils.ByteArray		#else Dynamic			#end;


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
	private var bytesLoader	: Loader;
	public var loader		(default, setLoader)		: ICommunicator;
#end

#if (neko || debug)
	public var _oid			(default, null)				: Int;
#end
	
	public var state		(default, null)				: SimpleStateMachine < AssetStates >;
	
	/**
	 * URL of the loaded bitmap (if it's loaded from an external image).
	 * Used for internal caching of bitmaps.
	 */
	public var uri			(default, null)				: URI;
	public var type			(default, null)				: AssetType;
	
	/**
	 * cached bitmapdata of the given source
	 */
	private var bitmapData		: BitmapData;
	private var displaySource	: DisplayObject;
	private var assetClass		: AssetClass;
	
	/**
	 * source bytes (will be set to null when the bytes are loaded)
	 */
	public var bytes		(default, null)				: BytesData;
	
	public var width		(default, null)				: Int;
	public var height		(default, null)				: Int;
	
	
	
	public function new (uri:URI = null, asset:AssetClass = null, data:BitmapData = null, bitmap:FlashBitmap = null, displaySource:DisplayObject = null)
	{
		state	= new SimpleStateMachine<AssetStates>(empty);
		width	= height = Number.INT_NOT_SET;
#if neko
		_oid	= ID.getNext();
#end
		if		(uri != null)				setURI( uri );
		else if (asset != null)				setClass( asset );
		else if (data != null)				setBitmapData( data );
		else if (bitmap != null)			setFlashBitmap( bitmap );
		else if (displaySource != null)		setDisplayObject( displaySource );
	}
	
	
	public function dispose ()
	{
		state.dispose();
		state	= null;
		unsetData();
#if neko
		_oid	= 0;
#end
	}
	
	
	public inline function isReady ()		{ return state.current == AssetStates.ready; }
	public inline function isLoading ()		{ return state.current == AssetStates.loading; }
	public inline function isLoadable ()	{ return state.current == AssetStates.loadable; }
	public inline function isLoaded ()		{ return /*isReady()*/ #if flash9 (loader != null && loader.isCompleted()) #else true #end; }
	
	public inline function isBitmapData ()		{ return type == AssetType.bitmapData; }
	public inline function isDisplayObject ()	{ return type == AssetType.displayObject; }
	public inline function isVector ()			{ return type == AssetType.vector; }
	
	
	private function disposeBytesLoader ()
	{
#if flash9
		if (bytesLoader != null)
		{
			if (state == null || state.is(loading))
				bytesLoader.close();
			
			bytesLoader.dispose();
			bytesLoader = null;
			
			if (bitmapData == null && state != null)
				state.current = empty;
		}
#end
	}
	
	
	private inline function createBytesLoader () : Void
	{
#if flash9
		bytesLoader	= new Loader();
		disposeBytesLoader	.onceOn( bytesLoader.events.load.error, this );
		handleLoadError		.onceOn( bytesLoader.events.load.error, this );
		handleUnloaded		.onceOn( bytesLoader.events.unloaded, this );
		setLoadedData		.onceOn( bytesLoader.events.load.completed, this );
#end
	}
	
	
	private inline function createURILoader () : Void
	{
#if flash9
		loader = new URLLoader();
#end
	}
	
	
	public function load ()
	{
#if flash9
		if (state.current == loadable) {
			if		(bytes != null)			loadBytes();
	//		else if (loader != null)		loader.load();		don't know the URI here
			else if (uri != null)			loadURI();
		}
#end
	}
	
	
	
	
	//
	// SETTERS
	//
	
#if flash9
	private function setLoader (v:ICommunicator)
	{
		if (v != loader) {
			if (loader != null) {
				loader.events.unloaded.unbind(this);
				loader.events.load.error.unbind(this);
				loader.events.load.completed.unbind(this);
			}
			
			loader = v;
			
			if (v != null) {
	//			Assert.that( v.isBinary(), "URILoader should load binary data!" );
				
				if (!v.isCompleted()) {
					handleLoadError	.onceOn( v.events.load.error, this );
					handleURILoaded	.onceOn( v.events.load.completed, this );
					handleUnloaded	.onceOn( v.events.unloaded, this );
				}
				else
					setBytes( v.bytes );
				
				state.current = loadable;
			}
		}
		return v;
	}
#end
	
	
	
	//
	// GETTERS
	//
	
	
	
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
		var source:flash.display.IBitmapDrawable = switch (type) {
			case AssetType.bitmapData:		cast bitmapData;
			case AssetType.displayObject:	cast displaySource;
			case AssetType.vector:			cast createAssetInstance();
		}
		
		bitmapData = new BitmapData( width, height, transparant, fillColor );
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
		
#if flash9
	//	var inst = Type.createInstance(assetClass, []);
		var inst = assetClass();
		if (displaySource == null)		displaySource = inst;
		if (width.notSet())				width	= inst.width.roundFloat();
		if (height.notSet())			height	= inst.height.roundFloat();
		return inst;
#else
		return null;
#end
	}
	
	
	
	
	//
	// IMAGE LOAD METHODS
	//
	
	
	private /*inline*/ function unsetData ()
	{
		if (type != null)
		{
			if (type != AssetType.displayObject #if flash9 || bytesLoader == null || !bytesLoader.isSwf() #end)
				disposeBytesLoader();
			
#if flash9	if (bitmapData != null)		bitmapData.dispose();	#end
			if (state != null)			state.current	= AssetStates.empty;		// important to this first, other objects have a chance to remove their references then...
			
#if flash9	loader			= null; #end				// don't dispose the loader, can be cached by value-objects (their responsibility to dispose it)
			uri				= null;
			assetClass		= null;
			displaySource	= null;
			bitmapData		= null;
			bytes			= null;						// don't clear the byte-array.. can be used in multiple places
			
			type			= null;
			width			= Number.INT_NOT_SET;
			height			= Number.INT_NOT_SET;
		}
	}
	
	
	
	public function loadURI (v:URI = null)
	{
		if (v != null)
			setURI(v);
		
		if (uri != null)
		{
#if flash9
			type			= AssetType.displayObject;
			state.current	= AssetStates.loading;
			
		//	trace("load "+uri+"; isURILoader: "+loader.is(URLLoader));
			if (loader.is(URLLoader))
				loader.as(URLLoader).load( uri );
#end
		}
	}
	
	
	/**
	 * Method will set the given URI as uri that should be loaded next time
	 * but holds off with the loading itself. This comes in handy when a bitmap
	 * should get loaded at the moment that it's used for the first time.
	 */
	public /*inline*/ function setURI (v:URI)
	{
		if (v != uri)
		{
			unsetData();
			if (v != null)
			{
				if (v.hasScheme( URIScheme.Scheme('asset')) )
				{
					trace(v.host);
#if neko			uri = v;
#else				setClass( function ():Dynamic { return Type.createInstance(cast v.host.resolveClass, []); } ); #end
				}
				else
				{
	//				trace(v.scheme+" => "+v);
					createURILoader();
					uri				= v;
					state.current	= loadable;
				}
			}
		}
	}
	
	
	/**
	 * LoadString with call setURI with the given uri and then try to load
	 * the uri.
	 * If there's no parameter given, it will try to load the current 'uri' 
	 * value.
	 */
	public inline function loadString (v:String)
	{
		loadURI( new URI(v) );
	}
	
	
	public inline function setString (v:String)
	{
		setURI( new URI(v) );
	}
	
	
	
	public inline function setBytes (v:BytesData, shouldUnsetData:Bool = true)
	{
		if (v != bytes)
		{
			if (shouldUnsetData)
				unsetData();
			
			if (v != null) {
				createBytesLoader();
				bytes			= v;
				state.current	= loadable;
			}
		}
#if flash9 bytes = v; #end
	}
	
	
	public /*inline*/ function loadBytes (v:BytesData = null, shouldUnsetData:Bool = true)
	{
#if flash9
		if (v != null)
			setBytes(v, shouldUnsetData);
		
		if (bytes != null)
		{
			Assert.notNull(bytesLoader);
			state.current = AssetStates.loading;
			bytesLoader.loadBytes(bytes);
		}
#end
	}
	
	
	public inline function setDisplayObject (v:DisplayObject, w:Int = Number.INT_NOT_SET, h:Int = Number.INT_NOT_SET)
	{
		if (v != displaySource)
		{
			unsetData();
			if (v != null)
			{
				displaySource	= v;
				width			= w.isSet() ? w : v.width.roundFloat();
				height			= h.isSet() ? h : v.height.roundFloat();
				type			= AssetType.displayObject;
				state.current	= AssetStates.ready;
			}
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
			
			if (v != null)
			{
				type			= AssetType.bitmapData;
				bitmapData		= v;
				width			= v.width;
				height			= v.height;
				state.current	= AssetStates.ready;
			}
		}
	}
	
	
	public inline function setVector (v:AssetClass)
	{
		if (v != assetClass)
		{
			unsetData();
			if (v != null)
			{
				type			= AssetType.vector;
				assetClass		= v;
				state.current	= AssetStates.ready;
			}
		}
	}
	
	
	public function setClass (factory:AssetClass)
	{
		if (factory != assetClass)
		{
			unsetData();
#if flash9
			if (factory == null)
				return;
			
			try
			{
				var asset:Dynamic = factory();
				
				if		(asset.is(BitmapData))		setBitmapData(cast asset);
				else if (asset.is(FlashBitmap))		setFlashBitmap(cast asset);
			//	else if (asset.is(DisplayObject))	setVector( v );
				
			/*	while (asset != null)
				{
				//	trace("\t\t"+asset+" -> isBitmap: "+(asset == BitmapData)+"; isDisplayObject: "+(asset == DisplayObject)+"; isFlashBitmap? "+(asset == FlashBitmap));
					if		(asset == BitmapData)		{ setBitmapData( Type.createInstance(v, []) );	break; }
					else if (asset == DisplayObject)	{ setVector( v ); break; }
					else if (asset == FlashBitmap)		{ setFlashBitmap( Type.createInstance(v, []) );	break; }
					
					asset = Type.getSuperClass( asset );
				}*/
			}
			catch (e:Dynamic) {
	#if debug
				throw "Error creating an instance of " + factory + "; Error: "+e;
	#end
			}
#else
			assetClass = factory;
#end
		}
	}

	
	
	//
	// EVENT HANDLERS
	//
	
	private function setLoadedData ()
	{
#if flash9
	//	trace(this+" - "+loader);
		if (bytesLoader == null || !bytesLoader.isCompleted())
			return;
		
	//	trace(bytesLoader.content+"; size: "+bytesLoader.width+", "+bytesLoader.height+"; mime: "+bytesLoader.info.contentType);
		try {
			setDisplayObject( bytesLoader.content, bytesLoader.width.roundFloat(), bytesLoader.height.roundFloat() );
		}
		catch (e:flash.errors.Error) {
			throw "Loading asset error. Check policy settings. "+e.message;
			disposeBytesLoader();
		}
#end
	}
	
	
	private function handleUnloaded () : Void
	{
		state.current = loadable;
	}
	
	
	private inline function handleLoadError (err:String) : Void
	{
		trace("Asset load-error: "+err+"; "+this);
	}
	
	
	private inline function handleURILoaded () : Void
	{
#if flash9
	//	trace(uri+"; totalBytes: "+loader.bytes.length);
		loadBytes( loader.bytes, false );
#end
	}
	
	
	
	
	//
	// IMAGE CREATE METHODS
	//
	
	public static inline function fromURI (v:URI) : Asset
	{
	//	trace(v);
		var b = new Asset();
		b.setURI(v);
	//	b.loadURI(v);
		return b;
	}
	
	
	public static inline function fromString (v:String) : Asset
	{
	//	trace(v);
		var b = new Asset();
		b.setString(v);
	//	b.loadString(v);
		return b;
	}
	
	
#if flash9
	public static inline function fromDisplayObject (v:DisplayObject) : Asset
	{
	//	trace(v);
		var b = new Asset();
		b.setDisplayObject(v);
		return b;
	}
	
	
	public static inline function fromFlashBitmap (v:FlashBitmap) : Asset
	{
	//	trace(v);
		var b = new Asset();
		b.setFlashBitmap(v);
		return b;
	}
	
	
	public static inline function fromBitmapData (v:BitmapData) : Asset
	{
	//	trace(v);
		var b = new Asset();
		b.setBitmapData(v);
		return b;
	}
	
	
	public static inline function fromBytes (v:BytesData) : Asset
	{
	//	trace(v);
		var b = new Asset();
		b.setBytes(v);
		return b;
	}
	
	
	public static inline function fromLoader (v:ICommunicator) : Asset
	{
	//	trace(v);
		var b = new Asset();
		b.loader = v;
		return b;
	}
	
	
	public static inline function createEmpty (width:Int, height:Int) : Asset
	{
	//	trace(width+", "+height);
		var b = new Asset();
		b.setBitmapData( new BitmapData(width, height) );
		return b;
	}
	
#end
	
	
	public static inline function fromClass (v:AssetClass) : Asset
	{
	//	trace(v);
		var b = new Asset();
		b.setClass(v);
		return b;
	}


#if neko
	public function isEmpty ()						{ return uri == null && assetClass == null && bitmapData == null && displaySource == null; }
	public function cleanUp () : Void				{}
	public function toCode (code:ICodeGenerator)	{ code.construct( this, [ uri, assetClass, bitmapData, null, this.displaySource ] ); }
#end

#if (neko || debug)
	public function toString ()
	{
		return	 if (assetClass != null)		"Asset( "+assetClass+" )" + state.current;
			else if (bitmapData != null)		"Asset( bitmapData )" + state.current;
			else if (displaySource != null)		"Asset( "+displaySource+" )" + state.current;
			else if (bytes != null)				"Asset( bytes("+ #if neko "" #else bytes.length #end +") )" + state.current;
			else if (uri != null)				"Asset( "+uri+" )" + state.current;
			else								"Asset( "+type+")" + state.current;
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