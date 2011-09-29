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
 import primevc.core.states.SimpleStateMachine;
 import primevc.core.states.MediaStates;
 import primevc.core.traits.IDisposable;
 import primevc.core.traits.IFreezable;
 import primevc.core.Bindable;
 import primevc.types.URI;



/**
 * @since   Sep 28, 2011
 * @author  Ruben Weijers
 */
interface IMediaStream implements IFreezable, implements IDisposable
{
    //
    // STREAM PROPERTIES
    //


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
     * Current state of the media-stream. Do not modify the state directly, but 
     * use the appropriate methods to change the state of mediastream.
     */
    public var state        (default, null)         : SimpleStateMachine<MediaStates>;

    /**
     * Bindable value with the total-time of the stream.
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


    //
    // STREAM METHODS
    //


    /**
     * Method will start playing the given or current url. If another
     * stream is already playing, it will be stopped.
     * If the current url is already playing, the stream will start again.
     */
    public function play ( stream:URI = null )  : Void;

    /**
     * Method will pause the stream if it was playing
     */
    public function pause ()                    : Void;

    /**
     * Method will resume the stream if it's available
     */
    public function resume ()                   : Void;

    /**
     * Method will stop the stream and rewind it
     */
    public function stop ()                     : Void;

    /**
     * Method will jump to the given position in the stream
     */
    public function seek (newPosition:Float)    : Void;

    public function togglePlayPauze ()          : Void;

    public function toggleMute ()               : Void;


    //
    // STATE METHODS
    //
    
    public function isStopped () : Bool;
    public function isPaused ()  : Bool;
    public function isPlaying () : Bool;
    public function isEmpty ()   : Bool;
    public function isMuted ()   : Bool;
    public function isFrozen ()  : Bool;
}