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