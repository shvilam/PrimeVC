package cases;
// import primevc.core.net.URLLoader;
 import primevc.gui.styling.CSSParser;
 import primevc.gui.styling.StyleContainer;
  using primevc.utils.ERegUtil;


class StyleParserTest
{
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
	
	public static inline var CORRECT_BG_IMAGE		= [
		"url(img.jpg		)",
		"url( test/img.jpg)",
		"url( 'test/img.jpg')",
		"url( \"test/img.jpg\"	)",
		"url(	http://img.hier.server.adr/username/img.jpg )",
		"url( http://img.hier.server.adr/username/img.jpg ) no-repeat",
		"url(http://img.hier.server.adr/username/img.jpg) repeat-all",
		"class(Img)",
		"class(nl.onlinetouch.skins.flair.ImageSkin)",
		"class(nl.ImageSkin) repeat-all",
		"class(nl.ImageSkin) no-repeat",
		"class( 		nl.onlinetouch.skins.flair.ImageSkin)"
	];
	
	public static inline var INCORRECT_BG_IMAGE		= [
		"url(http://img.hier.server.adr/username/img.jpg) ietsAnders",
		"url()",
		"url('')",
		'url("")',
		"class()",
		"class('aap')",
		"class(nl/onlinetouch/ImageSKins)"
	];
	
	
	public static function main ()
	{
		var test = new StyleParserTest();
	//	test.parse();
		test.executeUnitTests();
	}
	
	private var parser	: CSSParser;
	private var styles	: StyleContainer;
	
	
	public function new ()
	{
		styles	= new StyleContainer();
		parser	= new CSSParser(styles);
		
	//	throw parser.gradientExpr.getExpression();
	}
	
	
	public function parse ()
	{
		trace("start");
		var startT	= flash.Lib.getTimer();
		parser.parse(haxe.Resource.getString("stylesheet"));
		
		trace("finished in ("+(flash.Lib.getTimer() - startT)+" ms)");
		trace(styles);
	}
	
	
	public function executeUnitTests ()
	{
	//	testURIs();
		testBgProperties();
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
		trace("\n\nTESTING BG-LINEAR-GRADIENT REGEX");
		var expr = parser.linGradientExpr;
		testRegexp(expr, CORRECT_LGRADIENTS, true);
		testRegexp(expr, CORRECT_RGRADIENTS, false);
		testRegexp(expr, INCORRECT_LGRADIENTS, false);
		
		trace("\n\nTESTING BG-RADIAL-GRADIENT REGEX");
		var expr = parser.radGradientExpr;
		testRegexp(expr, CORRECT_RGRADIENTS, true);
		testRegexp(expr, CORRECT_LGRADIENTS, false);
		testRegexp(expr, INCORRECT_RGRADIENTS, false);
		
		//
		// TEST BG IMAGE REGEX
		//
		trace("\n\nTESTING BG-IMAGE REGEX");
		var expr = parser.bgImageExpr;
		testRegexp(expr, CORRECT_BG_IMAGE, true);
		testRegexp(expr, INCORRECT_BG_IMAGE, false);
		
		
		var expr = parser.linGradientExpr;
		expr.test(CORRECT_LGRADIENTS[2]);
		trace(expr.resultToString());
		
		var expr = parser.radGradientExpr;
		expr.test(CORRECT_RGRADIENTS[2]);
		trace(expr.resultToString());
	}
	
	
	private inline function testRegexp( expr:EReg, values:Array<String>, isCorrect) : Void
	{
		if (isCorrect)
			for (value in values)
				expr.test(value);
		else
			for (value in values)
				expr.testWrong(value);
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