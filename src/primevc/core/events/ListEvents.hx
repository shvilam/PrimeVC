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
 import primevc.core.dispatcher.Signals;
 import primevc.core.dispatcher.Signal0;
 import primevc.core.dispatcher.Signal2;
 import primevc.core.dispatcher.Signal3;
 

/**
 * Change events for a collection
 * 
 * @creation-date	Jun 29, 2010
 * @author			Ruben Weijers
 */
class ListEvents <DataType> extends Signals
{
	/**
	 * Signal which is dispatched when an item is added to the list.
	 * The event will contain the new item and the position on wich it is added.
	 */
	public var added	(default, null)		: Signal2 <DataType, Int>;
	/**
	 * Signal which is dispatched when an item is removed from the list. The 
	 * event will contain the removed item and the last position of the item.
	 */
	public var removed	(default, null)		: Signal2 <DataType, Int>;
	/**
	 * Signal which is dispatched when an item is moved to a different position.
	 * Event parameters:
	 * 		1. moved item
	 * 		2. old position
	 * 		3. new position
	 */
	public var moved	(default, null)		: Signal3 <DataType, Int, Int>;
	
	/**
	 * Signal which is dispatched when all of the items of the list have been 
	 * removed at once.
	 */
	public var reset	(default, null)		: Signal0;
	
	
	public function new ()
	{
		reset	= new Signal0();
		added	= new Signal2();
		removed	= new Signal2();
		moved	= new Signal3();
	}
}