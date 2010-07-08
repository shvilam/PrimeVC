package primevc.core.geom.constraints;
 

/**
 * Class to provide a int with dynamic rules wich can be applied on it when 
 * the value of the int is changed.
 * 
 * The constraints won't contain a value by themselves but their validate method
 * will be called when the value changes. The constraint can then apply it's
 * rules on the given value and change it if he likes that.
 * 
 * @creation-date	Jun 21, 2010
 * @author			Ruben Weijers
 */
class ConstrainedInt extends ConstraintBase <Int>
{
	/**
	 * Value of the cosntrained float. When the value is changed, the new
	 * value will first be checked by the constraints if they are enabled.
	 */
	public var value (default, setValue)		: Int;
		private inline function setValue (v)	{ return value = applyConstraint(v); }
	
	
	public function new (v = 0)
	{
		super();
		value = v;
	}
	
	
	override public function dispose ()
	{
		super.dispose();
		value = 0;
	}
	
	
	public function validateValue ()
	{
		value = applyConstraint(value);
	}
}