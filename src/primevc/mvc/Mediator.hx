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
 *  Ruben Weijers	<ruben @ onlinetouch.nl>
 */
package primevc.mvc;
// import primevc.core.dispatcher.Signals;

/**
 * Abstract Mediator class.
 * 
 * The Mediator translates requests between components.
 * Usually it acts as a layer between application-requests and the View.
 * 
 * A Mediator is not allowed to change Value-objects.
 * It can however request changes from a Proxy (defined within Model).
 * 
 * @author Danny Wilson
 * @creation-date Jun 22, 2010
 */
class Mediator <EventsTypeDef, ModelTypeDef, StatesTypeDef, ViewTypeDef, GUIType> extends Listener <EventsTypeDef, ModelTypeDef, StatesTypeDef, ViewTypeDef>, implements IMediator <GUIType>
{
	public var gui (default, setGUI)	: GUIType;
	
	
	public function new (events:EventsTypeDef, model:ModelTypeDef, states:StatesTypeDef, view:ViewTypeDef, gui:GUIType = null)
	{
		super(events, model, states, view);
		this.gui = gui;
	}
	
	
	override public function dispose ()
	{
		if (isDisposed())
			return;
		
		gui = null;
		super.dispose();
	}
	
	
	// Set the UI element that the mediator serves.
	private function setGUI (gui:GUIType)
	{
		if (isListening())
		{
			stopListening();
			this.gui = gui;
			
			if (gui != null)
				startListening();
		}
		else
			this.gui = gui;
		
		return gui;
	}
}
