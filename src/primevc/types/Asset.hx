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
 import primevc.core.net.ICommunicator;
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.traits.IDisposable;
 import primevc.core.traits.IValueObject;
 import primevc.gui.display.DisplayObject;
 import primevc.types.Number;
 import primevc.types.URI;
  using primevc.utils.Bind;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
  using Type;

#if flash9
 import primevc.core.net.URLLoader;
 import primevc.gui.display.Loader;

#elseif neko
 import primevc.tools.generator.ICodeFormattable;
 import primevc.tools.generator.ICodeGenerator;
 import primevc.types.Reference;
  using primevc.types.Reference;
#end


private typedef FlashBitmap		= #if flash9	flash.display.Bitmap		#else Dynamic			#end;
private typedef BitmapData		= #if flash9	flash.display.BitmapData	#else Dynamic			#end;
private typedef Factory			= primevc.types.Factory<Dynamic>;
private typedef BytesData		= haxe.io.BytesData;


/**
 * This class makes it easy to load images from several sources, e.g. load from
 * an URL, instantiate from an embedded asset, set the BitmapData directly,
 * give it an Bitmap instance or copy the pixels of a given DisplayObject.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
/*class Asset
				implements IDisposable
			,	implements IValueObject
#if neko	,	implements ICodeFormattable		#end
{
#if flash9
	private var bytesLoader	: Loader;
	public var loader		(default, setLoader)		: ICommunicator;
#end

#if (neko || debug)
//	public var _oid			(default, null)				: Int;
#end
	
//	public var state		(default, null)				: SimpleStateMachine < AssetStates >;
	
	/**
	 * URL of the loaded bitmap (if it's loaded from an external image).
	 * Used for internal caching of bitmaps.
	 */
/*	public var uri			(default, null)				: URI;
//	public var type			(default, null)				: AssetType;
	
	/**
	 * cached bitmapdata of the given source
	 */
/*	private var bitmapData		: BitmapData;
	private var displaySource	: DisplayObject;
	private var assetClass		: AssetClass;
	
	/**
	 * source bytes (will be set to null when the bytes are loaded)
	 */
/*	public var bytes		(default, null)				: BytesData;
	
//	public var width		(default, null)				: Int;
//	public var height		(default, null)				: Int;
	
	
	
	/*public function new (uri:URI = null, asset:AssetClass = null, data:BitmapData = null, bitmap:FlashBitmap = null, displaySource:DisplayObject = null)
	{
		state	= new SimpleStateMachine<AssetStates>(empty);
		width	= height = Number.INT_NOT_SET;
#if (neko || debug)
		_oid	= primevc.utils.ID.getNext();
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
	}*/
	
	
/*	private function disposeBytesLoader ()
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
			if		(assetClass != null)	loadClass();
			else if	(bytes != null)			loadBytes();
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
	
	
	private /*inline function unsetData ()
	{
		if (type != null)
		{
			trace(this);
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
/*	public function setURI (v:URI)
	{
		if (v != uri)
		{
			unsetData();
			if (v != null)
			{
		//		trace(v);
				if (v.hasScheme( URIScheme.Scheme('asset')) )
				{
			//		trace(v.host + " - "+v.host.resolveClass()+"; ? "+Type.createInstance( v.host.resolveClass(), []));
#if neko			uri = v;
#else				setClass( function ():Dynamic { return Type.createInstance( v.host.resolveClass(), []); } ); #end
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
/*	public inline function loadString (v:String)
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
	
	
//	public /*inline function loadBytes (v:BytesData = null, shouldUnsetData:Bool = true)
/*	{
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
			if (displaySource != null)
				trace(v+" => "+displaySource+"; "+displaySource.parent);
			else if (v != null)
				trace(v+"; "+v.getClass().getSuperClass().getClassName());
			
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
	
	
	/*public inline function setFlashBitmap (v:FlashBitmap)
	{
		trace(this);
		setBitmapData(v.bitmapData);
	}
	
	
	public inline function setBitmapData (v:BitmapData)
	{
		if (v != bitmapData)
		{
			unsetData();
			
			trace(v);
			if (v != null)
			{
				type			= AssetType.bitmapData;
				bitmapData		= v;
				width			= v.width;
				height			= v.height;
				state.current	= AssetStates.ready;
			}
		}
	}*/
	
	
