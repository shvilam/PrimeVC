package cases;


class OverrideTest
{
	static function main ()
	{
		var a = new A();
		trace( a.getSelf() );
		var b = new A();
		trace( b.getSelf() );
	}
}


class A
{
	public function new ();
	public dynamic function getSelf () : A	{ return this; }
}


class B extends A
{
	override dynamic public function getSelf () : B	{ return this; }
}