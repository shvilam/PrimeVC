package primevc.core.dispatcher;
 import primevc.core.ListNode;
  using primevc.core.dispatcher.Wire;
  using primevc.utils.BitUtil;

/**
 * Signal with 4 arguments to send()
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
class Signal4 <A,B,C,D> extends Signal<A->B->C->D->Void>, implements ISender4<A,B,C,D>, implements INotifier<A->B->C->D->Void>
{
	public function new();
	
	public inline function send(_1:A, _2:B, _3:C, _4:D)
	{
		//TODO: Run benchmarks and tests if this should really be inlined...
		
		var w = this.n;
		
		while (w != null)
		{
			var x = ListNode.next(w);
			
			if (w.isEnabled())
			{
				Assert.that(w != x);
				
				if (w.flags.has(Wire.VOID_HANDLER))
				 	w.sendVoid();
				else
					w.handler(_1,_2,_3,_4);
				
				if (w.flags.has(Wire.SEND_ONCE))
				 	w.dispose();
			}
			w = x; // Next node
		}
	}
	
	public inline function bind(owner:Dynamic, handler:A->B->C->D->Void)
	{
		return Wire.make( this, owner, handler, Wire.ENABLED );
	}
	
	public inline function bindOnce(owner:Dynamic, handler:A->B->C->D->Void)
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