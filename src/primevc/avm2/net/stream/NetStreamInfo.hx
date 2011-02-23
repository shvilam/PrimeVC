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



private typedef Level	= NetStreamInfoLevel;
private typedef Code	= NetStreamInfoCode;

/**
 * Wrapper class for the flash.event.NetStreamEvent.info object
 * 
 * @author Ruben Weijers
 * @creation-date Jan 07, 2011
 */
class NetStreamInfo
{
	public var level	(default, null) : NetStreamInfoLevel;
	public var code		(getCode, null) : NetStreamInfoCode;
	private var flashObj				: Dynamic;
	
	
	public function new (flashObj:Dynamic)
	{
		Assert.notNull( flashObj.code, "NetStreamInfo obj should have a code" );
		Assert.notNull( flashObj.level, "NetStreamInfo obj should have a level" );
		
		level = switch (flashObj.level) {
		 	case "status":	Level.status;
			case "error":	Level.error;
			case "warning":	Level.warning;
			default:		throw "unkown level '"+flashObj.level+"'";
		}
		
		this.flashObj = flashObj;
	}
	
	
	private function getCode ()
	{
		if (code == null)
		{
			code = switch (flashObj.code)
			{
				//Level.error
				case "NetStream.Failed":						Code.failed;
				case "NetStream.Publish.BadName":				Code.publishBadName;
				case "NetStream.Play.Failed":					Code.playFailed;
				case "NetStream.Play.StreamNotFound":			Code.playStreamNotFound;
				case "NetStream.Play.FileStructureInvalid":		Code.playFileStructureInvalid;
				case "NetStream.Play.NoSupportedTrackFound":	Code.playNoSupportedTrackFound;
				case "NetStream.Record.NoAccess":				Code.recordNoAccess;
				case "NetStream.Record.Failed":					Code.recordFailed;
				case "NetStream.Seek.Failed":					Code.seekFailed;
				case "NetStream.Seek.InvalidTime":				Code.seekInvalidTime;
				case "NetConnection.Call.BadVersion":			Code.callBadVersion;
				case "NetConnection.Call.Failed":				Code.callFailed;
				case "NetConnection.Call.Prohibited":			Code.callProhibited;
				case "NetConnection.Connect.Failed":			Code.netConnectionFailed;
				case "NetConnection.Connect.Rejected":			Code.netConnectionRejected;
				case "NetStream.Connect.Failed":				Code.streamConnectionFailed;
				case "NetStream.Connect.Rejected":				Code.streamConnectionRejected;
				case "NetConnection.Connect.AppShutdown":		Code.netConnectionAppShutdown;
				case "NetConnection.Connect.InvalidApp":		Code.netConnectionInvalidApp;
				case "SharedObject.Flush.Failed":				Code.sharedObjectFlushError;
				case "SharedObject.BadPersistence":				Code.sharedObjectBadPersistence;
				case "SharedObject.UriMismatch":				Code.sharedObjectUriMismatch;
				
				//Level.warning
				case "NetStream.Play.InsufficientBW":			Code.playInsufficientBw;
				
				//Level.status
				case "NetStream.Buffer.Empty":					Code.bufferEmpty;
				case "NetStream.Buffer.Full":					Code.bufferFull;
				case "NetStream.Buffer.Flush":					Code.bufferFlush;
				case "NetStream.Publish.Start":					Code.publishStart;
				case "NetStream.Publish.Idle":					Code.publishIdle;
				case "NetStream.Unpublish.Success":				Code.unpublishSuccess;
				case "NetStream.Play.Start":					Code.playStart;
				case "NetStream.Play.Stop":						Code.playStop;
				case "NetStream.Play.Reset":					Code.playReset;
				case "NetStream.Play.PublishNotify":			Code.notifyPublished;
				case "NetStream.Play.UnpublishNotify":			Code.notifyUnpublished;
				case "NetStream.Play.Transition":				Code.playTransition;
				case "NetStream.Pause.Notify":					Code.notifyPaused;
				case "NetStream.Unpause.Notify":				Code.notifyResumed;
				case "NetStream.Record.Start":					Code.recordStarted;
				case "NetStream.Record.Stop":					Code.recordStopped;
				case "NetStream.Seek.Notify":					Code.notifySeek;
				case "NetConnection.Connect.Closed":			Code.netConnectionClosed;
				case "NetConnection.Connect.Success":			Code.netConnectionSuccess;
				case "NetStream.Connect.Closed":				Code.streamConnectionClosed;
				case "NetStream.Connect.Success":				Code.streamConnectionSuccess;
				case "SharedObject.Flush.Success":				Code.sharedObjectFlushed;
				
				default:
					throw "Unkown code '"+flashObj.code+"'";
			}
		}
		return code;
	}
	
	
#if debug
	public function toString ()
	{
		return "[ " + level + " ] = " + code;
	}
#end
}