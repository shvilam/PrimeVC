package primevc.core.dispatcher;
 import primevc.core.IDisposable;
 import primevc.core.ListNode;
  using primevc.utils.BitUtil;

class Wire <FunctionSignature> extends ListNode<Wire<FunctionSignature>>, implements IDisposable
{
	/** Wire.flags bit which tells if the Wire is isEnabled(). */
	static public inline var ENABLED		= 1;
	/** Wire.flags bit which tells if Wire.handler takes 0 arguments. */
	static public inline var VOID_HANDLER	= 2;
	/** Wire.flags bit which tells if the Wire should be disposed() right after Signal.send(...) */
	static public inline var SEND_ONCE		= 4;
	
	static private var free : Wire<Dynamic>;
	static private var freeCount : Int = 0;
	
	/* static function __init__()
	{	
		var W = Wire;
		// Pre-allocate 9216 bytes of Wires
		for (i in 0 ... 256) {
			var b  = new Wire();
			b.n	   = W.free;
			W.free = b;
			W.freeCount++;
		}
	} */
		
	static public inline function make<T>( dispatcher:Signal<T>, owner:Dynamic, handlerFn:T, flags:Int ) : Wire<T>
	{
		var w:Wire<Dynamic>,
			W = Wire;
		
		if (W.free == null)
			w = new Wire<T>();
		else {
			--W.freeCount;
			W.free = (w = W.free).n; // i know it's unreadable.. but it's faster.
			w.n = null;
			Assert.that(w.owner == null && w.handler == null && w.signal == null && w.n == null);
		}
		
		w.owner   = owner;
		w.signal  = dispatcher;
		w.handler = handlerFn; // Unsets VOID_HANDLER (!!)
		w.flags	  = flags;
		w.doEnable();
		
		return cast w;
	}
	
	static public inline function sendVoid<T>( wire:Wire<Dynamic> ) {
		wire.handler();
	}
	
	
	// -----------------------
	// Instance implementation
	// -----------------------
	
	
	/** Is this Wire connected? Should it be called with 0 args? Should it be unbound after calling? **/
	public var flags	(default,null)	: Int;
	/** Handler function **/
	public var handler	(default,setHandler) : FunctionSignature;
	/** Wire owner object **/
	public var owner	(default, null) : Dynamic;
	/** Object referencing the parent Link in the Chain **/
	public var signal	(default, null)	: Signal<FunctionSignature>;
	
	//
	// INLINE PROPERTIES
	//
	
	private function new();
	
	public inline function isEnabled()
	{
		#if DebugEvents
		{
			var root = signal;
		
			var x = ListNode.next(root);
			var total = 0;
			var found = 0;
			while (x != null) {
				if (x == this) ++found;
				++total;
				x = x.n;
			}
			var isEnabled() = flags.has(ENABLED);
			trace("Total: "+total+" ; Found: "+found + " ; Enabled: "+isEnabled());
			Assert.that(isEnabled()? found == 1 : found == 0, "Found: "+found + " ; Enabled: "+isEnabled());
		}
		#end
		
		return flags.has(ENABLED);
	}
	
	private inline function setHandler( h:FunctionSignature )
	{
		// setHandler only accepts functions with FunctionSignature
		// and this is not a VOID_HANDLER for Signal1..4
		flags = flags.unset(VOID_HANDLER);
		
		return handler = h;
	}
	
	/** Enable propagation for the handler this link belongs too. **/
	public inline function enable()
	{
		if (!isEnabled())
		{
			flags |= ENABLED;
			doEnable();
		}
	}
	
	private inline function doEnable()
	{
		var s:ListNode<Wire<FunctionSignature>> = signal;
		this.n = s.n;
		s.n = this;
		Signal.notifyEnabled(signal, this);
	}
	
	/** Disable propagation for the handler this link belongs too. Usefull to quickly (syntax and performance wise) temporarily disable a handler.
		Adviced to use in classes which "in the usual way" would add and remove listeners alot. **/
	public inline function disable()
	{
		if (isEnabled())
		{
			flags ^= ENABLED;
			
			// Find LinkNode before this one
			var x:ListNode<Wire<FunctionSignature>> = signal;
			while (x.n != null && x.n != this) x = x.n;
			
			x.n = this.n;
			this.n = null;
			
			Signal.notifyDisabled(signal, this);
		}
	}
	
	public function dispose()
	{
		if (signal == null) return; // already disposed;
		
		disable();
		
		// Cleanup all connections
		handler = owner = signal = null;
		
		var W = Wire;
		if (W.freeCount != 256) {
			++W.freeCount;
			this.n = cast W.free;
			W.free = this;
		}
	}
	
	
	public inline function isBoundTo( target : Dynamic, ?handlerFn : Dynamic )
	{
		return this.owner == target 
			&& (handlerFn == null ||
		(
		  #if flash9
			this.handler == handlerFn
		  #else
			Reflect.compareMethods(handlerFn, this.handler)
		  #end
		));
	}
}