package primevc.core.dispatcher;
 import primevc.core.ListNode;
  using primevc.core.dispatcher.Wire;
  using primevc.utils.BitUtil;

/**
 * Signal with no arguments to send()
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class Signal0 extends Signal<Void->Void>, implements ISender0, implements INotifier<Void->Void>
{
	public function new();
	
	public inline function send()
	{
		//TODO: Run benchmarks and tests if this should really be inlined...
		
		var b = this.n;
		
		while (b != null)
		{
			var x = ListNode.next(b);
			
			if (b.isEnabled())
			{
				Assert.that(b != x);
				b.handler();
				
				if (b.flags.has(Wire.SEND_ONCE))
				 	b.dispose();
			}
			b = x; // Next node
		}
	}
	
	public inline function bind(owner:Dynamic, handler:Void->Void)
	{
		return observe(owner, handler);
	}
	
	public inline function bindOnce(owner:Dynamic, handler:Void->Void)
	{
		return observeOnce(owner, handler);
	}
	
	public inline function observe(owner:Dynamic, handler:Void->Void)
	{
		return Wire.make( this, owner, handler, Wire.ENABLED | Wire.VOID_HANDLER);
	}
	
	public inline function observeOnce(owner:Dynamic, handler:Void->Void)
	{
		return Wire.make( this, owner, handler, Wire.ENABLED | Wire.VOID_HANDLER | Wire.SEND_ONCE);
	}
}