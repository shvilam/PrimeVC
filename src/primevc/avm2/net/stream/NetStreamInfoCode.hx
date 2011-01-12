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
package primevc.avm2.net.stream;


/**
 * @see flash.event.NetStatusEvent.info
 * 
 * @author	Ruben Weijers
 * @since	Jan 7, 2011
 */
enum NetStreamInfoCode
{
	/**
	 * "NetStream.Buffer.Empty"	"status"
	 * 
	 * Data is not being received quickly enough to fill the buffer. Data flow 
	 * will be interrupted until the buffer refills, at which time a 
	 * NetStream.Buffer.Full message will be sent and the stream will begin 
	 * playing again.
	 */
	bufferEmpty;
	/**
	 * "NetStream.Buffer.Full"	"status"
	 * The buffer is full and the stream will begin playing.
	 */
	bufferFull;
	/**
	 * "NetStream.Buffer.Flush"	"status"
	 * Data has finished streaming, and the remaining buffer will be emptied.
	 */
	bufferFlush;
	
	
	
	/**
	 * "NetStream.Failed"	"error"
	 * Flash Media Server only. An error has occurred for a reason other than 
	 * those listed in other event codes.
	 */
	failed;
	
	
	
	/**
	 * "NetStream.Publish.Start"	"status"
	 * Publish was successful.
	 */
	publishStart;
	/**
	 * "NetStream.Publish.BadName"	"error"	
	 * Attempt to publish a stream which is already being published by someone 
	 * else.
	 */
	publishBadName;
	/**
	 * "NetStream.Publish.Idle"	"status"	
	 * The publisher of the stream is idle and not transmitting data.
	 */
	publishIdle;
	
	
	
	/**
	 * "NetStream.Unpublish.Success"	"status"
	 * The unpublish operation was successfuul.
	 */
	unpublishSuccess;
	
	
	/**
	 * "NetStream.Play.Start"	"status"
	 * Playback has started.
	 */
	playStart;
	/**
	 * "NetStream.Play.Stop"	"status"
	 * Playback has stopped.
	 */
	playStop;
	/**
	 * "NetStream.Play.Failed"	"error"
	 * An error has occurred in playback for a reason other than those listed 
	 * elsewhere in this table, such as the subscriber not having read access.
	 */
	playFailed;
	/**
	 * "NetStream.Play.StreamNotFound"	"error"	
	 * The FLV passed to the play() method can't be found.
	 */
	playStreamNotFound;
	/**
	 * "NetStream.Play.Reset"	"status"
	 * Caused by a play list reset.
	 */
	playReset;
	
	
	
	/**
	 * "NetStream.Play.PublishNotify"	"status"
	 * The initial publish to a stream is sent to all subscribers.
	 */
	notifyPublished;
	/**
	 * "NetStream.Play.UnpublishNotify"	"status"
	 * An unpublish from a stream is sent to all subscribers.
	 */
	notifyUnpublished;
	/**
	 * "NetStream.Play.InsufficientBW"	"warning"
	 * Flash Media Server only. The client does not have sufficient bandwidth 
	 * to play the data at normal speed.
	 */
	playInsufficientBw;
	/**
	 * "NetStream.Play.FileStructureInvalid"	"error"
	 * The application detects an invalid file structure and will not try to 
	 * play this type of file. For AIR and for Flash Player 9.0.115.0 and later.
	 */
	playFileStructureInvalid;
	/**
	 * "NetStream.Play.NoSupportedTrackFound"	"error"
	 * The application does not detect any supported tracks (video, audio or 
	 * data) and will not try to play the file. For AIR and for Flash Player 9.0.115.0 and later.
	 */
	playNoSupportedTrackFound;
	/**
	 * "NetStream.Play.Transition"	"status"
	 * Flash Media Server 3.5 and later only. The server received the command 
	 * to transition to another stream as a result of bitrate stream switching. 
	 * This code indicates a success status event for the NetStream.play2() 
	 * call to initiate a stream switch. If the switch does not succeed, the 
	 * server sends a NetStream.Play.Failed event instead. When the stream 
	 * switch occurs, an onPlayStatus event with a code of 
	 * "NetStream.Play.TransitionComplete" is dispatched. For 
	 * Flash Player 10 and later.
	 * 
	 * "NetStream.Play.Transition"	"status"
	 * Flash Media Server only. The stream transitions to another as a result 
	 * of bitrate stream switching. This code indicates a success status event 
	 * for the NetStream.play2() call to initiate a stream switch. If the 
	 * switch does not succeed, the server sends a NetStream.Play.Failed event 
	 * instead. For Flash Player 10 and later.
	 */
	playTransition;
	
	
	
