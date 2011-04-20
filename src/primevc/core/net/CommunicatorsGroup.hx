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
package primevc.core.net;
 import haxe.io.BytesData;
 import haxe.FastList;
 import primevc.core.events.LoaderEvents;
 import primevc.core.Bindable;
 import primevc.types.Number;
  using primevc.utils.Bind;
  using primevc.utils.NumberUtil;



/**
 * Group of multiple ICommunicators, but acting as one. This way it's possible
 * to display the progress of multiple ICommunicators in one ProgressBar.
 * 
 * @author Ruben Weijers
 * @creation-date Apr 19, 2011
 */
class CommunicatorsGroup implements ICommunicator
{
	public var events			(default,			null)		: LoaderSignals;
	public var bytes			(getBytes,			setBytes)	: BytesData;
	public var type				(default,			null)		: CommunicationType;
	
	
	/**
	 * Total bytes loaded/send for all processes together
	 */
	public var bytesProgress	(getBytesProgress,	null)		: Int;
	/**
	 * Total number of bytes to load/send for all processes together
	 */
	public var bytesTotal		(getBytesTotal,		null)		: Int;
	
	/**
	 * Indicates the number of process going on within the communicator
	 */
	public var length			(default,			null)		: Bindable<Int>;
	public var isStarted		(default,			null)		: Bool;
	
	
	private var list			: FastList<ICommunicator>;
	
	
	public function new ()
	{
		events	= new LoaderGroupEvents();
		list	= new FastList<ICommunicator>();
		length	= new Bindable<Int>(0);
		
		bytesProgress = bytesTotal = Number.INT_NOT_SET;
	}
	
	
	public function dispose ()
	{
		removeAll();
		length.dispose();
		events.dispose();
		events = null;
		length = null;
	}
	
	
	public inline function removeAll ()
	{
		while (list.head != null)
			list.pop().events.load.unbind(this);
		
		length.value = 0;
		bytesProgress = bytesTotal = Number.INT_NOT_SET;
	}
	
	
	public inline function add (communicator:ICommunicator) : Void
	{
		list.add( communicator );
		
		if (communicator.isInProgress())
			updateProgress();
		
		var evts = communicator.events.load;
		handleStarted	.on( evts.started,	 this );
		handleCompleted	.on( evts.completed, this );
		handleError		.on( evts.error, 	 this );
		updateProgress	.on( evts.progress,	 this );
	}
	
	
	public inline function remove (communicator:ICommunicator) : Void
	{
		communicator.events.load.unbind(this);
		list.remove( communicator );
		
		if (communicator.isInProgress())
			updateProgress();
	}
	
	
	/**
	 * Flag indicating wether the process is completed (true when a COMPLETE 
	 * event is fired or when the bytesProgress are equal to the bytesTotal)
	 */
	public inline function isCompleted ()	{ return bytesTotal > 0 && length.value == 0; }
	public inline function isInProgress ()	{ return length.value > 0; }
	
	
	/**
	 * Method will stop all communications
	 */
	public inline function close ()
	{
		var n = list.head;
		while (n != null) {
			n.elt.close();
			n = n.next;
		}
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function getBytesProgress ()		{ return bytesProgress; }
	private inline function getBytesTotal ()		{ return bytesTotal; }
	
	private inline function getBytes ()				{ Assert.abstract(); return null; }
	private inline function setBytes (v)			{ Assert.abstract(); return null; }
	
	
	
	//
	// EVENT HANDLERS
	//
	
	private function handleStarted ()
	{
		var oldLength = length.value;
		updateProgress();
		
		if (oldLength == 0 && length.value > 0) {
			isStarted = true;
			events.load.started.send();
		}
	}
	
	
	private function handleCompleted ()
	{
		updateProgress();
		
		if (length.value == 0) {
			isStarted = false;
			events.load.completed.send();
		}
	}
	
	
	private function handleError (error:String)
	{
		updateProgress();
		events.load.error.send(error);
	}
	
	
	private function updateProgress ()
	{
		var progress	= 0;
		var total		= 0;
		var l			= 0;
		
		var n = list.head;
		while (n != null) {
			var c = n.elt;
			if (c.bytesProgress.isSet())	progress += c.bytesProgress;
			if (c.bytesTotal.isSet())		total	 += c.bytesTotal;
			if (c.isInProgress())			l++;
			
			n = n.next;
		}
		
		bytesProgress	= progress;
		bytesTotal		= total;
		length.value	= l;
		
		events.load.progress.send( bytesProgress, bytesTotal );
	}
}



 import primevc.core.dispatcher.Signal0;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.dispatcher.Signal2;
 import primevc.core.events.CommunicationEvents;


/**
 * @author Ruben Weijers
 * @creation-date Apr 19, 2011
 */
private class LoaderGroupEvents extends LoaderSignals
{
	public function new ()
	{
		unloaded		= new Signal0();
		load			= new GroupCommunicationEvents();
		httpStatus		= new Signal1<Int>();
		uploadComplete	= new Signal1<String>();
	}
}



/**
 * @author Ruben Weijers
 * @creation-date Apr 19, 2011
 */
private class GroupCommunicationEvents extends CommunicationSignals
{
	public function new ()
	{
		started		= new Signal0();
		progress	= new Signal2();
		init		= new Signal0();
		completed	= new Signal0();
		error		= new Signal1();
	}
}