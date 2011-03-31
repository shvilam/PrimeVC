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
 import primevc.core.net.FileFilter;
 import primevc.gui.events.SelectEvents;
 import primevc.gui.traits.ICommunicator;
 import primevc.types.URI;
  using primevc.utils.Bind;
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
	public var events			(default,				null)	: LoaderEvents;
	
	public var bytesLoaded		(getBytesLoaded,		null)	: Int;
	public var bytesTotal		(getBytesTotal,			never)	: Int;
	public var isLoaded			(getIsLoaded,			never)	: Bool;
	public var data				(getData,				never)	: BytesData;
	
	public var creationDate		(getCreationDate,	 	never)	: Date;
	public var creator			(getCreator,		 	never)	: String;
	public var modificationDate	(getModificationDate,	never)	: Date;
	public var name				(getName,				never)	: String;
	public var type				(getType,				never)	: String;
	
	private var loader		: FlashFileRef;
	
	
	public function new (loader:FlashFileRef = null)
	{
		this.loader	= loader != null ? loader : new FlashFileRef();
		events		= new LoaderEvents(this.loader);
		super(this.loader);
		
		updateProgress.on( events.load.progress, this );
	}
	
	
	override public function dispose ()
	{
		close();
		events.dispose();
		events	= null;
		loader	= null;
		super.dispose();
	}
	
	
	public inline function load ()								{ Assert.equal(bytesTotal, 0 ); return loader.load(); }
	public inline function close ()								{ return loader.cancel(); }
	public inline function browse (?types:Array<FileFilter>)	{ return loader.browse(types); }
//	public inline function upload ()
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getBytesLoaded ()		{ return bytesLoaded; }
	private inline function getBytesTotal ()		{ return loader.size.int(); }
	private inline function getData ()				{ return loader.data; }
	private inline function getModificationDate ()	{ return loader.modificationDate; }
	private inline function getCreationDate ()		{ return loader.creationDate; }
	private inline function getCreator ()			{ return loader.creator; }
	private inline function getName ()				{ return loader.name; }
	private inline function getType ()				{ return loader.type; }
	
	private inline function getIsLoaded () {
		return bytesTotal > 0 && bytesLoaded >= bytesTotal;
	}
	
	
	//
	// EVENTHANDLERS
	//
	
	private function updateProgress (loaded:UInt, total:UInt)
	{
		this.bytesLoaded	= loaded;
	//	this.bytesTotal		= total;
	}
}