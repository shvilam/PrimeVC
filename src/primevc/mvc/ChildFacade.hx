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
package primevc.mvc;
 import primevc.core.dispatcher.Signals;
 import primevc.core.traits.IDisposable;



/**
 * Child facade is a facade for sub-applications. These applications can't run
 * standalone and need instructions from another facade. This is possible with
 * the channels that are given to the child-facade when it's getting connected.
 * 
 * Only after connecting with channels, the child will start-listening. If the
 * facade is disconnected, the child will stop-listening all it's mediators and
 * controllers.
 * 
 * @author Ruben Weijers
 * @creation-date May 25, 2011
 */
class ChildFacade <
		EventsType		: Signals,
		ModelType		: IMVCCore,
		StatesType		: IDisposable,
		ControllerType	: IMVCCoreActor,
		ViewType		: IMVCCoreActor,
		ChannelsType
	>
	extends Facade <EventsType, ModelType, StatesType, ControllerType, ViewType>
{
	public var channels		(default, null) : ChannelsType;
	
	
	override public function dispose ()
	{
		super.dispose();
		channels = null;
	}
	
	
	/**
	 * Method for connecting a facade with channels of another facade
	 */
	public inline function connect (external:ChannelsType) : Void
	{
		Assert.null(channels);
		Assert.notNull(external);
		channels = external;
		start();
	}
	
	
	/**
	 * Method for disconnecting a facade with channels of another facade
	 */
	public inline function disconnect () : Void
	{
	//	Assert.notNull(channels);
		if (channels != null)
			stop();
		
		channels = null;
	}
}