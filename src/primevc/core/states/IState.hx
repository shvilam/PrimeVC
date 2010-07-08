package primevc.core.states;
 import primevc.core.IDisposable;
 import primevc.core.dispatcher.Signal0;


/**
 * Description
 *
 * @creation-date	Jun 9, 2010
 * @author			Ruben Weijers
 */
interface IState implements IDisposable
{
	var id			(getId, null)		: Int;
	var entering	(default, null)		: Signal0;
	var exiting		(default, null)		: Signal0;
}