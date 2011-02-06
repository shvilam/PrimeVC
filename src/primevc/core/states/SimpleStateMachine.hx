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
 import primevc.core.traits.IDisposable;
 

/**
 * SimpleStateMachine is another implementation of the FiniteStateMachine 
 * design-pattern but simpler. It doesn't use State objects to define the
 * state but just uses enum values to change the currentState.
 * 
 * Instead firing 3 signals when the state changes (exiting old state, changing
 * states) there will be only one event, the change event.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class SimpleStateMachine <StateType> implements IDisposable
	#if (flash9 || cpp) ,implements haxe.rtti.Generic #end
{
	public var current		(default, setCurrent)	: StateType;
	public var defaultState	(default, setDefault)	: StateType;
	
	/**
	 * Change event, dispatched when the state changes
	 * @param	1. new state
	 * @param	2. old state
	 */
	public var change		(default, null)			: Signal2 < StateType, StateType >;
	
	
	public function new(defaultState:StateType, currentState:StateType = null)
	{
		this.change			= new Signal2();
		this.current		= currentState;
		this.defaultState	= defaultState;
	}
	
	
	public function dispose ()
	{
		(untyped this).defaultState	= null;
		(untyped this).current		= null;
		change.dispose();
		change = null;
	}
	
	
	private inline function setDefault (v:StateType)
	{
		defaultState = v;
		if (current == null)
			current = v;
		
		return v;
	}
	
	
	private inline function setCurrent (v:StateType)
	{
		if (current != v) {
			var old	= current;
			current	= v;
			change.send( v, old );
		}
		return v;
	}
	
	
	
	public inline function is (state : StateType) : Bool
	{
		return current == state;
	}
}