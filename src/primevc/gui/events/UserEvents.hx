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
package primevc.gui.events;
 import primevc.core.dispatcher.Signals;
 import primevc.core.dispatcher.INotifier;

typedef UserEvents = 
	#if		flash9	primevc.avm2.events.UserEvents;
	#elseif	flash8	primevc.avm1.events.UserEvents;
	#elseif	js		primevc.js  .events.UserEvents;
	#elseif neko	primevc.neko.events.UserEvents;
	#else	error	#end


/**
 * Cross-platform user-interface events.
 * 
 * @author Danny Wilson
 * @creation-date jun 15, 2010
 */
class UserSignals extends Signals
{
	public var mouse	(getMouse,	null)	: MouseEvents;
	public var key		(getKey,	null)	: KeyboardEvents;
	public var focus	(getFocus,	null)	: INotifier<Void->Void>;
	public var blur		(getBlur,	null)	: INotifier<Void->Void>;
	public var edit		(getEdit,	null)	: EditEvents;
	
	private inline function getMouse ()	{ if (mouse == null)	{ createMouse(); }		return mouse; }
	private inline function getKey ()	{ if (key == null)		{ createKey(); }		return key; }
	private inline function getFocus ()	{ if (focus == null)	{ createFocus(); }		return focus; }
	private inline function getBlur ()	{ if (blur == null)		{ createBlur(); }		return blur; }
	private inline function getEdit ()	{ if (edit == null)		{ createEdit(); }		return edit; }
	
	
	private function createMouse ()		{ Assert.abstract(); }
	private function createKey ()		{ Assert.abstract(); }
	private function createFocus ()		{ Assert.abstract(); }
	private function createBlur ()		{ Assert.abstract(); }
	private function createEdit ()		{ Assert.abstract(); }
	
	
	override public function dispose ()
	{
		if ((untyped this).mouse != null)	mouse	.dispose();
		if ((untyped this).key != null)		key		.dispose();
		if ((untyped this).focus != null)	focus	.dispose();
		if ((untyped this).blur != null)	blur	.dispose();
		if ((untyped this).edit != null)	edit	.dispose();
		
		edit	= null;
		mouse	= null;
		key		= null;
		blur	= focus = null;
	}
}
