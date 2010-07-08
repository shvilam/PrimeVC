package primevc.core.states;
 import primevc.core.dispatcher.Signal0;


/**
 * @author Ruben Weijers
 * @creation-date Jun 07, 2010
 */
class State implements IState
{
	public var id (getId, null)			: Int;
		private inline function getId()	: Int { return id; }
	
	public var entering	(default, null)	: Signal0;
	public var exiting	(default, null)	: Signal0;
	
	
	public function new ( id_:Int )
	{
		id			= id_;
		entering	= new Signal0();
		exiting		= new Signal0();
	}
	
	
	public function dispose ()
	{
		id = -1;
		entering.dispose();
		exiting.dispose();
	}
}