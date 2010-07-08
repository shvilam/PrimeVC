package primevc.core.dispatcher;

/**
 * A Sender is an object which allows sending of messages trough a dynamic method of type: <FunctionSignature>
 *  Usage: senderObj.send(...)
 *  
 * @see ISender
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
typedef Sender <FunctionSig> = {
	public var send (default,null) : FunctionSig;
}