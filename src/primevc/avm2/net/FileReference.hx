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
 import primevc.core.events.LoaderEvents;
 import primevc.gui.traits.ICommunicator;
 import primevc.types.URI;



private typedef FlashFileRef = flash.net.FileReference;


/**
 * AVM2 FileReference implementation
 * 
 * @author Ruben Weijers
 * @creation-date Mar 29, 2011
 */
class FileReference implements ICommunicator
{
	public var events		(default, null)					: LoaderEvents;
	public var bytesLoaded	(getBytesLoaded, never)			: UInt;
	public var bytesTotal	(getBytesTotal, never)			: UInt;
	public var isLoaded		(getIsLoaded, never)			: Bool;
	public var data			(getData, never)				: Dynamic;
	
	private var loader		: FlashFileRef;
	
	
	public function new (ref:FlashFileRef = null)
	{
		this.ref	= ref != null ? ref : new FlashFileRef();
		events		= new LoaderEvents(this.ref);
	}
	
	
	public function dispose ()
	{
		close();
		events.dispose();
		events	= null;
		loader	= null;
	}
	
	
	public inline function load ()					{ Assert.equal(bytesTotal, 0 ); return loader.load(); }
	public inline function close ()					{ return loader.cancel(); }
	public inline function browse (?types:Array)	{ return loader.browse(types); }
	public inline function upload ()
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getBytesLoaded ()		{ return loader.bytesLoaded; }
	private inline function getBytesTotal ()		{ return loader.bytesTotal; }
	private inline function getData ()				{ return loader.data; }
	private inline function getDataFormat ()		{ return loader.dataFormat; }
	private inline function setDataFormat (v)		{ return loader.dataFormat  = v; }
	
	private inline function getIsLoaded () {
		return bytesTotal > 0 && bytesLoaded >= bytesTotal;
	}
}