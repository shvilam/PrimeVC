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
package primevc.gui.components;
 import primevc.core.net.VideoStream;
 import primevc.core.states.VideoStates;
 import primevc.core.Bindable;
 import primevc.gui.behaviours.layout.AutoChangeLayoutChildlistBehaviour;
 import primevc.gui.core.IUIElement;
 import primevc.gui.core.UIContainer;
 import primevc.gui.core.UIDataContainer;
 import primevc.gui.core.UIGraphic;
 import primevc.gui.core.UIVideo;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.layout.LayoutFlags;
 import primevc.types.URI;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.TimeUtil;
  using Std;


private typedef VideoData = Bindable<URI>;


/**
 * @author Ruben Weijers
 * @creation-date Jan 07, 2011
 */
class VideoPlayer extends UIDataContainer < VideoData >
{
	private var ctrlBar		: VideoControlBar;
	private var video		: UIVideo;
	private var bigPlayBtn	: UIGraphic;
	public var stream		(default, null)	: VideoStream;
	
	
	override private function createChildren ()
	{
		children.add( video			= new UIVideo("video") );
		children.add( ctrlBar		= new VideoControlBar("ctrlBar") );
		children.add( bigPlayBtn	= new UIGraphic("bigPlayBtn") );
		
		layoutContainer.children.add( video.layout );
		layoutContainer.children.add( ctrlBar.layout );
		layoutContainer.children.add( bigPlayBtn.layout );
		
		stream = ctrlBar.stream = video.stream;
		
		togglePlayPauze		.on( userEvents.mouse.click, this );
		showOrHidePlayBtn	.on( stream.state.change, this );
	}
	
	
	override private function removeChildren ()
	{
		children.remove(ctrlBar);
		children.remove(video);
		layoutContainer.children.remove(ctrlBar.layout);
		layoutContainer.children.remove(video.layout);
		super.removeChildren();
	}
	
	
	override public function dispose ()
	{
		ctrlBar	.dispose();
		video	.dispose();
		stream	.dispose();
		
		ctrlBar = null;
		video	= null;
		stream	= null;
		super.dispose();
	}
	
	
	private function togglePlayPauze (mouseObj:MouseState)
	{
		if (mouseObj.target == this)
			stream.togglePlayPauze();
	}
	
	
	private function showOrHidePlayBtn (newState:VideoStates, oldState:VideoStates)
	{
		var b		= bigPlayBtn;
		var oldV	= b.window != null;
		b.visible	= newState != VideoStates.playing;
		
		if		(!oldV && b.visible)	children.add( b );
		else if	(oldV && !b.visible)	children.remove( b );
	}
}






/**
 * @author Ruben Weijers
 * @creation-date Jan 07, 2011
 */
class VideoControlBar extends UIContainer
{
	public static inline var STREAM = 1 << 10;
	
	
	private var playBtn			: Button;
	private var stopBtn			: Button;
	private var progressBar		: Slider;
	private var timeDisplay		: Label;
	private var muteBtn			: Button;
	private var volumeSlider	: Slider;
	private var fullScreenBtn	: Button;
	
	public var stream			(default, setStream)	: VideoStream;
	
	
	
	override public function dispose ()
	{
		stream = null;
		if (isInitialized())
		{
			layout.changed.unbind( this );
			
			playBtn.dispose();
			stopBtn.dispose();
			progressBar.dispose();
			timeDisplay.dispose();
			muteBtn.dispose();
			volumeSlider.dispose();
			fullScreenBtn.dispose();
			
			playBtn = stopBtn = fullScreenBtn = muteBtn = null;
			progressBar = volumeSlider = null;
			timeDisplay = null;
		}
		super.dispose();
	}
	
	
	override private function createBehaviours ()
	{
		super.createBehaviours();
		behaviours.add( new AutoChangeLayoutChildlistBehaviour(this) );
	}
	
	
	override private function createChildren ()
	{
		children.add( playBtn 		= new Button("playBtn") );
		children.add( stopBtn		= new Button("stopBtn") );
		children.add( progressBar	= new Slider("progressSlider") );
		children.add( timeDisplay	= new Label("timeDisplay") );
		children.add( muteBtn		= new Button("muteBtn") );
		children.add( volumeSlider	= new Slider("volumeSlider") );
		children.add( fullScreenBtn	= new Button("fullScreenBtn") );
		
		timeDisplay.data.value = "--:-- / --:--";
		
		//FIXME RUBEN: create a nice way with macro's to add children conditionally.. like 
		// children.addIf( child, function() width > 400; );
		// when( this.width > 400 ).on(updateLayout).addChild(btn); 
		addOrRemoveChildren.on( layout.changed, this );
		addOrRemoveChildren( LayoutFlags.WIDTH );
		
		if (stream != null)
			addStreamListeners();
	}


