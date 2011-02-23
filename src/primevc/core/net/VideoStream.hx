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
 import haxe.Timer;
#if flash9
 import primevc.avm2.net.stream.NetStreamInfo;
 import primevc.avm2.net.stream.NetStreamInfoCode;
 import primevc.avm2.net.stream.NetStreamInfoLevel;
 import primevc.avm2.net.NetConnection;
 import primevc.avm2.net.NetStream;
#end
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.states.VideoStates;
 import primevc.core.traits.IDisposable;
 import primevc.core.traits.IFreezable;
 import primevc.core.Bindable;
 import primevc.core.Error;
 import primevc.types.Number;
  using primevc.utils.Bind;
  using primevc.utils.NumberUtil;
  using Std;


/**
 * @author Ruben Weijers
 * @creation-date Jan 10, 2011
 */
class VideoStream implements IFreezable, implements IDisposable
{
#if flash9	
	private var connection	: NetConnection;
	public var source		(default, null)			: NetStream;
#end
	
	
	/**
	 * Variable will cache the volume when the toggleMute method is called.
	 * @default Number.FLOAT_NOT_SET
	 */
	private var cachedVolume : Float;
	
	/**
	 * Timer which will update the currentTime property. The timer is created
	 * when the first listener starts listening to currentTime changes.
	 */
	private var updateTimer	: Timer;
	
	
	/**
	 * audio-volume of the videostream.
	 * 0 =< value <= 1
	 * @default 0.7
	 */
	public var volume		(default, null)			: Bindable<Float>;
	
	/**
	 * URL of the video-stream.
	 */
	public var url			(default, null)			: Bindable<String>;
	
	/**
	 * Current state of the video-stream. Do not modify the state directly, but 
	 * use the appropriate methods to change the state of videostream.
	 */
	public var state		(default, null)			: SimpleStateMachine<VideoStates>;
	
	
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
	
	
	
	/**
	 * Bindable value with the total-time of the videostream.
	 */
	public var totalTime	(default, null)			: Bindable<Float>;
	
	/**
	 * Number of seconds the video-stream has been playing. This value is automaticly
	 * updated, as long as the video is playing. The first time the time is
	 * called, the stream will start a timer to update the value (every 200ms).
	 * 
	 * To seek the video, you should not change this property but use the "seek"
	 * method.
	 */
	public var currentTime	(getCurrentTime, null)	: Bindable<Float>;
	
			
	

