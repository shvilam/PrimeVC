package primevc.core.geom.constraints;
 import haxe.FastList;
 import primevc.core.IDisposable;
 

/**
 * Description
 * 
 * @creation-date	Jun 20, 2010
 * @author			Ruben Weijers
 */
class ConstraintBase <ConstraintDataType> implements IDisposable, implements haxe.rtti.Generic
{
	/**
	 * Flag indicating if the constraints on the float are enabled or not.
	 * @default	true
	 */
	public var constraintEnabled		: Bool;
	public var constraint				: IConstraint<ConstraintDataType>;
	
	
	public function new ()
	{
		constraintEnabled	= true;
	}
	
	
	public function dispose ()
	{
		if (constraint != null)
			constraint.dispose();
		constraint	= null;
	}
	
	
	private inline function applyConstraint (v)
	{
		if (constraintEnabled && constraint != null)
			v = constraint.validate(v);
		return v;
	}
}