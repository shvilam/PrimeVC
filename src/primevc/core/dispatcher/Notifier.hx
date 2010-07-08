package primevc.core.dispatcher;

/**
 * @see INotifier
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
typedef Notifier <FunctionSignature> = {
	public function bind		(owner:Dynamic, handler:FunctionSignature) : Wire<FunctionSignature>;
	public function bindOnce	(owner:Dynamic, handler:FunctionSignature) : Wire<FunctionSignature>;
}