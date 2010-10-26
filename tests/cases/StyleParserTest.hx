package cases;
// import primevc.core.net.URLLoader;
 import primevc.core.geom.space.Direction;
 import primevc.core.geom.space.Horizontal;
 import primevc.core.geom.space.MoveDirection;
 import primevc.core.geom.space.Position;
 import primevc.core.geom.space.Vertical;
 import primevc.gui.effects.AnchorScaleEffect;
 import primevc.gui.effects.CompositeEffect;
 import primevc.gui.effects.Easing;
 import primevc.gui.effects.EffectProperties;
 import primevc.gui.effects.FadeEffect;
 import primevc.gui.effects.IEffect;
 import primevc.gui.effects.MoveEffect;
 import primevc.gui.effects.ParallelEffect;
 import primevc.gui.effects.ResizeEffect;
 import primevc.gui.effects.RotateEffect;
 import primevc.gui.effects.ScaleEffect;
 import primevc.gui.effects.SequenceEffect;
 import primevc.gui.effects.SetAction;
 import primevc.gui.effects.WipeEffect;
 import primevc.gui.styling.StyleBlock;
 import primevc.gui.styling.CSSParser;
 import primevc.tools.generator.HaxeCodeGenerator;
 import primevc.tools.Manifest;
  using primevc.utils.Color;
  using primevc.utils.ERegUtil;
  using primevc.utils.NumberUtil;
  using primevc.utils.TypeUtil;
  using Std;
  using Type;


typedef BType = primevc.gui.filters.BitmapFilterType;


class StyleParserTest
{
	public static inline var CORRECT_INTS			= [ "1", "12456789", '35561', '-5789', "210" ];
	public static inline var INCORRECT_INTS			= [ '.123', '-0.12' ];																			//APPLY INCORRECT_FLOATS ALSO ON INTS
	
	public static inline var CORRECT_FLOATS			= [ '.123', '0.1', '-0.12' ];																	//APPLY CORRECT_INTS ALSO ON FLOATS
	public static inline var INCORRECT_FLOATS		= [ '.1234', '12345.789012345', "abc", '&', '!', '@', '#', '$', '%', '1.', '.', '*', '(', ')', '_', '-', '+', '=', '?', '/' ];
	
	public static inline var CORRECT_UNIT_INTS		= [ "12px", "2513em", "-1pt", "2ex", "3in", "4cm", "-5mm", "6pc" ];
	public static inline var INCORRECT_UNIT_INTS	= [ "0.123px", ".12px", "5%", "12 px", "210", "0" ];											//APPLY INCORRECT_UNIT_FLOATS AND CORRECT_INTS ALSO ON INTS
	
	public static inline var CORRECT_UNIT_FLOATS	= [ "12.578px", "-12.578px", ".12ex" ];															//APPLY CORRECT_UNIT_INTS ALSO ON UNIT_FLOATS
	public static inline var INCORRECT_UNIT_FLOATS	= [ "12.5789px", "px", "em", "pt", "ex", "in", "cm", "mm", "pc", "12%", "12 px", "12	em" ];	//APPLY CORRECT_FLOATS ALSO ON UNIT_FLOATS
	
	public static inline var CORRECT_PERCENTAGES	= [ "1%", "1234%", "0.123%", "1050.4%", "-5%" ];
	public static inline var INCORRECT_PERCENTAGES	= [ "12.5789px", "%", "px", "5 %", ".1234%" ];
	
	public static inline var CORRECT_UNIT_GROUP		= [ "2px 1em", "1.34cm 1in 2.84px", "41pc 0px 20px 1in", "2px 5px 0px", "0px 0px 3px 4px", "-1.1px -2.210px -3.321px -4.4px" ];
	public static inline var INCORRECT_UNIT_GROUP	= [ "2px 1", "1px 4px 3px 2px 1px", "2 px 2 px" ];
	
	public static inline var CORRECT_COLORS			= [
		"#aaa", 
		"#aaa000", 
		"#aaa000Fa", 
		"0xaaA", 
		"0xaaadDd", 
		"0xaaadddfe", 
		"rgba(30, 45		, 255,0.5)", 
		"rgba( 0,0, 255, 0.98742321   )", 
		"rgba(0,0,255,1)", 
		"rgba(255,255,255,0)"
	];
	public static inline var INCORRECT_COLORS		= [
		"aaa",
		"#aaaa", 
		"0xaaaa", 
		"#aaaaaaa", 
		"0xaaaaaaa", 
		"#3g5da1", 
		"0x3g5da1", 
		"rgba(15,20,25)", 
		"rgb(15,20,25,1)"
	];
	
	public static inline var CORRECT_LGRADIENTS		= [
		"linear-gradient( 90deg, #aaa, #000 )",
		"linear-gradient( -90deg, 0xaaa, #fad3aaff, 0x000000)",
		"linear-gradient(0deg, #aaa 10px, #fad3aaff 40%, 0x000000	 ,		pad)",
		"linear-gradient(0deg,#aaa ,#fad ,pad)",
		"linear-gradient(0deg,#aaa,#fad,repeat)",
		"linear-gradient ( 0deg, #fff 50px , #000 )",
		"linear-gradient ( 0deg , #aaa , #fad , reflect  )",
		"linear-gradient(0deg,#aaa,#fad)",
		"linear-gradient(	-4deg, #aaa, #bbbbbb, 0xccc, #ddddeeff, 0xeeeeeef0, #fff,repeat )",
		"linear-gradient( 720deg,	#aaa, rgba(10,20,30,1) 80%)"
	];
	public static inline var CORRECT_RGRADIENTS		= [
		"radial-gradient( 0, #aaa, #000 )",
		"radial-gradient( -0, 0xaaa, #fad3aaff, 0x000000)",
		"radial-gradient(-0.13456, #aaa 10px, #fad3aaff 40%, 0x000000	 ,		pad)",
		"radial-gradient( 	0.123456789,#aaa ,#fad ,pad)",
		"radial-gradient(1,#aaa,#fad,repeat)",
		"radial-gradient ( -1, #fff 50px , #000 )",
		"radial-gradient ( .12 , #aaa , #fad , reflect  )",
		"radial-gradient(0.078,#aaa,#fad)",
		"radial-gradient(-.456, #aaa, #bbbbbb, 0xccc, #ddddeeff, 0xeeeeeef0, #fff,repeat )",
		"radial-gradient( 0,	#aaa, rgba(10,20,30,1) 80%)"
	];
	
	public static inline var INCORRECT_LGRADIENTS	= [
		"linear-gradient()",
		"lineair-gradient(50deg,#fff,#000)",
		"linear-gradient ( 50 , #fff , #000 )",
		"linear-gradient ( 0 deg , #fff , #000 )",
		"linear-gradient ( #fff , #000 )",
		"linear-gradient ( 0deg, #fff 50 , #000 )",
		"linear-gradient ( 0deg, #fff 50p , #000 81 )",
	];
	public static inline var INCORRECT_RGRADIENTS	= [
		"radial-gradient()",
		"radial-gradient(-2,#fff,#000)",
		"radial-gradient ( 5 , #fff , #000 )",
		"radial-gradient ( -1.23 , #fff , #000 )",
		"radial-gradient ( #fff , #000 )",
		"radial-gradient ( 0, #fff 50 , #000 )",
		"radial-gradient ( 0, #fff 50p , #000 81 )",
	];
	
	public static inline var CORRECT_URI_IMAGE		= [
		"url(img.jpg		)",
		"url( test/img.jpg)",
		"url( 'test/img.jpg')",
		"url( \"test/img.jpg\"	)",
		"url(	http://img.hier.server.adr/username/img.jpg )",
		"url( http://img.hier.server.adr/username/img.jpg )",
		"url(http://img.hier.server.adr/username/img.jpg)",
	];
	public static inline var INCORRECT_URI_IMAGE	= [
		"url(http://img.hier.server.adr/username/img.jpg) ietsAnders",
		"url()",
		"url('')",
		'url("")',
	];
	
	public static inline var CORRECT_CLASS_IMAGE	= [
		"class(Img)",
		"class(nl.onlinetouch.skins.flair.ImageSkin)",
		"class(nl.ImageSkin  )",
		"class( 		nl.onlinetouch.skins.flair.ImageSkin)"
	];
	public static inline var INCORRECT_CLASS_IMAGE	= [
		"class()",
		"class('aap')",
		"class(nl/onlinetouch/ImageSKins)"
	];
	
	public static inline var CORRECT_FONT_FAMILIES		= [ "verdana", "VeRdAnA", "sans", "sans-serif", "monospace", "cursive", "fantasy", "'New Century Schoolbook'", "'Verdana8'", '"My Own Font"', '"Courier-New"' ];
	public static inline var INCORRECT_FONT_FAMILIES	= [ "New Century Schoolbook", "Verdana8", 'Zapf-Chancery', "8px", /*"bold", "italic", "large",*/ "''", "" ];
	public static inline var CORRECT_FONT_WEIGHT		= [ "normal", "BOLD", "lighter", "bolder", "inherit" ];
	public static inline var INCORRECT_FONT_WEIGHT		= [ "norml", "bld", "bolder4", "", "'bold'" ];
	public static inline var CORRECT_FONT_STYLE			= [ "normal", "italic", "oblique", "inherit" ];
	public static inline var INCORRECT_FONT_STYLE		= [ "bold", "bolder", "lighter" ];
	
	public static inline var CORRECT_FLOAT_HOR			= [ "float-hor", "float-hor( left, bottom )", "float-hor (right)", "float-hor (center, center)", "float-hor(right,top)" ];
	public static inline var CORRECT_FLOAT_VER			= [ "float-ver", "float-ver( top, right )", "float-ver (bottom)", "float-ver (center, center)", "float-ver(center,left)" ];
	public static inline var CORRECT_LAYOUT_FLOAT		= [ "float", "float( right, top )", "float (left)", "float (center, center)", "float (center,bottom)" ];
	public static inline var INCORRECT_FLOAT_HOR		= [ "float-ver", "float-hor()", "float-hor('left')", "float-hor(top)", "float-hor(bottom)", "float-hor(right, )" ];
	public static inline var INCORRECT_FLOAT_VER		= [ "float-hor", "float-ver()", "float-ver('top')", "float-ver(left)", "float-ver(right)", "float-ver(bottom, )" ];
	public static inline var INCORRECT_LAYOUT_FLOAT		= [ "float-hor", "float-ver", "float()", "float('left')", "float(top)", "float(bottom)", "float(left, )" ];
	
