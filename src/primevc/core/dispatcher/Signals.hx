package primevc.core.dispatcher;
 import primevc.core.IDisposable;
 import primevc.utils.TypeUtil;

/**
 * A group of dispatchers.
 * 
 * @author Danny Wilson
 * @creation-date jun 10, 2010
 */
class Signals implements IUnbindable<Dynamic>, implements IDisposable, implements haxe.Public
{
	public function dispose()
	{
		var f, R = Reflect, T = Type;
		
		for(field in T.getInstanceFields(T.getClass(this))) {
			f = R.field(this, field);
			if (f.is(IDisposable))
				f.dispose();
		}
	}
	
	public function unbind( listener : Dynamic, ?handler : Dynamic ) : Int
	{
		var f, count = 0, R = Reflect, T = Type;
		
		for(field in T.getInstanceFields(T.getClass(this))) {
			f = R.field(this, field);
			if (TypeUtil.is(f, IUnbindable))
				count += f.unbind(listener, handler);
		}
		return count;
	}
}