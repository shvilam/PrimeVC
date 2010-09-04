package cases;
// import primevc.core.net.URLLoader;
 import primevc.gui.graphics.fills.BitmapFill;
 import primevc.gui.graphics.fills.ComposedFill;
 import primevc.gui.graphics.fills.GradientFill;
 import primevc.gui.graphics.fills.GradientStop;
 import primevc.gui.graphics.fills.GradientType;
 import primevc.gui.graphics.fills.IFill;
 import primevc.gui.graphics.fills.SolidFill;
 import primevc.gui.graphics.fills.SpreadMethod;
 import primevc.gui.styling.declarations.UIElementStyle;
 import primevc.gui.styling.StyleContainer;
 import primevc.gui.text.FontStyle;
 import primevc.gui.text.FontWeight;
 import primevc.gui.text.TextAlign;
 import primevc.types.RGBA;
// import primevc.types.URL;
  using primevc.utils.Bind;
  using primevc.utils.Color;
  using primevc.utils.ERegUtil;
  using primevc.utils.TypeUtil;
  using Std;
  using StringTools;
  using Type;


class StyleParserTest
{
	public static function main ()
	{
		trace("start");
		var styles	= new StyleContainer();
		var parser	= new StyleSheetParser(styles);
		var startT	= flash.Lib.getTimer();
		parser.parse(haxe.Resource.getString("stylesheet"));
		
		trace("finished in ("+(flash.Lib.getTimer() - startT)+" ms)");
		trace("ids: " + styles.idSelectors.toString());
		trace("classes: " + styles.styleNameSelectors.toString());
		trace("elements: " + styles.typeSelectors.toString());
	//	var url		= new URL();
	//	url.parse("TestStyleSheet.css");
	//	parser.load(url);
	}
}


class StyleSheetParser
{
//	private var loader : URLLoader;
	
	public static inline var R_WHITESPACE		: String = "\n\r\t ";
	public static inline var R_BLOCK_VALUE		: String = R_WHITESPACE + "a-z0-9#:;-";
	public static inline var R_PROPERTY_NAME	: String = "a-z0-9-";
	public static inline var R_PROPERTY_VALUE	: String = "a-z0-9#-";
	public static inline var R_HEX_VALUE		: String = "0-9a-f";
	public static inline var R_HEX_EXPR			: String = "(0x|#)?(["+R_HEX_VALUE+"]{3}|["+R_HEX_VALUE+"]{6})";
	public static inline var R_GRADIENT_POS		: String = "([0-9]+)(px|%)";
	public static inline var R_GRADIENT_COLOR	: String = "("+R_HEX_EXPR+")["+R_WHITESPACE+"]?("+R_GRADIENT_POS+")?";
	public static inline var R_GRADIENT_SPREAD	: String = "pad|reflect|repeat";
	
