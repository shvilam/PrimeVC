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
#if flash9
 import flash.events.Event;
 import flash.media.SoundTransform;
#end
 import primevc.core.Bindable;
  using primevc.utils.IfUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


#if flash
private typedef Sound = flash.media.SoundMixer;
#end


/**
 * Singleton which collects all playing sound-objects and adds an API to apply 
 * actions on them.
 *
 * @since   Oct 3, 2011
 * @author  Ruben Weijers
 */
class SoundMixer
{
    private function new () {}
    
    private static var instance (getInstance, null) : SoundMixerInstance;
    
    private static inline function getInstance ()
    {
        if (instance.isNull())
            instance = new SoundMixerInstance();
        
        return instance;
    }


    public static inline function stopAll ()                        { instance.stopAll(); }
    public static inline function stopAllExcept (s:BaseMediaStream) { instance.stopAllExcept(s); }
    public static inline function freezeAll ()                      { instance.freezeAll(); }
    public static inline function defrostAll ()                     { instance.defrostAll(); }


    public static inline function add (s:BaseMediaStream)           { instance.add(s); }
    public static inline function remove (s:BaseMediaStream)        { instance.remove(s); }


    public static inline function mute ()                           { instance.mute(); }
    public static inline function unmute ()                         { instance.unmute(); }
    public static inline function toggleMute ()                     { instance.toggleMute(); }




    public static var volume    (getVolume, never)                  : Bindable<Float>;
        private static inline function getVolume ()                 { return instance.volume; }
    
    public static var isMuted   (getIsMuted, never)                 : Bindable<Bool>;
        private inline static function getIsMuted()                 { return instance.isMuted; }
    
    public static var isFrozen  (getIsFrozen, never)                : Bool;
        private inline static function getIsFrozen()                { return instance.isFrozen; }
}







/**
 * Singleton implemention
 */
private class SoundMixerInstance
{
    private var next        : BaseMediaStream;

    /**
     * Overall volume setting
     */
    public var volume       (default, null)        : Bindable<Float>;
    /**
     * Flag indicating if the sound is muted
     */
    public var isMuted      (default, null)         : Bindable<Bool>;
    /**
     * Flag indicating if all channels are frozem
     */
    public var isFrozen (getIsFrozen, never)        : Bool;
        private inline function getIsFrozen ()      { return numberOfFreezes > 0; }
    
    /**
     * The number of times "pauseAll" is called
     */
    private var numberOfFreezes                     : Int;
    
    
    public function new ()
    {
        volume              = new Bindable<Float>(1.0);
        isMuted             = new Bindable<Bool>(false);
        numberOfFreezes     = 0;
    }


    public function stopAll ()
    {
        var c = next;
        while (c.notNull()) {
            c.stop();
            c = c.next;
        }
        numberOfFreezes = 0;
    }


    public function stopAllExcept (exception:BaseMediaStream = null)
    {
        var c = next;
        while (c.notNull()) {
            if (c != exception)
                c.stop();
            c = c.next;
        }
        numberOfFreezes = 0;
    }


    public function freezeAll ()
    {
        var c = next;
        while (c.notNull()) {
            c.freeze();
            c = c.next;
        }
        numberOfFreezes++;
    }


    public function defrostAll ()
    {
        var c = next;
        numberOfFreezes--;
        while (c.notNull()) {
            c.defrost();
            c = c.next;
        }
    }


    public inline function add (s:BaseMediaStream)
    {
        Assert.notNull(s);
        if (isFrozen)
            for (i in 0 ... numberOfFreezes)
                s.freeze();
        
        (untyped s).next = next;
        next = s;
    //    ListUtil.addNode(this, s);
    }


    public function remove (s:BaseMediaStream)
    {
        Assert.notNull(s);

        //defrost the channel
        if (isFrozen)
            for (i in 0 ... numberOfFreezes)
                s.defrost();
        
        //remove it
        var cur = next;
        while (cur.notNull()) {
            if (cur.next == s) {
                (untyped cur).next = s.next;
                (untyped s).next   = null;
                break;
            }
            cur = cur.next;
        }
    }


    public function mute ()
    {
        if (!isMuted.value) {
            isMuted.value = true;
            applyVolume();
        }
    }


    public function unmute ()
    {
        if (isMuted.value) {
            isMuted.value = false;
            applyVolume();
        }
    }

    
    /**
     * Mutes or unmutes all soundClients. If a client is muted, the sound will
     * be paused instead of turning the volume to zero.
     */
    public inline function toggleMute ()
    {
        if (isMuted.value)  unmute();
        else                mute();
    }


    private function applyVolume ()
    {
#if flash9
        var s    = Sound.soundTransform;
        s.volume = isMuted.value.boolCalc() * volume.value;
        Sound.soundTransform = s;
#end
    }
}


