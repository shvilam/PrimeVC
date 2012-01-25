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
package primevc.core.media;
 import haxe.Timer;
#if flash9
 import primevc.avm2.net.stream.NetStreamInfo;
 import primevc.avm2.net.stream.NetStreamInfoCode;
 import primevc.avm2.net.stream.NetStreamInfoLevel;
 import primevc.avm2.net.NetConnection;
 import primevc.avm2.net.NetStream;
#end
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.states.MediaStates;
 import primevc.core.Bindable;
 import primevc.core.Error;
 import primevc.types.Number;
 import primevc.types.URI;
  using primevc.utils.Bind;
  using primevc.utils.NumberUtil;
  using Std;


/**
 * @author Ruben Weijers
 * @creation-date Jan 10, 2011
 */
class VideoStream extends BaseMediaStream
{
#if flash9	
	private var connection	: NetConnection;
	public var source		(default, null)			: NetStream;
	
	public var onMetaData	(default, null)			: Dynamic -> Void;
	public var onCuePoint	(default, null)			: Dynamic -> Void;
	public var onImageData	(default, null)			: Dynamic -> Void;
	public var onPlayStatus (default, null)			: Dynamic -> Void;
	public var onTextData	(default, null)			: Dynamic -> Void;
	public var onXMPData	(default, null)			: Dynamic -> Void;
#end
	
	/**
	 * Bindable value with the frame-rate of the videostream.
	 */
	public var framerate	(default, null)			: Bindable<Int>;
	
	/**
	 * Bindable value with the original width of the videostream
	 */
	public var width		(default, null)			: Bindable<Int>;
	
	/**
	 * Bindable value with the original height of the videostream
	 */
	public var height		(default, null)			: Bindable<Int>;
			
	

	public function new (streamUrl:URI = null)
	{
		framerate = new Bindable<Int>(0);
		width	  = new Bindable<Int>(0);
		height	  = new Bindable<Int>(0);
		super(streamUrl);
	}
	
	
	
	private function init ()
	{
		Assert.that(!isInitialized());
#if flash9
		connection		= new NetConnection();
		source			= new NetStream( connection );
		
		//dirty client to catch flash player exeptions..
		//@see http://www.actionscript.org/forums/archive/index.php3/t-142040.html
		source.client	= this;
		onMetaData		= handleMetaData;
		onCuePoint		= handleCuePoint;
		onImageData		= handleImageData;
		onPlayStatus	= handlePlayStatus;
		onTextData		= handleTextData;
		onXMPData		= handleXMPData;
		handleSecurityError	.on( connection.events.securityError, 	this );
		handleASyncError	.on( connection.events.asyncError, 		this );
		handleIOError		.on( connection.events.ioError, 		this );
		handleNetStatus		.on( connection.events.netStatus, 		this );

		handleASyncError	.on( source.events.asyncError, 			this );
		handleIOError		.on( source.events.ioError, 			this );
		handleNetStatus		.on( source.events.netStatus, 			this );
		
	//	connection.connect( null );
#end
	}
	
	
	override public function dispose ()
	{
		if (source == null)
			return;					// <-- is already disposed
		
		stop();
		
#if flash9
	//	source.client = null;		//gives error "Invalid parameter flash.net::NetStream/set client()"
		if (isInitialized())
		{
			source.dispose();
			connection.dispose();
			connection	= null;
			source		= null;
		}
#end
		
		super.dispose();
		framerate.dispose();
		width	 .dispose();
		height	 .dispose();
		width = height = framerate = null;
	}
	
	
	private inline function isInitialized ()
	{
		return #if flash9 source != null #else false #end;
	}

	
	
	//
	// VIDEO METHODS
	//
	
	
	override public function play ( ?newUrl:URI )
	{
		if (!isInitialized()) 	init();
		if (!isStopped())		stop();
		if (newUrl != null)		url.value = newUrl;
		
		trace(url.value);
		Assert.notNull( url.value, "There is no video-url to play" );
		source.play( url.value.toString() );
	}
	

	override public function pause ()
	{
		source.pause();
		if (!isEmpty())
			state.current = MediaStates.paused;
	}
	
	
	override public function resume ()
	{
		if (!isPaused())
			return;
		
		source.resume();
		state.current = MediaStates.playing;
	}
	
	
	override public function stop ()
	{
		if (isEmpty())
			return;
		
		source.close();
		state.current = MediaStates.stopped;
	}
	
	
	override public function seek (newPosition:Float)
	{
		if (isEmpty())
			return;
		
		newPosition = validatePosition(newPosition);
		if (newPosition == source.time)
			return;
		
		source.seek( newPosition );
	}
	
	
	public function toggleFullScreen ()		//FIXME
	{
		trace("toggleFullScreen");
	}
	
	
	
