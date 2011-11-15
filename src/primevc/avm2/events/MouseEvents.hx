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
package primevc.avm2.events;
private typedef MouseSignal = primevc.avm2.events.MouseSignal; // override import
 import primevc.core.geom.Point;
 import primevc.gui.events.MouseEvents;
 import primevc.gui.events.KeyModState;
 import flash.events.IEventDispatcher;
 import flash.events.MouseEvent;


/**
 * Group of proxying Signals to flash.events.Mouse events.
 * 
 * @author Danny Wilson
 * @creation-date jun 11, 2010
 */
class MouseEvents extends MouseSignals
{
	private var eventDispatcher : IEventDispatcher;
	
	public function new (eventDispatcher:IEventDispatcher)
	{
		super();
		this.eventDispatcher = eventDispatcher;
	}
	
	
	override public function dispose ()
	{
		eventDispatcher = null;
		super.dispose();
	}
	
	
	override private function createDown ()			{ down			= new MouseSignal( eventDispatcher, MouseEvent.MOUSE_DOWN	, 1); }
	override private function createUp ()			{ up			= new MouseSignal( eventDispatcher, MouseEvent.MOUSE_UP		, 1); }
	override private function createMove ()			{ move			= new MouseSignal( eventDispatcher, MouseEvent.MOUSE_MOVE	, 0); }
	override private function createClick () 		{ click			= new MouseSignal( eventDispatcher, MouseEvent.CLICK		, 1); }
	override private function createDoubleClick ()	{ doubleClick	= new MouseSignal( eventDispatcher, MouseEvent.DOUBLE_CLICK	, 2); }
	override private function createOverChild ()	{ overChild		= new MouseSignal( eventDispatcher, MouseEvent.MOUSE_OVER	, 0); }
	override private function createOutOfChild ()	{ outOfChild	= new MouseSignal( eventDispatcher, MouseEvent.MOUSE_OUT	, 0); }
	override private function createRollOver ()		{ rollOver		= new MouseSignal( eventDispatcher, MouseEvent.ROLL_OVER	, 0); }
	override private function createRollOut ()		{ rollOut		= new MouseSignal( eventDispatcher, MouseEvent.ROLL_OUT		, 0); }
	override private function createScroll ()		{ scroll		= new MouseSignal( eventDispatcher, MouseEvent.MOUSE_WHEEL	, 0); }
}