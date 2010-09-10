package cases;
  using primevc.utils.NumberUtil;

class IsNan
{
	static function main()
	{
		var float:Float = 0;
		var nan:Float = Math.NaN;
		var nullf:Float = #if !flash9 null #else nan #end;
		
		var one = 1.17264870091264061;
		var two = one * 200000.010012031239701793097;
		var three = two / 300000.123987163916986896;
		
	#if debug	
		Assert.that(float.isSet());
		Assert.that(nan.notSet());
		Assert.that(nullf.notSet());
		Assert.that(one.isSet());
		Assert.that(two.isSet());
		Assert.that(three.isSet());
		trace("IsNan tests passed!");
	#else
		trace("Recompile in DEBUG mode!");
	#end
	}
}