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
 * DAMAGE.s
 *
 *
 * Authors:
 *  Ruben Weijers	<ruben @ rubenw.nl>
 */
package primevc.mvc.routing;


private typedef Address = Int;


/**
 * @author Ruben Weijers
 * @creation-date May 16, 2011
 */
class Modem implements IModem
{
	private static var addresses			: Address = 0;
	
	
	public var address	(default, null)		: Address;
	
	/**
	 * Method that is called when the router receives a message
	 */
	public var receive	(default, default)	: MessageType -> Address -> Void;
	
	
	
	public function new ()
	{
		address = Modem.addresses++;
	}
	
	
	public function dispose ()
	{
		if (isConnected())
			disconnect();
		
		address = -1;
		receive = null;
	}
	
	
	public function connect (modem:IModem)
	{
		
	}
	
	
	public function disconnect (modem:IModem)	: Void;
	public function isConnected ()				: Bool;
	
	
	/**
	 * Returns true if the modem is connected to the address and the target-modem
	 * is listening
	 */
	public function ping (address:Address)		: Bool;
	
	
	/**
	 * Async message where the sender wants a response to the message
	 * @param	a pipe with an event to listen for an answer
	 */
	public function request (message:MessageType, request:ASync<Dynamic>, target:Address = -1)	: Void;
	
	
	/**
	 * Method to send a message to the target without having interest in the
	 * response.
	 */
	public function send (message:MessageType, target:Address = -1) : Void;
}