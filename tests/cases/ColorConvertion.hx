package cases;
  using primevc.utils.Color;


/**
 * 
 * @author Ruben Weijers
 * @creation-date Mar 07, 2011
 */
class ColorConvertion
{
	public static function main ()
	{
		var color	= 0x111111ff;
		var base	= 0xffffffff;
		trace( base.alphaBlendColors(color, 0.32).uintToString() );
		trace( base.alphaBlendColors(color, 0.36).uintToString() );
		trace( base.alphaBlendColors(color, 0.15).uintToString() );
		trace( color.uintToString() );
		trace( base.alphaBlendColors(color, 0.05).uintToString() );
		
	}
}