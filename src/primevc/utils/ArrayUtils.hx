package primevc.utils;

class ArrayUtils
{
	public static function sortAlphabetically(arr:Array<String>)
	{
		#if flash9
		untyped arr.sort()
		#else
		arr.sort(compareAlphabetically);
		#end
	}
	
	public static function compareAlphabetically(x:String,y:String)
	{
		var s = x.length <= y.length? x : y;
		
		for (i in 0 ... s.length) {
			var c1 = x.charCodeAt(i);
			var c2 = y.charCodeAt(i);
			
			if (c1 == c2) continue;
			return c1 - c2;
		}
		
		return x == s? -1 : 1;
	}
}