	public static inline var CORRECT_HOR_CIRCLE			= [ "hor-circle", "hor-circle( left, bottom )", "hor-circle (right)", "hor-circle (center, center)", "hor-circle(right,top)" ];
	public static inline var CORRECT_VER_CIRCLE			= [ "ver-circle", "ver-circle( top, right )", "ver-circle (bottom)", "ver-circle (center, center)", "ver-circle(center,left)" ];
	public static inline var CORRECT_LAYOUT_CIRCLE		= [ "circle", "circle( right, top )", "circle (left)", "circle (center, center)", "circle (center,bottom)" ];
	public static inline var INCORRECT_HOR_CIRCLE		= [ "ver-circle", "hor-circle()", "hor-circle('left')", "hor-circle(top)", "hor-circle(bottom)", "hor-circle(right, )" ];
	public static inline var INCORRECT_VER_CIRCLE		= [ "hor-circle", "ver-circle()", "ver-circle('top')", "ver-circle(left)", "ver-circle(right)", "ver-circle(bottom, )" ];
	public static inline var INCORRECT_LAYOUT_CIRCLE	= [ "ver-circle", "hor-circle", "circle()", "circle('left')", "circle(top)", "circle(bottom)", "circle(left, )" ];
	
	public static inline var CORRECT_HOR_ELLIPSE		= [ "hor-ellipse", "hor-ellipse( left, bottom )", "hor-ellipse (right)", "hor-ellipse (center, center)", "hor-ellipse(right,top)" ];
	public static inline var CORRECT_VER_ELLIPSE		= [ "ver-ellipse", "ver-ellipse( top, right )", "ver-ellipse (bottom)", "ver-ellipse (center, center)", "ver-ellipse(center,left)" ];
	public static inline var CORRECT_LAYOUT_ELLIPSE		= [ "ellipse", "ellipse( right, top )", "ellipse (left)", "ellipse (center, center)", "ellipse (center,bottom)" ];
	public static inline var INCORRECT_HOR_ELLIPSE		= [ "ver-ellipse", "hor-ellipse()", "hor-ellipse('left')", "hor-ellipse(top)", "hor-ellipse(bottom)", "hor-ellipse(right, )" ];
	public static inline var INCORRECT_VER_ELLIPSE		= [ "hor-ellipse", "ver-ellipse()", "ver-ellipse('top')", "ver-ellipse(left)", "ver-ellipse(right)", "ver-ellipse(bottom, )" ];
	public static inline var INCORRECT_LAYOUT_ELLIPSE	= [ "hor-ellipse", "ver-ellipse", "ellipse()", "ellipse('left')", "ellipse(top)", "ellipse(bottom)", "ellipse(left, )" ];
	
	public static inline var CORRECT_FIXED_TILE			= [ "fixed-tile", "fixed-tile( horizontal )", "fixed-tile (vertical)", "fixed-tile( horizontal, 25 )", "fixed-tile(vertical,5,left)", "fixed-tile(vertical,5,right,bottom)", "fixed-tile	( vertical , 50 , center , top )" ];
	public static inline var INCORRECT_FIXED_TILE		= [ "fixed-tile()", "fixed-tile (diagonal)", "fixed-tile ('vertical')", "fixed-tile( horizontal, left )", "fixed-tile(vertical,top)", "fixed-tile(vertical,5,bottom)" ];
	
	public static inline var CORRECT_DYN_TILE			= [ "dynamic-tile", "dynamic-tile( horizontal )", "dynamic-tile (vertical)", "dynamic-tile( horizontal, left )", "dynamic-tile(vertical,left,bottom)", "dynamic-tile(vertical,right,bottom)", "dynamic-tile	( vertical   , center , top )" ];
	public static inline var INCORRECT_DYN_TILE			= [ "dynamic-tile()", "dynamic-tile (diagonal)", "dynamic-tile ('vertical')", "dynamic-tile( horizontal, top )", "dynamic-tile(vertical,bottom)", "dynamic-tile(vertical,5,bottom)" ];
	
	public static inline var CORRECT_TRIANGLE			= [ "triangle", "triangle(top-left)", "triangle ( BOTTOM-RIGHT )", "TRiangLE( Middle-Left )", "TrIaNgLe(bottom-center)", "triangle(1px, 15px)", "triangle ( 600px ,   3em )", "triangle(0px,0px)" ];
	public static inline var INCORRECT_TRIANGLE			= [ "circle", "ellipse", "rectangle", "line", "triangle()", "triangle (9px)", "triangle(9, 5)", "triangle(top)", "triangle(bottom)", "triangle (	center)", "tRiangle(middle-center)" ];
	
	
	public static function main ()
	{
		var test	= new StyleParserTest();
		var startT	= haxe.Timer.stamp();
		test.executeUnitTests();
		var secondT	= haxe.Timer.stamp();
		test.parse();
		var thirdT	= haxe.Timer.stamp();
		test.generate();
		var endT	= haxe.Timer.stamp();
		
		trace("\n\nunit-tests: "+secToMs(secondT - startT)+"ms ("+test.correctTests+" / " + test.totalTests +")\nparsing: "+secToMs(thirdT - secondT)+"ms\ngenerating: "+secToMs(endT - thirdT)+"ms");
	}
	
	
	public static inline function secToMs (sec:Float) : Int {
		return (sec * 1000).int();
	}
	
	
	private var parser			: CSSParserMethodTest;
	private var generator		: HaxeCodeGenerator;
	
	public var correctTests		: Int;
	public var totalTests		: Int;
	
	
	public function new ()
	{
		parser		= new CSSParserMethodTest();
		generator	= new HaxeCodeGenerator();
		
	//	throw parser.gradientExpr.getExpression();
	}
	
	
	public function parse ()
	{
		trace("=============== PARSING ==================");
		parser.parse( "cases/TestStyleSheet.css" );
#if debug
	//	parser.parse(haxe.Resource.getString("stylesheet"));
		trace(parser.getStyles());
#else
	//	parser.parse(haxe.Resource.getString("stylesheet"));
#end
	}
	
	
	public function generate ()
	{
#if debug
		trace("============ GENERATE CODE ===============");
		generator.generate(parser.getStyles());
		trace(generator.flush());
#else
		generator.generate(parser.getStyles());
#end
	}
	
	
	public function executeUnitTests ()
	{
#if debug
	//	testURIs();
		totalTests		= 0;
		correctTests	= 0;
		testSimpleProperties();
		testGraphicProperties();
		testFontProperties();
		testLayoutProperties();
		
		parser.testParseShadowFilter();
		parser.testParseBevelFilter();
		parser.testParseGlowFilter();
		parser.testParseBlurFilter();
		parser.testParseGradientBevelFilter();
		parser.testParseEffect();
#end
	}
	
#if debug
	private inline function testSimpleProperties ()
	{
		//
		// TEST INTS
		//
		trace("\n\nTESTING INT VALUE REGEX");
		var expr = parser.intValExpr;
		testRegexp(expr, CORRECT_INTS, true);
		testRegexp(expr, INCORRECT_INTS, false);
		testRegexp(expr, CORRECT_FLOATS, false);
		testRegexp(expr, INCORRECT_FLOATS, false);
		
		//
		// TEST FLOATS
		//
		trace("\n\nTESTING FLOAT VALUE REGEX");
		var expr = parser.floatValExpr;
		testRegexp(expr, CORRECT_FLOATS, true);
		testRegexp(expr, CORRECT_INTS, true);
		testRegexp(expr, INCORRECT_FLOATS, false);
		
		//
		// TEST UNIT INTS
		//
		trace("\n\nTESTING UNIT INTS REGEX");
		var expr = parser.intUnitValExpr;
		testRegexp(expr, CORRECT_UNIT_INTS, true);
		testRegexp(expr, INCORRECT_UNIT_INTS, false);
		testRegexp(expr, INCORRECT_UNIT_FLOATS, false);
		testRegexp(expr, CORRECT_INTS, false);
		testRegexp(expr, CORRECT_FLOATS, false);
		
		//
		// TEST UNIT FLOATS
		//
		trace("\n\nTESTING UNIT FLOATS REGEX");
		var expr = parser.floatUnitValExpr;
		testRegexp(expr, CORRECT_UNIT_FLOATS, true);
		testRegexp(expr, CORRECT_UNIT_INTS, true);
		testRegexp(expr, INCORRECT_UNIT_FLOATS, false);
		testRegexp(expr, CORRECT_FLOATS, false);
		testRegexp(expr, INCORRECT_FLOATS, false);
		
		//
		// TEST PERCENTAGE VALUES
		//
		trace("\n\nTESTING PERCENTAGE REGEX");
		var expr = parser.percValExpr;
		testRegexp(expr, CORRECT_PERCENTAGES, true);
		testRegexp(expr, INCORRECT_PERCENTAGES, false);
		testRegexp(expr, CORRECT_INTS, false);
		testRegexp(expr, INCORRECT_INTS, false);
		testRegexp(expr, CORRECT_FLOATS, false);
		testRegexp(expr, INCORRECT_FLOATS, false);
		
		//
		// TEST FLOAT GROUP
		//
		trace("\n\nTESTING FLOAT UNIT REGEX");
		var expr = parser.floatUnitGroupValExpr;
		testRegexp(expr, CORRECT_UNIT_GROUP, true);
		testRegexp(expr, CORRECT_UNIT_FLOATS, true);
		testRegexp(expr, CORRECT_UNIT_INTS, true);
		testRegexp(expr, INCORRECT_UNIT_GROUP, false);
		testRegexp(expr, CORRECT_INTS, false);
		testRegexp(expr, CORRECT_FLOATS, false);
		testRegexp(expr, INCORRECT_INTS, false);
		testRegexp(expr, INCORRECT_FLOATS, false);
		testRegexp(expr, INCORRECT_UNIT_FLOATS, false);
	}
	
	
	
