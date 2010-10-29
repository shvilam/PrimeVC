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
package primevc.core.states;
 import primevc.core.dispatcher.Signal2;
 import primevc.core.dispatcher.INotifier;
 import primevc.utils.FastArray;
  using primevc.utils.Bind;


/**
 * @author Ruben Weijers
 * @creation-date Jun 08, 2010
 */
class FiniteStateMachine implements IFiniteStateMachine
{
	//
	// PROPERTIES
	//
	
	public var current		(default, setCurrent)		: IState;
	public var defaultState	(default, setDefaultState)	: IState;
	
	public var states		(default, null)				: FastArray <IState>;
	public var change		(default, null)				: Signal2 < IState, IState >;
	private var enabled		: Bool;
	
	
	public function new ()
	{
		states	= FastArrayUtil.create();
		enabled	= true;
		change	= new Signal2();
	}
	
	
	public function dispose ()
	{
		defaultState	= null;
		current			= null;
		
		for (state in states)
			state.dispose();
		
		change.dispose();
		change = null;
		states = null;
	}
	
	
	
	
	//
	// SETTERS / GETTERS
	//
	
	
	/**
	 * Setter will let the old state dispatch an exiting event and the new 
	 * state will dispatch an entering event.
	 * 
	 * The StateGroup itself will also dispatch an change event containing
	 * both the old and new state.
	 * 
	 * @private
	 */
	private function setCurrent (newState:IState) : IState
	{
		if (newState == null)
			newState = defaultState;
		
		if (!enabled)												return current;	//can't change states when we're not enabled
		if (current == newState)									return current;	//don't need to change since we're already in this state
		if (newState != null && states[ newState.id ] != newState)	return current;	//can't go to a state that isn't part of this FSM
		
		//dispathc exiting event
		if (current != null)
			current.exiting.send();
		
		//set new state and dispatch change event
		change.send( current, newState );
		current = newState;
		
		//dispatch entering event
		if (current != null)
			current.entering.send();
		
		return current;
	}
	
	
	/**
	 * Setter for the defaultstate. When the currentstate is empty,
	 * it will be set to the default-state.
	 * @private
	 */
	private function setDefaultState (newState:IState) : IState
	{
		defaultState = newState;

		if (current == null)
			current = defaultState;
		
		return defaultState;
	}
	
	
	
	
	//
	// METHODS
	//
	
	
	public function enable ()							{ enabled = true; }
	public function disable ()							{ enabled = false; }
	
	public function enableInState (trigger:IState)		{ enable.on( trigger.entering, this ); }
	public function disableInState (trigger:IState)		{ disable.on( trigger.exiting, this ); }
	
	
	public function changeOn (event:INotifier<Dynamic>, toState:IState)
	{
		var t = this;
		event.observe( this, function () { t.setCurrent( toState ); } );
	}
}