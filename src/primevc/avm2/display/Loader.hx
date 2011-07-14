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
package primevc.avm2.display;
 import flash.display.DisplayObject;
 import flash.display.LoaderInfo;
 import flash.display.SWFVersion;
 import flash.net.URLRequest;
 import flash.system.ApplicationDomain;
 import flash.system.LoaderContext;

 import haxe.io.BytesData;

 import primevc.core.events.LoaderEvents;
 import primevc.core.geom.Rectangle;
 import primevc.core.net.CommunicationType;
 import primevc.core.net.FileType;
 import primevc.core.net.ICommunicator;
 import primevc.core.Bindable;
 import primevc.types.URI;
 import primevc.utils.FastArray;
  using primevc.utils.Bind;
  using primevc.utils.FastArray;
  using primevc.utils.FileUtil;


typedef FlashLoader = flash.display.Loader;


/**
 * @author Ruben Weijers
 * @since sometime in 2010
 */
class Loader implements ICommunicator
{
	//
	// LOADER QUEUE
	//
	
	/**
	 * queue with loaders that are waiting to load until other Loaders
	 * are finished (FIFO).
	 */
	private static var queue:FastArray<Loader>	= FastArrayUtil.create();
	/**
	 * max Loaders loading at the same time. If this number is reached, the
	 * other Loaders will wait in the queue
	 */
	private static inline var MAX_CONNECTIONS	= 5;
	private static 		  var QUEUE_LENGTH		= 0;
	/**
	 * number of active load processes
	 */
	private static var CONNECTIONS				= 0;
	public  static var isPaused (default, null) : Bool;

	private static var firstLoader : Loader 	= null;
	private static var lastLoader  : Loader 	= null;
	
	@:keep public static inline function pauseAll ()
	{
		trace(queueInfo());
		isPaused = true;
	}


	@:keep public static inline function resumeAll ()
	{
		if (isPaused) {
			trace(queueInfo());
			isPaused = false;
			openNextConnection();
		}
	}

	private static inline function loadSlotAvailable () 		: Bool	{ return !isPaused && CONNECTIONS < MAX_CONNECTIONS; }
	private static inline function queueIsEmpty ()				: Bool	{ return QUEUE_LENGTH == 0; }
	private static inline function addConnection (l:Loader)		: Void	{ Assert.that(!isPaused); CONNECTIONS++; /*trace(CONNECTIONS); active.push(l); trace(active);*/ }
	private static inline function removeConnection (l:Loader)	: Void	{ Assert.that(CONNECTIONS > 0, CONNECTIONS); CONNECTIONS--; /*active.removeItem(l); trace(active); trace(CONNECTIONS);*/ openNextConnection(); }


	private static inline function openNextConnection ()
	{
		if (!isPaused && !queueIsEmpty() && loadSlotAvailable())
		{
			var l = firstLoader;
			Assert.notNull(l);
			Assert.that(!l.isLoaded());
			Assert.that(!l.isStarted);
			Assert.that(!l.isFinished);
			var uri = l.lastURI,
				c	= l.lastContext;
			
			removeFromQueue(l);
			trace(queueInfo()+"; "+l.id);
			l.startLoading(uri, c);
		}
	}


	private static inline function addToQueue (l:Loader)
	{
		if (firstLoader == null)	firstLoader = l;
		if (lastLoader  == null)	lastLoader  = l;
		else {
			lastLoader.nextLoader	= l;
			l.prevLoader			= lastLoader;
			lastLoader				= l;
		}
		QUEUE_LENGTH++;
	//	trace(queueInfo()+"; "+l.id);
	}


	private static inline function removeFromQueue (l:Loader)
	{
		if (l.isQueued())
		{
			if (l == firstLoader)	firstLoader = l.nextLoader;
			if (l == lastLoader)	lastLoader	= l.prevLoader;

			if (l.prevLoader != null)	l.prevLoader.nextLoader = l.nextLoader;
			if (l.nextLoader != null)	l.nextLoader.prevLoader = l.prevLoader;

			l.nextLoader	= l.prevLoader = null;
			l.lastURI		= null;
			l.lastContext	= null;

			QUEUE_LENGTH--;
#if debug
			Assert.that(QUEUE_LENGTH > -1);
			if (QUEUE_LENGTH > 0)
				Assert.notNull(firstLoader, queueInfo());
#end
						
		//	trace(queueInfo()+"; "+l.id);
		}
	//	trace(l+"; first: "+firstLoader+"; last: "+lastLoader);
	}



