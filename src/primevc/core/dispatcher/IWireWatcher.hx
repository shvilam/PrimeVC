package primevc.core.dispatcher;

/**
 * @author Danny Wilson
 * @creation-date jun 10, 2010
 */
interface IWireWatcher <T>
{
	function wireEnabled	(wire:Wire<T>) : Void;
	function wireDisabled	(wire:Wire<T>) : Void;
}