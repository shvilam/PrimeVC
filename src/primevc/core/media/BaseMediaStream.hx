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
package primevc.core.media;
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.states.MediaStates;
 import primevc.core.traits.IDisposable;
 import primevc.core.traits.IFreezable;
 import primevc.core.Bindable;
 import primevc.types.Number;
 import primevc.types.URI;
  using primevc.utils.Bind;
  using primevc.utils.NumberUtil;



/**
 * @since   Sep 28, 2011
 * @author  Ruben Weijers
 */
class BaseMediaStream implements IMediaStream
{
    private static inline var DEFAULT_VOLUME = 0.7;

    /**
     * Variable will cache the volume when the toggleMute method is called.
     * @default Number.FLOAT_NOT_SET
     */
    private var cachedVolume : Float;
    
    /**
     * Timer which will update the currentTime property. The timer is created
     * when the first listener starts listening to currentTime changes.
     */
    private var updateTimer : haxe.Timer;
    
    
    /**
     * audio-volume of the media-stream.
     * 0 =< value <= 1
     * @default 0.7
     */
    public var volume       (default, null)         : Bindable<Float>;
    
    /**
     * URL of the video-stream.
     */
    public var url          (default, null)         : Bindable<URI>;

    /**
     * Property only used by SoundMixer. Identical as ListNode, accept that SoundMixer 
     * can change the value.
     */
    public var next         (default, null)         : BaseMediaStream;
    
    /**
     * Current state of the media-stream. Do not modify the state directly, but 
     * use the appropriate methods to change the state of mediastream.
     */
    public var state        (default, null)         : SimpleStateMachine<MediaStates>;

    /**
     * Bindable value with the total-time of the stream (in sec.).
     */
    public var totalTime    (default, null)         : Bindable<Float>;
    
    /**
     * Number of seconds the stream has been playing. This value is automaticly
     * updated, as long as the stream is playing. The first time the time is
     * called, the stream will start a timer to update the value (every 200ms).
     * 
     * Note:
     * To seek the in the stream, you should not change this property but use the "seek"
     * method.
     */
    public var currentTime  (getCurrentTime, null)  : Bindable<Float>;
    
            
    

    public function new (streamUrl:URI = null)
    {
        url             = new Bindable<URI>(streamUrl);
        volume          = new Bindable<Float>(DEFAULT_VOLUME);
        currentTime     = new Bindable<Float>(0.0);
        totalTime       = new Bindable<Float>(0.0);
        
        cachedVolume    = Number.FLOAT_NOT_SET;
        var curState    = streamUrl == null ? MediaStates.empty : MediaStates.stopped;
        state           = new SimpleStateMachine<MediaStates>( MediaStates.empty, curState );

        validateURL.on( url.change, this );
    }
    
    
    public function dispose ()
    {
        stop();
        
        if (updateTimer != null) {
            updateTimer.stop();
            updateTimer = null;
        }
        
        volume      .dispose();
        state       .dispose();
        url         .dispose();
        totalTime   .dispose();
        
        url     = null;
        state   = null;
        volume  = totalTime = null;
        
        (untyped this).currentTime.dispose();
        (untyped this).currentTime = null;
    }

    
    
    //
    // MEDIA METHODS
    //
    
    
    
    /**
     * Method will start playing the given or current url. If another
     * stream is already playing, it will be stopped.
     * If the current url is already playing, the stream will start again.
     */
    public function play ( ?newUrl:URI )        { Assert.abstract(); }
    
    
    /**
     * Method will pause the stream if it was playing
     */
    public function pause ()                    { Assert.abstract(); }
    public function resume ()                   { Assert.abstract(); }
    public function stop ()                     { Assert.abstract(); }
    public function seek (newPosition:Float)    { Assert.abstract(); }


    private inline function validatePosition (pos:Float) : Float
    {
        return pos.within(0, totalTime.value);
    }
    
    
    public function togglePlayPauze ()
    {
        if      (isPlaying())   pause();
        else if (isPaused())    resume();
        else if (isStopped())   play();
    }
    
    
    public function toggleMute ()
    {
        if (isMuted())
        {
            volume.value    = cachedVolume.isSet() ? cachedVolume : DEFAULT_VOLUME;
            cachedVolume    = Number.FLOAT_NOT_SET;
        }
        else
        {   
            cachedVolume    = volume.value;
            volume.value    = 0;
        }
    }
    
    
    
    private inline function freezeState ()
    {
        state.current = MediaStates.frozen( state.current );
    }
    
    
    private inline function defrostState ()
    {
        switch (state.current)
        {
            case frozen( prevState ):   state.current = prevState;
            default:
        }
    }


    public  function freeze ()          { Assert.abstract(); }
    public  function defrost ()         { Assert.abstract(); }
    private function getCurrentTime()   { return currentTime; }
    
    
    
    //
    // STATE METHODS
    //
    
    public inline function isStopped () : Bool  { return state.current == MediaStates.stopped; }
    public inline function isPaused ()  : Bool  { return state.current == MediaStates.paused; }
    public inline function isPlaying () : Bool  { return state.current == MediaStates.playing; }
    public inline function isEmpty ()   : Bool  { return state.current == MediaStates.empty; }
    public inline function isMuted ()   : Bool  { return volume.value == 0; }
    public inline function isFrozen ()  : Bool
    {
        return switch (state.current) {
            case frozen( prevState ):   true;
            default:                    false;
        }
    }
    
    
    private function validateURL (newURL:URI, oldURL:URI)
    {
        if (oldURL != null)
            stop();
        
        state.current = (newURL == null) ? MediaStates.empty : MediaStates.stopped;
    }
    
    
#if flash9
    private function handleIOError (error:String)
    {
        trace(error);
        state.current = MediaStates.error(error);
    }
#end
}
