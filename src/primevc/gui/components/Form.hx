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
 import primevc.core.geom.space.Horizontal;
 import primevc.core.geom.space.Vertical;
 import primevc.core.Bindable;
 import primevc.gui.core.IUIContainer;
 import primevc.gui.core.UIComponent;
 import primevc.gui.layout.algorithms.float.HorizontalFloatAlgorithm;
 import primevc.gui.layout.algorithms.float.VerticalFloatAlgorithm;
 import primevc.gui.layout.LayoutContainer;
 import primevc.gui.layout.VirtualLayoutContainer;
 import primevc.gui.traits.ISelectable;
  using primevc.utils.Bind;
  using primevc.utils.TypeUtil;


/* 
 * @author Ruben Weijers
 * @creation-date Oct 5, 2011
 */
class Form
{
    public static function addHorLabelRow (form:IUIContainer, labelStr:String, input:UIComponent, direction:Horizontal = null) : Void
    {
        createLabelRow( form, labelStr, input, createHorizontalRow(direction) );
    }


    public static function addVerLabelRow (form:IUIContainer, labelStr:String, input:UIComponent, direction:Vertical = null) : Void
    {
        createLabelRow( form, labelStr, input, createVerticalRow(direction) );
    }


    private static inline function createLabelRow (form:IUIContainer, labelStr:String, input:UIComponent, row:LayoutContainer)
    {
        var label = new Label(input.id.value+"Label", new Bindable<String>(labelStr+":"));

        // bind hover events together
        var inputEvents = input.userEvents.mouse;
        var labelEvents = label.userEvents.mouse;
        labelEvents.rollOver.on( inputEvents.rollOver,  input );
        labelEvents.rollOut .on( inputEvents.rollOut,   input );
        
        label.enabled.pair( input.enabled );
        label.dispose.on( input.state.disposed.entering, label );
        row  .dispose.on( input.state.disposed.entering, row );

        if (input.is(ISelectable))
            inputEvents.click.on( labelEvents.click,    input );

        // attach row
        row .attach(label.layout).attach(input.layout);
        form.attachLayout( row );
        form.attachDisplay( label ).attachDisplay( input );
    }


    public static inline function createHorizontalRow (direction:Horizontal = null) : LayoutContainer
    {
        var row          = new VirtualLayoutContainer();
        row.percentWidth = 1;
        row.algorithm    = new HorizontalFloatAlgorithm( direction == null ? Horizontal.left : direction, Vertical.center );
        return row;
    }


    public static inline function createVerticalRow (direction:Vertical = null) : LayoutContainer
    {
        var row          = new VirtualLayoutContainer();
        row.percentWidth = 1;
        row.algorithm    = new VerticalFloatAlgorithm( direction == null ? Vertical.center : direction, Horizontal.left );
        return row;
    }
}