	public function new (streamUrl:String = null)
	{
		url				= new Bindable<String>(streamUrl);
		volume			= new Bindable<Float>(0.7);
		currentTime		= new Bindable<Float>(0.0);
		totalTime		= new Bindable<Float>(0.0);
		framerate		= new Bindable<Int>(0);
		width			= new Bindable<Int>(0);
		height			= new Bindable<Int>(0);
		
		cachedVolume	= Number.FLOAT_NOT_SET;
		var curState	= streamUrl == null ? VideoStates.empty : VideoStates.stopped;
		state			= new SimpleStateMachine<VideoStates>( VideoStates.empty, curState );
		
#if flash9
		connection		= new NetConnection();
		source			= new NetStream( connection );
		
		//dirty client to catch flash player exeptions..
		//@see http://www.actionscript.org/forums/archive/index.php3/t-142040.html
		source.client	= this;
		
		handleSecurityError	.on( connection.events.securityError, this );
		handleASyncError	.on( connection.events.asyncError, this );
		handleIOError		.on( connection.events.ioError, this );
		handleNetStatus		.on( connection.events.netStatus, this );
		handleASyncError	.on( source.events.asyncError, this );
		handleIOError		.on( source.events.ioError, this );
		handleNetStatus		.on( source.events.netStatus, this );
		
	//	connection.connect( null );
#end
		
		changeVolume		.on( volume.change, this );
		validateURL			.on( url.change, this );
	}
	
	
	public function dispose ()
	{
		if (source == null)
			return;					// <-- is already disposed
		
		stop();
		
#if flash9
	//	source.client = null;		//gives error "Invalid parameter flash.net::NetStream/set client()"
		source.dispose();
		connection.dispose();
		connection	= null;
		source		= null;
#end
		if (updateTimer != null) {
			updateTimer.stop();
			updateTimer = null;
		}
		
		volume		.dispose();
		state		.dispose();
		url			.dispose();
		totalTime	.dispose();
		framerate	.dispose();
		width		.dispose();
		height		.dispose();
		
		url		= null;
		state	= null;
		volume	= totalTime = null;
		width	= height = framerate = null;
		
		(untyped this).currentTime.dispose();
		(untyped this).currentTime = null;
	}
	
	
	
	
	//
	// VIDEO METHODS
	//
	
	
	/**
	 * Method will start playing the given or current video-url. If another
	 * video is already playing, it will be stopped.
	 * If the current url-video is already playing, the video will start again.
	 */
	public function play ( ?newUrl:String )
	{
		if (!isStopped())
			stop();
		
		if (newUrl != null)
			url.value = newUrl;
		
		trace(url.value);
		Assert.notNull( url.value, "There is no video-url to play" );
		source.play( url.value );
	}
	
	
	/**
	 * Method will pause the video if it was playing
	 */
	public function pause ()
	{
		source.pause();
		if (!isEmpty())
			state.current = VideoStates.paused;
	}
	
	
	public function resume ()
	{
		if (!isPaused())
			return;
		
		source.resume();
		state.current = VideoStates.playing;
	}
	
	
	public function stop ()
	{
		if (isEmpty())
			return;
		
		source.close();
		state.current = VideoStates.stopped;
	}
	
	
	public function seek (newPosition:Float)
	{
		if (isEmpty())
			return;
		
		var total	= totalTime.value;
		var cur		= source.time;
		
		if		(newPosition > total)	newPosition = total;
		else if (newPosition < 0)		newPosition	= 0;
		if		(newPosition == cur)	return;
		
		source.seek( newPosition );
	}
	
	
	public function togglePlayPauze ()
	{
		if		(isPlaying())	pause();
		else if (isPaused())	resume();
		else if (isStopped())	play();
	}
	
	
	public function toggleFullScreen ()
	{
		trace("toggleFullScreen");
	}
	
	
	public function toggleMute ()
	{
		if (isMuted())
		{
		 	volume.value	= cachedVolume.isSet() ? cachedVolume : 0.7;
			cachedVolume	= Number.FLOAT_NOT_SET;
		}
		else
		{	
			cachedVolume	= volume.value;
			volume.value	= 0;
		}
	}
	
	
	
	
	//
	// IFREEZABLE IMPLEMENTATION
	//
	
	
	/**
	 * Method will pause the current movie to optimize animations. It will
	 * store the old-state to enable restoring the state after the animation
	 * is done.
	 */
	public function freeze ()
	{
		if (isFrozen())
			return;
		
		source.pause();
		state.current = VideoStates.frozen( state.current );
	}
	
	
	/**
	 * Method will restore the state of the video to before it was frozen.
	 */
	public function defrost ()
	{
		//retrieve old state
		switch (state.current)
		{
			case frozen( prevState ):	state.current = prevState;
			default:					null;
		}
		
		if (state.current == playing)
			source.resume();
	}
	
	
	
	//
	// STATE METHODS
	//
	
	public inline function isStopped ()	: Bool	{ return state.current == VideoStates.stopped; }
	public inline function isPaused ()	: Bool	{ return state.current == VideoStates.paused; }
	public inline function isPlaying ()	: Bool	{ return state.current == VideoStates.playing; }
	public inline function isEmpty ()	: Bool	{ return state.current == VideoStates.empty; }
	public inline function isMuted ()	: Bool	{ return volume.value == 0; }
	public inline function isFrozen ()	: Bool
	{
		return switch (state.current) {
			case frozen( prevState ):	true;
			default:					false;
		}
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	private function getCurrentTime ()
	{
		if (updateTimer == null) {
			updateTimer			= new Timer(200);
			updateTimer.run		= updateTime;
			currentTime.value	= source.time;
		}
		
		return currentTime;
	}
	
	
	
	//
	// EVENTHANDLERS
	//
	
	
	private function updateTime ()
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
		volume.value = newValue = newValue.within( 0, 1 );
		
		if (oldValue == volume.value)
			return;
		
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
	
	
	private function validateURL (newURL:String, oldURL:String)
	{
		if (oldURL != null)
			stop();
		
		state.current = (newURL == null) ? VideoStates.empty : VideoStates.stopped;
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
	
	
	private function handleIOError (error:String)
	{
		trace(error);
	}
	
	
	private function handleNetStatus (event:NetStreamInfo)
	{
		switch (event.code)
		{
			case NetStreamInfoCode.playStreamNotFound:
				state.current = VideoStates.stopped;
				trace("invalid video-url "+url.value);
			
			
			case NetStreamInfoCode.notifySeek:
				if (isPlaying())
					source.resume();
			
			
			case NetStreamInfoCode.playStop:
				state.current = VideoStates.stopped;
				if (updateTimer != null)
					updateTimer.stop();
			
			
			case NetStreamInfoCode.playStart:
				state.current = VideoStates.playing;
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
	private function onMetaData ( info:Dynamic )
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
	
	
	private function onCuePoint ( ?metaData )
	{
		trace( "cuePoint: " + metaData);
	}
	
	
	private function onXmlData( ?metaData )
	{
		trace( "onXmlData: " + metaData);
	}
#end
}