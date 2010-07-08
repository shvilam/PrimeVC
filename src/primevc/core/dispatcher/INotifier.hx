package primevc.core.dispatcher;

/**
 * An INotifier calls message handlers of type <FunctionSignature> that are registered using bind().
 * INotifier is Observable aswell.
 * 
 * @see Observable
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
interface INotifier <FunctionSignature> implements IUnbindable <FunctionSignature>
{
	public function observe		(owner:Dynamic, handler:Void->Void)			: Wire<FunctionSignature>;
	public function observeOnce	(owner:Dynamic, handler:Void->Void)			: Wire<FunctionSignature>;
	public function bind		(owner:Dynamic, handler:FunctionSignature)	: Wire<FunctionSignature>;
	public function bindOnce	(owner:Dynamic, handler:FunctionSignature)	: Wire<FunctionSignature>;
}
