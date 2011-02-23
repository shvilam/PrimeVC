package primevc.mvc;
#if debug
  using primevc.utils.BitUtil;
#end


/**
 * @author Ruben Weijers
 * @creation-date Dec 14, 2010
 */
class MVCState
{
	public static inline var LISTENING	: Int = 1;
	public static inline var DISPOSED	: Int = 2;
	
	public static inline var ENABLED	: Int = 4;
	public static inline var EDITING	: Int = 8;
	
	
#if debug
	public static inline function readState (state:Int)
	{
		var str = [];
		if (state.has(LISTENING))	str.push( "listening" );
		if (state.has(DISPOSED))	str.push( "disposed" );
		if (state.has(EDITING))		str.push( "editing" );
		if (state.has(ENABLED))		str.push( "enabled" );
		
		return str.join(", ");
	}
#end
}