	private inline function testGraphicProperties ()
	{
		//
		// TEST BG COLOR
		//
		trace("\n\nTESTING BG-COLOR REGEX");
		var expr = parser.colorValExpr;
		testRegexp(expr, CORRECT_COLORS, true);
		testRegexp(expr, INCORRECT_COLORS, false);
		
		//
		// TEST BG GRADIENT
		//
		//*
		trace("\n\nTESTING BG-LINEAR-GRADIENT REGEX");
		var expr = parser.linGradientExpr;
		testRegexp(expr, CORRECT_LGRADIENTS, true);
		testRegexp(expr, CORRECT_RGRADIENTS, false);
		testRegexp(expr, INCORRECT_LGRADIENTS, false);
		//*/
		trace("\n\nTESTING BG-RADIAL-GRADIENT REGEX");
		var expr = parser.radGradientExpr;
		testRegexp(expr, CORRECT_RGRADIENTS, true);
		testRegexp(expr, CORRECT_LGRADIENTS, false);
		testRegexp(expr, INCORRECT_RGRADIENTS, false);
		//*/
		
		//
		// TEST BG IMAGE REGEX
		//
		trace("\n\nTESTING IMAGE URI REGEX");
		var expr = parser.imageURIExpr;
		testRegexp(expr, CORRECT_URI_IMAGE, true);
		testRegexp(expr, INCORRECT_URI_IMAGE, false);
		testRegexp(expr, CORRECT_CLASS_IMAGE, false);
		
		trace("\n\nTESTING CLASS REFERENCE REGEX");
		var expr = parser.classRefExpr;
		testRegexp(expr, CORRECT_CLASS_IMAGE, true);
		testRegexp(expr, INCORRECT_CLASS_IMAGE, false);
		testRegexp(expr, CORRECT_URI_IMAGE, false);
		
		
		//
		// TEST SHAPE PROPERTY
		// 
		trace("\n\nTESTING TRIANGLE REGEX");
		var expr = parser.triangleExpr;
		testRegexp(expr, CORRECT_TRIANGLE, true);
		testRegexp(expr, INCORRECT_TRIANGLE, false);
		
		
		
		/*
		var expr = parser.percValExpr;
		expr.test(CORRECT_PERCENTAGES[3]);
		trace(expr.resultToString());
		//*/
		/*
		var expr = parser.intUnitValExpr;
		expr.test(CORRECT_UNIT_INTS[0]);
		trace(expr.resultToString());
		//*/
		/*
		var expr = parser.floatUnitValExpr;
		expr.test(CORRECT_UNIT_FLOATS[0]);
		trace(expr.resultToString());
		//*/
		/*
		var expr = parser.linGradientExpr;
		expr.test(CORRECT_LGRADIENTS[9]);
		trace(expr.resultToString());
		//*/
		/*
		var expr = parser.radGradientExpr;
		expr.test(CORRECT_RGRADIENTS[2]);
		trace(expr.resultToString());
		//*/
		/*
		var expr = parser.imageURIExpr;
		expr.test(CORRECT_URI_IMAGE[5]);
		trace(expr.resultToString());
		//*/
		/*
		var expr = parser.imageClassExpr;
		expr.test(CORRECT_CLASS_IMAGE[2]);
		trace(expr.resultToString());
		//*/
		/*
		var expr = parser.gradientColorExpr;
		expr.test( "#fff000 50px" );
		trace(expr.resultToString());
		expr.test( "#fff 10.4%" );
		trace(expr.resultToString());
		expr.testWrong( "0xfff000 10.4" );
		trace(expr.resultToString());
		//*/
		/*
		var expr = parser.floatUnitGroupValExpr;
		expr.test(CORRECT_UNIT_GROUP[0]);
		trace(expr.resultToString());
		//*/
	}
	
	
	private inline function testFontProperties ()
	{
		//
		// TEST FONT-FAMILY
		//
		trace("\n\nTESTING FONT-FAMILY REGEX");
		var expr = parser.fontFamilyExpr;
		testRegexp(expr, CORRECT_FONT_FAMILIES, true);
		testRegexp(expr, INCORRECT_FONT_FAMILIES, false);
		
		trace("\n\nTESTING FONT-WEIGHT REGEX");
		var expr = parser.fontWeightExpr;
		testRegexp(expr, CORRECT_FONT_WEIGHT, true);
		testRegexp(expr, INCORRECT_FONT_WEIGHT, false);
		
		trace("\n\nTESTING FONT-STYLE REGEX");
		var expr = parser.fontStyleExpr;
		testRegexp(expr, CORRECT_FONT_STYLE, true);
		testRegexp(expr, INCORRECT_FONT_STYLE, false);
		testRegexp(expr, INCORRECT_FONT_WEIGHT, false);
	}
	
	
	private inline function testLayoutProperties ()
	{
		//
		// TEST LAYOUT ALGORITHM
		//
		trace("\n\nTESTING FLOAT-HORIZONTAL REGEX");
		var expr = parser.floatHorExpr;
		testRegexp(expr, CORRECT_FLOAT_HOR, true);
		testRegexp(expr, INCORRECT_FLOAT_HOR, false);
		testRegexp(expr, CORRECT_FLOAT_VER, false);
		testRegexp(expr, CORRECT_HOR_CIRCLE, false);
		testRegexp(expr, CORRECT_VER_CIRCLE, false);
		testRegexp(expr, CORRECT_HOR_ELLIPSE, false);
		testRegexp(expr, CORRECT_VER_ELLIPSE, false);
		testRegexp(expr, CORRECT_LAYOUT_FLOAT, false);
		testRegexp(expr, CORRECT_LAYOUT_CIRCLE, false);
		testRegexp(expr, CORRECT_LAYOUT_ELLIPSE, false);
		
		trace("\n\nTESTING FLOAT-VERTICAL REGEX");
		var expr = parser.floatVerExpr;
		testRegexp(expr, CORRECT_FLOAT_VER, true);
		testRegexp(expr, INCORRECT_FLOAT_VER, false);
		testRegexp(expr, CORRECT_FLOAT_HOR, false);
		testRegexp(expr, CORRECT_HOR_CIRCLE, false);
		testRegexp(expr, CORRECT_VER_CIRCLE, false);
		testRegexp(expr, CORRECT_HOR_ELLIPSE, false);
		testRegexp(expr, CORRECT_VER_ELLIPSE, false);
		testRegexp(expr, CORRECT_LAYOUT_FLOAT, false);
		testRegexp(expr, CORRECT_LAYOUT_CIRCLE, false);
		testRegexp(expr, CORRECT_LAYOUT_ELLIPSE, false);
		
		trace("\n\nTESTING FLOAT REGEX");
		var expr = parser.floatExpr;
		testRegexp(expr, CORRECT_LAYOUT_FLOAT, true);
		testRegexp(expr, INCORRECT_LAYOUT_FLOAT, false);
		testRegexp(expr, CORRECT_FLOAT_HOR, false);
		testRegexp(expr, CORRECT_FLOAT_VER, false);
		testRegexp(expr, CORRECT_HOR_CIRCLE, false);
		testRegexp(expr, CORRECT_VER_CIRCLE, false);
		testRegexp(expr, CORRECT_HOR_ELLIPSE, false);
		testRegexp(expr, CORRECT_VER_ELLIPSE, false);
		testRegexp(expr, CORRECT_LAYOUT_CIRCLE, false);
		testRegexp(expr, CORRECT_LAYOUT_ELLIPSE, false);
		
		
		
		trace("\n\nTESTING HORIZONTAL-CIRCLE REGEX");
		var expr = parser.horCircleExpr;
		testRegexp(expr, CORRECT_HOR_CIRCLE, true);
		testRegexp(expr, INCORRECT_HOR_CIRCLE, false);
		testRegexp(expr, CORRECT_VER_CIRCLE, false);
		testRegexp(expr, CORRECT_FLOAT_HOR, false);
		testRegexp(expr, CORRECT_FLOAT_VER, false);
		testRegexp(expr, CORRECT_HOR_ELLIPSE, false);
		testRegexp(expr, CORRECT_VER_ELLIPSE, false);
		testRegexp(expr, CORRECT_LAYOUT_FLOAT, false);
		testRegexp(expr, CORRECT_LAYOUT_CIRCLE, false);
		testRegexp(expr, CORRECT_LAYOUT_ELLIPSE, false);
		
		trace("\n\nTESTING VERTICAL-CIRCLE REGEX");
		var expr = parser.verCircleExpr;
		testRegexp(expr, CORRECT_VER_CIRCLE, true);
		testRegexp(expr, INCORRECT_VER_CIRCLE, false);
		testRegexp(expr, CORRECT_HOR_CIRCLE, false);
		testRegexp(expr, CORRECT_FLOAT_HOR, false);
		testRegexp(expr, CORRECT_FLOAT_VER, false);
		testRegexp(expr, CORRECT_HOR_ELLIPSE, false);
		testRegexp(expr, CORRECT_VER_ELLIPSE, false);
		testRegexp(expr, CORRECT_LAYOUT_FLOAT, false);
		testRegexp(expr, CORRECT_LAYOUT_CIRCLE, false);
		testRegexp(expr, CORRECT_LAYOUT_ELLIPSE, false);
		
		trace("\n\nTESTING CIRCLE REGEX");
		var expr = parser.circleExpr;
		testRegexp(expr, CORRECT_LAYOUT_CIRCLE, true);
		testRegexp(expr, INCORRECT_LAYOUT_CIRCLE, false);
		testRegexp(expr, CORRECT_HOR_CIRCLE, false);
		testRegexp(expr, CORRECT_VER_CIRCLE, false);
		testRegexp(expr, CORRECT_FLOAT_HOR, false);
		testRegexp(expr, CORRECT_FLOAT_VER, false);
		testRegexp(expr, CORRECT_HOR_ELLIPSE, false);
		testRegexp(expr, CORRECT_VER_ELLIPSE, false);
		testRegexp(expr, CORRECT_LAYOUT_FLOAT, false);
		testRegexp(expr, CORRECT_LAYOUT_ELLIPSE, false);
		
		
		
		trace("\n\nTESTING HORIZONTAL-ELLIPSE REGEX");
		var expr = parser.horEllipseExpr;
		testRegexp(expr, CORRECT_HOR_ELLIPSE, true);
		testRegexp(expr, INCORRECT_HOR_ELLIPSE, false);
		testRegexp(expr, CORRECT_VER_ELLIPSE, false);
		testRegexp(expr, CORRECT_HOR_CIRCLE, false);
		testRegexp(expr, CORRECT_VER_CIRCLE, false);
		testRegexp(expr, CORRECT_FLOAT_HOR, false);
		testRegexp(expr, CORRECT_FLOAT_VER, false);
		testRegexp(expr, CORRECT_LAYOUT_FLOAT, false);
		testRegexp(expr, CORRECT_LAYOUT_CIRCLE, false);
		testRegexp(expr, CORRECT_LAYOUT_ELLIPSE, false);
		
		trace("\n\nTESTING VERTICAL-ELLIPSE REGEX");
		var expr = parser.verEllipseExpr;
		testRegexp(expr, CORRECT_VER_ELLIPSE, true);
		testRegexp(expr, INCORRECT_VER_ELLIPSE, false);
		testRegexp(expr, CORRECT_HOR_ELLIPSE, false);
		testRegexp(expr, CORRECT_HOR_CIRCLE, false);
		testRegexp(expr, CORRECT_VER_CIRCLE, false);
		testRegexp(expr, CORRECT_FLOAT_HOR, false);
		testRegexp(expr, CORRECT_FLOAT_VER, false);
		testRegexp(expr, CORRECT_LAYOUT_FLOAT, false);
		testRegexp(expr, CORRECT_LAYOUT_CIRCLE, false);
		testRegexp(expr, CORRECT_LAYOUT_ELLIPSE, false);
		
		trace("\n\nTESTING ELLIPSE REGEX");
		var expr = parser.ellipseExpr;
		testRegexp(expr, CORRECT_LAYOUT_ELLIPSE, true);
		testRegexp(expr, INCORRECT_LAYOUT_ELLIPSE, false);
		testRegexp(expr, CORRECT_HOR_ELLIPSE, false);
		testRegexp(expr, CORRECT_VER_ELLIPSE, false);
		testRegexp(expr, CORRECT_HOR_CIRCLE, false);
		testRegexp(expr, CORRECT_VER_CIRCLE, false);
		testRegexp(expr, CORRECT_FLOAT_HOR, false);
		testRegexp(expr, CORRECT_FLOAT_VER, false);
		testRegexp(expr, CORRECT_LAYOUT_FLOAT, false);
		testRegexp(expr, CORRECT_LAYOUT_CIRCLE, false);
		
		trace("\n\nTESTING DYNAMIC TILE REGEX");
		var expr = parser.dynamicTileExpr;
		testRegexp(expr, CORRECT_DYN_TILE, true);
		testRegexp(expr, INCORRECT_DYN_TILE, false);
		testRegexp(expr, CORRECT_FIXED_TILE, false);
		testRegexp(expr, CORRECT_HOR_ELLIPSE, false);
		testRegexp(expr, CORRECT_VER_ELLIPSE, false);
		testRegexp(expr, CORRECT_HOR_CIRCLE, false);
		testRegexp(expr, CORRECT_VER_CIRCLE, false);
		testRegexp(expr, CORRECT_FLOAT_HOR, false);
		testRegexp(expr, CORRECT_FLOAT_VER, false);
		testRegexp(expr, CORRECT_LAYOUT_FLOAT, false);
		testRegexp(expr, CORRECT_LAYOUT_CIRCLE, false);
		testRegexp(expr, CORRECT_LAYOUT_ELLIPSE, false);
		
		trace("\n\nTESTING FIXED TILE REGEX");
		var expr = parser.fixedTileExpr;
		testRegexp(expr, CORRECT_FIXED_TILE, true);
		testRegexp(expr, INCORRECT_FIXED_TILE, false);
		testRegexp(expr, CORRECT_DYN_TILE, false);
		testRegexp(expr, CORRECT_HOR_ELLIPSE, false);
		testRegexp(expr, CORRECT_VER_ELLIPSE, false);
		testRegexp(expr, CORRECT_HOR_CIRCLE, false);
		testRegexp(expr, CORRECT_VER_CIRCLE, false);
		testRegexp(expr, CORRECT_FLOAT_HOR, false);
		testRegexp(expr, CORRECT_FLOAT_VER, false);
		testRegexp(expr, CORRECT_LAYOUT_FLOAT, false);
		testRegexp(expr, CORRECT_LAYOUT_CIRCLE, false);
		testRegexp(expr, CORRECT_LAYOUT_ELLIPSE, false);
	}
	
	
	private inline function testRegexp( expr:EReg, values:Array<String>, isCorrect) : Void
	{
		if (isCorrect)
			for (value in values) {
				if (expr.test(value))
					correctTests++;
				totalTests++;
			}
		else
			for (value in values) {
				if (expr.testWrong(value))
					correctTests++;
				totalTests++;
			}
	}
}





