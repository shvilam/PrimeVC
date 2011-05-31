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
 import primevc.core.traits.IDisablable;
 import primevc.core.traits.IDisposable;
 import primevc.core.ListNode;
  using primevc.utils.BitUtil;

/**
 * A Wire is the connection between a Signal0-4 dispatcher, and a handler object+function.
 * 
 * This allows to quickly (temporarily) disconnect (disable) the handler from the signal dispatcher.
 * 
 * Implementation detail: Wires are added to a bounded freelist (max 256 free objects) to reduce garbage collector pressure.
 * This means you should never reuse a Wire after calling dispose() and/or after unbinding the handler from the signal (which returned this Wire).
 */
class Wire <FunctionSignature> extends WireList<FunctionSignature>, implements IDisposable, implements IDisablable
{
	/** Wire.flags bit which tells if the Wire is isEnabled(). */
	static public inline var ENABLED		= 1;
	/** Wire.flags bit which tells if Wire.handler takes 0 arguments. */
	static public inline var VOID_HANDLER	= 2;
	/** Wire.flags bit which tells if the Wire should be disposed() right after Signal.send(...) */
	static public inline var SEND_ONCE		= 4;
	
//	static private var free : Wire<Dynamic>;
//	static private var freeCount : Int = 0;
	
/*	static function __init__()
	{	
		var W = Wire;
		// Pre-allocate Wires
		for (i in 0 ... 2048) {
			var b  = new Wire();
			b.n	   = W.free;
			W.free = b;
			++W.freeCount;
		}
	}
*/		
	static public function make<T>( dispatcher:Signal<T>, owner:Dynamic, handlerFn:T, flags:Int #if debug, ?pos : haxe.PosInfos #end ) : Wire<T>
	{
		var w:Wire<Dynamic>,
			W = Wire;
		
//		if (W.free == null)
			w = new Wire<T>();
/*		else {
			W.free = (w = W.free).n; // i know it's unreadable.. but it's faster.
			--W.freeCount;
			w.n = null;
			Assert.that(w.owner == null && w.handler == null && w.signal == null && w.n == null);
		}
*/		
		w.owner   = owner;
		w.signal  = dispatcher;
		w.handler = handlerFn; // Unsets VOID_HANDLER (!!)
		w.flags	  = flags;
		w.doEnable();
		
		#if debug w.bindPos = pos; #end
		
		return untyped w;
	}
	
	static public inline function sendVoid<T>( wire:Wire<Dynamic> ) {
		wire.handler();
	}
	
	
	// -----------------------
	// Instance implementation
	// -----------------------
	
	
	/** Is this Wire connected? Should it be called with 0 args? Should it be unbound after calling? **/
	public var flags	(default,null)	: Int;
	/** Handler function **/
	public var handler	(default,setHandler) : FunctionSignature;
	/** Wire owner object **/
	public var owner	(default, null) : Dynamic;
	/** Object referencing the parent Link in the Chain **/
	public var signal	(default, null)	: Signal<FunctionSignature>;
	
#if debug
	static var instanceCount = 0;
	public var bindPos		: haxe.PosInfos;
	public var instanceNum	: Int;
	
	public function toString() {
		return "{Wire["+instanceNum+" (instanceCount: "+instanceCount+")] bound at: "+ bindPos.fileName + ":" + bindPos.lineNumber + ", flags = 0x"+ StringTools.hex(flags, 2) +", owner = " + owner + "}";
	}
	public function pos(?p:haxe.PosInfos) : Wire<FunctionSignature> {
		#if debug untyped this.bindPos = p; return this; #end
	}
	
#else
	
	public inline function pos() : Wire<FunctionSignature> {
		return this;
	}
#end
	
	
	
	
	//
	// INLINE PROPERTIES
	//
	
	private function new() {
		flags = 0;
		#if debug instanceNum = ++instanceCount; #end
	}
	
	public inline function isEnabled() : Bool
	{
		#if DebugEvents
		{
			var root = signal;
		
			var x = ListNode.next(root);
			var total = 0;
			var found = 0;
			while (x != null) {
				if (x == this) ++found;
				++total;
				x = x.n;
			}
			var isEnabled = flags.has(ENABLED);
			trace("Total: "+total+" ; Found: "+found + " ; Enabled: "+isEnabled);
			Assert.that(isEnabled ? found == 1 : found == 0, "Found: "+found + " ; Enabled: "+isEnabled);
		}
		#end
		return flags.has(ENABLED);
	}
	
	private inline function setHandler( h:FunctionSignature )
	{
		// setHandler only accepts functions with FunctionSignature
		// and this is not a VOID_HANDLER for Signal1..4
		flags = flags.unset(VOID_HANDLER);
		
		return handler = h;
	}
	
	/** Enable propagation for the handler this link belongs too. **/
	public inline function enable()
	{
		if (!isEnabled())
		{
			flags = flags.set( ENABLED );
			doEnable();
		}
	}
	
	private inline function doEnable()
	{
		var s:ListNode<Wire<FunctionSignature>> = signal;
		this.n = s.n;
		s.n = this;
		Signal.notifyEnabled(signal, this);
	}
	
	/**
	 * Disable propagation for the handler this link belongs too. Usefull to 
	 * quickly (syntax and performance wise) temporarily disable a handler.
	 * 
	 * Adviced to use in classes which "in the usual way" would add and remove 
	 * listeners alot.
	 */
	public /*inline*/ function disable()
	{
		if (isEnabled())
		{
			flags = flags.unset( ENABLED );
			
			// Find LinkNode before this one
			var x:ListNode<Wire<FunctionSignature>> = signal;
			while (x.n != null && x.n != this) x = x.n;
			
			x.n = this.n;
			this.n = null;
			
			// If this wire is disabled during the call to it's handler we need 
			// to update the reference to the next-sendable in the Signal.send-list.
			// @see Signal.nextSendable
			if (signal.nextSendable == this)
				signal.nextSendable = x.n;
			
			Signal.notifyDisabled(signal, this);
		}
	}
	
	public function dispose()
	{
		if (signal == null) return; // already disposed;
		
		disable();
		
		// Cleanup all connections
		handler = owner = signal = null;
		flags	= 0;
		
/*		var W = Wire;
		if (W.freeCount != 2048) {
			++W.freeCount;
			this.n = cast W.free;
			W.free = this;
		}
		else
*/		 	Assert.that(n == null);
	}
	
	
	public inline function isBoundTo( target : Dynamic, ?handlerFn : Dynamic )
	{
		return this.owner == target 
			&& (handlerFn == null ||
		(
		  #if flash9
			this.handler == handlerFn
		  #else
			Reflect.compareMethods(handlerFn, this.handler)
		  #end
		));
	}
	
	
	public inline function isDisposed () : Bool
	{
		return signal == null || owner == null || handler == null;
	}
}