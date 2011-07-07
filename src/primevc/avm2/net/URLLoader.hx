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
package primevc.avm2.net;
 import flash.net.URLLoaderDataFormat;
 import flash.net.URLRequest;

 import haxe.io.BytesData;

 import primevc.core.events.LoaderEvents;

 import primevc.core.net.CommunicationType;
 import primevc.core.net.ICommunicator;
 import primevc.core.net.URLVariables;
 import primevc.core.Bindable;

 import primevc.types.Number;
 import primevc.types.URI;
 import primevc.utils.FastArray;
#if debug
  using primevc.core.net.HttpStatusCodes;
#end
  using primevc.utils.Bind;
  using primevc.utils.FastArray;
  using primevc.utils.NumberUtil;
  using Std;


private typedef FlashLoader = flash.net.URLLoader;


/**
 * AVM2 URLLoader implementation
 * 
 * @author Ruben Weijers
 * @creation-date Sep 04, 2010
 */
class URLLoader implements ICommunicator
{
	//
	// URLLOADER QUEUE
	//
	
	/**
	 * queue with urlloaders that are waiting to load until other URLLoaders
	 * are finished (FIFO).
	 */
	private static var queue:FastArray<URLLoader>	= FastArrayUtil.create();
	/**
	 * max URLLoaders loading at the same time. If this number is reached, the
	 * other URLLoaders will wait in the queue
	 */
	private static inline var MAX_CONNECTIONS		= 30;
	/**
	 * number of active load processes
	 */
	private static		  var CONNECTIONS			= 0;
	
	
	private static inline function loadSlotAvailable () 		: Bool	{ return CONNECTIONS < MAX_CONNECTIONS; }
	private static inline function queueIsEmpty ()				: Bool	{ return queue.length == 0; }
	private static inline function openNextConnection ()		: Void	{ if (!queueIsEmpty() && loadSlotAvailable()) { var n = queue.shift(); n.loadRequest(n.lastRequest); } }
	private static inline function addToQueue (l:URLLoader)		: Void	{ queue.push(l); }
	private static inline function removeFromQueue (l:URLLoader): Void	{ queue.removeItem(l); }
	private static inline function addConnection ()				: Void	{ CONNECTIONS++; }
	private static inline function removeConnection ()			: Void	{ CONNECTIONS--; openNextConnection(); }
	
	
	
	//
	// URLLOADER IMPLEMENTATION
	//
	
	public static inline var STARTED	= 1 << 0;
	public static inline var QUEUED		= 1 << 1;
	public static inline var LOADING	= 1 << 2;
	public static inline var COMPLETED	= 1 << 3;
	
	public var events			(default,			null)			: LoaderSignals;
	public var bytesProgress	(getBytesProgress,	null)			: Int;
	public var bytesTotal		(getBytesTotal,		null)			: Int;
	public var length			(default,			never)			: Bindable<Int>;
	public var type				(default,			null)			: CommunicationType;
	public var isStarted		(default,			null)			: Bool;
	public var isQueued			(default,			null)			: Bool;
	
	public var data				(getData,			setData)		: Dynamic;
	public var bytes			(getBytes,			setBytes)		: BytesData;
	public var dataFormat		(getDataFormat,		setDataFormat)	: URLLoaderDataFormat;
	private var loader			: FlashLoader;
#if debug
	private var uri				: URI;
#end
	
	
	public function new (loader:FlashLoader = null)
	{
		if (loader == null)
		{
			this.loader = new FlashLoader();
			setBinary();
		}
		else
		{
			this.loader	= loader;
		}
		
		bytesProgress	= bytesTotal = Number.INT_NOT_SET;
		events			= new LoaderEvents(this.loader);
		
		setStarted		.on( events.load.started, 	 this );
		unsetStarted	.on( events.load.completed,  this );
		unsetStarted	.on( events.load.error, 	 this );
		unsetStarted	.on( events.unloaded,		 this );
		
//#if debug	trackError.on( events.load.error, this ); #end
//#if debug	trackHttpStatus.on( events.httpStatus, this ); #end		
//#if debug	trackCompleted.on( events.load.completed, this ); #end
	}
	
	
	public function dispose ()
	{
		if (isStarted)
			close();
		
		if (isQueued)
			removeFromQueue(this);
		
		events.dispose();
		events	= null;
		type	= null;
		loader	= null;
		data	= null;
#if debug	uri	= null; #end
	}
	
	
	public function binaryPOST (uri:URI, mimetype:String = "application/octet-stream")
	{
			this.type	= CommunicationType.sending;
#if debug	this.uri	= uri; #end
		
		var request		= uri.toRequest();
		request.requestHeaders.push(new flash.net.URLRequestHeader("Content-type", mimetype));
	//	request.requestHeaders.push(new flash.net.URLRequestHeader("Content-Length", bytes.length.string()));	<-- not allowed in as3
		request.requestHeaders.push(new flash.net.URLRequestHeader("Cache-Control", "no-cache"));
		request.method = flash.net.URLRequestMethod.POST;
		request.data   = bytes;
		
	//	trace(request);
		loadRequest(request);
	}
	
	
	public function formPOST (uri:URI, vars:URLVariables)
	{
			this.type	= CommunicationType.sending;
#if debug	this.uri	= uri; #end
		
		var request		= uri.toRequest();
		request.requestHeaders.push(new flash.net.URLRequestHeader("Content-type", "multipart/form-data"));
		request.method = flash.net.URLRequestMethod.POST;
		request.data   = vars;
		
		setBinary();
		loadRequest(request);
	}
	
	
	public inline function load (v:URI)
	{
#if debug
		Assert.that(bytesTotal.notSet() || bytesTotal == 0, this.toString() );
	 	uri	= v;
#end
		this.type	= CommunicationType.loading;
		return loadRequest(v.toRequest());
	}
	
	
	private var lastRequest : URLRequest;
	
