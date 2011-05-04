package cases;



/**
 * @author Ruben Weijers
 * @creation-date Apr 15, 2011
 */
class ReflectStaticProperties
{
	public static function main ()
	{
		var inst	= new StaticTestClass();
		traceFields("StaticTestClass inst", Reflect.fields(inst));
		
		traceFields("StaticTestClass class inst", Type.getInstanceFields(StaticTestClass));
		traceFields("StaticTestClass class", Type.getClassFields(StaticTestClass));
	}
	
	
	private static function traceFields (title:String, fields:Array<String>) : Void
	{
		trace(" ===== FIELDS of "+title+" ( "+fields.length+" ) ===== ");
		for (i in 0...fields.length)
			trace("\t\t[ "+i+" ] = "+fields[i]);
		
		trace("ended");
	}
}


class StaticTestClass
{
	public static var test1 : String = "Test1";
	public static var test2 : Array<Int> = [0,5,7,9];
	public static inline var test3 : String = "Test3";
	private static inline var test4 : String = "Test4";
	
	
	private var testProperty1 : Float;
	public  var testProperty2 : Float;
	public function new () {
		testProperty1 = 1.0;
		testProperty2 = 2.9;
	}
	public function testMethod (testParam:Int);
	
}