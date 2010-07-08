package primevc.core.dispatcher;

/**
 * An ISender4 facilitates dispatching of 4-tuple messages.
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
interface ISender4 <A,B,C,D> implements ISender
{
	public function send (a:A, b:B, c:C, d:D)	: Void;
}
