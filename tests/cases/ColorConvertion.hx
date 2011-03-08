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
		var color	= 0xfefefeff;
		var base	= 0x000000ff;
		trace( base.alphaBlendColors(color, 0.22).uintToString() );
		trace( base.alphaBlendColors(color, 0.36).uintToString() );
		trace( base.alphaBlendColors(color, 0.15).uintToString() );
		trace( color.uintToString() );
		trace( base.alphaBlendColors(color, 0.05).uintToString() );
		
	}
}