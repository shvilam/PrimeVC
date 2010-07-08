package primevc.core.geom.constraints;
 import primevc.core.IDisposable;
 

/**
 * Description
 *
 * @creation-date	Jun 20, 2010
 * @author			Ruben Weijers
 */
interface IConstraint <ValidateType> implements IDisposable, implements haxe.rtti.Generic 
{
	function validate (v:ValidateType) : ValidateType;
}