package primevc.core.dispatcher;

/**
 * Either a signal, a group of signals, or anything else that can unbind.
 *  
 * @author Danny Wilson
 * @creation-date jun 10, 2010
 */
interface IUnbindable<T>
{
	public function unbind( listener : Dynamic, ?handler : Null<T> ) : Int;
}