	private function addStreamListeners ()
	{
		updateSliderValidator	.on( stream.totalTime.change, this );
		
		stream.togglePlayPauze	.on( playBtn.userEvents.mouse.click, this );
		stream.stop				.on( stopBtn.userEvents.mouse.click, this );
		stream.toggleFullScreen	.on( fullScreenBtn.userEvents.mouse.click, this );
		stream.toggleMute		.on( muteBtn.userEvents.mouse.click, this );
		
		progressBar	.data.bind( stream.currentTime );
		volumeSlider.data.pair( stream.volume );
		
		updateTimeLabel		.on( stream.currentTime.change, this );
		updateTimeLabel		.on( stream.totalTime.change, this );
		stream.freeze		.on( progressBar.sliding.begin, this );
		stream.defrost		.on( progressBar.sliding.apply, this );
		startSeeking		.on( progressBar.sliding.apply, this );
		handleStreamChange	.on( stream.state.change, this );
		
		handleStreamChange( stream.state.current, null );
		updateTimeLabel();
	}
	
	
	private function removeStreamListeners ()
	{
		playBtn			.userEvents.mouse.unbind(this);
		stopBtn			.userEvents.mouse.unbind(this);
		fullScreenBtn	.userEvents.mouse.unbind(this);
		muteBtn			.userEvents.mouse.unbind(this);
		
		progressBar	.data.unbind( stream.currentTime );
		volumeSlider.data.unbind( stream.volume );
		stream.totalTime.change.unbind( this );
		
		progressBar.sliding.unbind(this);
		stream.state.change.unbind( this );
	}
	
	
	override public function validate ()
	{
		if (changes.has(STREAM))
		{
			if (stream != null)
				addStreamListeners();
		}
		super.validate();
	}
	
	
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setStream (v:VideoStream)
	{
		if (stream != v)
		{
			if (stream != null && isInitialized())
				removeStreamListeners();
			
			stream = v;
			invalidate(STREAM);
		}
		return v;
	}
	
	
	
	
	//
	// EVENT HANDLERS
	//
	
	
	private function handleStreamChange (newState:VideoStates, oldState:VideoStates)
	{
		trace(oldState+" => "+newState);
		switch (newState)
		{
			case VideoStates.playing:
				playBtn.id.value	= "pauseBtn";
			
			
			case VideoStates.paused:
				playBtn.id.value	= "playBtn";
			
			
			case VideoStates.stopped:
				playBtn.id.value	= "playBtn";
				enabled.value		= true;
			
			
			case VideoStates.empty:
				enabled.value		= false;
			
			
			case VideoStates.frozen(realState):
			//	enabled.value = false;
				
		}
	}
	
	
	private function updateSliderValidator (newTime:Float, oldTime:Float)
	{
		Assert.notNull( progressBar );
		progressBar.validator.max = newTime;
		trace(oldTime+" => "+newTime);
	}
	
	
	/**
	 * Method is called when the currentTime or totalTime changes and will
	 * update the time-label value.
	 */
	private function updateTimeLabel () : Void
	{
		var curTime = stream.currentTime.value.int().secondsToTime();
		var totTime = stream.totalTime.value.int().secondsToTime();
		timeDisplay.data.value = curTime + " / " + totTime;
	}
	
	
	/**
	 * Method is called when the user releases the video-progressbar and will
	 * seek the the new-position in the video-stream.
	 */
	private function startSeeking ()
	{
		stream.seek( progressBar.data.value );
	}
	
	
	/**
	 * Method is called when the size is changed and with add or remove some 
	 * of the displayobjects.
	 */
	private function addOrRemoveChildren (changes:Int)
	{
		if (changes.hasNone( LayoutFlags.WIDTH ))
			return;
		
		var width = layout.innerBounds.width;
		showOrHide( volumeSlider,	width > 250 );
		showOrHide( stopBtn,		width > 300 );
		showOrHide( timeDisplay,	width > 400 );
	}
	
	
	private inline function showOrHide (child:IUIElement, show:Bool)
	{
		if (child.visible != show)
			child.visible = child.layout.includeInLayout = show;
	}
}