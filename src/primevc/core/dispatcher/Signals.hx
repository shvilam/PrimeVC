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
 import primevc.core.IDisposable;
 import primevc.utils.TypeUtil;

/**
 * A group of dispatchers.
 * 
 * @author Danny Wilson
 * @creation-date jun 10, 2010
 */
class Signals implements IUnbindable<Dynamic>, implements IDisposable, implements haxe.Public
{
	public function dispose()
	{
		var f, R = Reflect, T = Type;
		
		for(field in T.getInstanceFields(T.getClass(this))) {
			f = R.field(this, field);
			if (TypeUtil.is(f, IDisposable))
				f.dispose();
		}
	}
	
	public function unbind( listener : Dynamic, ?handler : Dynamic ) : Int
	{
		var f, count = 0, R = Reflect, T = Type;
		
		for(field in T.getInstanceFields(T.getClass(this))) {
			f = R.field(this, field);
			if (TypeUtil.is(f, IUnbindable))
				count += f.unbind(listener, handler);
		}
		return count;
	}
}