/*	public inline function setVector (v:AssetClass)
	{
		if (v != assetClass)
		{
			unsetData();
			trace(v);
			if (v != null)
			{
				type			= AssetType.vector;
				throw "vector... what should we do with you :)";
				assetClass		= v;
				state.current	= AssetStates.ready;
			}
		}
	}
	
	
	public function loadClass (?v:AssetClass)
	{
		if (v != null)
			setClass(v);
		
		if (assetClass != null)
		{
#if flash9
			state.current = AssetStates.loading;
			try
			{
				var asset:Dynamic = assetClass();
				
				if		(asset.is(BitmapData))		setBitmapData(cast asset);
				else if (asset.is(FlashBitmap))		setFlashBitmap(cast asset);
				else if (asset.is(DisplayObject))	setDisplayObject(cast asset);
				else
					throw "unkown type "+asset+"; "+Type.getClass(asset).getSuperClass().getClassName();
			//	else if (asset.is(DisplayObject))	setVector( v );
				
			/*	while (asset != null)
				{
				//	trace("\t\t"+asset+" -> isBitmap: "+(asset == BitmapData)+"; isDisplayObject: "+(asset == DisplayObject)+"; isFlashBitmap? "+(asset == FlashBitmap));
					if		(asset == BitmapData)		{ setBitmapData( Type.createInstance(v, []) );	break; }
					else if (asset == DisplayObject)	{ setVector( v ); break; }
					else if (asset == FlashBitmap)		{ setFlashBitmap( Type.createInstance(v, []) );	break; }
					
					asset = Type.getSuperClass( asset );
				}*/
/*			}
			catch (e:Dynamic) {
	#if debug
				throw "Error creating an instance of " + assetClass + "; Error: "+e;
	#end
			}
#end
		}
	}
	
	
	public inline function setClass (factory:AssetClass)
	{
		if (factory != assetClass)
		{
			unsetData();
			assetClass = factory;
			state.current = factory == null ? AssetStates.empty : AssetStates.loadable;
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
	
	
	
	
	
/*	public static inline function fromBytes (v:BytesData) : Asset
	{
	//	trace(v);
		var b = new Asset();
		b.setBytes(v);
		return b;
	}*/
	
	
/*	public static inline function fromLoader (v:ICommunicator) : Asset
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

}*/



/**
 * This class makes it easy to load images from several sources, e.g. load from
 * an URL, instantiate from an embedded asset, set the BitmapData directly,
 * give it an Bitmap instance or copy the pixels of a given DisplayObject.
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class Asset		implements IDisposable
			,	implements IValueObject
#if neko	,	implements ICodeFormattable		#end
{
	//
	// FACTORY METHODS
	//
	
#if flash9
	public static inline function fromFlashBitmap	(v:FlashBitmap)					: Asset	{ return fromBitmapData(v.bitmapData); }
	public static inline function fromBitmapData	(v:BitmapData)					: Asset	{ return new BitmapAsset(v); }
	public static inline function fromDisplayObject	(v:DisplayObject, ?f:Factory)	: Asset	{ return new DisplayAsset(v, f); }
	public static inline function fromBytes			(v:BytesData)					: Asset	{ return new BytesAsset(v); }
	public static inline function fromLoader		(v:ICommunicator)				: Asset	{ return new ExternalAsset(null, v); }
	public static inline function fromFactory		(v:Factory)						: Asset	{ return fromUnkown( v(), v ); } //new DisplayFactoryAsset( v ); }
	public static inline function fromString		(v:String)						: Asset	{ return fromURI(new URI(v)); }
	
	
	public static function		  fromURI			(v:URI)				: Asset
	{
		if (v.hasScheme( URIScheme.Scheme('asset')) )
			return fromUnkown( Type.createInstance( v.host.resolveClass(), []) );
		else
			return new ExternalAsset(v);
	}
	
	
	public static function fromUnkown (v:Dynamic, ?factory:Factory) : Asset
	{
		var asset:Asset = null;
		
		if		(v.is(FlashBitmap))		asset = fromFlashBitmap( v.as(FlashBitmap) );
	//	if		(v.is(Factory))			asset = fromFactory( v.as(Factory) );
		else if (v.is(BitmapData))		asset = fromBitmapData( v.as(BitmapData) );
		else if (v.is(DisplayObject))	asset = fromDisplayObject( v.as(DisplayObject), factory );
		else if (v.is(URI))				asset = fromURI( v.as(URI) );
		else if (v.is(ICommunicator))	asset = fromLoader( v.as(ICommunicator) );
		return asset;
	}
#end
	
	

	
	
	
	//
	// CLASS DEF
	//


	/**
	 * cached bitmapdata of the given source
	 */
	private var bitmapData : BitmapData;

