package primevc.js.events;

import primevc.core.dispatcher.Wire;
import primevc.core.dispatcher.Signal1;
import primevc.core.dispatcher.IWireWatcher;
import primevc.core.ListNode;
import js.Dom;

typedef DOMEvent =
{
	/*
	eventPhase constants
	CAPTURING_PHASE	= 1;
	AT_TARGET		= 2;
	BUBBLING_PHASE	= 3;
	*/
	public var type				(default, null):String; // The type of the event.
	public var bubbles			(default, null):Bool; // Indicates whether the event can bubble.
	public var canBubble		(default, null):Bool; // Indicates whether the event can bubble.
	public var cancelable		(default, null):Bool; // Indicates whether the event can have its default action prevented.
	public var cancelBubble 	:Bool; // The Microsoft equivalent of 'stopPropagation()'.
	public var currentTarget	(default, null):Dynamic; // The target whose EventListeners are currently being processed.
	public var defaultPrevented	(default, null):Bool; // Indicates whether the default action has been prevented.
	public var eventPhase		(default, null):Int; // The phase the event is in.
	public var returnValue		(default, null):Bool; 
	public var srcElement		(default, null):Dynamic; // The Microsoft equivalent of 'target'.
	public var target			(default, null):Dynamic; // The target of the event.
	public var timeStamp		(default, null):Int; // The time at which the event was created in milliseconds relative to 1970-01-01 00:00:00.
	
	public function preventDefault():Void; // Prevents the browser from performing the default action for the event.
	public function stopImmediatePropagation():Void; 
	public function stopPropagation():Void; // Prevents the event from any further propagation.
}

/**
 * @author	Stanislav Sopov
 * @since 	March 2, 2011
 */
class DOMSignal1<Type> extends Signal1<Type>, implements IWireWatcher<Type->Void>
{
	var eventDispatcher:Dynamic;
	var event:String;
	
	public function new (eventDispatcher:Dynamic, event:String)
	{
		super();
		this.eventDispatcher = eventDispatcher;
		this.event = event;
	}
	
	public function wireEnabled (wire:Wire<Type->Void>):Void
	{	
		Assert.that(n != null);
		
		if (ListUtil.next(n) == null) // First wire connected
		{
			untyped eventDispatcher.addEventListener(event, dispatch, false);
		}
	}
	
	public function wireDisabled (wire:Wire<Type->Void>):Void
	{	
		if (n == null) // No more wires connected
		{
			untyped eventDispatcher.removeEventListener(event, dispatch, false);
		}
	}
	
	private function dispatch(e:Event) 
	{
		Assert.abstract();
	}
}