	private inline function loadRequest(request:URLRequest)
	{
		if (isStarted)
			close();
		
		if (isQueued) {
			removeFromQueue(this);
			isQueued = false;
		}
		
		if (loadSlotAvailable())
		{
			isStarted = true;
			addConnection();
			loader.load(request);
		}
		else
		{
			lastRequest = request;
			addToQueue(this);
			isQueued = true;
		}
		
	//	trace(CONNECTIONS + " / "+MAX_CONNECTIONS+"; queue: "+queue.length+"; "+request.url+isQueued);
	}
	
	
	public inline function close ()
	{
		loader.close();
		isStarted	= false;
		bytesTotal	= bytesProgress = Number.INT_NOT_SET;
		type		= null;
#if debug	uri		= null; #end
		events.unloaded.send();
	}
	
	
	public inline function isCompleted ()			{ return bytesTotal > 0 && bytesProgress >= bytesTotal; }
	public inline function isInProgress ()			{ return isStarted && !isCompleted(); }
	
	public inline function isBinary ()		: Bool	{ return loader.dataFormat == URLLoaderDataFormat.BINARY; }
	public inline function isText ()		: Bool	{ return loader.dataFormat == URLLoaderDataFormat.TEXT; }
	public inline function isVariables ()	: Bool	{ return loader.dataFormat == URLLoaderDataFormat.VARIABLES; }
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getBytesProgress ()		{ return bytesProgress.isSet()	? bytesProgress	: loader.bytesLoaded; }
	private inline function getBytesTotal ()		{ return bytesTotal.isSet()  	? bytesTotal	: loader.bytesTotal; }
	private inline function getData ()				{ return data != null			? data			: loader.data; }
	public  inline function getRawData ()			{ return loader.data; }
//	private inline function getLength ()			{ return 1; }
	
	private inline function getDataFormat ()		{ return loader.dataFormat; }
	private inline function setDataFormat (v)		{ return loader.dataFormat  = v; }
	
	
	private  function setData (v)
	{
		if (data != v)
		{
			data = v;
			
			if (v != null) {
				if		(Std.is(v, URLVariables))	setVariables();
				else if (Std.is(v, BytesData))		setBinary();
				else								setText();
			}
			bytesProgress = bytesTotal = Number.INT_NOT_SET;
		}
		return v;
	}
	
	
	private inline function getBytes () : BytesData	{ return isBinary() ? cast(data, BytesData) : null; }
	private inline function setBytes (v:BytesData)
	{
		data = v;
		
		if (v != null)
			bytesProgress = bytesTotal = v.length;
		
		return v;
	}
	
	
	public inline function setBinary ()		: Void		{ loader.dataFormat = URLLoaderDataFormat.BINARY; }
	public inline function setText ()		: Void		{ loader.dataFormat = URLLoaderDataFormat.TEXT; }
	public inline function setVariables ()	: Void		{ loader.dataFormat = URLLoaderDataFormat.VARIABLES; }
	
	
	//
	// EVENTHANDLERS
	//
	
	private function setStarted ()		{ isStarted = true; }
	private function unsetStarted ()	{ isStarted = false; removeConnection(); }
	
#if debug
	public function toString ()
	{
		return "URLLoader("+bytesProgress+" / "+bytesTotal + (isStarted ? " - started" : "") + (isCompleted() ? " - completed" : "") + (isInProgress() ? " - progress" : "") + "; " + loader.dataFormat + "; "+uri+")";
	}
	
//	private function trackError ()		{ trace(loader.data); }
//	private function trackHttpStatus (status:Int)		{ trace(status.read()+" => "+uri+"[ "+bytesProgress+" / "+ bytesTotal+" ]; type: "+type+"; format: "+dataFormat+"; "+loader.data); }
//	private function trackCompleted ()					{ trace(uri+"[ "+bytesProgress+" / "+ bytesTotal+" ]; type: "+type+"; format: "+dataFormat+"; "+loader.data); }
#end
}