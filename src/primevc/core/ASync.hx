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
package primevc.core;
 import primevc.core.dispatcher.IUnbindable;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.traits.IDisposable;
  using primevc.utils.Bind;
  using primevc.utils.BitUtil;


/**
 * 
 * @author Ruben Weijers
 * @creation-date May 16, 2011
 */
class ASync <DataType> implements IDisposable, implements IUnbindable<DataType->Dynamic>
{
	private static inline var NONE		= 0;
	private static inline var CANCELED	= 1 << 0;
	private static inline var REQUESTED	= 1 << 1;
	private static inline var REPLIED	= 1 << 2;
	private static inline var DISPOSED	= 1 << 3;
	
	
	private var response		: Signal1<DataType>;
	private var error			: Signal1<String>;
	
	/**
	 * Flag indicating if a request is already send or canceled
	 */
	private var state			: Int;
	private var _reply			: DataType;
	
	public var handleRequest	(default, setHandleRequest)	: Void -> Void;
	public var handleCancel		(default, setHandleCancel)	: Void -> Void;
	
	
	
	
	public function new (requestHandler:Void->Void = null, cancelHandler:Void->Void = null)
	{
		response	= new Signal1();
		error		= new Signal1();
#if !flash9
		state		= NONE;
#end
		if (requestHandler != null)		handleRequest 	= requestHandler;
		if (cancelHandler != null)		handleCancel 	= cancelHandler;
	}
	
	
	public function dispose ()
	{
		Assert.that( state.hasNone(DISPOSED) );
		response.dispose();
		error.dispose();
		
		response	= null;
		error		= null;
		state		= DISPOSED;
		
		handleRequest = handleCancel = null;
		(untyped this)._reply = null; // Int can't be set to null, so we trick the compiler with "untyped"
	}
	
	
	public inline function unbindAll ()
	{
		response.unbindAll();
		error.unbindAll();
	}
	
	
	public function unbind(owner:Dynamic, ?handler:Null<DataType->Dynamic>) : Void
	{
		Assert.that( state.hasNone(DISPOSED) );
		response.unbind(owner);
		error.unbind(owner);
	}
	
	
	public function get<T> (owner:Dynamic, responseHandler:DataType->T, errorHandler:String->Dynamic = null)
	{
		Assert.that( state.hasNone(DISPOSED) );
		if (state.has(REPLIED))
			responseHandler(_reply);
		
		else
		{
			responseHandler.on( response, owner );
			if (errorHandler != null)
				errorHandler.on( error, owner );
			
			if (state.hasNone(REQUESTED)) {
				state = REQUESTED;
				if (handleRequest != null)		// ASync-object can exist before the handler is created..
					handleRequest();
			}
		}
	}
	
	
	public inline function cancel () : Void
	{
		if (state != REQUESTED)
			return;
		
		state = CANCELED;
		if (handleCancel != null)
			handleCancel();
		
		unbindAll();
		state = NONE;
	}
	
	
	public inline function reply (data:DataType) : Void
	{
		Assert.that( state.hasNone(DISPOSED) );
		response.send(data);
		_reply = data;
		unbindAll();
		state  = REPLIED;
	}
	
	
	public inline function sendError (message:String) : Void
	{
		Assert.that( state.hasNone(DISPOSED) );
		error.send(message);
		unbindAll();
	}
	
	
	//
	// GETTERS / SETTERS
	//
	
	private inline function setHandleRequest (handler:Void->Void)
	{
		Assert.that( state.hasNone(DISPOSED) );
		handleRequest = handler;
		if (handler != null && state.has(REQUESTED))
			handler();
		return handler;
	}
	
	
	private inline function setHandleCancel (handler:Void->Void)
	{
		Assert.that( state.hasNone(DISPOSED) );
		handleCancel = handler;
		return handler;
	}
}