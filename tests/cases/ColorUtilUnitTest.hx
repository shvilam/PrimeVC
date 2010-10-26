package cases;
 import primevc.types.RGBA;
 import primevc.utils.Color;
  using primevc.utils.Color;


/**
 * Class description
 * 
 * @author Ruben Weijers
 * @creation-date Jul 30, 2010
 */
class ColorUtilUnitTest
{
	public static function main ()
	{
		var color:RGBA = Color.create(0xAA, 0xFC, 0xBA, 0x8F );
		Assert.equal( color.red(),				0xAA, "Red should be "+0xAA.uintToString() + " instead of " + color.red().uintToString() );
		Assert.equal( color.green(),			0xFC, "Green should be "+0xFC.uintToString() + " instead of " + color.green().uintToString() );
		Assert.equal( color.blue(),				0xBA, "Blue should be "+0xBA.uintToString() + " instead of " + color.blue().uintToString() );
		Assert.equal( color.alpha(),			0x8F, "Alpha should be "+0x8F.uintToString() + " instead of " + color.alpha().uintToString() );
		
		Assert.equal( color.rgb(),				0xAAFCBA, "Color should be "+0xAAFCBA.uintToString() + " instead of " + color.rgb().uintToString() );
		
		Assert.equal( color.red().float(),		0xAA / 255 );
		Assert.equal( color.green().float(),	0xFC / 255 );
		Assert.equal( color.blue().float(),		0xBA / 255 );
		Assert.equal( color.alpha().float(),	0x8F / 255 );
		
		color = Color.create(0,0,0,0);
		compareColors( color = color.setRed(0xab),		Color.create(0xAB,0,0,0) );
		compareColors( color = color.setGreen(0xab),	Color.create(0xAB,0xAB,0,0) );
		compareColors( color = color.setBlue(0xab),		Color.create(0xAB,0xAB,0xAB,0) );
		compareColors( color = color.setAlpha(0xab),	Color.create(0xAB,0xAB,0xAB,0xAB) );
		
		color = Color.create(0,0,0,0);
		color = color.setRed(0x33);
		compareColors( color,						Color.create(0x33, 0, 0, 0) );
		color = color.setGreen(0xF4);
		compareColors( color,						Color.create(0x33, 0xF4, 0, 0) );
		color = color.setBlue(0x77);
		compareColors( color,						Color.create(0x33, 0xF4, 0x77, 0) );
		color = color.setAlpha(0x12);
		compareColors( color,						Color.create(0x33, 0xF4, 0x77, 0x12) );
		color = color.setAlpha(0xa5);
		compareColors( color,						Color.create(0x33, 0xF4, 0x77, 0xa5) );
		color = color.setRgb(0x00F78d);
		compareColors( color,						Color.create(0x00, 0xF7, 0x8d, 0xa5) );
		
	//	compareColors( Color.create(100, 50, 0),	0x643200FF , "Color should be "+0x643200.uintToString() + " instead of " + Color.create(100, 50, 0).string());
		
		color			= Color.create(0xFF, 0x66, 0x44, 0xFF);
		var newColor	= Color.create(0x7F, 0x33, 0x22, 0xFF);
		color			= color.tint(.5);
		compareColors( color, newColor );
	}
	
	
	public static inline function compareColors (testColor:RGBA, correctColor:RGBA) : Void
	{
#if neko
		Assert.equal( testColor.color, correctColor.color, "Color should be "+correctColor.color.uintToString()+" instead of "+testColor.color.uintToString() );
		Assert.equal( testColor.a, correctColor.a, "Alpha should be "+correctColor.a.uintToString()+" instead of "+testColor.a.uintToString() );
#else
	//	Assert.equal( testColor.rgb(), correctColor.rgb(), "Color should be "+correctColor.rgb().uintToString()+" instead of "+testColor.rgb().uintToString() );
	//	Assert.equal( testColor.alpha(), correctColor.alpha(), "Alpha should be "+correctColor.alpha().uintToString()+" instead of "+testColor.alpha().uintToString() );
		Assert.equal( testColor, correctColor, "Color should be "+correctColor.string()+" instead of "+testColor.string() );
#end
	}
}