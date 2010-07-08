package primevc.core.states;
 import primevc.utils.FastArray;
 

/**
 * Finite State Machine that will automaticy instatiate all states.
 * So new State is not needed anymore :-)
 * 
 * @creation-date	Jun 10, 2010
 * @author			Ruben Weijers
 */
class AutoFiniteStateMachine extends FiniteStateMachine, implements haxe.rtti.Infos
{
	public static inline var STATE_CLASS		: String = "primevc.core.states.State";
	public static inline var STATE_INTERFACE	: String = "primevc.core.states.IState";
	
	public function new() 
	{
		super();
		__init();
	}
	
	
	private function __init () : Void
	{
		var cl							= Type.getClass(this);
		var fields:FastArray<String>	= (untyped cl).fields;
		
		var struct = Xml.parse(untyped cl.__rtti).firstElement().elements();
		var element:Xml;
		var prop:Xml;
		
		if (fields == null) {
			fields = (untyped cl).fields = FastArrayUtil.create();
			
			for (element in struct)
			{
				prop = element.firstElement();
				
				if (prop != null && prop.nodeName == 'c' && (prop.get('path') == STATE_INTERFACE || prop.get('path') == STATE_CLASS))
				{
					fields.push(element.nodeName);
					setField( element.nodeName, new State( states.length ) );
				}
			}
		} else {
			for (field in fields) {
				setField( field, new State( states.length ) );
			}
		}
	}
	
	
	private function setField ( name:String, value:State ) : Void
	{
		if (Reflect.field(this, name ) == null)
		{
			Reflect.setField(this, name, value);
			if (value != null)
				states.push( value );
		}
	}
	
	
	/**
	 * method will automaticly set all state properties to 'null'
	 */
	override public function dispose ()
	{
		super.dispose();
		
		var cl = Type.getClass(this);
		var fields:FastArray<String> = untyped cl.fields;
		for (field in fields) {
			setField( field, null );
		}
	}
}