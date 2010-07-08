package primevc.core;


#if flash9
 import flash.utils.TypedDictionary;


/**
 * @since	mar 21, 2010
 * @author	Ruben Weijers
 */
class AbstractFactory < Product > // implements haxe.rtti.Generic
{
	private var instances : TypedDictionary < Class < Product > , Product > ;
	
	public function new ()
	{
		instances = new TypedDictionary( true );
	}
	
	
	/**
	 * factory method. Will create a new instance of the requested style if
	 * it doesn't exist yet, and will otherwise return a previous created 
	 * instance.
	 */
	public function getProduct ( productBluePrint:Class <Product>, ?args:Array < Dynamic > = null ) : Product
	{
		if (!instances.exists( productBluePrint )) {
			instances.set( productBluePrint, Type.createInstance( productBluePrint, args == null ? [] : args ) );
		}
		return instances.get( productBluePrint );
	}
}

#end