	/**
	 * container with all the style blocks
	 */
	private var styles				: StyleContainer;
	/**
	 * block that is currently handled by the parser
	 */
	private var currentBlock		: UIElementStyle;
	
	
	private var blockExpr			: EReg;
	private var propExpr			: EReg;
	private var intValExpr			: EReg;
	private var colorValExpr		: EReg;
	private var gradientExpr		: EReg;
	private var gradientColorExpr	: EReg;
	private var gradientStopExpr	: EReg;
	
	
	public function new (styles:StyleContainer)
	{
		this.styles = styles;
	/*	loader = new URLLoader();
		parse.on( loader.events.loaded, this );
		handleError.on( loader.events.error, this );*/
	}
	
	
	private inline function init ()
	{
		blockExpr = new EReg(
			  "(^([.#]?)([a-z]+))"			//match style selectors containing .name, #name or name
			+ "[" + R_WHITESPACE + "]*{"	//match opening of a block
			+ "([" + R_BLOCK_VALUE + "]*)"	//match content of a block
			+ "[" + R_WHITESPACE + "]*}"	//match closing of a block
			, "im");
		
		propExpr = new EReg(
			  "[" + R_WHITESPACE + "]*([" + R_PROPERTY_NAME + "]+)[" + R_WHITESPACE + "]*:"		//match property name
			+ "[" + R_WHITESPACE + "]*([" + R_PROPERTY_VALUE + "]+)[" + R_WHITESPACE + "]*;"	//match property value
			, "im");
		
		intValExpr			= new EReg("([0-9]+[ a-z]*)", "i");
		colorValExpr		= new EReg(R_HEX_EXPR, "i");
		gradientExpr		= new EReg(
			  "("
				+ "(lineair-gradient)[(]"													//match lineair gradient	(2 = type)
				+ "(([0-9]+)deg)"															//match rotation			(4 = degrees)
				+ "(["+R_WHITESPACE+"]*,["+R_WHITESPACE+"]*(("+R_GRADIENT_COLOR+"){2,}))"	//match colors				(6 = colors)
				+ "(["+R_WHITESPACE+"]*,["+R_WHITESPACE+"]*("+R_GRADIENT_SPREAD+"))?"		//match spread method		(8 = method)
			    + "[)])|("
				+ "(radial-gradient)[(]"														//match radial gradient		(2 = type)
				+ "([0-1-]+)"																//match focal point			(3 = point)
				+ "(["+R_WHITESPACE+"]*,["+R_WHITESPACE+"]*(("+R_GRADIENT_COLOR+"){2,}))"	//match colors				(5 = colors)
				+ "(["+R_WHITESPACE+"]*,["+R_WHITESPACE+"]*("+R_GRADIENT_SPREAD+"))?"		//match spread method		(7 = method)
			    + "[)])"
			, "im");
		gradientColorExpr	= new EReg(R_GRADIENT_COLOR, "i");
		gradientStopExpr	= new EReg(R_GRADIENT_POS, "i");
	}
	
	
/*	public function load (url:URL)
	{
		trace("load "+url);
		loader.load(url);
	}*/
	
	
	/**
	 * Find style blocks
	 */
	public inline function parse (styleString:String) : Void
	{
		trace("parse");
		trace(styleString);
		init();
		blockExpr.matchAll(styleString, handleMatchedBlock);
	}
	
	
	/**
	 * Method to handle each matched style block and put it in the right
	 * style-container.
	 */
	private function handleMatchedBlock (expr:EReg) : Void
	{
		var name = expr.matched(3);
		trace("handleMatchedBlock for "+name);
		
		//find the correct list to add the entry in
		var list = 
			if		(expr.matched(2) == "#")	styles.idSelectors;
			else if (expr.matched(2) == ".")	styles.styleNameSelectors;
			else								styles.typeSelectors;
		
		//create a styleobject for this name if it doens't exist
		if (list.exists(name))		currentBlock = list.get(name);
		else						list.set( name, currentBlock = new UIElementStyle() );
		
		var content = expr.matched(4).trim();
		if (content != "")
			parseBlock(content);
	}
	
	
	/**
	 * Method to find all the style properties in one style block
	 */
	private inline function parseBlock (content:String) : Void
	{
		trace("parseBlock "+content);
		propExpr.matchAll(content, handleMatchedProperty);
	}
	
	
	/**
	 * Method to handle each matched property
	 */
	private function handleMatchedProperty (expr:EReg)
	{
		var name	= expr.matched(1);
		var val		= expr.matched(2);
		trace("handleMatchedProperty "+name+" = "+val);
		switch (name)
		{
			//font properties
			case "font-size":			currentBlock.font.size		= parseInt(val);
			case "font-family":			currentBlock.font.family	= val;
			case "color":				currentBlock.font.color		= parseColor(val);
			case "text-align":			currentBlock.font.align		= parseTextAlign(val);
			case "font-weight":			currentBlock.font.weight	= parseFontWeight(val);
			case "font-style":			currentBlock.font.style		= parseFontStyle(val);
			
			//graphic properties
			case "background":			parseBackground(val);
			case "background-color":	parseColorFill(val);
			case "background-image":	parseBgImage(val);
			case "background-repeat":	parseBgRepeat(val);
			
			//layout properties
		}
	}
	
	
	//
	// FONT PARSE METHODS
	//
	
	/**
	 * Method to convert the given value to an int and convert the value 
	 * according to the unit.
	 */
	private inline function parseInt (v:String) : Int
	{
		return (intValExpr.match(v)) ? intValExpr.matched(1).parseInt() : 0;
	}
	
	
	/**
	 * Method parses a color value like #aaa000 or 0xaaa000 to a RGBA value
	 */
	private inline function parseColor (v:String) : RGBA
	{
		var val = "000000";
		if (colorValExpr.match(v))
			val = colorValExpr.matched(1);
		return v.rgba();
	}
	
	
	private inline function parseTextAlign (v:String) : TextAlign
	{
		return switch (v) {
			default:		TextAlign.left;
			case "center":	TextAlign.center;
			case "right":	TextAlign.right;
		}
	}