	/**
	 * "NetStream.Pause.Notify"	"status"
	 * The stream is paused.
	 */
	notifyPaused;
	/**
	 * "NetStream.Unpause.Notify"	"status"
	 * The stream is resumed.
	 */
	notifyResumed;
	
	
	
	/**
	 * "NetStream.Record.Start"	"status"
	 * Recording has started.
	 */
	recordStarted;
	/**
	 * "NetStream.Record.NoAccess"	"error"
	 * Attempt to record a stream that is still playing or the client has no 
	 * access right.
	 */
	recordNoAccess;
	/**
	 * "NetStream.Record.Stop"	"status"
	 * Recording stopped.
	 */
	recordStopped;
	/**
	 * "NetStream.Record.Failed"	"error"
	 * An attempt to record a stream failed.
	 */
	recordFailed;
	
	
	
	/**
	 * "NetStream.Seek.Failed"	"error"
	 * The seek fails, which happens if the stream is not seekable.
	 */
	seekFailed;
	/**
	 * "NetStream.Seek.InvalidTime"	"error"	
	 * For video downloaded with progressive download, the user has tried to 
	 * seek or play past the end of the video data that has downloaded thus 
	 * far, or past the end of the video once the entire file has downloaded. 
	 * The message.details property contains a time code that indicates the 
	 * last valid position to which the user can seek.
	 */
	seekInvalidTime;
	/**
	 * "NetStream.Seek.Notify"	"status"
	 * The seek operation is complete.
	 */
	notifySeek;
	
	/**
	 * "NetConnection.Call.BadVersion"	"error"
	 * Packet encoded in an unidentified format.
	 */
	callBadVersion;
	/**
	 * "NetConnection.Call.Failed"	"error"
	 * The NetConnection.call method was not able to invoke the server-side 
	 * method or command.
	 */
	callFailed;
	/**
	 * "NetConnection.Call.Prohibited"	"error"
	 * An Action Message Format (AMF) operation is prevented for security 
	 * reasons. Either the AMF URL is not in the same domain as the file 
	 * containing the code calling the NetConnection.call() method, or the 
	 * AMF server does not have a policy file that trusts the domain of the 
	 * the file containing the code calling the NetConnection.call() method.
	 */
	callProhibited;
	
	
	
	/**
	 * "NetConnection.Connect.Closed"	"status"
	 * The connection was closed successfully.
	 */
	netConnectionClosed;
	/**
	 * "NetConnection.Connect.Failed"	"error"
	 * The connection attempt failed.
	 */
	netConnectionFailed;
	/**
	 * "NetConnection.Connect.Success"	"status"
	 * The connection attempt succeeded.
	 */
	netConnectionSuccess;
	/**
	 * "NetConnection.Connect.Rejected"	"error"
	 * The connection attempt did not have permission to access the application.
	 */
	netConnectionRejected;
	
	
	
	/**
	 * "NetStream.Connect.Closed"	"status"
	 * The P2P connection was closed successfully. The info.stream property 
	 * indicates which stream has closed.
	 */
	streamConnectionClosed;
	/**
	 * "NetStream.Connect.Failed"	"error"	
	 * The P2P connection attempt failed. The info.stream property indicates 
	 * which stream has failed.
	 */
	streamConnectionFailed;
	/**
	 * "NetStream.Connect.Success"	"status"
	 * The P2P connection attempt succeeded. The info.stream property 
	 * indicates which stream has succeeded.
	 */
	streamConnectionSuccess;
	/**
	 * "NetStream.Connect.Rejected"	"error"	
	 * The P2P connection attempt did not have permission to access the other 
	 * peer. The info.stream property indicates which stream was rejected.
	 */
	streamConnectionRejected;
	
	
	
	/**
	 * "NetConnection.Connect.AppShutdown"	"error"
	 * The specified application is shutting down.
	 */
	netConnectionAppShutdown;
	/**
	 * "NetConnection.Connect.InvalidApp"	"error"
	 * The application name specified during connect is invalid.
	 */
	netConnectionInvalidApp;
	
	
	
	/**
	 * "SharedObject.Flush.Success"	"status"
	 * The "pending" status is resolved and the SharedObject.flush() call 
	 * succeeded.
	 */
	sharedObjectFlushed;
	/**
	 * "SharedObject.Flush.Failed"	"error"
	 * The "pending" status is resolved, but the SharedObject.flush() failed.
	 */
	sharedObjectFlushError;
	/**
	 * "SharedObject.BadPersistence"	"error"
	 * A request was made for a shared object with persistence flags, but the 
	 * request cannot be granted because the object has already been created 
	 * with different flags.
	 */
	sharedObjectBadPersistence;
	/**
	 * "SharedObject.UriMismatch"	"error"
	 * An attempt was made to connect to a NetConnection object that has a 
	 * different URI (URL) than the shared object.
	 */
	sharedObjectUriMismatch;
}