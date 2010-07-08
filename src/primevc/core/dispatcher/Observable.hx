package primevc.core.dispatcher;

/**
 * Used by primevc.utils.Bind
 * 
 * @author Danny Wilson
 * @creation-date Jun 09, 2010
 */
typedef Observable = {
	public function observe		(owner:Dynamic, handler:Void->Void) : Wire<Dynamic>;
	public function observeOnce	(owner:Dynamic, handler:Void->Void) : Wire<Dynamic>;
}