	private var lastURI		: URI;
	private var lastContext	: LoaderContext;
	private var nextLoader	: Loader;
	private var prevLoader	: Loader;

	private inline function isQueued ()
	{
		return prevLoader != null || nextLoader != null || firstLoader == this;
	}


#if debug
	private static inline function queueInfo()
	{
		return "connections: "+CONNECTIONS + " / "+MAX_CONNECTIONS+"; queue: "+QUEUE_LENGTH+"; first: "+firstLoader+"; last: "+lastLoader;
	}
#end


	//
	// LOADER FREELIST IMPLEMENTATION
	//

	private static inline var	MAX_LOADERS : Int = 50;
	private static var	 		free		: Loader;
	private static var			freeCount	: Int = 0;

	@:keep public static function get () : Loader
	{
		var r:Loader = null,		//loader to return
			L		 = Loader;		//Loader class
		
		if (L.free == null)
			r = new Loader();
		else
		{
			r			= L.free;
			L.free		= r.nextFree;
			r.nextFree	= null;
			--L.freeCount;
		}
		Assert.notNull(r);
		return r;
	}


	/**
	 * Reference to the next free loader (if there is any)
	 */
	private var nextFree		: Loader;




	//
	// CLASS IMPLEMENTATION
	//


	public static var defaultContext = new LoaderContext(false, new ApplicationDomain());
	
	public  var events			(default,			null)		: LoaderSignals;
	
	public  var bytes			(getBytes,			setBytes)	: BytesData;
	public  var bytesProgress	(getBytesProgress,	never)		: Int;
	public  var bytesTotal		(getBytesTotal,		never)		: Int;
	public  var type			(default,			null)		: CommunicationType;
	public  var length			(default,			null)		: Bindable<Int>;

//	public  var isQueued		(default,			null)		: Bool;
	public  var isStarted		(default,			null)		: Bool;
	private var isFinished										: Bool;
	
	public  var info			(getInfo,			never)		: LoaderInfo;
	public  var content			(getContent,		null)		: DisplayObject;
	public  var height			(getHeight,			never)		: Float;
	public  var width			(getWidth,			never)		: Float;
	public  var isAnimated		(default,			null)		: Bool;
	
	private var loader			: FlashLoader;
	private var fileType		: FileType;
	
#if debug
	private static var counter = 0;
	private var id : Int;
#end

	
	public function new ()
	{
#if debug
		id = counter++;
#end
		loader		= new FlashLoader();
		events		= new LoaderEvents( info );
		isAnimated	= false;
		
		setStarted	.on( events.load.started, 	 this );
		setFinished	.on( events.load.completed,  this );
		unsetStarted.on( events.load.error, 	 this );
	//	unsetStarted.on( events.unloaded,		 this );
	}
	
	
	/**
	 * Method will unload the given Loader and add it to the freelist
	 * if the MAX_LOADERS isn't reached. Otherwise the loader will be
	 * disposed.
	 */
	public function dispose ()
	{
	//	trace(id+"; "+queueInfo()+"; "+isQueued());
	//	trace("first: "+firstLoader+"; last: "+lastLoader);
		
		close();
		unload();

		Assert.that(!isFinished);
		Assert.that(!isStarted);

		// freelist shizzle
		if (freeCount == MAX_LOADERS)
		{
			events.dispose();
			nextFree	= null;
			loader		= null;
			events		= null;
		}
		else
		{
#if flash9	if (loader.parent != null)
				loader.parent.removeChild(loader);
#end
			Assert.null(nextFree);
			var L = Loader;
			nextFree = L.free;
			L.free	 = this;
			L.freeCount++;
		}
	}
	
	
	@:keep public  function load (v:URI, ?c:LoaderContext) : Void
	{
		if (isStarted)
			close();
		
		type 		= CommunicationType.loading;
		isFinished	= false;
		if (isQueued())
			removeFromQueue(this);
		
		if (loadSlotAvailable())
			startLoading(v, c);
		else
		{
			lastURI		= v;
			lastContext	= c;
			addToQueue(this);
		}
	//	trace(id+"; "+queueInfo()+"; "+isQueued());
	//	trace(id+": "+CONNECTIONS + " / "+MAX_CONNECTIONS+"; queue: "+queue.length+"; "+v+"; "+loadQueueIndex);
	}


