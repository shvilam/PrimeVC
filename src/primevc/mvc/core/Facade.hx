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
package primevc.mvc.core;
 import primevc.mvc.events.MVCEvents;


/**
 * Abstract Façade class.
 * 
 * The Façade is responsible for initializing in order:
 * <ul>
 * <li> Event-Signals           </li>
 * <li> Model-Proxies           </li>
 * <li> App states collection	</li>
 * <li> Controller-Commands     </li>
 * <li> and View-Mediators.     </li>
 * </ul>
 * 
 * Facade initializes the main parts of the application 
 * (model, view, controller) and provides a main access point for them.
 * Acting as a binding component it allows to separate the model from
 * the view, thus separating data from UI elements respectively. 
 * 
 * @modified May 10, 2011, Ruben Weijers
 * 		Added application-states to the facade.
 * 
 * @author Danny Wilson
 * @creation-date Jun 22, 2010
 * @type <EventsType> all event groups used in this application/subsystem.
 */
class Facade < EventsType:MVCEvents, ModelType:IModel, StatesType:IStates, ViewType:IView, ControllerType:IController > implements primevc.core.traits.IDisposable
    #if !docs, implements haxe.rtti.Generic #end
{
	public var events		(default, null)	: EventsType;
	public var model		(default, null)	: ModelType;
	public var view			(default, null)	: ViewType;
	public var controller	(default, null)	: ControllerType;
	public var states		(default, null) : StatesType;
	
	
	private function new ()
	{	
		setupEvents();
		Assert.notNull( events, "Events-collection can't be empty.");
		
		setupModel();
		Assert.notNull(model, "Proxy-collection can't be empty.");
		
		setupStates();
		Assert.notNull(states, "States-collection can't be empty.");
		
		setupView();
		Assert.notNull(view, "Mediator-collection can't be empty.");
		
		setupController();
		Assert.notNull(controller, "Controller-collection can't be empty.");
		
		model.init();
		controller.init();
		view.init();
		
		events.started.send();
	}
	
	
	public function dispose()
	{
		if (events == null)
			return; // already disposed
		
		controller	.dispose();
		view		.dispose();
		states		.dispose();
		model		.dispose();
		events		.dispose();
		
		controller	= null;
		view		= null;
		states		= null;
		model		= null;
		events		= null;
	}
	
	/**
	 * Must instantiate the event-signals for this Facade.
	 */
	function setupEvents()		{ Assert.abstract(); }
	
	/**
	 * Must instantiate the Model for this Facade.
	 */
	function setupModel()		{ Assert.abstract(); }
	
	/**
	 * Must instantiate the States for this Facade.
	 */
	function setupStates()		{ Assert.abstract(); }
	
	/**
	 * Must map the event handlers, and setup behaviours/commands for this (sub)system.
	 */
	function setupController()	{ Assert.abstract(); }
	
	/**
	 * Must instantiate the View for this (sub)system.
	 * - Flash:			Supply a reference to the base DisplayObject to the view.
	 * - Javascript:	Supply a reference to the base DOM-element to the view.
	 */
	function setupView()		{ Assert.abstract(); }
}