class CSSParserMethodTest extends CSSParser
{
	public function new ()
	{
		super(
			new StyleBlock(null),
			new Manifest( "../src/manifest.xml" )
		);
	}
	
	
	public function getStyles () {
		return styles;
	}
	
	
	//
	// TEST METHODS
	//
	
	
	public function testParseShadowFilter ()
	{
		trace("\n\nTESTING PARSE SHADOW FILTER");
		
		//
		//test correct values. Syntax (variable order except for the order within the '()'):
		//( <distance>px? <blurX>px? <blurY>px? <strength>? ) | <angle>deg? | <rgba>? | <inner>? | <hide-object>? | <knockout>? | <quality>?
		//
		
		
		var v = "5px 10px 12px 3 90deg #ff00aadd inner hide-object knockout high";
		var f = parseShadowFilter(v);
		Assert.equal( f.distance,	5,				"distance" );
		Assert.equal( f.blurX,		10,				"blurX" );
		Assert.equal( f.blurY,		12,				"blurY" );
		Assert.equal( f.strength,	3,				"strength" );
		Assert.equal( f.angle,		90,				"angle" );
		Assert.equal( f.color,		0xff00aa,		"color" );
		Assert.equal( f.alpha,		0xdd.float(),	"alpha" );
		Assert.equal( f.inner,		true,			"inner" );
		Assert.equal( f.hideObject,	true,			"hideObject" );
		Assert.equal( f.knockout,	true,			"knockout" );
		Assert.equal( f.quality,	3,				"quality" );
		
		
		
		var v = ".789px 3 90deg #ff0000 medium";
		var f = parseShadowFilter(v);
		Assert.equal( f.distance,	.789,			"distance" );
		Assert.equal( f.blurX,		4,				"blurX" );
		Assert.equal( f.blurY,		4,				"blurY" );
		Assert.equal( f.strength,	3,				"strength" );
		Assert.equal( f.angle,		90,				"angle" );
		Assert.equal( f.color,		0xff0000,		"color" );
		Assert.equal( f.alpha,		0xff.float(),	"alpha" );
		Assert.equal( f.inner,		false,			"inner" );
		Assert.equal( f.hideObject,	false,			"hideObject" );
		Assert.equal( f.knockout,	false,			"knockout" );
		Assert.equal( f.quality,	2,				"quality" );
		
		
		
		var v = "inner 210 knockout 12.701deg";
		var f = parseShadowFilter(v);
		Assert.equal( f.distance,	4,				"distance" );
		Assert.equal( f.blurX,		4,				"blurX" );
		Assert.equal( f.blurY,		4,				"blurY" );
		Assert.equal( f.strength,	210,			"strength" );
		Assert.equal( f.angle,		12.701,			"angle" );
		Assert.equal( f.color,		0x00000,		"color" );
		Assert.equal( f.alpha,		0xff.float(),	"alpha" );
		Assert.equal( f.inner,		true,			"inner" );
		Assert.equal( f.hideObject,	false,			"hideObject" );
		Assert.equal( f.knockout,	true,			"knockout" );
		Assert.equal( f.quality,	1,				"quality" );
		
		
		
		var v = "5px 10px 12px";
		var f = parseShadowFilter(v);
		Assert.equal( f.distance,	5,				"distance" );
		Assert.equal( f.blurX,		10,				"blurX" );
		Assert.equal( f.blurY,		12,				"blurY" );
		Assert.equal( f.strength,	1,				"strength" );
		Assert.equal( f.angle,		45,				"angle" );
		Assert.equal( f.color,		0x00,			"color" );
		Assert.equal( f.alpha,		0xff.float(),	"alpha" );
		Assert.equal( f.inner,		false,			"inner" );
		Assert.equal( f.hideObject,	false,			"hideObject" );
		Assert.equal( f.knockout,	false,			"knockout" );
		Assert.equal( f.quality,	1,				"quality" );
		
		
		
		var v = "4px 4px 4px #ff0000 180deg";
		var f = parseShadowFilter(v);
		Assert.equal( f.distance,	4,				"distance" );
		Assert.equal( f.blurX,		4,				"blurX" );
		Assert.equal( f.blurY,		4,				"blurY" );
		Assert.equal( f.strength,	1,				"strength" );
		Assert.equal( f.angle,		180,			"angle" );
		Assert.equal( f.color,		0xff0000,		"color" );
		Assert.equal( f.alpha,		0xff.float(),	"alpha" );
		Assert.equal( f.inner,		false,			"inner" );
		Assert.equal( f.hideObject,	false,			"hideObject" );
		Assert.equal( f.knockout,	false,			"knockout" );
		Assert.equal( f.quality,	1,				"quality" );
	}
	
	
	
	
	public function testParseBevelFilter ()
	{
		trace("\n\nTESTING PARSE BEVEL FILTER");

		//
		// test correct values. Syntax (variable order except for the order within the '()'):
		// ( <distance>px? <blurX>px? <blurY>px? <strength>? ) | <angle>deg? | ( <rgba-shadow>? | <rgba-highlight>? ) | <inner|outer|full>? | <knockout>? | <quality>?
		//


		var v = "5px 10px 12px 3 90deg #ff00aadd #00aadd full knockout high";
		var f = parseBevelFilter(v);
		Assert.equal( f.distance,		5,				"distance" );
		Assert.equal( f.blurX,			10,				"blurX" );
		Assert.equal( f.blurY,			12,				"blurY" );
		Assert.equal( f.strength,		3,				"strength" );
		Assert.equal( f.angle,			90,				"angle" );
		Assert.equal( f.highlightColor,	0xff00aa,		"highlightColor" );
		Assert.equal( f.highlightAlpha,	0xdd.float(),	"highlightAlpha" );
		Assert.equal( f.shadowColor,	0x00aadd,		"shadowColor" );
		Assert.equal( f.shadowAlpha,	0xff.float(),	"shadowAlpha" );
		Assert.equal( f.type,			BType.FULL,		"type" );
		Assert.equal( f.knockout,		true,			"knockout" );
		Assert.equal( f.quality,		3,				"quality" );



		var v = ".789px 3 90deg #ff0000 medium";
		var f = parseBevelFilter(v);
		Assert.equal( f.distance,		.789,			"distance" );
		Assert.equal( f.blurX,			4,				"blurX" );
		Assert.equal( f.blurY,			4,				"blurY" );
		Assert.equal( f.strength,		3,				"strength" );
		Assert.equal( f.angle,			90,				"angle" );
		Assert.equal( f.highlightColor,	0xff0000,		"color" );
		Assert.equal( f.highlightAlpha,	0xff.float(),	"alpha" );
		Assert.equal( f.shadowColor,	0x000000,		"shadowColor" );
		Assert.equal( f.shadowAlpha,	0xff.float(),	"shadowAlpha" );
		Assert.equal( f.type,			BType.INNER,	"type" );
		Assert.equal( f.knockout,		false,			"knockout" );
		Assert.equal( f.quality,		2,				"quality" );
		


		var v = "60 #abcdef12 #fedcba98 low outer";
		var f = parseBevelFilter(v);
		Assert.equal( f.distance,		4,				"distance" );
		Assert.equal( f.blurX,			4,				"blurX" );
		Assert.equal( f.blurY,			4,				"blurY" );
		Assert.equal( f.strength,		60,				"strength" );
		Assert.equal( f.angle,			45,				"angle" );
		Assert.equal( f.highlightColor,	0xabcdef,		"color" );
		Assert.equal( f.highlightAlpha,	0x12.float(),	"alpha" );
		Assert.equal( f.shadowColor,	0xfedcba,		"shadowColor" );
		Assert.equal( f.shadowAlpha,	0x98.float(),	"shadowAlpha" );
		Assert.equal( f.type,			BType.OUTER,	"type" );
		Assert.equal( f.knockout,		false,			"knockout" );
		Assert.equal( f.quality,		1,				"quality" );
	}




