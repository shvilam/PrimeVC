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
package primevc.gui.states;
 import primevc.core.states.AutoFiniteStateMachine;
 import primevc.core.states.IState;
 

/**
 * Unused class describing all the fases of the constructor of the skin.
 * 
 * @creation-date	Jun 18, 2010
 * @author			Ruben Weijers
 */
class SkinConstructingStates extends AutoFiniteStateMachine
{
	/**
	 * Default state when the skin hasn't done anything.
	 */
	public var constructing			: IState;
	/**
	 * State is set when the layout is created.
	 */
	public var layoutCreated		: IState;
	/**
	 * State is set when the skin has created it's states.
	 * State is part of the constructing fase.
	 */
	public var statesCreated		: IState;
	
	/**
	 * State is set when the skin has created it's behaviours.
	 * State is part of the constructing fase.
	 */
	public var behavioursCreated	: IState;
	
	/**
	 * Component is constructed when:
	 *  - layout is created
	 *  - states are created
	 *  - behaviours are set
	 */
	public var constructed			: IState;
	
	
	public function new ()
	{
		super();
		defaultState = constructing;
	}
}