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
  using primevc.core.ListNode;
  using primevc.core.dispatcher.Wire;
  using primevc.utils.BitUtil;
  using primevc.utils.IfUtil;

/**
 * Signal with 1 argument to send()
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class Signal1 <A> extends Signal<A->Void>, implements ISender1<A>, implements INotifier<A->Void>
{
	public function new();
	
	public inline function send(_1:A)
	{
		//TODO: Run benchmarks and tests if this should really be inlined...
		
		var w = this.n;
		
		while (w.notNull())
		{
			var x = w.next();
			
			if (w.isEnabled())
			{
				Assert.that(w != x);
				Assert.that(w.flags != 0);
				
				if (w.flags.has(Wire.SEND_ONCE))
					w.disable();
				
				if (w.flags.has(Wire.VOID_HANDLER))
				 	w.sendVoid();
				else
				 	w.handler(_1);
				
				if (w.flags.has(Wire.SEND_ONCE))
				 	w.dispose();
			}
			w = x; // Next node
		}
	}
	
	public inline function bind(owner:Dynamic, handler:A->Void)
	{
		return Wire.make( this, owner, handler, Wire.ENABLED );
	}
	
	public inline function bindOnce(owner:Dynamic, handler:A->Void)
	{
		return Wire.make( this, owner, handler, Wire.ENABLED | Wire.SEND_ONCE);
	}
	
	public inline function observe(owner:Dynamic, handler:Void->Void)
	{
		return Wire.make( this, owner, cast handler, Wire.ENABLED | Wire.VOID_HANDLER);
	}
	
	public inline function observeOnce(owner:Dynamic, handler:Void->Void)
	{
		return Wire.make( this, owner, cast handler, Wire.ENABLED | Wire.VOID_HANDLER | Wire.SEND_ONCE);
	}
	
#if DebugEvents
	static function __init__()
	{
		// Unit tests
		var num=0, b1:Wire<String->Void>=null, b2:Wire<String->Void>=null, b3:Wire<String->Void>=null, b4:Wire<String->Void>=null, b5:Wire<String->Void>=null;

		var handlersCalled = 0;

		var d = new Signal1<String>();
		var name = function(l) {
			return if (l == b1) "B1";
			else   if (l == b2) "B2";
			else   if (l == b3) "B3";
			else   if (l == b4) "B4";
			else   if (l == b5) "B5";
		}

		var linkedWires = function() {
			var count = 0;
			var l = d.n;
			var linked = "";
			while (l != null) {
				++count;
				linked += name(l) + ", ";
				l = ListNode.next(l);
			}
			trace(linked);
			return count;
		}
		var handler = function(s) { trace("b12 handler(): "+linkedWires()); handlersCalled++; }

		var o = {};

		b1 = d.bind(o, handler); Assert.that(b1._ == d);
		b1.dispose();
		b1 = d.bind(o, handler); Assert.that(b1._ == d);
		
		b2 = d.bind(o, handler); Assert.that(b2._ == d);
		
		Assert.that(b1.isEnabled());
		Assert.that(b2.isEnabled());
		
		handlersCalled = 0; trace("0");
		d.send("a");
		Assert.that(handlersCalled == 2);
		
		b2.disable();
		Assert.that(b2.isEnabled() == false);
		handlersCalled = 0; trace("0 - b");
		d.send("a");
		Assert.that(handlersCalled == 1);
		
		b2.enable();
		Assert.that(b2.isEnabled());
		handlersCalled = 0; trace("0 - c");
		d.send("a");
		Assert.that(handlersCalled == 2);

		// Disable in handler test
		var disablingHandler = null;
		disablingHandler = function(s) { trace("b3 disablingHandler(): "+linkedWires()); handlersCalled++; b3.disable(); Assert.that(d.n != b3); }
		b3 = d.bind(o, disablingHandler);

		handlersCalled = 0; trace("1");
		d.send("a");
		Assert.that(handlersCalled == 3, ""+handlersCalled);
		d.send("a");
		Assert.that(handlersCalled == 5, ""+handlersCalled);
		d.send("a");
		Assert.that(handlersCalled == 7, ""+handlersCalled);

		var enablingHandler = null;
		enablingHandler = function(s) { trace("b4 enablingHandler(): "+linkedWires()); handlersCalled++; b3.enable(); Assert.that(d.n == b3); }
		b4 = d.bind(o, enablingHandler);

		handlersCalled = 0; trace("2 ----------------");
		d.send("a");
		Assert.that(handlersCalled == 3, ""+handlersCalled);
		trace(": 2b --------------");
		d.send("a");
		Assert.that(handlersCalled == 7, ""+handlersCalled);
		trace(": 2c --------------");
		d.send("a");
		Assert.that(handlersCalled == 11, ""+handlersCalled);
		
		var togglingHandler = null;
		togglingHandler = function(s) { 
			trace("togglingHandler()");
			handlersCalled++;
			Assert.that(b5.isEnabled());
			Assert.that(d.n == b5);

			b5.disable();
			Assert.that(d.n != b5);
			Assert.that(!b5.isEnabled());

			b5.enable();
			Assert.that(d.n == b5);
			Assert.that(b5.isEnabled());
		}
		b5 = d.bind(o, togglingHandler);

		handlersCalled = 0; trace("3");
		Assert.that(b3.isEnabled());
		Assert.that(b4.isEnabled());
		Assert.that(b5.isEnabled());
		num = linkedWires(); Assert.that(num == 5, "" + num);
		d.send("a");
		Assert.that(handlersCalled == 5, ""+handlersCalled);

		handlersCalled = 0; trace("4");
		Assert.that(b1.isEnabled());
		Assert.that(b2.isEnabled());
		Assert.that(b3.isEnabled());
		Assert.that(b4.isEnabled());
		Assert.that(b5.isEnabled());
		num = linkedWires(); Assert.that(num == 5, "" + num);
		d.send("a");
		Assert.that(handlersCalled == 5, ""+handlersCalled);

		handlersCalled = 0; trace("5");
		Assert.that(b3.isEnabled());
		Assert.that(b4.isEnabled());
		Assert.that(b5.isEnabled());
		num = linkedWires(); Assert.that(num == 5, "" + num);
		d.send("a");
		Assert.that(handlersCalled == 5, ""+handlersCalled);
		
		trace("Pass!");
	}
#end
}