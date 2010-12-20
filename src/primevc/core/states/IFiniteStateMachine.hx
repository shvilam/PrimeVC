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
 import primevc.core.traits.IDisposable;
 import primevc.core.dispatcher.Signal2;
 import primevc.utils.FastArray;


private typedef NewState = IState;
private typedef OldState = IState;


/**
 * Interface describing the FiniteStateMachine
 * 
 * @creation-date	Jun 9, 2010
 * @author			Ruben Weijers
 */
interface IFiniteStateMachine implements haxe.rtti.Infos, implements IDisposable
{
	//
	// PROPERTIES
	//
	
	/**
	 * Collection of states that the current statemachine can have.
	 */
	var states			(default, null)				: FastArray < IState >;
	/**
	 * Current state of the group. State must be in the <code>states</code>
	 * list.
	 */
	var current			(default, setCurrent)		: IState;
	/**
	 * State that will be used when there is no state set.
	 */
	var defaultState	(default, setDefaultState)	: IState;
	/**
	 * Change dispatcher. First parameter is the new state, the second parameter
	 * is the old state.
	 */
	var change			(default, null)				: Signal2 < NewState, OldState >;
	
	
	
	
	//
	// METHODS
	//
	
	/*
	 * Method will add a new state to the list with available states.
	 * It is recommended that the state is also declared as class
	 * variable.
	 * @param	state
	 */
//	function add (state:IState) : Void;
//	function remove (state:IState) : Void;
	
	/**
	 * Enabel the current state group. The group will be allowed to siwtch from states
	 * again when it's enabled.
	 */
	function enable ()	: Void;
	
	/**
	 * Disable the current state group. It's not posible to switch from states when
	 * the group is disabled.
	 */
	function disable ()	: Void;
	
	/**
	 * Method will enable the stategroup when the given state is entered.
	 * The StateGroup won't be automaticly disabled when the given state is
	 * exited.
	 * 
	 * @param	trigger
	 */
	function enableInState (trigger:IState) : Void;
	
	/**
	 * Method will disable the stategroup when the given state is entered.
	 * The StateGroup won't be automaticly enabled when the given state is
	 * exited.
	 * 
	 * @param	trigger
	 */
	function disableInState (trigger:IState) : Void;
}