/**
 * Binding helper functions.
 * With super duper special power function overload faking action ..!
 * 
 * Usage:
 *  
 *  using primevc.utils.Bind;
 *  ...
 *  eventHandler.on(eventDispatcher);
 *  reDispatcher.on(eventDispatcher);
 *  
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
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
package primevc.utils;
 import primevc.core.dispatcher.Sender;
 import primevc.core.dispatcher.Notifier;
 import primevc.core.dispatcher.Observable;

class RedispatchObserveAny {
	// TODO: Check if we should optimize this case by changing handler.send to null, and adding another flag (SEND_VOID_SIGNAL) to Wire.
	static inline public function on<Sig>(handler:Sender<Void->Void>, dispatcher:Observable, ?owner:Dynamic) {
		return dispatcher.observe(owner == null? handler : owner, handler.send);
	}
}

class RedispatchAny {
	// TODO: Check if we should optimize this case by changing handler.send to null, and adding another flag (SEND_TO_SIGNAL) to Wire.
	static inline public function on<Sig>(handler:Sender<Sig>, dispatcher:Notifier<Sig>, ?owner:Dynamic) {
		return dispatcher.bind(owner == null? handler : owner, handler.send);
	}
}

class ObserveAny {
	static inline public function on<R>(handler:Void->R, dispatcher:Observable, owner:Dynamic) {
		return dispatcher.observe(owner, untyped handler);
	}
}

class Bind1 {
	static inline public function on<A,R>(handler:A->R, dispatcher:Notifier<A->Void>, owner:Dynamic) {
		return dispatcher.bind(owner, untyped handler);
	}
}

class Bind2 {
	static inline public function on<A,B,R>(handler:A->B->R, dispatcher:Notifier<A->B->Void>, owner:Dynamic) {
		return dispatcher.bind(owner, untyped handler);
	}
}

class Bind3 {
	static inline public function on<A,B,C,R>(handler:A->B->C->R, dispatcher:Notifier<A->B->C->Void>, owner:Dynamic) {
		return dispatcher.bind(owner, untyped handler);
	}
}

class Bind4 {
	static inline public function on<A,B,C,D,R>(handler:A->B->C->D->R, dispatcher:Notifier<A->B->C->D->Void>, owner:Dynamic) {
		return dispatcher.bind(owner, untyped handler);
	}
}


//
// Once variants
//


class RedispatchObserveAnyOnce {
	static inline public function onceOn<Sig>(handler:Sender<Void->Void>, dispatcher:Observable, ?owner:Dynamic) {
		return dispatcher.observeOnce(owner == null? handler : owner, handler.send);
	}
}

class RedispatchAnyOnce {
	static inline public function onceOn<Sig>(handler:Sender<Sig>, dispatcher:Notifier<Sig>, ?owner:Dynamic) {
		return dispatcher.bindOnce(owner == null? handler : owner, handler.send);
	}
}

class ObserveAnyOnce {
	static inline public function onceOn<R>(handler:Void->R, dispatcher:Observable, owner:Dynamic) {
		return dispatcher.observeOnce(owner, untyped handler);
	}
}

class Bind1Once {
	static inline public function onceOn<A,R>(handler:A->R, dispatcher:Notifier<A->Void>, owner:Dynamic) {
		return dispatcher.bindOnce(owner, untyped handler);
	}
}

class Bind2Once {
	static inline public function onceOn<A,B,R>(handler:A->B->R, dispatcher:Notifier<A->B->Void>, owner:Dynamic) {
		return dispatcher.bindOnce(owner, untyped handler);
	}
}

class Bind3Once {
	static inline public function onceOn<A,B,C,R>(handler:A->B->C->R, dispatcher:Notifier<A->B->C->Void>, owner:Dynamic) {
		return dispatcher.bindOnce(owner, untyped handler);
	}
}

class Bind4Once {
	static inline public function onceOn<A,B,C,D,R>(handler:A->B->C->D->R, dispatcher:Notifier<A->B->C->D->Void>, owner:Dynamic) {
		return dispatcher.bindOnce(owner, untyped handler);
	}
}