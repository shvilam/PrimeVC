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
 import flash.display.IBitmapDrawable;
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
	public static inline function createEmptyBitmap	(w:Int, h:Int)					: Asset	{ return fromBitmapData( new BitmapData(w, h) ); }
	
	
	public static function fromURI (v:URI) : Asset
	{
		if (v == null)
			return null;
		if (v.hasScheme( URIScheme.Scheme('asset')) )
			return fromUnkown( Type.createInstance( v.host.resolveClass(), []) );
		else
			return new ExternalAsset(v);
	}
	
	
	public static function fromUnkown (v:Dynamic, ?factory:Factory) : Asset
	{
		var asset:Asset = null;
		
		if		(v.is(FlashBitmap))		asset = fromFlashBitmap(	v.as(FlashBitmap) );
	//	else if	(v.is(Factory))			asset = fromFactory(		v.as(Factory) );
		else if (v.is(BitmapData))		asset = fromBitmapData(		v.as(BitmapData) );
		else if (v.is(DisplayObject))	asset = fromDisplayObject(	v.as(DisplayObject), factory );
		else if (v.is(URI))				asset = fromURI(			v.as(URI) );
		else if (v.is(ICommunicator))	asset = fromLoader(			v.as(ICommunicator) );
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
		state	= new SimpleStateMachine<AssetStates>(empty);
		width	= height = Number.INT_NOT_SET;
#if neko			source	= data; #end
#if (neko || debug)	_oid	= primevc.utils.ID.getNext(); #end
#if flash9			Assert.notNull(type); #end
	}
	
	
	public function dispose ()
	{
		unsetData();
		state.dispose();
		state	= null;
#if neko				source	= null; #end
#if (neko || debug)		_oid	= 0; #end
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
		var display = toDrawable();
		if (display == null)
			return null;
		
		bitmapData = new BitmapData( width, height, transparant, fillColor );
		bitmapData.draw( display, matrix );
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
		
		removeBitmapData();
//		source		= null;
//		type		= null;
		width		= Number.INT_NOT_SET;
		height		= Number.INT_NOT_SET;
	}


	private inline function removeBitmapData ()
	{
		if (bitmapData != null) {
			bitmapData.dispose();
			bitmapData	= null;
		}
	}
	
	
	
	//
	// ABSTRACT METHODS
	//
	
//	private function setData (v:SourceType)	: SourceType		{ Assert.abstract(); return v; }
	public  function toDisplayObject ()		: DisplayObject		{ Assert.abstract(); return null; }
#if flash9
	public  function toDrawable ()			: IBitmapDrawable	{ Assert.abstract(); return null; }
#end
	public  function load ()				: Void				{ Assert.abstract(); }
	public  function close ()				: Void				{ Assert.abstract(); }
#if neko
	public  function isEmpty ()				: Bool				{ return source == null; }
#else
	public  function isEmpty ()				: Bool				{ Assert.abstract(); return false; }
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
class BitmapAsset extends Asset
{
	public var data	(default, setData) : BitmapData;
	
	
	public function new (source:BitmapData = null)
	{
		this.type = AssetType.bitmapData;
		super();
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
			
			removeBitmapData();
			data = v;
			if (v != null)
			{
				bitmapData = v;
				width	= v.width;
				height	= v.height;
				setReady();
			}
		}
		return v;
	}
	
	
	override public  function toDisplayObject () : DisplayObject	{ return new primevc.gui.display.BitmapShape( bitmapData ); }
#if flash9
	override public  function toDrawable ()		 : IBitmapDrawable	{ return bitmapData; }
#end
	override public  function load ()								{}
	override public  function close ()								{}
	override public  function isEmpty ()							{ return data == null; }
#if debug
	override public  function toString ()							{ return "BitmapAsset("+data+")" + super.toString(); }
#end
}





/**
 * @author Ruben Weijers
 * @creation-date Jun 1, 2011
 */
class DisplayAsset extends Asset
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
			removeBitmapData();

			if (v != null)
			{
				width		= v.width.roundFloat();
				height		= v.height.roundFloat();
				setReady();
			}
		}
		return v;
	}
	
	
	override public function toDisplayObject () : DisplayObject
	{
		if (data == null || (data.parent != null && factory != null))
			return data = factory();
		else
			return data;
	}

#if flash9
	override public  function toDrawable ()		 : IBitmapDrawable	{ return data == null ? toDisplayObject() : data; }
#end
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
class BytesAssetBase extends Asset
{
#if flash9
	private var loader	: Loader;
#end
	
	
	public function new ()										{ type = AssetType.displayObject; super(); }
	override private function unsetData ()						{ disposeLoader(); super.unsetData(); }
	inline	 public  function isLoaded ()						{ return loader != null && loader.isCompleted(); }
	override public  function toDisplayObject ()				{ return isLoaded() ? loader.content : null; }
#if flash9
	override public  function toDrawable () : IBitmapDrawable	{ return toDisplayObject(); }
#end
	override public  function close ()							{ if (loader != null) loader.close(); }
	
	
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
class BytesAsset extends BytesAssetBase
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
class ExternalAsset extends BytesAssetBase
{
	public var externalLoader	(default, setExternalLoader)	: ICommunicator;
	public var data				(default, setData)				: URI;
	
	
	public function new (source:URI, ?loader:ICommunicator)
	{
		super();
		externalLoader = loader == null ? new URLLoader() : loader;
		data = source;
	}
	
	
	override public  function dispose ()
	{
		super.dispose();
		externalLoader = null;
	}
	
	
	override public  function isEmpty ()					{ return data == null; }
#if debug
	override public  function toString ()					{ return "ExternalAsset("+data+")" + super.toString(); }
#end
	
	
	override public  function load ()
	{
		if (!isLoadable())
			return;
		
		setLoading();
		
		if		(externalLoader.isCompleted())		loadBytes( externalLoader.bytes );	
		else if (externalLoader.is(URLLoader))		externalLoader.as(URLLoader).load( data );
	}
	
	
	override public  function close ()
	{
		if (externalLoader != null && externalLoader.isInProgress())
			externalLoader.close();
		
		super.close();
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
				events.load.error		.unbind(this);
				events.load.completed	.unbind(this);
				events.unloaded			.unbind(this);
		//		externalLoader.dispose();		// don't dispose it, could be used by other assets/value-objects
			}
			
			externalLoader = v;
			
			if (v != null)
			{
				if (v.is(URLLoader))
					Assert.that( v.as(URLLoader).isBinary(), "URILoader should load binary data!" );
				
				if (!v.isCompleted()) {
					var events = v.events;
					handleLoadError	.onceOn( events.load.error,		this );
					handleURILoaded	.onceOn( events.load.completed,	this );
					handleUnloaded	.onceOn( events.unloaded,		this );
				}
				
				if (v.isCompleted())
					setLoadable();
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
		Assert.that( externalLoader.isCompleted(), ""+externalLoader );
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
}