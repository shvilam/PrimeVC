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
 *  Danny Wilson	<danny @ onlinetouch.nl>
 */
package primevc.avm2.events;
 import primevc.core.dispatcher.INotifier;
 import primevc.gui.events.EditEvents;
 import primevc.gui.events.KeyboardEvents;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.events.UserEvents;


/**	
 * AVM2 UserEvents implementation
 * 
 * @creation-date	Jun 15, 2010
 * @author			Danny Wilson
 */
class UserEvents extends primevc.gui.events.UserSignals	
{
	public function new(eventDispatcher)
	{
		this.mouse		= new primevc.avm2.events.MouseEvents(eventDispatcher);
		this.key		= new primevc.avm2.events.KeyboardEvents(eventDispatcher);
		this.focus		= new FlashSignal0(eventDispatcher, flash.events.FocusEvent.FOCUS_IN);
		this.blur		= new FlashSignal0(eventDispatcher, flash.events.FocusEvent.FOCUS_OUT);
		this.edit		= new EditEvents(eventDispatcher);
	}
	
	
	override public function dispose ()
	{
		mouse.dispose();
		key.dispose();
		focus.dispose();
		blur.dispose();
		edit.dispose();
		
		mouse = null;
		key = null;
		focus = null;
		blur = null;
		edit = null;
	}
}