#if neko
	private var source		: Dynamic;
#end
#if (neko || debug)
	public var _oid			(default, null)				: Int;
#end
	public var state		(default, null)				: SimpleStateMachine<AssetStates>;
	public var type			(default, null)				: AssetType;
	public var width		(default, null)				: Int;
	public var height		(default, null)				: Int;
	
	
	
	public function new ( #if neko data:Dynamic #end )
	{
#if neko
		source	= data;
#end
		state	= new SimpleStateMachine<AssetStates>(empty);
		width	= height = Number.INT_NOT_SET;
#if (neko || debug)
		_oid	= primevc.utils.ID.getNext();
#end
#if flash9
		Assert.notNull(type);
#end
	}
	
	
	public function dispose ()
	{
		unsetData();
		state.dispose();
		state	= null;
#if (neko || debug)
		_oid	= 0;
#end
	}
	
	
	
	
	public inline function isReady ()			{ return state.is(ready); }
	public inline function isLoading ()			{ return state.is(loading); }
	public inline function isLoadable ()		{ return state.is(loadable); }
	
	public inline function setEmpty ()			{ state.current = AssetStates.empty; }
	public inline function setReady ()			{ state.current = AssetStates.ready; }
	public inline function setLoading ()		{ state.current = AssetStates.loading; }
	public inline function setLoadable ()		{ state.current = AssetStates.loadable; }
	
	public inline function isBitmapData ()		{ return type == AssetType.bitmapData; }
	public inline function isDisplayObject ()	{ return type == AssetType.displayObject; }
//	public inline function isVector ()			{ return type.is(vector); }
	
	
	public function toBitmapData (matrix:Matrix2D = null, transparant:Null<Bool> = null, fillColor:Null<UInt> = null) : BitmapData
	{
		if (isLoadable())
			load();
		
		if (!isReady())
			return null;
		
		if (bitmapData != null && matrix == null && transparant == null && fillColor == null)
			return bitmapData;
		
		if (transparant == null)	transparant = true;
		if (fillColor == null)		fillColor	= 0x00ffffff;
		
#if flash9
		var display = toDisplayObject();
		if (display == null || !display.is(flash.display.IBitmapDrawable))
			return null;
		
		bitmapData = new BitmapData( width, height, transparant, fillColor );
		bitmapData.draw( display.as(flash.display.IBitmapDrawable), matrix );
		return bitmapData;
#else
		return null;
#end
	}
	
	
	private function unsetData ()
	{
		if (state.is(empty))
			return;
		
		close();
		if (state != null)
			setEmpty();		// important to this first, other objects have a chance to remove their references then...
		
		bitmapData	= null;
//		source		= null;
//		type		= null;
		width		= Number.INT_NOT_SET;
		height		= Number.INT_NOT_SET;
	}
	
	
	
	//
	// ABSTRACT METHODS
	//
	
//	private function setData (v:SourceType)	: SourceType	{ Assert.abstract(); return v; }
	public  function toDisplayObject ()		: DisplayObject	{ Assert.abstract(); return null; }
	public  function load ()				: Void			{ Assert.abstract(); }
	public  function close ()				: Void			{ Assert.abstract(); }
#if neko
	public  function isEmpty ()				: Bool			{ return source == null; }
#else
	public  function isEmpty ()				: Bool			{ Assert.abstract(); return false; }
#end
	

#if neko
	public  function cleanUp () : Void				{}
	public  function toCode (code:ICodeGenerator)
	{
		var method:String = null;
		if		(source.is(URI))			method = "fromURI";
		else if (source.is(Factory))		method = "fromFactory";
		else if (source.is(ICommunicator))	method = "fromLoader";
		else if (source.is(String))			method = "fromString";
		else								method = "fromUnkown";
		
		code.constructFromFactory(this, method, [source]);
	}
#end

#if (neko || debug)
	public  function toString ()
	{
		return "."+(state != null ? ""+state.current : "disposed") + " - " + _oid+"; type: "+type;
	}
#end
}