	public function testParseGlowFilter ()
	{
		trace("\n\nTESTING PARSE GLOW FILTER");

		//
		// test correct values. Syntax (variable order except for the order within the '()'):
		// ( <blurX>px? <blurY>px? <strength>? ) | <rgba>? | <inner>? | <knockout>? | <quality>?
		//


		var v = "10px 12px 3 #ff00aadd inner knockout high";
		var f = parseGlowFilter(v);
		Assert.equal( f.blurX,		10,				"blurX" );
		Assert.equal( f.blurY,		12,				"blurY" );
		Assert.equal( f.strength,	3,				"strength");
		Assert.equal( f.color,		0xff00aa,		"color" );
		Assert.equal( f.alpha,		0xdd.float(),	"alpha" );
		Assert.equal( f.inner,		true,			"inner" );
		Assert.equal( f.knockout,	true,			"knockout" );
		Assert.equal( f.quality,	3,				"quality" );



		var v = "10 #ff0000 medium";
		var f = parseGlowFilter(v);
		Assert.equal( f.blurX,		4,				"blurX" );
		Assert.equal( f.blurY,		4,				"blurY" );
		Assert.equal( f.strength,	10,				"strength");
		Assert.equal( f.color,		0xff0000,		"color" );
		Assert.equal( f.alpha,		0xff.float(),	"alpha" );
		Assert.equal( f.inner,		false,			"inner" );
		Assert.equal( f.knockout,	false,			"knockout" );
		Assert.equal( f.quality,	2,				"quality" );
		
		
		var v = "knockout #abcdef12 low";
		var f = parseGlowFilter(v);
		Assert.equal( f.blurX,		4,				"blurX" );
		Assert.equal( f.blurY,		4,				"blurY" );
		Assert.equal( f.strength,	1,				"strength");
		Assert.equal( f.color,		0xabcdef,		"color" );
		Assert.equal( f.alpha,		0x12.float(),	"alpha" );
		Assert.equal( f.inner,		false,			"inner" );
		Assert.equal( f.knockout,	true,			"knockout" );
		Assert.equal( f.quality,	1,				"quality" );
		
	}




	public function testParseBlurFilter ()
	{
		trace("\n\nTESTING PARSE BLUR FILTER");

		//
		// test correct values. Syntax (variable order except for the order within the '()'):
		// <blurX>px? | <blurY>px? | <quality>?
		//


		var v = "5px 10px high";
		var f = parseBlurFilter(v);
		Assert.equal( f.blurX,			5,				"blurX" );
		Assert.equal( f.blurY,			10,				"blurY" );
		Assert.equal( f.quality,		3,				"quality" );



		var v = "medium";
		var f = parseBlurFilter(v);
		Assert.equal( f.blurX,			4,				"blurX" );
		Assert.equal( f.blurY,			4,				"blurY" );
		Assert.equal( f.quality,		2,				"quality" );



		var v = "10px 0px low";
		var f = parseBlurFilter(v);
		Assert.equal( f.blurX,			10,				"blurX" );
		Assert.equal( f.blurY,			0,				"blurY" );
		Assert.equal( f.quality,		1,				"quality" );

		var v = "0px 0px";
		var f = parseBlurFilter(v);
		Assert.equal( f.blurX,			0,				"blurX" );
		Assert.equal( f.blurY,			0,				"blurY" );
		Assert.equal( f.quality,		1,				"quality" );
	}
	
	
	
