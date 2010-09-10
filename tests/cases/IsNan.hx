package cases;
  using primevc.utils.NumberUtil;

class IsNan
{
	static function main()
	{
		var float:Float = 0;
		var nan:Float = Math.NaN;
		var nullf:Float = #if !flash9 null #else nan #end;
		
	#if debug	
		Assert.that(float.isSet());
		Assert.that(nan.notSet());
		Assert.that(nullf.notSet());
		trace("IsNan tests passed!");
	#else
		trace("Recompile in DEBUG mode!");
	#end
	}
}