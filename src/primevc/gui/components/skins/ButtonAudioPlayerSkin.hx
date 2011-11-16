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
 *  Ruben Weijers   <ruben @ rubenw.nl>
 */
package primevc.gui.components.skins;
 import primevc.core.states.MediaStates;
 import primevc.gui.components.AudioPlayer;
 import primevc.gui.components.Button;
 import primevc.gui.core.UIGraphic;
 import primevc.gui.core.Skin;
  using primevc.utils.Bind;



private typedef Flags = primevc.gui.core.UIElementFlags;



/**
 * AudioPlayer with a play/stop button. Around the button is a 
 * small progressbar.
 * 
 * @author Ruben Weijers
 * @creation-date Sep 29, 2011
 */
class ButtonAudioPlayerSkin extends Skin<AudioPlayer>
{
    private var progress    : UIGraphic;
    private var playStopBtn : Button;


    override public function childrenCreated ()
    {
        owner.styleClasses.add("buttonAudioPlayer");
        progress    = new UIGraphic("progress");
        playStopBtn = new Button();
    //  playStopBtn.styleClasses.add("normalBtn");
        
        handleStreamState.on( owner.stream.state.change, this );
        updateProgressBar.on( owner.stream.currentTime.change, this);
        handleStreamState(    owner.stream.state.current, null );
        updateProgressBar(    owner.stream.currentTime.value, 0);

        owner.attach(progress);
        owner.attach(playStopBtn);
    }


    override public  function removeChildren ()
    {
        owner.styleClasses.remove("buttonAudioPlayer");
        owner.stream.state.change.unbind( this );
        owner.stream.currentTime.change.unbind( this );

        progress.dispose();
        playStopBtn.dispose();
        playStopBtn = null;
        progress    = null;
    }


    private function handleStreamState (newState:MediaStates, oldState:MediaStates)
    {
        var mouseClick = playStopBtn.userEvents.mouse.click;
        mouseClick.unbind(this);
        switch (newState) {
            case MediaStates.stopped:
                playStopBtn.id.value = "playBtn";
                owner.play.onceOn( mouseClick, this );
                playStopBtn.enable();
            
            case MediaStates.playing:
                playStopBtn.id.value = "stopBtn";
                owner.stop.onceOn( mouseClick, this );
                playStopBtn.enable();

            case MediaStates.paused:
                playStopBtn.id.value = "playBtn";
                owner.resume.onceOn( mouseClick, this );
                playStopBtn.enable();
            
            case MediaStates.error(string):
                playStopBtn.id.value = "playBtn";
                playStopBtn.disable();
            
            case MediaStates.empty:
                playStopBtn.id.value = "playBtn";
                playStopBtn.disable();
            
            default:
        }
    }


    private function play ()    { owner.stream.play(); }
    private function stop ()    { owner.stream.stop(); }
    private function resume ()  { owner.stream.resume(); }


    private function updateProgressBar (newV:Float, oldV:Float)
    {
        var total = owner.stream.totalTime.value;
        progress.graphicData.percentage = (newV == 0 || total == 0) ? 0 : newV / total;
    }
}