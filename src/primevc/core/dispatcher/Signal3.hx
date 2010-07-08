package primevc.core.dispatcher;
 import primevc.core.ListNode;
  using primevc.core.dispatcher.Wire;
  using primevc.utils.BitUtil;

/**
 * Signal with 3 arguments to send()
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class Signal3 <A,B,C> extends Signal<A->B->C->Void>, implements ISender3<A,B,C>, implements INotifier<A->B->C->Void>
{
	public function new();
	
	public inline function send(_1:A, _2:B, _3:C)
	{
		//TODO: Run benchmarks and tests if this should really be inlined...
		
		var b = this.n;
		
		while (b != null)
		{
			var x = ListNode.next(b);
			
			if (b.isEnabled())
			{
				Assert.that(b != x);
				
				if (b.flags.has(Wire.VOID_HANDLER))
				 	b.sendVoid();
				else
					b.handler(_1,_2,_3);
				
				if (b.flags.has(Wire.SEND_ONCE))
				 	b.dispose();
			}
			b = x; // Next node
		}
	}
	
	public inline function bind(owner:Dynamic, handler:A->B->C->Void)
	{
		return Wire.make( this, owner, handler, Wire.ENABLED );
	}
	
	public inline function bindOnce(owner:Dynamic, handler:A->B->C->Void)
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