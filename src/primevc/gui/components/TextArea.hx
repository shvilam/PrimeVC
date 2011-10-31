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
 * DAMAGE.
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.components;
 import primevc.core.dispatcher.Wire;
 import primevc.core.Bindable;

 import primevc.gui.core.UITextField;
 import primevc.gui.core.Skin;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.events.UserEventTarget;
 import primevc.gui.input.Keyboard;
 import primevc.gui.input.KeyCodes;

  using primevc.gui.input.KeyCodes;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;
  using primevc.utils.NumberUtil;


private typedef Flags = primevc.gui.core.UIElementFlags;


/**
 * TODO: TextArea component displays a multiline textfield and adds the posibility
 * to divide the text of the component in multiple columns.
 * 
 * @author Ruben Weijers
 * @creation-date Oct 27, 2011
 */
class TextArea<VOType> extends InputField<VOType>
{
	override private function createChildren ()
	{
		field = UITextField.createLabelField(id.value + "TextField", data, this, layoutContainer);
#if flash9
		handleKeyDown.on( field.userEvents.key.down, this );
        updateScroll .on( layout.changed, true );
        field.makeEditable();
        field.mouseEnabled = field.tabEnabled = true;
        field.multiline    = true;
#end
		attachDisplay(field);
		Assert.null( layoutContainer.algorithm );
		Assert.null( skin );
	}


	override public  function removeChildren ()
	{
		field.dispose();
		field = null;
	}


	override public function validate ()
	{
		var c = changes;
		super.validate();
		if (c.has( Flags.TEXTSTYLE )) {
			field.embedFonts	= embedFonts;
			field.wordWrap		= wordWrap;
			field.textStyle 	= textStyle;
		}
		if (c.has( Flags.RESTRICT ))		field.restrict	= restrict;
		if (c.has( Flags.MAX_CHARS ))		field.maxChars	= maxChars;
	}
	

#if flash9
	override public function isFocusOwner (target:UserEventTarget)
	{
		return target == this || field.isFocusOwner(target);
	}


	private function updateScroll ()
	{
		updateLayoutScrollY();
		updateLayoutScrollX();
	}


	private function handleKeyDown (k:KeyboardState)
	{
		switch (k.keyCode()) {
			case KeyCodes.LEFT, KeyCodes.RIGHT:		updateLayoutScrollX();
			case KeyCodes.UP, 	KeyCodes.DOWN:		updateLayoutScrollY();
			default:
		}
	}



	//
	// SCROLLING
	//

    private var scrollX 	: Wire<Dynamic>;
    private var scrollY 	: Wire<Dynamic>;


	override public function enableClipping ()
	{
        var s   = layoutContainer.scrollPos;
        scrollX = applyLayoutScrollX.on( s.xProp.change, this );
        scrollY = applyLayoutScrollY.on( s.yProp.change, this );
	}


	override public function disableClipping ()
	{
		scrollX.dispose();
		scrollY.dispose();
		scrollX = scrollY = null;
	}


    private inline function updateLayoutScrollX ()
    {
    	var f = field, l = layoutContainer;			//	a      =        b - 1  		 /    c - 1            * d
    	if (f.maxScrollH > 1) { scrollX.disable(); l.scrollPos.x = (((f.scrollH - 1) / (f.maxScrollH - 1)) * l.scrollableWidth).floorFloat(); scrollX.enable(); }
    }


    private inline function updateLayoutScrollY ()
    {
    	var f = field, l = layoutContainer;			//	a      =        b - 1    	 /    c - 1            * d
    	if (f.maxScrollV > 1) { scrollY.disable(); l.scrollPos.y = (((f.scrollV - 1) / (f.maxScrollV - 1)) * l.scrollableHeight).floorFloat(); scrollY.enable(); }
    }


    /** @see updateScrollY **/
    private function applyLayoutScrollX (newV:Int, oldV:Int)
    {
        var f = field, l = layoutContainer;
        f.scrollH = (((l.scrollPos.x / l.scrollableWidth) * (f.maxScrollH - 1)) + 1).floorFloat();
    }
    
    
    private function applyLayoutScrollY (newV:Int, oldV:Int)
    {
        var f = field, l = layoutContainer;

    /*  var a = l.scrollPos.y;
        var c = f.maxScrollV;
        var d = l.scrollableHeight;
    	a =  ((b - 1) / (c - 1)) * d
        (b - 1) / (c - 1) = (a / d)
        (b - 1) = (a / d) * (c - 1)
        b       = ((a / d) * (c - 1)) + 1 */
        f.scrollV = (((l.scrollPos.y / l.scrollableHeight) * (f.maxScrollV - 1)) + 1).floorFloat();
    }
#end
}