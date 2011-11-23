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
 * Base class for mediator and controllers
 * 
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
class MVCActor <FacadeDef> extends MVCNotifier, implements IMVCActor
{
	//TODO: Ask Nicolas why you can't have typedefs as type constraint parameters...
	@manual private var f : FacadeDef;
	
	
	public function new (facade:FacadeDef, enabled = true)
	{
		this.f = facade;
		super(enabled);
	}
	
	
	override public function dispose ()
	{
		if (isDisposed())
			return;
		
		if (isListening())
			stopListening();
		
		f = null;
		super.dispose();
	}
	
	
	public function startListening () : Void		{ state = state.set( 	MVCFlags.LISTENING ); }
	public function stopListening () : Void			{ state = state.unset( 	MVCFlags.LISTENING ); if (isEnabled()) { disable(); } }
	public inline function isListening () : Bool	{ return state.has( 	MVCFlags.LISTENING ); }
}