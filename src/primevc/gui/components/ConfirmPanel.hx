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
 import primevc.core.dispatcher.Signal0;
 import primevc.gui.core.IUIElement;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.input.KeyCodes;
 import primevc.gui.managers.ISystem;
  using primevc.utils.Bind;


/**
 * Panel with an ok/cancel button
 * 
 * @author Ruben Weijers
 * @creation-date Oct 5, 2011
 */
class ConfirmPanel extends AlertPanel
{
    /**
     * Text to display on the cancel button. If the value is "",
     * the button won't be displayed.
     */
    public var cancelLabel  (default, setCancelLabel)   : String;
    public var cancelBtn    (default, null)             : Button;
    public var canceled     (default, null)             : Signal0;


    public function new (id:String = null, title:String = null, content:IUIElement = null, system:ISystem = null, applyLabel:String = "Toepassen", cancelLabel:String = "Annuleren")     //TRANSLATE
    {
        super(id, title, content, system, applyLabel);
        canceled         = new Signal0();
        this.cancelLabel = cancelLabel;

        addKeyListeners     .on( displayEvents.addedToStage, this );
        removeKeyListeners  .on( displayEvents.removedFromStage, this );
    }


    override public function dispose ()
    {
        if (isDisposed())
            return;
        
        super.dispose();
        canceled.dispose();
        canceled = null;
    }

    
    override private function createChildren ()
    {
        super.createChildren();
        if (cancelLabel != "")
            createCancelBtn( cancelLabel );
    }

    
    override public function removeChildren ()
    {
        if (cancelBtn != null)
            removeCancelBtn();
        super.removeChildren();
    }


    private function cancel ()
    {
        canceled.send();
        close();
    }


    private inline function setCancelLabel (v:String)
    {
        if (v != cancelLabel)
        {
            if (isInitialized())
            {
                if (v != "") {
                    if (cancelBtn == null)  createCancelBtn(v);
                    else                    cancelBtn.data.value = v;
                }
                else
                    removeCancelBtn();
            }
            cancelLabel = v;
        }
        return v;
    }


    private inline function createCancelBtn (cancelLabel:String)
    {
        cancelBtn = new Button("cancelBtn", cancelLabel);
        cancelBtn.styleClasses.add("linkBtn");
        addToFooter( cancelBtn );
        cancel.on( cancelBtn.userEvents.mouse.click, this );
    }


    private inline function removeCancelBtn ()
    {
        cancelBtn.dispose();
        cancelBtn = null;
    }


    private function addKeyListeners ()
    {
        //check if the escape key is pressed, if so, close the popup
        checkEscapePressed.on( userEvents.key.down, this );
        checkEscapePressed.on( window.userEvents.key.down, this );
    }


    private function removeKeyListeners ()
    {
        window.userEvents.key.down.unbind(this);
        userEvents.key.down.unbind(this);
    }


    private function checkEscapePressed (event:KeyboardState)
    {
        if (event.keyCode() == KeyCodes.ESCAPE)
            cancel();
    }
}