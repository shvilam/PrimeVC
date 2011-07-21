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


/**
 * A group of <i>Signal</i> instances and (when applicable) other signal groups.
 * 
 * Signals allows to pool Signal instances in one place.
 * It implements the haxe.Public interface to make signals public by default. 
 * 
 * <h2>Usage example of a group with 1 Signal and another signal group</h2>
 * <code>
 * class LoaderSignals extends Signals
 * {
 *	var unloaded		(default, null)		: Signal0;
 *	var load			(default, null)		: CommunicationEvents;
 * }
 * </code>
 * 
 * @author Danny Wilson
 * @author Ruben Weijers
 * @creation-date jun 10, 2010
 */
@:autoBuild(primevc.utils.MacroUtils.autoEnable())
@:autoBuild(primevc.utils.MacroUtils.autoDisable())
@:autoBuild(primevc.utils.MacroUtils.autoUnbind())
@:autoBuild(primevc.utils.MacroUtils.autoUnbindAll())
@:autoBuild(primevc.utils.MacroUtils.autoDispose())
class Signals implements IUnbindable<Dynamic>, implements IDisposable, implements IDisablable, implements haxe.Public
{
	private var _enabled : Bool;
	
	public function new ()		{ _enabled = true; }
	public function disable ()	{ _enabled = false; }
	public function enable ()	{ _enabled = true; }
	public function dispose ()	{}
	
	/**
	 * @param	listener
	 * @param	handler
	 */
	public function unbind (listener:Dynamic, ?handler:Null<Dynamic>) {}
	public function unbindAll () {}
	
	public inline function isEnabled ()	{ return _enabled; }
	
/*	public function dispose()	{ MacroUtils.disposeFields(); }
	public function enable()	{ MacroUtils.enableFields(); }
	public function disable()	{ MacroUtils.disableFields(); }
	
	/**
	 * Uses reflection to find all IUbindable properties of this class and forwards the arguments to them.
	 * @see		Signal.unbind
	 */
/*	public function unbind( listener : Dynamic, ?handler : Dynamic ) : Void
	{
		MacroUtils.unbindFields();
	}*/
}