	public function testParseGradientBevelFilter ()
	{
		trace("\n\nTESTING PARSE GRADIENT-BEVEL FILTER");
		
		//
		//test correct values. Syntax (variable order except for the order within the '()'):
		//( <distance>px? <blurX>px? <blurY>px? <strength>? ) | <angle>deg? | <rgba>? | <inner>? | <hide-object>? | <knockout>? | <quality>?
		//
		
		
		var v = "5px 10px 12px 3 90deg #ff00aadd, #00aadd inner knockout high";
		var f = parseGradientBevelFilter(v);
		Assert.equal( f.distance,	5,				"distance" );
		Assert.equal( f.blurX,		10,				"blurX" );
		Assert.equal( f.blurY,		12,				"blurY" );
		Assert.equal( f.strength,	3,				"strength" );
		Assert.equal( f.angle,		90,				"angle" );
		
		Assert.equal( f.colors.length,	2,			"colors" );
		Assert.equal( f.alphas.length,	2,			"alphas" );
		Assert.equal( f.ratios.length,	2,			"ratios" );
		
		Assert.equal( f.colors[0],	0xff00aa,		"color" );
		Assert.equal( f.alphas[0],	0xdd.float(),	"alpha" );
		Assert.equal( f.ratios[0],	0,				"ratio" );
		
		Assert.equal( f.colors[1],	0x00aadd,		"color" );
		Assert.equal( f.alphas[1],	0xff.float(),	"alpha" );
		Assert.equal( f.ratios[1],	255,			"ratio" );
		
		Assert.equal( f.type,		BType.INNER,	"inner" );
		Assert.equal( f.knockout,	true,			"knockout" );
		Assert.equal( f.quality,	3,				"quality" );
		
		
		
		var v = "outer .789px 3 90deg #ff0000, #abcdef12 60px, #333 medium";
		var f = parseGradientBevelFilter(v);
		Assert.equal( f.distance,	.789,			"distance" );
		Assert.equal( f.blurX,		4,				"blurX" );
		Assert.equal( f.blurY,		4,				"blurY" );
		Assert.equal( f.strength,	3,				"strength" );
		Assert.equal( f.angle,		90,				"angle" );
		
		Assert.equal( f.colors.length,	3,			"colors" );
		Assert.equal( f.alphas.length,	3,			"alphas" );
		Assert.equal( f.ratios.length,	3,			"ratios" );
		
		Assert.equal( f.colors[0],	0xff0000,		"color" );
		Assert.equal( f.alphas[0],	0xff.float(),	"alpha" );
		Assert.equal( f.ratios[0],	0,				"ratio" );
		
		Assert.equal( f.colors[1],	0xabcdef,		"color" );
		Assert.equal( f.alphas[1],	0x12.float(),	"alpha" );
		Assert.equal( f.ratios[1],	60,				"ratio" );
		
		Assert.equal( f.colors[2],	0x333333,		"color" );
		Assert.equal( f.alphas[2],	0xff.float(),	"alpha" );
		Assert.equal( f.ratios[2],	255,			"ratio" );
		
		Assert.equal( f.type,		BType.OUTER,	"type" );
		Assert.equal( f.knockout,	false,			"knockout" );
		Assert.equal( f.quality,	2,				"quality" );
	}
	
	
	
	
	public function testParseEffect ()
	{
		//
		// test anchorScaleEffect
		//
		
		trace("\n\nTESTING PARSE ANCHOR SCALE EFFECT");
		
		var v = "anchor-scale";
		var e = parseEffect(v).as(AnchorScaleEffect);
		trace(e);
		Assert.equal( e.duration,			350,				"duration" );
		Assert.that( e.delay.notSet(),							"delay" );
		Assert.equal( e.easing,				null,				"easing" );
		Assert.equal( e.zoomPosition,		Position.TopLeft,	"zoom-position" );
		Assert.that( e.startValue.notSet(),						"start-value" );
		Assert.that( e.endValue.notSet(),						"end-value" );
		
		var v = "anchor-scale bottom-left 400ms 50ms";
		var e = parseEffect(v).as(AnchorScaleEffect);
		trace(e);
		Assert.equal( e.duration,			400,				"duration" );
		Assert.equal( e.delay,				50,					"delay" );
		Assert.equal( e.easing,				null,				"easing" );
		Assert.equal( e.zoomPosition,		Position.BottomLeft,"zoom-position" );
		Assert.that( e.startValue.notSet(),						"start-value" );
		Assert.that( e.endValue.notSet(),						"end-value" );
		
		var v = "anchor-scale 400ms 50ms Bounce-Out middle-right 100% 312.3%";
		var e = parseEffect(v).as(AnchorScaleEffect);
		trace(e);
		Assert.equal( e.duration,			400,					"duration" );
		Assert.equal( e.delay,				50,						"delay" );
		Assert.equal( e.easingName,			"bounce-out",			"easing-name" );
		Assert.equal( e.zoomPosition,		Position.MiddleRight,	"zoom-position" );
		Assert.equal( e.startValue,			1.0,					"start-value" );
		Assert.equal( e.endValue,			3.123,					"end-value" );
		
		
		//
		// test fade-effect
		//
		
		trace("\n\nTESTING PARSE FADE EFFECT");
		
		var v = "fade";
		var e = parseEffect(v).as(FadeEffect);
		trace(e);
		Assert.equal( e.duration,			350,				"duration" );
		Assert.that( e.delay.notSet(),							"delay" );
		Assert.equal( e.easing,				null,				"easing" );
		Assert.that( e.startValue.notSet(),						"start-value" );
		Assert.that( e.endValue.notSet(),						"end-value" );
		
		var v = "fade 400ms 50ms";
		var e = parseEffect(v).as(FadeEffect);
		trace(e);
		Assert.equal( e.duration,			400,				"duration" );
		Assert.equal( e.delay,				50,					"delay" );
		Assert.equal( e.easing,				null,				"easing" );
		Assert.that( e.startValue.notSet(),						"start-value" );
		Assert.that( e.endValue.notSet(),						"end-value" );
		
		var v = "fade 400ms elastic-in-out 0% 99%";
		var e = parseEffect(v).as(FadeEffect);
		trace(e);
		Assert.equal( e.duration,			400,				"duration" );
		Assert.that( e.delay.notSet(),							"delay" );
		Assert.equal( e.easingName,			"elastic-in-out",	"easing-name" );
		Assert.equal( e.startValue,			0,					"start-value" );
		Assert.equal( e.endValue,			0.99,				"end-value" );
		
		
		
		//
		// test move-effect
		//
		
		trace("\n\nTESTING PARSE MOVE EFFECT");
		
		var v = "move";
		var e = parseEffect(v).as(MoveEffect);
		trace(e);
		Assert.equal( e.duration,		350,				"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easing,			null,				"easing" );
		Assert.that( e.startX.notSet(),						"start-x-value" );
		Assert.that( e.startY.notSet(),						"start-y-value" );
		Assert.that( e.endX.notSet(),						"end-x-value" );
		Assert.that( e.endY.notSet(),						"end-y-value" );
		
		var v = "move 400ms 50ms";
		var e = parseEffect(v).as(MoveEffect);
		trace(e);
		Assert.equal( e.duration,		400,				"duration" );
		Assert.equal( e.delay,			50,					"delay" );
		Assert.equal( e.easing,			null,				"easing" );
		Assert.that( e.startX.notSet(),						"start-x-value" );
		Assert.that( e.startY.notSet(),						"start-y-value" );
		Assert.that( e.endX.notSet(),						"end-x-value" );
		Assert.that( e.endY.notSet(),						"end-y-value" );
		
		var v = "move 400ms circ-in 20px, 0px";
		var e = parseEffect(v).as(MoveEffect);
		trace(e);
		Assert.equal( e.duration,		400,				"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easingName,		"circ-in",			"easing-name" );
		Assert.that( e.startX.notSet(),						"start-x-value" );
		Assert.that( e.startY.notSet(),						"start-y-value" );
		Assert.equal( e.endX,			20,					"end-x-value" );
		Assert.equal( e.endY,			0,					"end-y-value" );
		
		var v = "move 20px ,40px 100px,-50.4px";
		var e = parseEffect(v).as(MoveEffect);
		trace(e);
		Assert.equal( e.duration,		350,				"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easingName,		null,				"easing-name" );
		Assert.equal( e.startX,			20,					"start-x-value" );
		Assert.equal( e.startY,			40,					"start-y-value" );
		Assert.equal( e.endX,			100,				"end-x-value" );
		Assert.equal( e.endY,			-50.4,				"end-y-value" );
		
		
		
		//
		// test resize-effect
		//
		
		trace("\n\nTESTING PARSE RESIZE EFFECT");
		
		var v = "resize";
		var e = parseEffect(v).as(ResizeEffect);
		trace(e);
		Assert.equal( e.duration,		350,				"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easing,			null,				"easing" );
		Assert.that( e.startW.notSet(),						"start-w-value" );
		Assert.that( e.startH.notSet(),						"start-h-value" );
		Assert.that( e.endW.notSet(),						"end-w-value" );
		Assert.that( e.endH.notSet(),						"end-h-value" );
		
		var v = "resize 400ms";
		var e = parseEffect(v).as(ResizeEffect);
		trace(e);
		Assert.equal( e.duration,		400,				"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easing,			null,				"easing" );
		Assert.that( e.startW.notSet(),						"start-w-value" );
		Assert.that( e.startH.notSet(),						"start-h-value" );
		Assert.that( e.endW.notSet(),						"end-w-value" );
		Assert.that( e.endH.notSet(),						"end-h-value" );
		
		var v = "resize 400ms sine-out 0px,20px";
		var e = parseEffect(v).as(ResizeEffect);
		trace(e);
		Assert.equal( e.duration,		400,				"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easingName,		"sine-out",			"easing-name" );
		Assert.that( e.startW.notSet(),						"start-w-value" );
		Assert.that( e.startH.notSet(),						"start-h-value" );
		Assert.equal( e.endW,			0,					"end-w-value" );
		Assert.equal( e.endH,			20,					"end-h-value" );
		
		var v = "resize 0px ,		0px .123px,-50.4px";
		var e = parseEffect(v).as(ResizeEffect);
		trace(e);
		Assert.equal( e.duration,		350,				"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easingName,		null,				"easing-name" );
		Assert.equal( e.startW,			0,					"start-w-value" );
		Assert.equal( e.startH,			0,					"start-h-value" );
		Assert.equal( e.endW,			.123,				"end-w-value" );
		Assert.equal( e.endH,			-50.4,				"end-h-value" );
		
		
		
		//
		// test rotate-effect
		//
		
		trace("\n\nTESTING PARSE ROTATE EFFECT");
		
		var v = "rotate";
		var e = parseEffect(v).as(RotateEffect);
		trace(e);
		Assert.equal( e.duration,			350,				"duration" );
		Assert.that( e.delay.notSet(),							"delay" );
		Assert.equal( e.easing,				null,				"easing" );
		Assert.that( e.startValue.notSet(),						"start-value" );
		Assert.that( e.endValue.notSet(),						"end-value" );
		
		var v = "rotate 400ms 50ms";
		var e = parseEffect(v).as(RotateEffect);
		trace(e);
		Assert.equal( e.duration,			400,				"duration" );
		Assert.equal( e.delay,				50,					"delay" );
		Assert.equal( e.easing,				null,				"easing" );
		Assert.that( e.startValue.notSet(),						"start-value" );
		Assert.that( e.endValue.notSet(),						"end-value" );
		
		var v = "rotate 400ms expo-out 51deg 315deg";
		var e = parseEffect(v).as(RotateEffect);
		trace(e);
		Assert.equal( e.duration,			400,				"duration" );
		Assert.that( e.delay.notSet(),							"delay" );
		Assert.equal( e.easingName,			"expo-out",			"easing-name" );
		Assert.equal( e.startValue,			51,					"start-value" );
		Assert.equal( e.endValue,			315,				"end-value" );
		
		var v = "rotate 400ms expo-out 51deg ";
		var e = parseEffect(v).as(RotateEffect);
		trace(e);
		Assert.equal( e.duration,			400,				"duration" );
		Assert.that( e.delay.notSet(),							"delay" );
		Assert.equal( e.easingName,			"expo-out",			"easing-name" );
		Assert.that( e.startValue.notSet(),						"start-value" );
		Assert.equal( e.endValue,			51,					"end-value" );
		
		
		
		//
		// test scale-effect
		//
		
		trace("\n\nTESTING PARSE SCALE EFFECT");
		
		var v = "scale";
		var e = parseEffect(v).as(ScaleEffect);
		trace(e);
		Assert.equal( e.duration,		350,				"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easing,			null,				"easing" );
		Assert.that( e.startX.notSet(),						"start-x-value" );
		Assert.that( e.startY.notSet(),						"start-y-value" );
		Assert.that( e.endX.notSet(),						"end-x-value" );
		Assert.that( e.endY.notSet(),						"end-y-value" );
		
		var v = "scale 400ms";
		var e = parseEffect(v).as(ScaleEffect);
		trace(e);
		Assert.equal( e.duration,		400,				"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easing,			null,				"easing" );
		Assert.that( e.startX.notSet(),						"start-x-value" );
		Assert.that( e.startY.notSet(),						"start-y-value" );
		Assert.that( e.endX.notSet(),						"end-x-value" );
		Assert.that( e.endY.notSet(),						"end-y-value" );
		
		var v = "scale 40ms linear-out 0%,20%";
		var e = parseEffect(v).as(ScaleEffect);
		trace(e);
		Assert.equal( e.duration,		40,					"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easingName,		"linear-out",		"easing-name" );
		Assert.that( e.startX.notSet(),						"start-x-value" );
		Assert.that( e.startY.notSet(),						"start-y-value" );
		Assert.equal( e.endX,			0,					"end-x-value" );
		Assert.equal( e.endY,			.2,					"end-y-value" );
		
		var v = "scale 0% , 0% 400.123%, 50%";
		var e = parseEffect(v).as(ScaleEffect);
		trace(e);
		Assert.equal( e.duration,		350,				"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easingName,		null,				"easing-name" );
		Assert.equal( e.startX,			0,					"start-x-value" );
		Assert.equal( e.startY,			0,					"start-y-value" );
		Assert.equal( e.endX,			4.00123,			"end-x-value" );
		Assert.equal( e.endY,			.5,					"end-y-value" );
		
		
		//
		// test set-action-effect
		//
		
		trace("\n\nTESTING PARSE SET-ACTION EFFECT");
		
		var v = "set-action";
		var prop = parseEffectProperties(v);
		Assert.null(prop);
		var e = parseEffect(v).as(SetAction);
		Assert.notNull(e);
		
		trace("\n\nTESTING PARSE SET-ACTION ALPHA EFFECT");
		
		var v = "set-action alpha()";
		var prop = parseEffectProperties(v);
		Assert.null(prop);
		
		var v = "set-action alpha(80% 40%)";
		var prop = parseEffectProperties(v);
		Assert.notNull(prop);
		trace(prop);
		switch (prop) {
			case alpha(from, to):
				Assert.equal(from, 0.8, "alpha-from");
				Assert.equal(to, 0.4, "alpha-to");
			
			default:
				Assert.that(false);
		}
		
		var v = "set-action alpha(45.1%)";
		var prop = parseEffectProperties(v);
		Assert.notNull(prop);
		trace(prop);
		switch (prop) {
			case alpha(from, to):
				Assert.that(from.notSet(), "alpha-from");
				Assert.equal(to, 0.451, "alpha-to");
			
			default:
				Assert.that(false);
		}
		
		
		
		trace("\n\nTESTING PARSE SET-ACTION POSITION EFFECT");
		
		var v = "set-action position()";
		var prop = parseEffectProperties(v);
		Assert.null(prop);
		
		
		var v = "set-action position(20px,809047px 4px,6px)";
		var prop = parseEffectProperties(v);
		Assert.notNull(prop);
		trace(prop);
		switch (prop) {
			case position(fromX, fromY, toX, toY):
				Assert.equal(fromX, 20, "pos-fromX");
				Assert.equal(fromY, 809047, "pos-fromY");
				Assert.equal(toX, 4, "pos-toX");
				Assert.equal(toY, 6, "pos-toY");
			
			default:
				Assert.that(false);
		}
		
		
		var v = "set-action position(4px,6px)";
		var prop = parseEffectProperties(v);
		Assert.notNull(prop);
		trace(prop);
		switch (prop) {
			case position(fromX, fromY, toX, toY):
				Assert.that(fromX.notSet(), "pos-fromX");
				Assert.that(fromY.notSet(), "pos-fromY");
				Assert.equal(toX, 4, "pos-toX");
				Assert.equal(toY, 6, "pos-toY");
			
			default:
				Assert.that(false);
		}
		
		
		trace("\n\nTESTING PARSE SET-ACTION ROTATION EFFECT");
		
		var v = "set-action rotation()";
		var prop = parseEffectProperties(v);
		Assert.null(prop);
		
		
		var v = "set-action rotation(	4deg	987deg	)";
		var prop = parseEffectProperties(v);
		Assert.notNull(prop);
		trace(prop);
		switch (prop) {
			case rotation(from, to):
				Assert.equal(from, 4, "rotation-from");
				Assert.equal(to, 987, "rotation-to");
			
			default:
				Assert.that(false);
		}
		
		
		var v = "set-action rotation(987deg)";
		var prop = parseEffectProperties(v);
		trace(prop);
		switch (prop) {
			case rotation(from, to):
				Assert.that(from.notSet(), "rotation-from");
				Assert.equal(to, 987, "rotation-to");
			
			default:
				Assert.that(false);
		}		
		
		
		trace("\n\nTESTING PARSE SET-ACTION SIZE EFFECT");
		
		var v = "set-action size()";
		var prop = parseEffectProperties(v);
		Assert.null(prop);
		
		
		var v = "set-action size(	3px,4px	 650px,40px	 )";
		var prop = parseEffectProperties(v);
		Assert.notNull(prop);
		trace(prop);
		switch (prop) {
			case size(fromW, fromH, toW, toH):
				Assert.equal(fromW, 3, "size-width-from");
				Assert.equal(fromH, 4, "size-height-from");
				Assert.equal(toW, 650, "size-width-to");
				Assert.equal(toH, 40, "size-height-to");
			
			default:
				Assert.that(false);
		}
		
		
		var v = "set-action size (650px	,		40px)";
		var prop = parseEffectProperties(v);
		trace(prop);
		switch (prop) {
			case size(fromW, fromH, toW, toH):
				Assert.that(fromW.notSet(), "size-width-from");
				Assert.that(fromH.notSet(), "size-height-from");
				Assert.equal(toW, 650, "size-width-to");
				Assert.equal(toH, 40, "size-height-to");
			
			default:
				Assert.that(false);
		}
		
		
		
		trace("\n\nTESTING PARSE SET-ACTION SCALE EFFECT");
		
		var v = "set-action scale()";
		var prop = parseEffectProperties(v);
		Assert.null(prop);
		
		
		var v = "set-action scale(4% , 95% 100%  , 0.12%)";
		var prop = parseEffectProperties(v);
		Assert.notNull(prop);
		trace(prop);
		switch (prop) {
			case scale(fromX, fromY, toX, toY):
				Assert.equal(fromX, .04,	"scale-x-from");
				Assert.equal(fromY, .95,	"scale-y-from");
				Assert.equal(toX, 1,		"scale-x-to");
				Assert.equal(toY, .0012,	"scale-y-to");
			
			default:
				Assert.that(false);
		}
		
		
		var v = "set-action scale(4% , 95%)";
		var prop = parseEffectProperties(v);
		Assert.notNull(prop);
		trace(prop);
		switch (prop) {
			case scale(fromX, fromY, toX, toY):
				Assert.that(fromX.notSet(),	"scale-x-from");
				Assert.that(fromY.notSet(),	"scale-y-from");
				Assert.equal(toX, .04,		"scale-x-to");
				Assert.equal(toY, .95,		"scale-y-to");
			
			default:
				Assert.that(false);
		}
		
		
		
		trace("\n\nTESTING PARSE SET-ACTION ANY EFFECT");
		
		var v = "set-action any()";
		var prop = parseEffectProperties(v);
		Assert.null(prop);
		
		
		var v = "set-action any(skewX, 10, 5)";
		var prop = parseEffectProperties(v);
		Assert.notNull(prop);
		trace(prop);
		switch (prop) {
			case any(propName, from, to):
				Assert.equal(propName,	"skewX",	"prop-name");
				Assert.equal(from,		"10",		"start-value");
				Assert.equal(to,		"5",		"end-value");
			
			default:
				Assert.that(false);
		}
		
		
		var v = "set-action any(skewX, 10)";
		var prop = parseEffectProperties(v);
		Assert.notNull(prop);
		trace(prop);
		switch (prop) {
			case any(propName, from, to):
				Assert.equal(propName,	"skewX",	"prop-name");
				Assert.null(from,					"start-value");
				Assert.equal(to,		"10",		"end-value");
			
			default:
				Assert.that(false);
		}
		
		
		
		//
		// test wipe-effect
		//
		
		trace("\n\nTESTING PARSE WIPE EFFECT");
		
		var v = "wipe";
		var e = parseEffect(v).as(WipeEffect);
		Assert.notNull(e);
		trace(e);
		Assert.equal( e.duration,			350,		"duration" );
		Assert.that( e.delay.notSet(),					"delay" );
		Assert.equal( e.easing,				null,		"easing" );
		Assert.that( e.startValue.notSet(),				"start-value" );
		Assert.that( e.endValue.notSet(),				"end-value" );
		
		var v = "wipe 400ms";
		var e = parseEffect(v).as(WipeEffect);
		Assert.notNull(e);
		trace(e);
		Assert.equal( e.duration,			400,		"duration" );
		Assert.that( e.delay.notSet(),					"delay" );
		Assert.equal( e.easing,				null,		"easing" );
		Assert.that( e.startValue.notSet(),				"start-value" );
		Assert.that( e.endValue.notSet(),				"end-x-value" );
		
		var v = "wipe 40ms linear-out 0px 400px";
		var e = parseEffect(v).as(WipeEffect);
		Assert.notNull(e);
		trace(e);
		Assert.equal( e.duration,			40,				"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easingName,			"linear-out",	"easing-name" );
		Assert.equal( e.startValue,			0,				"start-value" );
		Assert.equal( e.endValue,			400,			"end-value" );
		
		var v = "wipe 400px";
		var e = parseEffect(v).as(WipeEffect);
		Assert.notNull(e);
		trace(e);
		Assert.equal( e.duration,			350,			"duration" );
		Assert.that( e.delay.notSet(),						"delay" );
		Assert.equal( e.easingName,			null,			"easing-name" );
		Assert.that( e.startValue.notSet(),					"start-value" );
		Assert.equal( e.endValue,			400,			"end-value" );
		
		
		
		
		
		//
		// test parallel-effect
		//
		
		trace("\n\nTESTING PARSE PARALLEL EFFECT");
		
		var v = "parallel";
		var e = parseEffect(v);
		Assert.null(e);
		
		var v = "parallel 4ms 30ms elastic-in";
		var e = parseEffect(v).as(ParallelEffect);
		Assert.null(e);
		
		var v = "parallel (fade 15ms)";
		var e = parseEffect(v).as(ParallelEffect);
		Assert.notNull(e, "effect");
		trace(e);
		Assert.equal( e.duration,			350,				"duration" );
		Assert.that( e.delay.notSet(),							"delay" );
		Assert.equal( e.easing,				null,				"easing" );
		Assert.equal( e.effects.length,		1,					"child-length" );
		Assert.that( e.effects.getItemAt(0).is(FadeEffect),		"first child-effect");
		Assert.equal( e.effects.getItemAt(0).duration, 15,		"first child-effect duration");
		Assert.that( e.effects.getItemAt(0).delay.notSet(),		"first child-effect delay");
		
		var v = "parallel 900ms 50ms bounce-out (wipe left-to-right 200ms, fade 15ms elastic-in)";
		var e = parseEffect(v).as(ParallelEffect);
		Assert.notNull(e, "effect");
		trace(e);
		Assert.equal( e.duration,			900,				"duration" );
		Assert.equal( e.delay,				50,					"delay" );
		Assert.equal( e.easingName,			"bounce-out",		"easing" );
		Assert.notNull( e.effects,								"child-collection");
		Assert.equal( e.effects.length,		2,					"child-length" );
		Assert.that( e.effects.getItemAt(0).is(WipeEffect),		"first child-effect");
		Assert.equal( e.effects.getItemAt(0).duration, 200,		"first child-effect duration");
		Assert.null( e.effects.getItemAt(0).easingName,			"first-child-effect easing" );
		Assert.that( e.effects.getItemAt(0).delay.notSet(),		"first child-effect delay");
		
		Assert.that( e.effects.getItemAt(1).is(FadeEffect),		"second child-effect");
		Assert.equal( e.effects.getItemAt(1).duration, 15,		"second child-effect duration");
		Assert.equal( e.effects.getItemAt(1).easingName,		"elastic-in",		"second-child-effect easing" );
		Assert.that( e.effects.getItemAt(1).delay.notSet(),		"second child-effect delay");
		
		
		
		//
		// test sequence-effect
		//
		
		trace("\n\nTESTING PARSE SEQUENCE EFFECT");
		
		var v = "sequence";
		var e = parseEffect(v);
		Assert.null(e);
		
		var v = "sequence 4ms 30ms elastic-in";
		var e = parseEffect(v).as(SequenceEffect);
		Assert.null(e);
		
		var v = "sequence (fade 15ms)";
		var e = parseEffect(v).as(SequenceEffect);
		Assert.notNull(e, "effect");
		trace(e);
		Assert.equal( e.duration,			350,				"duration" );
		Assert.that( e.delay.notSet(),							"delay" );
		Assert.equal( e.easing,				null,				"easing" );
		Assert.equal( e.effects.length,		1,					"child-length" );
		Assert.that( e.effects.getItemAt(0).is(FadeEffect),		"first child-effect");
		Assert.equal( e.effects.getItemAt(0).duration, 15,		"first child-effect duration");
		Assert.that( e.effects.getItemAt(0).delay.notSet(),		"first child-effect delay");
		
		var v = "sequence 900ms 50ms bounce-out (wipe left-to-right 200ms, fade 15ms)";
		var e = parseEffect(v).as(SequenceEffect);
		Assert.notNull(e, "effect");
		trace(e);
		Assert.equal( e.duration,			900,				"duration" );
		Assert.equal( e.delay,				50,					"delay" );
		Assert.equal( e.easingName,			"bounce-out",		"easing" );
		Assert.notNull( e.effects,								"child-collection");
		Assert.equal( e.effects.length,		2,					"child-length" );
		Assert.that( e.effects.getItemAt(0).is(WipeEffect),		"first child-effect");
		Assert.equal( e.effects.getItemAt(0).duration, 200,		"first child-effect duration");
		Assert.that( e.effects.getItemAt(0).delay.notSet(),		"first child-effect delay");
		
		Assert.that( e.effects.getItemAt(1).is(FadeEffect),		"second child-effect");
		Assert.equal( e.effects.getItemAt(1).duration, 15,		"second child-effect duration");
		Assert.that( e.effects.getItemAt(1).delay.notSet(),		"second child-effect delay");
		
		trace("\n\nTESTING PARSE NESTED SEQUENCE EFFECT");
		var v = "sequence (parallel ( fade 500ms 40%, move 300ms elastic-out ), fade 600ms 100% )";
		var e = parseEffect(v).as(SequenceEffect);
		Assert.notNull(e, "effect");
		trace(e);
	//	Assert.equal( e.duration,			900,				"duration" );	
		Assert.that( e.delay.notSet(),							"delay" );
		Assert.equal( e.easingName,			null,				"easing" );
		Assert.notNull( e.effects,								"child-collection");
		Assert.equal( e.effects.length,		2,					"child-length" );
		Assert.that( e.effects.getItemAt(0).is(ParallelEffect),	"first child-effect = '" + e.effects.getItemAt(0) + "' but should be a ParallelEffect");
		var parallel = e.effects.getItemAt(0).as(ParallelEffect);
		Assert.equal( parallel.effects.length, 2,					"nested child-effect");
		Assert.that( parallel.effects.getItemAt(0).is(FadeEffect),	"first nested child-effect");
		Assert.equal( parallel.effects.getItemAt(0).duration, 500,	"first nested child-effect duration");
		Assert.that( parallel.effects.getItemAt(0).delay.notSet(),	"first child-effect delay");
		Assert.that( parallel.effects.getItemAt(1).is(MoveEffect),	"second nested child-effect");
		Assert.equal( parallel.effects.getItemAt(1).duration, 300,	"second nested child-effect duration");
		Assert.that( parallel.effects.getItemAt(1).delay.notSet(),	"second child-effect delay");
	//	Assert.equal( e.effects.getItemAt(0).duration, 200,		"first child-effect duration");
	//	Assert.equal( e.effects.getItemAt(0).delay, 0,			"first child-effect delay");
		
		Assert.that( e.effects.getItemAt(1).is(FadeEffect),		"second child-effect");
		Assert.equal( e.effects.getItemAt(1).duration, 600,		"second child-effect duration");
		Assert.that( e.effects.getItemAt(1).delay.notSet(),		"second child-effect delay");
	}
#end
}


/*	
	private inline function testURIs ()
	{	
		//
		// TEST URI REGEX
		//
	/*	trace("\n\nTESTING URI'S");
		expr = new EReg(CSSParser.R_URI_EXPR, "im");
		
		//localhost test
		expr.test( "http://localhost");
		expr.test( "ftp://localhost");
		expr.test( "localhost" );
		expr.test( "http://localhost/waar/is/daar");
		expr.test( "http://localhost/waar/daar/");
		expr.test( "http://localhost/waar/is/daar/dan.huh");
		expr.test( "http://localhost/waar/is/daar/dan.huh?DOE");
		expr.test( "http://localhost?doe=iets");
		expr.test( "http://localhost?doe=iets&zeg");
		expr.test( "http://localhost?doe=iets&zeg=a");
		expr.test( "http://localhost/test?doe=iets&zeg=a");
		expr.test( "http://localhost?doe=iets&zeg=dit&niks&aap");
		expr.testWrong( "http://localhost?&iets=daar");
		expr.test( "http://localhost#iets");
		expr.test( "http://localhost?doe#iets");
		expr.testWrong( "http://localhost?#iets");
		
		expr.test( "http://localhost/waar/is/daar/?test=iets#met-wat_dan");
		
		//test IPv4 addresses
		expr.test( "http://192.168.1.1");
		expr.testWrong( "http://192.16");
		expr.testWrong( "http://192.168.256.1");
		expr.test( "http://192.168.255.1");
		expr.test( "192.168.255.1" );
		expr.test( "http://192.168.255.1?doe=iets");
		expr.test( "http://192.168.255.1?doe#iets");
		expr.test( "http://192.168.255.1#iets");
		expr.testWrong( "http://192.168.255.1?#iets");
		expr.test( "http://192.168.255.1/waar/is/daar");
		expr.test( "http://192.168.255.1/waar/is/daar/");
		expr.test( "http://192.168.255.1/waar/is/daar/?test=iets#met-wat_dan");
		
		
		//test DNS URI's
		expr.test( "http://www.img.nl");
		expr.test( "www.img.nl" );
		expr.test( "img.nl" );
		expr.test( "img.nl/broodje/aap.php" );
		expr.test( "http://www.img.nl?doe=iets");
		expr.test( "http://www.img.nl?doe#iets");
		expr.test( "http://www.img.nl#iets");
		expr.testWrong( "http://www.img.nl?#iets");
		expr.test( "http://www.img.nl/waar/is/daar");
		expr.test( "http://www.img.nl/waar/is/daar/");
		expr.test( "http://www.img.nl/waar/is/daar/?test=iets#met-wat_dan");
		expr.test( "http://img.nl/daar");
		expr.test( "http://img.nl/daar/poep.html");
		expr.test( "http://img.hier.server.adr/u/s/e/rn/ame/img.jpg");
		expr.test( "http://img.nl/daar/?poep");
		expr.test( "http://img.nl/daar/?poep=test");
		expr.test( "http://img.nl/daar/?poep=test&aap=daar");
		expr.testWrong( "http://img.nl/daar/?poep=test&aap=da ar");
		expr.test( "http://img.nl/daar/?poep=test&aap=daar#go-to%20test");
		expr.test( "http://img.nl/daar/?poep=test&aap=daar#go");
		expr.testWrong( "http://img.nl/daar/?poep=test&aap=daar#go to%20test");
		expr.test( "http://img.nl/daar/#go-to%20test");
		expr.test( "http://img.nl/daar#go-to%20test");
		
		expr.testWrong( "dsfsdf" );
		expr.testWrong( "http://img.nl/daar//?poep" );
		expr.testWrong( "http://img.nl/daar///?poep" );
		
		//test local file's
		expr = new EReg("^"+CSSParser.R_FILE_EXPR, "im");
		expr.test( "test.j" );
		expr.test( "test.jg" );
		expr.test( "test.jpg" );
		expr.test( "test.jpeg" );
		expr.testWrong( "test." );
		expr.testWrong( "test" );
	}
}

/*
class UIElementStyleParser
{
	private var loader : URLLoader;
	
	
	public function new (styles:StyleChildren)
	{
		this.styles = styles;
		loader = new URLLoader();
		parse.on( loader.events.loaded, this );
		handleError.on( loader.events.error, this );
	}
	
	
	public function load (url:URL)
	{
		trace("load "+url);
		loader.load(url);
	}
	
	
	//
	// EVENTHANDLERS
	//
	
	private function handleError (err:String)
	{
		trace(err);
	}
}*/