package primevc.core.dispatcher;

/**
 * An ISender1 facilitates dispatching of messages.
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
interface ISender1 <A> implements ISender
{
	public function send (a:A)					: Void;
}
