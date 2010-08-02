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
		var color = 0xAAFCBA8F;
		Assert.equal( color.red(),				0xAA, "Red should be "+0xAA.string() + " instead of " + color.red().string() );
		Assert.equal( color.green(),			0xFC, "Green should be "+0xFC.string() + " instead of " + color.green().string() );
		Assert.equal( color.blue(),				0xBA, "Blue should be "+0xBA.string() + " instead of " + color.blue().string() );
		Assert.equal( color.alpha(),			0x8F, "Alpha should be "+0x8F.string() + " instead of " + color.alpha().string() );
		
		Assert.equal( color.rgb(),				0xAAFCBA, "Color should be "+0xAAFCBA.string() + " instead of " + color.rgb().string() );
		
		Assert.equal( color.red().float(),		0xAA / 255 );
		Assert.equal( color.green().float(),	0xFC / 255 );
		Assert.equal( color.blue().float(),		0xBA / 255 );
		Assert.equal( color.alpha().float(),	0x8F / 255 );
		
		color = 0x00000000;
		Assert.equal( color.setRed(0xab),		0xAB000000, "Color should be "+0xAB000000.string() + " instead of " + color.setRed(0xab).string() );
		Assert.equal( color.setGreen(0xab),		0x00AB0000, "Color should be "+0x00AB0000.string() + " instead of " + color.setGreen(0xab).string() );
		Assert.equal( color.setBlue(0xab),		0x0000AB00, "Color should be "+0x0000AB00.string() + " instead of " + color.setBlue(0xab).string() );
		Assert.equal( color.setAlpha(0xab),		0x000000AB, "Color should be "+0x000000AB.string() + " instead of " + color.setAlpha(0xab).string() );
		
		color = 0x00000000;
		color = color.setRed(0x33);
		Assert.equal( color,					0x33000000 );
		color = color.setGreen(0xF4);
		Assert.equal( color,					0x33F40000 );
		color = color.setBlue(0x77);
		Assert.equal( color,					0x33F47700 );
		color = color.setAlpha(0x12);
		Assert.equal( color,					0x33F47712 );
		color = color.setAlpha(0xa5);
		Assert.equal( color,					0x33F477a5 );
		color = color.setRgb(0x00F78d);
		Assert.equal( color,					0x00F78da5 );
		
		Assert.equal( Color.create(100, 50, 0),	0x643200FF , "Color should be "+0x643200FF.string() + " instead of " + Color.create(100, 50, 0).string());
		
		color			= 0xFF6644FF;
		var newColor	= 0x7F3322FF;
		color			= color.tint(.5);
		Assert.equal( color, newColor, "Color should be "+newColor.string() + " instead of " + color.string() );
	}
}