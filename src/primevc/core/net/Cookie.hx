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
package primevc.core.net;

#if flash9
 import flash.Error;
 import flash.events.NetStatusEvent;
 import flash.net.SharedObject;
 import flash.net.SharedObjectFlushStatus;
#end

/**
 * @since	feb 16, 2010
 * @author	Ruben Weijers
 */
class Cookie < DataType >
{
	public var name (default, null)	: String;
	public var data					: DataType;
	
#if flash
	private var localObj			: SharedObject;
#end

	
	public function new (name:String)
	{
		this.name = name;
		
		//FIXME write the cookie implementation for other languages
#if flash9
		try
		{
			localObj = SharedObject.getLocal( name );
			
			if (localObj != null)
				data = localObj.data;
		}
		catch (error : Error)
		{
			trace("Cookie read error! " + error);
		}
#end
	}
	
	
	/**
	 * Method will store the changed cookie values
	 */
	public function save ()
	{
#if flash9
		try
		{
			var flushStatus = localObj.flush();
		
			if (flushStatus == SharedObjectFlushStatus.PENDING)
			{
				trace("Requesting permission to save object...");
				localObj.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus, false, 0, true);
			}
			else
			{
				trace("Value flushed to disk.");
			}
		}
		catch (error : Error)
		{
			trace("Error... Could not write SharedObject to disk. "+error);
		}
#end
	}
	
	
	/**
	 * Method will remove the cookie-data
	 */
	public function delete ()
	{
#if flash9
		localObj.clear();
#end
	}
	
	
#if flash9
	private function onFlushStatus (event)
	{
		localObj.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus, false);
		switch (event.info.code)
		{
			case "SharedObject.Flush.Success":		trace("User granted permission -- value saved.");
			case "SharedObject.Flush.Failed":		trace("User denied permission -- value not saved.");
		}
	}
#end
}