package primevc.gui.behaviours;
 import primevc.core.IDisposable;
 

/**
 * A behaviour binds method-calls with events to enable the default
 * behaviour as described in the Bevaviour class itself.
 *
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
interface IBehaviour < TargetType > implements IDisposable
{
	public var target (default, setTarget)	: TargetType;
	/**
	 * Method to implement the behaviour in. This method should be overwritten 
	 * by all subclasses and will be called when a new target is set.
	 */
	private function init() : Void;
	/**
	 * Reset method will remove the behaviour from the target. This method 
	 * should be overwritten by all subclasses and will be called when a
	 * target is set to null or when the bahaviour is disposed.
	 */
	private function reset() : Void;
}