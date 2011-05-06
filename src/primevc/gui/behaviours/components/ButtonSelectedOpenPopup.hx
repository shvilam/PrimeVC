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
 import primevc.gui.core.IUIContainer;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.input.KeyCodes;
 import primevc.gui.traits.ISelectable;
  using primevc.utils.Bind;


/**
 * Class will help with opening and closing a popup for combobox components.
 * The popup will be opened when the component is selected and when the
 * selected value changes to false, the popup will be removed again.
 * 
 * @author Ruben Weijers
 * @creation-date Feb 10, 2011
 */
class ButtonSelectedOpenPopup extends BehaviourBase < ISelectable >
{
	private var popup		: IUIContainer;
	private var keyDownWire	: Wire<Dynamic>;
	
	
	public function new (target, popup:IUIContainer)
	{
		super(target);
		this.popup = popup;
	}
	
	
	override public function dispose ()
	{
		popup = null;
		super.dispose();
	}
	
	
	override private function init ()
	{
		popup.layout.includeInLayout = false;
		target.deselect		.on( target.displayEvents.removedFromStage, this );
		handleSelectChange	.on( target.selected.change, this );
		
		target.deselect		.on( target.window.deactivated, this );
		target.deselect		.on( target.enabled.change, this );
		
		//check if the popup should already be opened
		handleSelectChange( target.selected.value, false );
		
		//check if the escape key is pressed, if so, close the popup
		keyDownWire = checkEscapePressed.on( popup.userEvents.key.down, this );
		keyDownWire.disable();
	}
	
	
	override private function reset ()
	{
		keyDownWire.dispose();
		keyDownWire = null;
		
		target.selected.change.unbind(this);
		target.displayEvents.removedFromStage.unbind(this);
	}
	
	
	public function handleSelectChange (newVal:Bool, oldVal:Bool)
	{
		if (newVal)		openPopup();
		else			closePopup();
	}
	
	
	public function openPopup ()
	{
		if (popup.window != null)
			return;
		
		Assert.notNull( popup );
		target.system.popups.add( popup );
		keyDownWire.enable();
	}
	
	
	public function closePopup ()
	{
		if (popup.window == null)
			return;
		
		popup.system.popups.remove( popup );
		keyDownWire.disable();
	}
	
	
	private function checkEscapePressed (event:KeyboardState)
	{
		if (event.keyCode() == KeyCodes.ESCAPE)
			target.deselect();
	}
}