	private /*inline*/ function startLoading (v:URI, ?c:LoaderContext)
	{
		if (c == null)
			c = defaultContext;
#if debug	
		Assert.notNull(v, this);
		Assert.that(!isQueued(), this);
#end
		isStarted = true;
		addConnection(this);
		trace(id+": "+v);
		loader.load(new URLRequest(v.toString()), c);
	}
	
	
	public inline function loadBytes (v:BytesData, ?c:LoaderContext) : BytesData
	{
		Assert.notNull(v);
		if (isStarted)
			close();
		
		isStarted	= true;
		type		= CommunicationType.loading;
		
		if (c == null)
			c = defaultContext;
		
		loader.loadBytes(v, c);
		return v;
	}
	
	
	public inline function unload () : Void
	{
#if flash10	loader.unloadAndStop();
#else		loader.unload(); #end
			fileType	= null;
			type		= null;
			isFinished	= false;
	}
	
	public inline function close () : Void
	{
		if (isStarted && !isLoaded()) {
			try { loader.close(); } 
			catch(e:Dynamic) { trace(this+": loader close error: "+e); }
		}
		
		else if (isQueued()) {
		//	trace(id+"; "+queueInfo()+"; "+isQueued());
			removeFromQueue(this);
		}
		unsetStarted();
	}


	public inline function isSwf () : Bool			{ return fileType == FileType.SWF; }
	public inline function isLoaded () : Bool		{ return bytesTotal > 0 && bytesProgress >= bytesTotal; }
	public inline function isCompleted () : Bool	{ return isFinished; } //bytesTotal > 0 && bytesProgress >= bytesTotal; }
	public inline function isInProgress ()			{ return isStarted && !isCompleted(); }
//	public inline function isAnimated () : Bool		{ return info.frameRate > 2; }
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getBytes ()				{ return info.bytes; }
	private inline function setBytes (v:BytesData)	{ return loadBytes(v); }
	
	private inline function getInfo ()				{ return loader.contentLoaderInfo; }
	private inline function getBytesProgress ()		{ return info.bytesLoaded; }
	private inline function getBytesTotal ()		{ return info.bytesTotal; }
//	private inline function getLength ()			{ return 1; }
	
	private inline function getWidth ()				{ return info.width; }
	private inline function getHeight ()			{ return info.height; }
	
	
	/**
	 * Method will try to return the content of the flash-loader to allow the
	 * loader to be disposed without losing the loaded content.
	 * 
	 * If the loaded content is an avm1-movie, the loader will be returned 
	 * since the content can't be seperated from the loader. This also means
	 * that when a avm1-movie is loaded and used on the stage, it will be unloaded
	 * when this loader is getting disposed!
	 * 
	 * If the loaded content is an avm2-movie, the loader will also be returned
	 * since some flex-swf's will otherwise throw errors.
	 */
	private function getContent () : DisplayObject
	{
		if (content != null)
			return content;
		
		var c:DisplayObject = null;
	//	trace(info.actionScriptVersion+"; "+info.contentType);
		if (fileType == null)
			fileType = info.contentType.toFileType();
		
		if ( isSwf() )
		{
			loader.scrollRect	= new Rectangle(0, 0, width, height);
			isAnimated			= info.frameRate > 2;
			c = loader;
		}
		else
		{
			c = loader.contentLoaderInfo.content;
			isAnimated = false;
		}
		
		
		if (!isAnimated)
			c.cacheAsBitmap	= true;
		
		return content = c;
		/*try {
			if (loader.contentLoaderInfo.swfVersion < 9)
				return loader;
			else
				return loader; //cast loader.contentLoaderInfo.content;
		}
		catch (e:Dynamic) {
			return cast loader.contentLoaderInfo.content;
		}*/
	}
	
	
	
	//
	// EVENTHANDLERS
	//
	
	private inline function setStarted ()	{ isStarted = true; }
	private inline function setFinished ()	{ isFinished = true; unsetStarted(); }
	private inline function unsetStarted ()	{ if (isStarted) { isStarted = false; removeConnection(this); } }

#if debug
	public function toString ()
	{
		return "Loader( "+id+"; "
			+ (loader != null ? (bytesProgress+" / "+bytesTotal) : "")
			+ (isStarted ? " - started" : "") 
			+ (isCompleted() ? " - completed" : "") 
			+ (isInProgress() ? " - progress" : "")
			+ ")"; // + ((untyped this).content != null ? "; content: " + (untyped this).content+")" : "");
	}
#end
}