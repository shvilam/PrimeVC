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
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.gui.behaviours.components;
 import primevc.core.dispatcher.Wire;
 import primevc.gui.behaviours.BehaviourBase;
 import primevc.gui.components.IListHolder;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.input.KeyCodes;
 import primevc.gui.traits.IInteractive;
  using primevc.gui.input.KeyCodes;
  using primevc.utils.Bind;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;


/**
 * @author Ruben Weijers
 * @creation-date May 06, 2011
 */
class ListKeyNavigationBehaviour extends BehaviourBase<IListHolder<Dynamic>>
{
	private var keyDownWire		: Wire<KeyboardState -> Void>;
	private var currentFocus	: Int;
	
	
	
	override private function init ()
	{
		enableKeyListeners	.on( target.userEvents.focus, this );
		disableKeyListeners	.on( target.userEvents.blur, this );
		
		keyDownWire	= changeSelectedItem.on( target.userEvents.key.down, this );
		keyDownWire.disable();
	}
	
	
	override private function reset ()
	{
		keyDownWire.dispose();
		keyDownWire = null;
		target.userEvents.focus.unbind(this);
		target.userEvents.blur.unbind(this);
	}
	
	
	private function enableKeyListeners ()
	{
		trace("enable "+target);
		currentFocus = target.selectedIndex.value;
		keyDownWire.enable();
	}
	
	
	private function disableKeyListeners ()
	{
		trace("disable "+target);
		keyDownWire.disable();
	}
	
	
	private function changeSelectedItem (event:KeyboardState)
	{
		var index	= currentFocus; //target.selectedIndex.value;
		var k		= event.keyCode();
		var max		= target.list.data.length - 1;
		
		if (k.isEnter())
		{
			target.selectedIndex.value = index;
		}
		else if (k == KeyCodes.ESCAPE)
		{
	//		target.deselect();
		}
		else
		{
			if (k.isArrow())
				index = switch (k) {
					case KeyCodes.UP:		index - 1;
					case KeyCodes.DOWN:		index + 1;
					default:				index;
				}
			else if (k == KeyCodes.PAGE_UP	 || k == KeyCodes.HOME)		index = 0;
			else if (k == KeyCodes.PAGE_DOWN || k == KeyCodes.END)		index = max;
				
			
			trace(k+": "+index+", "+target.list.data.length);
			if (index != currentFocus && index.isWithin(0, max))
			{
				if (currentFocus != -1) {
					//fake rollout old "hovered" item
					var item = target.list.getRendererAt( currentFocus );
					item.as(IInteractive).userEvents.mouse.rollOut.send( MouseState.fake );
				}
				currentFocus = index;
				
				if (currentFocus != -1) {
					//fake highlight new "hovered" item
					var item = target.list.getRendererAt( index );
					item.as(IInteractive).userEvents.mouse.rollOver.send( MouseState.fake );
				}
			}
		}
	}
}