	private inline function parseFontWeight (v:String) : FontWeight
	{
		return switch (v) {
		default:			FontWeight.normal;
			case "bold":	FontWeight.bold;
			case "bolder":	FontWeight.bolder;
			case "lighter":	FontWeight.lighter;
		}
	}


	private inline function parseFontStyle (v:String) : FontStyle
	{
		return switch (v) {
			default:		FontStyle.normal;
			case "italic":	FontStyle.italic;
			case "oblique":	FontStyle.oblique;
		}
	}
	
	
	
	//
	// FILLS PARSE METHODS
	//
	
	private inline function parseBackground (v:String) : Void
	{
		
	}
	
	
	/**
	 * Method will parse a Solid- or Gradient-color value.
	 * 
	 * Solid color allows:
	 * 		- 0x000000
	 * 		- #000000
	 * 		- #000
	 * 		- #000000FF	-> (RGBA)
	 * 
	 * Values that are not specified as RGBA will always have a transparancy 
	 * value of 100%.
	 * 
	 * Gradient color allows:
	 * 		- lineair-gradient(deg, color1 <position>, color2 <position>, .., <spreadMethod>) 
	 * 		- radial-gradient(focal-point, color1 <position>, color2 <position>, ..)
	 * 
	 * Color values in a gradient can have the same format as a solid 
	 * background-color. The position of the gradientstop is optional. Without
	 * a position, the color will be placed on it's number devided by 255. If
	 * you do specify a color, it can have a px or % value.
	 * 
	 * SpreadMethod defines how the gradient is spread. Allowed values are:
	 * 		- pad		(no-repeat) (default)
	 * 		- reflect	(repeat gradient and reverse every odd repeat)
	 * 		- repeat	(repeat gradient)
	 */
	private inline function parseColorFill (v:String) : Void
	{
		var fill:IFill;
		if (colorValExpr.match(v))
		{
			fill = new SolidFill(parseColor(v));
		}
		else if (gradientExpr.match(v))
		{
			var type		= gradientExpr.matched(2) == "lineair-gradient" ? GradientType.linear : GradientType.radial;
			var colorsStr	= type == GradientType.linear ? gradientExpr.matched(6) : gradientExpr.matched(5);
			var focalPoint	= type == GradientType.linear ? 0 : gradientExpr.matched(3).parseInt();
			var degr		= type == GradientType.linear ? gradientExpr.matched(4).parseInt() : 0;
			var method		= parseGradientMethod( type == GradientType.linear ? gradientExpr.matched(8) : gradientExpr.matched(7) );
			
			var gr		= new GradientFill(type, method, focalPoint);
			gr.rotation	= degr;
			
			//add colors
			if (colorsStr != null)
			{
				while (true)
				{
					if ( !gradientColorExpr.match(colorsStr) )
						break;
					
					var pos = gradientColorExpr.matched(3).parseInt();
					if (gradientColorExpr.matched(4) == "%")
						pos = ((pos / 100) * 255).int();
					
					gr.add( new GradientStop( gradientColorExpr.matched(1).rgba(), pos ) );
					colorsStr = gradientStopExpr.matchedRight();
				}
				
				//only add the gradient if there are colors
				fill = gr;
			}
		}
		
		//add fill to styleBlock
		if (fill != null)
		{
			if ( currentBlock.graphics.background == null || currentBlock.graphics.background.is( fill.getClass() ) ) {
				currentBlock.graphics.background = fill;
			} else {
				//create complex fill ?
			}
		}
	}
	
	
	private inline function parseBgImage (v:String) : Void
	{
		
	}
	
	
	private inline function parseBgRepeat (v:String) : Void
	{
		
	}
	
	
	private inline function parseGradientMethod (v:String) : SpreadMethod
	{
		return switch (v) {
			case "pad":		SpreadMethod.normal;
			case "reflect":	SpreadMethod.reflect;
			case "repeat":	SpreadMethod.repeat;
		};
	}
	
	
	//
	// EVENTHANDLERS
	//
	
/*	private function handleError (err:String)
	{
		trace(err);
	}*/
}