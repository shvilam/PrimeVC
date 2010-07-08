package primevc.core.dispatcher;

/**
 * An ISender2 facilitates dispatching of tuple messages.
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
interface ISender2 <A,B> implements ISender
{
	public function send (a:A, b:B)				: Void;
}
