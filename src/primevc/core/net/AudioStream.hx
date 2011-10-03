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
 *  Ruben Weijers   <ruben @ onlinetouch.nl>
 */
package primevc.core.net;
#if flash9
 import primevc.avm2.media.Sound;
 import flash.events.Event;
 import flash.media.SoundChannel;
#end
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.states.MediaStates;
 import primevc.core.traits.IDisposable;
 import primevc.core.traits.IFreezable;
 import primevc.core.Bindable;
 import primevc.types.Number;
 import primevc.types.URI;
 import primevc.utils.NumberUtil;
  using primevc.utils.Bind;
  using primevc.utils.IfUtil;
  using primevc.utils.NumberUtil;



/**
 * @since   Sep 28, 2011
 * @author  Ruben Weijers
 */
class AudioStream extends BaseMediaStream
{
#if flash9
    public var source       : Sound;

    /**
     * The SoundChannel which is created when a sound starts playing.
     */
    private var channel     : SoundChannel;

    /**
     * the number of times to repeat the audio-file. -1 means continues looping.
     * @default     0
     */
    public  var repeat      (default, default)  : Int;
    /**
     * Number of times the file has already repeated itself.
     */
    public  var repeated    (default, null)     : Int;
    /**
     * the number of milliseconds a sound has been playing after it's been paused (since a SoundChannel can only stop)
     */
    private var lastPos     : Float;

    /**
     * Flag indicating wether the Sound.load-method is called on the URI. Flash will give
     * an error when load is called twice on the same URI.
     */
    private var isLoaded    : Bool;
#end
    

    public function new (streamUrl:URI = null)
    {
        super(streamUrl);
        repeat  = repeated = 0;
        lastPos = 0;
        changeVolume.on( volume.change, this );
    }
    
    
    
    private inline function init ()
    {
        Assert.that(!isInitialized());
#if flash9
        source = new Sound();
        updateTotalTime.on( source.events.completed, this );
        handleIOError  .on( source.events.error, this );
#end
    }
    
    
    override public function dispose ()
    {
        super.dispose();
#if flash9
        if (isInitialized())
        {
            source.dispose();
            source = null;
        }
#end
    }
    
    
    private inline function isInitialized ()
    {
        return #if flash9 source.notNull() #else false #end;
    }

    
    
    //
    // AUDIO METHODS
    //
    
    
    override public function play ( ?newUrl:URI )
    {
        if (!isInitialized())                       init();
        if (!isStopped() || channel.notNull())      stop();
        if (newUrl.notNull())                       url.value = newUrl;
        
        Assert.notNull( url.value, "There is no sound-url to play" );

        if (!isLoaded) {
            source.load(url.value.toRequest());
            isLoaded = true;
        }
        
        state.current = MediaStates.playing;
        applyResume();
    }
    
    
    /**
     * Method will pause the audio if it was playing
     */
    override public function pause ()
    {
        if (!isEmpty()) {
            applyPause();
            state.current = MediaStates.paused;
        }
    }
    
    
    override public function resume ()
    {
        if (!isPaused())
            return;
        
        state.current = MediaStates.playing;
        applyResume();
    }
    
    
    override public function stop ()
    {
        if (isEmpty())
            return;
        
        state.current   = MediaStates.stopped;
        applyStop();
        repeated        = 0;
    }
    
    
    override public function seek (newPosition:Float)
    {
        if (isEmpty())
            return;
        
        newPosition = validatePosition(newPosition);
        if (newPosition == lastPos || (channel.notNull() && newPosition == channel.position))
            return;
#if flash9
        lastPos = newPosition;
        if (isPlaying()) {
            applyStop();
            applyResume();
        }
#end
    }


    private inline function applyPause ()
    {
#if flash9
        if (channel.notNull()) {
            lastPos = channel.position;
            applyStop();
        }
#end
    }


    private inline function applyResume ()
    {
#if flash9
        channel = source.play(lastPos);
        channel.addEventListener(Event.SOUND_COMPLETE, untyped applyRepeat);
#end    lastPos = 0;
        applyVolume();
        startUpdateTimer();
    }


    private inline function applyStop ()
    {
#if flash9
        stopUpdateTimer();

        if (channel.notNull()) {
            channel.stop();
            channel.removeEventListener(Event.SOUND_COMPLETE, untyped applyRepeat);
            channel = null;
            updateCurrentTime();
        }
#end
    }


    private function applyRepeat (event:Event)
    {
        repeated++;
        if (shouldLoop()) {
            applyStop();
            applyResume();
        } else
            stop();
    }


    private inline function shouldLoop ()
    {
        return repeated < repeat;
    }
    
    
    
    
    //
    // IFREEZABLE IMPLEMENTATION
    //
    
    override public function freeze ()
    {
        if (isFrozen())
            return;
        
        applyPause();
        freezeState();
    }
    
    
    override public function defrost ()
    {
        defrostState();
        
        if (state.current == playing)
            applyResume();
    }


    private inline function startUpdateTimer ()
    {
        if (currentTime.hasListeners() && updateTimer.isNull()) {
            updateTimer     = new haxe.Timer(200);
            updateTimer.run = updateCurrentTime;
            updateCurrentTime();
        }
    }


    private inline function stopUpdateTimer ()
    {
        if (updateTimer.notNull()) {
            updateTimer.stop();
            updateTimer = null;
        }
    }
    
    
    private inline function updateCurrentTime ()
    {
        if (channel != null) {
            trace(channel.position+" / "+source.length);
        }
#if flash9  currentTime.value = channel.notNull() ? channel.position * .001 : .0; #end
    }


    private inline function updateTotalTime ()
    {
#if flash9  totalTime.value = source.length * .001; #end
    }
    
    
    
    //
    // EVENTHANDLERS
    //


    override private function validateURL (newURL:URI, oldURL:URI)
    {
        super.validateURL(newURL, oldURL);
        isLoaded = false;
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
        
        if (channel.notNull())
            applyVolume();
    }


    private inline function applyVolume ()
    {
#if flash9
        Assert.notNull(channel);
        if (channel.soundTransform.volume != volume.value)
        {
            var sound               = channel.soundTransform;
            sound.volume            = volume.value;
            channel.soundTransform  = sound;
        }
#end
    }
}
