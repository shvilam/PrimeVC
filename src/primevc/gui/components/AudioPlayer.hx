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
package primevc.gui.components;
 import primevc.core.net.AudioStream;
 import primevc.core.Bindable;
 import primevc.gui.core.UIDataContainer;
 import primevc.types.URI;


/**
 * @author Ruben Weijers
 * @creation-date Sep 28, 2011
 */
class AudioPlayer extends UIDataContainer <Bindable<URI>>
{
    public var stream       (default, null)         : AudioStream;

    public function new (id = null, uri:URI = null) { super(id, new Bindable<URI>(uri)); }
    override private function createChildren ()     { stream = new AudioStream(data.value); }
    override public  function removeChildren ()     { stream.dispose(); stream = null; super.removeChildren(); }

    override private function initData ()           { stream.url.pair(data); }
    override private function removeData ()         { stream.url.unbind(data); }

    public  inline function play ()                 { stream.play(); }         // can't call stream.play directly with some signals if they have parameters
    public  inline function stop ()                 { stream.stop(); }
    public  inline function resume ()               { stream.resume(); }
    public  inline function pause ()                { stream.pause(); }
}