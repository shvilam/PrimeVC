package primevc.core.dispatcher;

/**
 * An ISender3 facilitates dispatching of 3-tuple messages.
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
interface ISender3 <A,B,C> implements ISender
{
	public function send (a:A, b:B, c:C)		: Void;
}
