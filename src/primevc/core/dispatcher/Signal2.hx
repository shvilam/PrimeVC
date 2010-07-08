package primevc.core.dispatcher;
 import primevc.core.ListNode;
  using primevc.core.dispatcher.Wire;
  using primevc.utils.BitUtil;

/**
 * Signal with 2 arguments to send()
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class Signal2 <A,B> extends Signal<A->B->Void>, implements ISender2<A,B>, implements INotifier<A->B->Void>
{
	public function new();
	
	public inline function send(_1:A, _2:B)
	{
		//TODO: Run benchmarks and tests if this should really be inlined...
		
		var b:Wire<A->B->Void> = this.n;
		
		while (b != null)
		{
			var x:Wire<A->B->Void> = ListNode.next(b);
			
			if (b.isEnabled())
			{
				Assert.that(b != x);
				
				if (b.flags.has(Wire.VOID_HANDLER))
				 	b.sendVoid();
				else
					b.handler(_1,_2);
				
				if (b.flags.has(Wire.SEND_ONCE))
				 	b.dispose();
			}
			b = x; // Next node
		}
	}
	
	public inline function bind(owner:Dynamic, handler:A->B->Void)
	{
		return Wire.make( this, owner, handler, Wire.ENABLED );
	}
	
	public inline function bindOnce(owner:Dynamic, handler:A->B->Void)
	{
		return Wire.make( this, owner, handler, Wire.ENABLED | Wire.SEND_ONCE);
	}
	
	public inline function observe(owner:Dynamic, handler:Void->Void)
	{
		return Wire.make( this, owner, cast handler, Wire.ENABLED | Wire.VOID_HANDLER);
	}
	
	public inline function observeOnce(owner:Dynamic, handler:Void->Void)
	{
		return Wire.make( this, owner, cast handler, Wire.ENABLED | Wire.VOID_HANDLER | Wire.SEND_ONCE);
	}
}