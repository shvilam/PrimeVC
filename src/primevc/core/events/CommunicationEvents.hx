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
package primevc.core.events;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.dispatcher.Signals;


typedef CommunicationEvents = 
	#if		flash9	primevc.avm2.events.CommunicationEvents;
	#elseif	flash8	primevc.avm1.events.CommunicationEvents;
	#elseif	js		primevc.js  .events.CommunicationEvents;
	#elseif	neko	CommunicationSignals;
	#else	error;	#end




typedef ErrorHandler	= String -> Void;
typedef ProgressHandler	= UInt -> UInt -> Void;
typedef ErrorSignal		= primevc.core.dispatcher.Signal1< String >;
typedef ProgressSignal	= primevc.core.dispatcher.Signal2<UInt,UInt>;


/**
 * Cross-platform communication events
 * 
 * @author Ruben Weijers
 * @creation-date Jul 31, 2010
 */
class CommunicationSignals extends Signals
{
	/**
	 * Dispatched when a communication operation has started
	 */
	var started		(default, null) : Signal0;
	
	/**
	 * Dispatched when a communication operation received initial data
	 */
	var init		(default, null) : Signal0;
	
	/**
	 * Dispatched when data there is progress receiving or sending data
	 */
	var progress	(default, null) : ProgressSignal;
	
	/**
	 * Dispatched when data communication is done
	 */
	var completed	(default, null) : Signal0;
	
	/**
	 * Dispatched when an error occured during the communication
	 */
	var error		(default, null) : ErrorSignal;
}