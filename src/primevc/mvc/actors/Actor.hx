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
package primevc.mvc.actors;
 import primevc.core.traits.IDisposable;
  using primevc.utils.BitUtil;



/**
 * Class is the base class for mediator and controllers
 * 
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
class Actor <FacadeDef> implements IDisposable
{
	public var state	(default, null)	: Int;
	//TODO: Ask Nicolas why the %$@#! you can't have typedefs as type constraint parameters...
	public var f		(default, null) : FacadeDef;
	
	
	public function new (facade:FacadeDef)
	{
		state	= 0;
		this.f	= facade;
	}
	
	
	public function dispose ()
	{
		if (isDisposed())
			return;
		
		stopListening();
		state	= state.set( ActorState.DISPOSED );
		f		= null;
	}
	
	
	public function startListening () : Void		{ if (!isListening())	state = state.set( ActorState.LISTENING ); }
	public function stopListening () : Void			{ if (isListening())	state = state.unset( ActorState.LISTENING ); }
	private inline function isListening () : Bool	{ return state.has( ActorState.LISTENING ); }
	private inline function isDisposed () : Bool	{ return state.has( ActorState.DISPOSED ); }
}