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
 */
package primevc.core.dispatcher;
 import primevc.core.traits.IDisposable;


/**
 * An INotifier calls message handlers of type <FunctionSignature> that are registered using bind().
 * INotifier is Observable aswell.
 * 
 * @see Observable
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
interface INotifier <FunctionSignature> implements IUnbindable <FunctionSignature>, implements IDisposable
{
	public function observe		    (owner:Dynamic, handler:Void->Void)			: Wire<FunctionSignature>;
	public function observeOnce	    (owner:Dynamic, handler:Void->Void)			: Wire<FunctionSignature>;
	public function observeDisabled	(owner:Dynamic, handler:Void->Void)	        : Wire<FunctionSignature>;
    
    public function bind            (owner:Dynamic, handler:FunctionSignature)  : Wire<FunctionSignature>;
    public function bindOnce        (owner:Dynamic, handler:FunctionSignature)  : Wire<FunctionSignature>;
    public function bindDisabled    (owner:Dynamic, handler:FunctionSignature)  : Wire<FunctionSignature>;
}
