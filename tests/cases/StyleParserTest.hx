package cases;
// import primevc.core.net.URLLoader;
 import primevc.gui.styling.CSSParser;
 import primevc.gui.styling.StyleContainer;
  using primevc.utils.ERegUtil;
  using Std;


class StyleParserTest
{
	public static inline var CORRECT_INTS			= [ "1", "12456789", '35561', '-5789' ];
	public static inline var INCORRECT_INTS			= [ '.123', '-0.12' ];																			//APPLY INCORRECT_FLOATS ALSO ON INTS
	
	public static inline var CORRECT_FLOATS			= [ '.123', '0.1', '-0.12' ];																	//APPLY CORRECT_INTS ALSO ON FLOATS
	public static inline var INCORRECT_FLOATS		= [ '.1234', '12345.789012345', "abc", '&', '!', '@', '#', '$', '%', '1.', '.', '*', '(', ')', '_', '-', '+', '=', '?', '/' ];
	
	public static inline var CORRECT_UNIT_INTS		= [ "12px", "0", "2513em", "-1pt", "2ex", "3in", "4cm", "-5mm", "6pc" ];
	public static inline var INCORRECT_UNIT_INTS	= [ "0.123px", ".12px", "5%", "12 px" ];														//APPLY INCORRECT_UNIT_FLOATS AND CORRECT_INTS ALSO ON INTS
	
	public static inline var CORRECT_UNIT_FLOATS	= [ "12.578px", "-12.578px", ".12ex" ];																				//APPLY CORRECT_UNIT_INTS ALSO ON UNIT_FLOATS
	public static inline var INCORRECT_UNIT_FLOATS	= [ "12.5789px", "px", "em", "pt", "ex", "in", "cm", "mm", "pc", "12%", "12 px", "12	em" ];	//APPLY CORRECT_FLOATS ALSO ON UNIT_FLOATS
	
	public static inline var CORRECT_PERCENTAGES	= [ "1%", "1234%", "0.123%", "1050.4%", "-5%" ];
	public static inline var INCORRECT_PERCENTAGES	= [ "12.5789px", "%", "px", "5 %", ".1234%" ];
	
	public static inline var CORRECT_UNIT_GROUP		= [ "2px 1em", "1.34cm 1in 2.84px", "41pc 0 20px 1in", "2px 5px 0", "0 0 3px 4px", "-1.1px -2.210px -3.321px -4.4px" ];
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
		"url( http://img.hier.server.adr/username/img.jpg ) no-repeat",
		"url(http://img.hier.server.adr/username/img.jpg) repeat-all",
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
		"class(nl.ImageSkin) repeat-all",
		"class(nl.ImageSkin) no-repeat",
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
	
	
	public static function main ()
	{
		var test	= new StyleParserTest();
		var startT	= haxe.Timer.stamp();
		test.executeUnitTests();
		var secondT	= haxe.Timer.stamp();
		test.parse();
		var endT	= haxe.Timer.stamp();
		
		trace("\n\nunit-tests: "+secToMs(secondT - startT)+"ms ("+test.correctTests+" / " + test.totalTests +")\nparsing: "+secToMs(endT - secondT)+"ms");
	}
	
	
	public static inline function secToMs (sec:Float) : Int {
		return (sec * 1000).int();
	}
	
	
	private var parser			: CSSParser;
	private var styles			: StyleContainer;
	public var correctTests		: Int;
	public var totalTests		: Int;
	
	
	public function new ()
	{
		styles	= new StyleContainer();
		parser	= new CSSParser(styles);
		
	//	throw parser.gradientExpr.getExpression();
	}
	
	
	public function parse ()
	{
		trace("=============== PARSING ==================");
		parser.parse(haxe.Resource.getString("stylesheet"));
		trace(styles);
	}
	
	
	public function executeUnitTests ()
	{
	//	testURIs();
		totalTests		= 0;
		correctTests	= 0;
		testSimpleProperties();
		testBgProperties();
		testFontProperties();
		testLayoutProperties();
	}
	
	
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
	
	
	
	private inline function testBgProperties ()
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
		
		trace("\n\nTESTING IMAGE CLASS REGEX");
		var expr = parser.imageClassExpr;
		testRegexp(expr, CORRECT_CLASS_IMAGE, true);
		testRegexp(expr, INCORRECT_CLASS_IMAGE, false);
		testRegexp(expr, CORRECT_URI_IMAGE, false);
		
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
		expr.testWrong( "test" );*/
	}
}

/*
class StyleSheetParser
{
	private var loader : URLLoader;
	
	
	public function new (styles:StyleContainer)
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