	//
	// IFREEZABLE IMPLEMENTATION
	//
	
	
	/**
	 * Method will pause the current movie to optimize animations. It will
	 * store the old-state to enable restoring the state after the animation
	 * is done.
	 */
	override public function freeze ()
	{
		if (isFrozen())
			return;
		
		source.pause();
		freezeState();
	}
	
	
	/**
	 * Method will restore the state of the video to before it was frozen.
	 */
	override public function defrost ()
	{
		defrostState();
		
		if (state.current == playing)
			source.resume();
	}
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	override private function getCurrentTime ()
	{
		if (!isPlaying()) {
			return currentTime;
		}
		if (updateTimer == null) {
			updateTimer			= new Timer(200);
			updateTimer.run		= updateTime;
			updateTime();
		}
		
		return currentTime;
	}
	
	
	
	//
	// EVENTHANDLERS
	//
	
	
	private inline function updateTime ()
	{
		currentTime.value = source.time;
	}
	
	
	/**
	 * Method is called when the value of the volume bindable changes. It will
	 * make sure the value is 0 => value >= 1.
	 * The method will also apply the new volume-level on the video-stream.
	 */
	private function changeVolume (newValue:Float, oldValue:Float)
	{
		newValue = newValue.within( 0, 1 );
        if (newValue != volume.value || oldValue == newValue) {
            volume.value = newValue;
            return;
        }

#if flash9
		Assert.notNull(source);
		if (source.soundTransform != null && source.soundTransform.volume != newValue)
		{
			var sound				= source.soundTransform;
			sound.volume			= newValue;
			source.soundTransform	= sound;
		}
#end
	}
	
	
#if flash9
	private function handleSecurityError (error:String)
	{
		trace(error);
	}
	
	
	private function handleASyncError (error:Error)
	{
		trace(error);
	}
	
	
	private function handleNetStatus (event:NetStreamInfo)
	{
		switch (event.code)
		{
			case NetStreamInfoCode.playStreamNotFound:
				state.current = MediaStates.stopped;
				trace("invalid video-url "+url.value);
			
			
			case NetStreamInfoCode.notifySeek:
				if (isPlaying())
					source.resume();
			
			
			case NetStreamInfoCode.playStop:
				state.current = MediaStates.stopped;
				if (updateTimer != null)
					updateTimer.stop();
			
			
			case NetStreamInfoCode.playStart:
				state.current = MediaStates.playing;
				if (updateTimer != null)
					updateTimer.run = updateTime;
			
			
			default:
				trace("no-handler for net-code: "+event);
		}
	}
	
	
	/**
	 * "EventHandlers" for the NetStream.client class. If not set, the 
	 * flashplayer will throw errors.
	 * 
	 * @param	?metaData
	 */
	private function handleMetaData ( info:Dynamic ) : Void
	{
		Assert.notNull(info);
	/*	trace( "duration: " + info.duration);
		trace( "width: " + info.width);
		trace( "height: " + info.height);*/
		totalTime.value	= info.duration;
		framerate.value	= info.framerate;
		width.value		= info.width;
		height.value	= info.height;
	}
	
	
	public function handleCuePoint ( metaData:Dynamic ) : Void
	{
	//	nl.demonsters.debugger.MonsterDebugger.inspect(metaData);
		trace( "cuePoint: " + metaData);
	}
	
	
	public function handlePlayStatus ( metaData:Dynamic ) : Void
	{
	//	nl.demonsters.debugger.MonsterDebugger.inspect(metaData);
		trace( "onPlayStatus: " + metaData);
	}
	
	
	public function handleXMPData( metaData:Dynamic ) : Void
	{
	//	nl.demonsters.debugger.MonsterDebugger.inspect(metaData);
		trace( "onXMPData: " + metaData);
	}
	
	
	public function handleImageData( metaData:Dynamic ) : Void
	{
	//	nl.demonsters.debugger.MonsterDebugger.inspect(metaData);
		trace( "onImageData: " + metaData);
	}
	
	
	public function handleTextData ( metaData:Dynamic ) : Void
	{
	//	nl.demonsters.debugger.MonsterDebugger.inspect(metaData);
		trace( "onTextData: " + metaData);
	}
#end
}