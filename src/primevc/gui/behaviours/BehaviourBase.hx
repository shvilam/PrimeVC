package primevc.gui.behaviours;
 

/**
 * Base class for a behaviour
 * 
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
class BehaviourBase < TargetType > implements IBehaviour < TargetType >
{
	public var target (default, setTarget)	: TargetType;
	
	public function new( newTarget:TargetType )		{ target = newTarget; }
	public function dispose ()						{ reset(); target = null; }
	private function init()							{ Assert.abstract(); }
	private function reset()						{ Assert.abstract(); }
	
	
	private inline function setTarget (newTarget:TargetType) : TargetType
	{
		if (target != null)
			reset();
		
		target = newTarget;
		
		if (target != null)
			init();
		
		return target;
	}
}