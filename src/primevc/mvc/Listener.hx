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
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package primevc.mvc;
  using primevc.utils.BitUtil;



/**
 * Class is the base class for mediator and commands and defines that the object
 * is able to listen and to send events.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
class Listener <EventsTypeDef, ModelTypeDef, StatesTypeDef, ViewTypeDef> extends Notifier <EventsTypeDef>
{
	//TODO: Ask Nicolas why the %$@#! you can't have typedefs as type constraint parameters...
	
	public var model	(default, null)		: ModelTypeDef;
	public var states	(default, null)		: StatesTypeDef;
	public var view		(default, null)		: ViewTypeDef;
	
	
	public function new (events:EventsTypeDef, model:ModelTypeDef, states:StatesTypeDef, view:ViewTypeDef)
	{
		super( events );
		
		this.model	= model;
		this.states	= states;
		this.view	= view;
		
		Assert.notNull(model,	"Model cannot be null for "+this);
		Assert.notNull(states,	"States cannot be null for "+this);
		Assert.notNull(view,	"View cannot be null for "+this);
	}
	
	
	public function startListening () : Void		{ if (!isListening())	state = state.set( MVCState.LISTENING ); }
	public function stopListening () : Void			{ if (isListening())	state = state.unset( MVCState.LISTENING ); }
	private inline function isListening () : Bool	{ return state.has( MVCState.LISTENING ); }
	
	
	override public function dispose()
	{
		if (isDisposed())
			return;
		
		stopListening();
		
		model	= null;
		states	= null;
		view	= null;
		super.dispose();
	}
}