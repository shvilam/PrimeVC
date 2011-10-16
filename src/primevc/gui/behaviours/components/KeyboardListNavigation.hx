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
package primevc.gui.behaviours.components;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.components.SelectableListView;
 import primevc.gui.core.IUIDataElement;
 import primevc.gui.display.IInteractiveObject;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.input.KeyCodes;
  using primevc.gui.input.KeyCodes;
  using primevc.utils.Bind;
  using primevc.utils.IfUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


/**
 * Class will help with opening and closing a popup for combobox components.
 * The popup will be opened when the component is selected and when the
 * selected value changes to false, the popup will be removed again.
 * 
 * @author Ruben Weijers
 * @creation-date Feb 10, 2011
 */
class KeyboardListNavigation<T> extends BehaviourBase < SelectableListView<T> >
{
    override private function init ()
    {
        var t = target;
        changeSelectedItem.on( t.userEvents.key.down, this );
        checkHoveredItem  .on( t.userEvents.mouse.move, this );
        checkHoveredItem  .on( t.userEvents.mouse.scroll, this );
    }


    override private function reset ()
    {
        var t = target;
        t.userEvents.key.down    .unbind(this);
        t.userEvents.mouse.move  .unbind(this);
        t.userEvents.mouse.scroll.unbind(this);
        t.children.change        .unbind(this);
        t.blurRenderers();
    }




    //
    // EVENTHANDLERS
    //


    private function changeSelectedItem (event:KeyboardState)
    {
        var t       = target;
        var index   = t.focusIndex;
        if (index == -1)
            index   = t.depthToIndex(0);
        
        var k       = event.keyCode();
        var max     = t.data.length - 1;
        
        if (k.isEnter()) {
            if (index > -1)
                t.select( t.data.getItemAt(index) );
        }
        else
        {
            if      (k == KeyCodes.UP)      index -= 1;
            else if (k == KeyCodes.DOWN)    index += 1;
            else if (k == KeyCodes.PAGE_UP   || k == KeyCodes.HOME)     index = 0;
            else if (k == KeyCodes.PAGE_DOWN || k == KeyCodes.END)      index = max;
            
            // TODO: check if a-z is pressed to select items that start with that letter
            if (t.focusIndex != index && index.isWithin(0, max))
                t.focusRendererAt( index );
        }
    }


    
    /**
     * Eventhandler can be called after a mouse-event and give focus to the object 
     * underneath the mouse-cursor. Used after a scroll-event.
     */
    private function checkHoveredItem (mouse:MouseState)
    {
        var target = mouse.target;
        if (target.notNull() && target.is(IUIDataElement) && target.is(IInteractiveObject))
            this.target.focusRenderer(cast target);
    }
}