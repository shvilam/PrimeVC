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
package primevc.tools;
 import primevc.core.dispatcher.Notifier;
 import primevc.core.dispatcher.Observable;
 import primevc.core.dispatcher.Wire;
 import primevc.core.traits.IDisposable;
  using primevc.utils.Bind;
  using Reflect;


private typedef SignalType <T>	= {
	> Notifier<T>, 
	public function send		() : T;
	public function dispose		() : Void;
//	public function observe		(owner:Dynamic, handler:Void->Void) : Wire<Dynamic>;
};


/**
 * @author Ruben Weijers
 * @creation-date Dec 08, 2010
 */
class SignalRepeater <FunctionSig> implements IDisposable
{
	private var timer			: haxe.Timer;
	private var startBinding	: Wire<Dynamic>;
	private var stopBinding		: Wire<Dynamic>;
	private var params			: Array<Dynamic>;
	private var delay			: Int;
	
	public var event			: SignalType<FunctionSig>;
	
	
	public function new (SignalClass:Class<Dynamic>, sourceSignal:SignalType<FunctionSig>, stopSignal:Observable, delay:Int)
	{
		this.delay		= delay;
		event			= Type.createInstance( SignalClass, [] );
		startBinding	= sourceSignal.bind( this, cast start );
		stopBinding		= stopSignal.observe(this, cast stop );
		
		stopBinding.disable();
	}
	
	
	public function dispose ()
	{
		stop();
		startBinding.dispose();
		stopBinding.dispose();
		event.dispose();
		
		startBinding = stopBinding = null;
		event	= null;
		params	= null;
	}
	
	
	public function enable ()			{ startBinding.enable(); }
	public function disable ()			{ stop(); startBinding.disable(); }
	private function dispatchEvent ()	{ event.callMethod( event.field("send"), params ); }
	
	
	private function start (__arguments__)
	{
		stopBinding.enable();
		startBinding.disable();
		
		params		= __arguments__;
		
		timer		= new haxe.Timer( delay );
		timer.run	= dispatchEvent;
		dispatchEvent();
	}
	
	
	private function stop ()
	{
		if (timer != null) {
			timer.stop();
			timer = null;
		}
		stopBinding.disable();
		startBinding.enable();
	}
}