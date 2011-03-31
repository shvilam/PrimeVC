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
package primevc.mvc.events;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.dispatcher.Signal1;
 import primevc.core.dispatcher.Signal2;
 import primevc.core.events.CommunicationEvents;


/**
 * OperationEvents are used to start/stop operations and track the progress of
 * the operations.
 * 
 * @author Ruben Weijers
 * @creation-date Nov 16, 2010
 */
class OperationEvents <DataType> extends CommunicationSignals
{
	public var start	(default, null)		: Signal1 < DataType >;
	public var stop		(default, null)		: Signal0;
	
	public function new ()
	{
	//	start		= new Signal1();
	//	stop		= new Signal0();
		started		= new Signal0();
		progress	= new Signal2();
		completed	= new Signal0();
		error		= new Signal1();
	}
	
	
	override public function dispose ()
	{
	//	start.dispose();
	//	stop.dispose();
		started.dispose();
		progress.dispose();
		completed.dispose();
		error.dispose();
		
	//	start = null;
	//	stop = null;
		started = completed = null;
		error = null;
		progress = null;
	}
}