#if !neko
/**
 * @author Ruben Weijers
 * @creation-date Jun 1, 2011
 */
class BitmapAsset extends Asset/*<BitmapData>*/
{
	public var data	(default, setData) : BitmapData;
	
	
	public function new (source:BitmapData = null, width:Int = Number.INT_NOT_SET, height:Int = Number.INT_NOT_SET)
	{
		this.type = AssetType.bitmapData;
		super();
		this.width	= width;
		this.height	= height;
		if (source != null)
			data	= source;
	}
	
	
	override private function unsetData ()
	{
		if (data != null)
			data.dispose();
		
		super.unsetData();
	}
	
	
	private function setData (v:BitmapData)
	{
		if (v != data)
		{
			if (data != null && v == null)
				unsetData();
			
			else if (v != null)
			{
				data	= bitmapData = v;
				width	= v.width;
				height	= v.height;
				setReady();
			}
		}
		return v;
	}
	
	
	override public  function toDisplayObject () : DisplayObject	{ return new primevc.gui.display.BitmapShape( bitmapData ); }
	override public  function load ()								{}
	override public  function isEmpty ()							{ return data == null; }
#if debug
	override public  function toString ()							{ return "BitmapAsset("+data+")" + super.toString(); }
#end
}





/**
 * @author Ruben Weijers
 * @creation-date Jun 1, 2011
 */
class DisplayAsset extends Asset/*<DisplayObject>*/
{
	public var data	(default, setData) : DisplayObject;
	private var factory : Factory;
	
	
	public function new (source:DisplayObject = null, factory:Factory = null)
	{
		this.type		= AssetType.displayObject;
		super();
		this.data		= source;
		this.factory	= factory;
	}
	
	
	private function setData (v:DisplayObject)
	{
		if (v != data)
		{
			if (data != null && v == null)
				unsetData();
			
			data = v;
			
			if (v != null)
			{
				bitmapData	= null;
				width		= v.width.roundFloat();
				height		= v.height.roundFloat();
				setReady();
			}
		}
		return v;
	}
	
	
	override public function toDisplayObject () : DisplayObject
	{
		if (data != null)
			trace(this + ";" + (data.parent != null)+"; "+(factory != null));
		if (data == null && data.parent != null && factory != null)
			return data = factory();
		else
			return data;
	}
	override public  function load ()								{}
	override public  function close ()								{}
	override public  function isEmpty ()							{ return data == null; }
#if debug
	override public  function toString ()							{ return "DisplayAsset("+data+")" + super.toString(); }
#end
}




/**
 * @author Ruben Weijers
 * @creation-date Jun 1, 2011
 */
class BytesAssetBase/*<DataType>*/ extends Asset/*<DataType>*/
{
#if flash9
	private var loader	: Loader;
#end
	
	
	public function new ()							{ type = AssetType.displayObject; super(); }
	override private function unsetData ()			{ disposeLoader(); super.unsetData(); }
	inline	 public  function isLoaded ()			{ return loader != null && loader.isCompleted(); }
	override public  function toDisplayObject ()	{ return isLoaded() ? loader.content : null; }
	override public  function close ()				{ if (loader != null) loader.close(); }
	
	
	private function loadBytes (bytes:BytesData)
	{
#if flash9
		Assert.notNull(bytes);
		if (loader == null)
		{
			loader = new Loader();
			var events = loader.events;
			disposeLoader	.on( events.load.error, this );
			handleLoadError	.on( events.load.error, this );
			handleUnloaded	.on( events.unloaded, this );
			setLoadedData	.on( events.load.completed, this );
		}
		
		setLoading();
		loader.loadBytes( bytes );
#end
	}
	
	
	
	//
	// EVENTHANDLERS
	//
	
