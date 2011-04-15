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
package primevc.avm2.net;
 import flash.net.URLLoaderDataFormat;
 import flash.net.URLRequest;

 import haxe.io.BytesData;

 import primevc.core.events.LoaderEvents;
 import primevc.core.net.CommunicationType;
 import primevc.core.net.FileFilter;
 import primevc.core.net.ICommunicator;
 import primevc.core.net.URLVariables;
 import primevc.gui.events.SelectEvents;
 import primevc.types.URI;
  using primevc.utils.Bind;
  using primevc.utils.FileUtil;
  using Std;



private typedef FlashFileRef = flash.net.FileReference;


/**
 * AVM2 FileReference implementation
 * 
 * @author Ruben Weijers
 * @creation-date Mar 29, 2011
 */
class FileReference extends SelectEvents, implements ICommunicator
{
	public var events			(default,				null)		: LoaderEvents;
	
	public var bytesProgress	(getBytesProgress,		null)		: Int;
	public var bytesTotal		(getBytesTotal,			null)		: Int;
	public var bytes			(getBytes,				setBytes)	: BytesData;
	public var type				(default,				null)		: CommunicationType;
	public var length			(getLength,				null)		: Int;
	public var isStarted		(default,				null)		: Bool;
	
	public var creationDate		(getCreationDate,	 	never)		: Date;
	public var creator			(getCreator,		 	never)		: String;
	public var modificationDate	(getModificationDate,	never)		: Date;
	public var name				(getName,				never)		: String;
	public var fileType			(getFileType,			never)		: String;
	
	private var loader			: FlashFileRef;
	
	
	public function new (loader:FlashFileRef = null)
	{
		this.loader	= loader != null ? loader : new FlashFileRef();
		events		= new LoaderEvents(this.loader);
		super(this.loader);
		
		var e = events.load;
		updateProgress	.on( e.progress,	this );
		
		setStarted		.on( e.started, 	this );
		unsetStarted	.on( e.completed, this );
		unsetStarted	.on( e.error, 	this );
		unsetStarted	.on( events.unloaded,		this );
		unsetStarted	.on( events.uploadComplete,	this );
	}
	
	
	override public function dispose ()
	{
		close();
		events.dispose();
		events	= null;
		type	= null;
		loader	= null;
		super.dispose();
	}
	
	
	public inline function close ()								{ return loader.cancel(); }
	public inline function browse (?types:Array<FileFilter>)	{ return loader.browse(types); }
	
	
	public inline function load ()
	{
		if (isStarted)
			close();
		
		type = CommunicationType.loading;
		return loader.load();
	}
	
	
	public /*inline*/ function upload (uri:URI, vars:URLVariables, uploadDataFieldName:String = "file")
	{
		if (isStarted)
			close();
		
		type			= CommunicationType.sending;
		
		var request		= uri.toRequest();
		request.method	= flash.net.URLRequestMethod.POST;
		request.data	= vars;
		bytesProgress	= 0;
		
		trace(uri);
		loader.upload(request, uploadDataFieldName);
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getBytesProgress ()		{ return bytesProgress; }
	private inline function getBytesTotal ()		{ return loader.size.int(); }
	private inline function getBytes ()				{ return loader.data; }
	private inline function setBytes (v)			{ Assert.abstract(); return null; }		// impossible to set the bytes of a file-reference!
	private inline function getLength ()			{ return 1; }
	
	private inline function getModificationDate ()	{ return loader.modificationDate; }
	private inline function getCreationDate ()		{ return loader.creationDate; }
	private inline function getCreator ()			{ return loader.creator; }
	private inline function getName ()				{ return loader.name; }
	
	/**
	 * Method will return the FileReference.type variable when it's not null or 
	 * the extension of the file
	 */
	private inline function getFileType ()			{ return loader.type == null ? name.getExtension() : loader.type; }
	public inline function isCompleted ()			{ return bytesTotal > 0 && bytesProgress >= bytesTotal; }
	
	
	//
	// EVENTHANDLERS
	//
	
	private function updateProgress (loaded:Int, total:Int)
	{
	//	trace(loaded+"/"+total);
		this.bytesProgress = loaded;
	//	this.bytesTotal = total;
	}
	
	private function setStarted ()		{ isStarted = true; }
	private function unsetStarted ()	{ isStarted = false; }
	
	
#if debug
	public function toString ()
	{
		return "FileReference( "+type+" => "+bytesProgress + " / " + bytesTotal + " - started? "+ isStarted +" )";
	}
#end
}