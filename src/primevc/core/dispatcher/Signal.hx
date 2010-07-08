package primevc.core.dispatcher;
 import primevc.core.ListNode;
  using primevc.utils.TypeUtil;
  using primevc.core.dispatcher.Wire;

/**
 * Abstract internal base class for all Signals.
 *  
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class Signal <FunctionSignature> extends ListNode<Wire<FunctionSignature>>, implements IUnbindable<FunctionSignature>, implements primevc.core.IDisposable
{
	static public inline function notifyEnabled<T>(s:Signal<T>, w:Wire<T>) : Void
	{
		if (s.is(IWireWatcher)) {
			var x:IWireWatcher<T> = cast s;
			x.wireEnabled(w);
		}
	}

	static public inline function notifyDisabled<T>(s:Signal<T>, w:Wire<T>) : Void
	{
		if (s.is(IWireWatcher)) {
			var x:IWireWatcher<T> = cast s;
			x.wireDisabled(w);
		}
	}
	
	
	/**
	 * Unbind all handlers for the given listener object,
	 *  or when a handler != null: unbound this specific handler.
	 *  
	 *  @return number of handlers unbound
	 */
	public function unbind( listener : Dynamic, ?handler : Null<FunctionSignature> ) : Int
	{
		Assert.that(listener != null);
		
		var b = this.n, count = 0;
		
		while (b != null) {
			var x = ListNode.next(b);
			if( b.isBoundTo(listener, handler) ) {
				b.dispose();
				++count;
			}
			b = x;
		}
		return count;
	}
	
	/**
	 *  Unbind all handlers.
	 */
	public function dispose()
	{
		var b = this.n;
		while(b != null) {
			var x = ListNode.next(b);
			b.dispose();
			b = x;
		}
	}
	
	/** Identify where the event is called (nice for debugging) ** /
	public inline function source(?pos:haxe.PosInfos)
	{
	  #if debug
		Event.callPos = pos;
	  #end
		return this;
	}
	
	/**
	 * Performance tests and optimization notes:
	 * 
	 * - Calling:
	 *  	var send (default,null) : FunctionSignature;
	 *	 is 4 times slower then:
	 *  	public function send( FunctionSignature );
	 * 
	 * - haxe.rtti.Generic not required for Signal subclasses
	 *	  Signal0,1,2,3 and 4  hardly (if at all) got a few ms faster calling send() 2 000 000 times.
	 */
}