	private inline function disposeLoader ()
	{
#if flash9
		if (loader != null)
		{
			if (isLoading())
				loader.close();
		
			loader.dispose();
			loader = null;
		}
#end
		if (isEmpty())	setEmpty();
		else			setLoadable();
	}
	
	
	private function handleLoadError (err:String)	{ trace("Asset load-error: "+err+"; "+this); disposeLoader(); }
	private function handleUnloaded ()				{ setLoadable(); }
	
	
#if flash9
	private function setLoadedData ()
	{
		if (!isLoaded())
			return;
		
		try {
			width	= loader.width.roundFloat();
			height	= loader.height.roundFloat();
			setReady();
		}
		catch (e:flash.errors.Error) {
			handleLoadError("Loading asset error. Check policy settings. "+e.message);
		}
		
	//	trace(loader.content+"; size: "+loader.width+", "+loader.height+"; "+width+", "+height+"; mime: "+loader.info.contentType);
	}	
#end
}



/**
 * @author Ruben Weijers
 * @creation-date Jun 02, 2011
 */
class BytesAsset extends BytesAssetBase/*<BytesData>*/
{
	public var data	(default, setData) : BytesData;
	
	
	public function new (source:BytesData)					{ super(); data = source; }
	override public  function load ()						{ loadBytes(data); }
	override public  function isEmpty ()					{ return data == null; }
#if debug
	override public  function toString ()					{ return "BytesAsset("+data+")" + super.toString(); }
#end
	
	
	private function setData (v:BytesData)
	{
		if (v != data)
		{
			if (data != null)
				unsetData();
			
			if (v != null) {
				data = v;
				setLoadable();
			}
		}
		return v;
	}
}



/**
 * @author Ruben Weijers
 * @creation-date Jun 1, 2011
 */
class ExternalAsset extends BytesAssetBase/*<URI>*/
{
	public var externalLoader	(default, setExternalLoader)	: ICommunicator;
	public var data				(default, setData)				: URI;
	
	
	public function new (source:URI, ?loader:ICommunicator)
	{
		super();
		externalLoader = loader == null ? new URLLoader() : loader;
		data = source;
	}
	
	
	override public function dispose ()
	{
		externalLoader = null;
		super.dispose();
	}
	
	
	override public  function isEmpty ()					{ return data == null; }
#if debug
	override public  function toString ()					{ return "ExternalAsset("+data+")" + super.toString(); }
#end
	
	
	override public function load ()
	{
		if (!isLoadable())
			return;
		
		setLoading();
		
		if (!externalLoader.isCompleted())
			if (externalLoader.is(URLLoader))
				externalLoader.as(URLLoader).load( data );
		else
			loadBytes( externalLoader.bytes );
	}
	
	
	override public  function close ()
	{
		if (isLoading()) {
			externalLoader.close();
			super.close();
		}
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setExternalLoader (v:ICommunicator)
	{
		if (v != externalLoader)
		{
			if (externalLoader != null)
			{
				var events = externalLoader.events;
				events.load.unbind(this);
				events.unloaded.unbind(this);
		//		externalLoader.dispose();		// don't dispose it, could be used by other assets/value-objects
			}
			
			externalLoader = v;
			
			if (v != null)
			{
				if (v.is(URLLoader))
					Assert.that( v.as(URLLoader).isBinary(), "URILoader should load binary data!" );
				
				if (!v.isCompleted()) {
					var events = v.events;
					handleLoadError	.onceOn( events.load.error, this );
					handleURILoaded	.onceOn( events.load.completed, this );
					handleUnloaded	.onceOn( events.unloaded, this );
				}
			}
			
		}
		return v;
	}
	
	
	private function setData (v:URI)
	{
		if (v != data)
		{
			if (data != null)
				unsetData();
			
			if (v != null) {
				data = v;
				setLoadable();
			}
		}
		return v;
	}
	
	
	
	//
	// EVENTHANDLERS
	//
	
	private function handleURILoaded ()
	{
		Assert.notNull( externalLoader );
		Assert.that( externalLoader.isCompleted() );
		loadBytes( externalLoader.bytes );
	}
}
#end


enum AssetStates {
	empty;		//there's no data in the Bitmap
	loadable;	//a loader object is created but not loaded yet
	loading;	//the loader is loading an external resource
	ready;		//the bitmap is filled with bitmap-data
}


enum AssetType {
	bitmapData;
	displayObject;
//	vector;
}